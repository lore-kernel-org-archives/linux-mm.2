Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00FC4CE8D71
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575C78E0021; Fri, 14 Nov 2025 12:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF278E000A; Fri, 14 Nov 2025 12:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B0B8E0021; Fri, 14 Nov 2025 12:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17CFF8E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:53:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C03A012DF90
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:53:38 +0000 (UTC)
X-FDA: 84109960116.22.33C069C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 57460140012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:53:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nsQ8u76B;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IsxNocsz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763142815; a=rsa-sha256;
	cv=pass;
	b=8SwGXeQXOIahN6WDj5ADFp8e3KSmcjiaeMc0oKB0hdl7KjxWUw+CHaypCKlbjkAakEfqtU
	6mNj1iJ6v+iJcLw1sH9jp9rWGApc/tBa2qsnmkY+siOiwRnYaMdEjcaQdrCDBgrddaT/LW
	wha9jFueUvi+MOqT2GeDcLIimPgW1Vw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nsQ8u76B;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IsxNocsz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763142815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPdB7gtkUp8S4WYFdjxlBeL4fjTzglCqepHicN2IE7Y=;
	b=YEe8B+rZnip85QSXeDOsxSOsOrUOKprlsE6QrdUFmFR8IeQg1n4AjKVAV0hpL6f5s02D0v
	6S0G7Y6yCCzkK7Xu1/L3NZ5KuOsvd9R6LNjGiPNk1gAnyj7JDo5mlsXvIQwNHih4rZZXqa
	4DRd67rOPh4XKTeyqQniC7XVyGM04ME=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEGuvTb003103;
	Fri, 14 Nov 2025 17:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZPdB7gtkUp8S4WYFdjxlBeL4fjTzglCqepHicN2IE7Y=; b=
	nsQ8u76BPWinlDBpSEIzmiD/nCf3x/AdU5OsehzS1h66Whggkx/1FVzYW6eGnioc
	o8YhUSEhhaayV45DiGIkod4UWw4HWmAdAC+xzS6hNzfVeCYkF1JVbul6BRP831au
	xmwRc4oN5g24AMLaxsU0lwZVxG0RO0ZOiAXh0kg7YM2AhFKkNrHn8bf7l/FZzRbe
	kMVxP5l//cdAOdVxNf3Usoo05nYecdapdWL6DGer9IrpwAbOTil00Pdc71BVB+WJ
	2KVh/zo432X/E+xKG+pWTtyG1b4VLC427RNYhrsgz6BAr8UlUk59qFlZXzPE28yR
	MxC7WGk9cRgfJJy2+HjgcQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4adr8sspkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 17:53:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEHqDbb011007;
	Fri, 14 Nov 2025 17:53:30 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaqm1y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 17:53:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yZ8Z8m4lnOKGxCW6iilncHO9BY6Wkh+aYXYzxHenVZ4yoYvu/YR58bYtf07Rp5nicuMC6ca6NjZmQD7FGMG/UM7V1Y0ZT9PQN1AJ9sNpJk+qvTVP7Qn90DhfTwA9Pxhg66KtHyJJ7Z4giaC5HBBrE7OhouSIdJPs7fICQV+7bBis8sy3bqjxL/DkqkG53V2L/ouUYuMP5DlBt4Q157/79IbBsyHN7ZK5CCaJ0OKsrEjbF5/9QYz4dS5YYomxFEjvlArGtZVhxtgKPkercre6u1Y3+LEJd8Lz+kIFv9HCRhz327xy85JaULANxZqIMzG5z1VT4EHtf/4nmu8ROcXeBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPdB7gtkUp8S4WYFdjxlBeL4fjTzglCqepHicN2IE7Y=;
 b=O71a59uBI13gVzC3wTF8WUqhCd9NNa7dkARd/XRzXEnV+8zvuRmYiGiGrCJpx3zAgYK6wnuiBXTphzzB6IIs/rmB34tfWquS1dg2UMa0ZMRTC70eCuAHe3bROLa8/Z7wUjr1Li0E4jJGq10vl30BfyD1x5Sy3U9OgpKjV8FsGSRCOEuynSqBMhdlLwE57hlAcfGhE9qTcChOO8TYM1nlcgp0WMO0+gjBqPDraEzjowGojHIZlSKWCbqaG/tUXDFvREfl+yP4j93Fd2ShMdatY1tMk2jAn8bx8QUulz8OzmAJ+Gy+Ff3pc7eGVRkv8728KD+NbYobXg60vX/Siv9kgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPdB7gtkUp8S4WYFdjxlBeL4fjTzglCqepHicN2IE7Y=;
 b=IsxNocszWLIbwI8VEmG/61b/GRpBqCuD9DK0Qn/8N5p5Oacw7BdJmsJvtoQwXVrMLu+nANG4ViflZ6CjDIy4aggwNrviM1uve+phENaehNfsmK8x/rM8DXJcf2u4dQSPm5ZoM2XyIpE1Z9RvjxaNqgUXyND5yJdW5HTnoOPusSo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6756.namprd10.prod.outlook.com (2603:10b6:930:97::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 17:53:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 17:53:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: propagate VM_SOFTDIRTY on merge
Date: Fri, 14 Nov 2025 17:53:18 +0000
Message-ID: <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: bf4314e4-bd63-47ef-5cc0-08de23a6b678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kDxDMz/Ch5mdK84hIjPPKbU686rk51NLrSm9/ZZrVaFojEi3QEZ125dVfAZf?=
 =?us-ascii?Q?2cKB0UkpugnT333pBwJajJjykJ66v+d8VJFebn3gtHGb8+xcW/4QsquBrZYI?=
 =?us-ascii?Q?equWBRlBb9TWfwqKZHo1yjc9h25JZvhBaPNSuBtOgE3ArtA4+xTQC69ATVSi?=
 =?us-ascii?Q?BoIGKzSR4BMymmYDU9aF1+rusjjtfSiIO7PVa6ZQOHUGYlounetY3qU8vRzJ?=
 =?us-ascii?Q?wMAV/18jz1+dVbmhzLxtWx1TDRIlr+FwXl0KTFzcJQBV7OildXfnnX/RHIZ3?=
 =?us-ascii?Q?zEsgmd9LBn4x1OtakDbsXcW2NPK0hNsH7MyGv4wjiFsBneX9o2PVVTOoNTQ5?=
 =?us-ascii?Q?BFD3GcxgErQXsGRJY17fU+87IREiMEKt583qEVHo6BLyx8G5+ONo71gEDSrK?=
 =?us-ascii?Q?D/Vy+Jnzk6zTpgqUB0fhV/dl8eLJPmTgDJQBJdPXCI2ImjH0p6ULA3BY5CwA?=
 =?us-ascii?Q?v86VyG7oxMOiN2lQJ8+O4COWnctiLu6HrfODoeFsWYwx2MMVNnpI4v7PRF79?=
 =?us-ascii?Q?ww/HVOsKHu1AzrTGsK+Q+BfwkCPbICQjHy5S0GS2fDxvclcQUddKubCnsU1y?=
 =?us-ascii?Q?1yqluyc8wKAj7uOtCS7kfTaeXu1WHb2C0Vlxe5wIN/rca+j5DjMPwF7YAhDa?=
 =?us-ascii?Q?zhmtHE5CUrzSVGTySIZ0sQSTWm5AknJQuns3Zn5Htj2ua7Z+leSOiCnPgK5t?=
 =?us-ascii?Q?wlTvWyF8ikWsdJIaS83dhFlRUejXVEkmy/Ywd8zDk1PPNROZHm4jJjbSeZiB?=
 =?us-ascii?Q?G1g9lYrPldeV+G8bmRt4VdCyJyTqAcfPwzFS85b2m1VHjC3QvveBcoFbjXU8?=
 =?us-ascii?Q?YupOYfnOlOOYEtIpLHwBdfsoYn5m3iLUaAE0kASYtUEfyhGc6b+so3SbMUDH?=
 =?us-ascii?Q?rtPRMwXrdmhVQV94L5kWyolmRxKmgTOAra1O60e6H62ikIc79QM38Eq7hrLn?=
 =?us-ascii?Q?0KZ10YkKNgc4Iwf4Tfip2VERJD9tsHTUqwcRzYN0hCEZcWEz2SsDh+zDlxcC?=
 =?us-ascii?Q?aUI+tlKYP1+CldOZt5dGIZhIq0In2zyZnsNO6enA207eqAcEoFyQ9VWaFVuR?=
 =?us-ascii?Q?U9zBMpRO0ed2/IwoVWThK4opuYptcX2doABA74FNYMi6+awK9dOu5HfQsjA6?=
 =?us-ascii?Q?W+WCsclVBTKMhPfnzrocppEMgZadV86lTkAOSHHkMjlUGpWFjOcJaREAN/7a?=
 =?us-ascii?Q?f9vydi7oo20sY8VX1XvVQuVfKpctPhvS8Me5lgH0YNHPKCW+qKqfWNwpRRKz?=
 =?us-ascii?Q?UqfV4lYYX1tTJ/+AT5R787g/MlNEW9LofrPpEzKP0if8yDMT1Bj3vEwUgCND?=
 =?us-ascii?Q?zIV6EImrQEe/fRdecC0v0oENjuIbKGnlQcKyvWHLbu7S3Yt/CDTfK26go9BV?=
 =?us-ascii?Q?5CkNmgEe7x2qYcVFCxfHmfasgwYyW9XWPXxBO35H4AZEjwuScqio7L+SmGiI?=
 =?us-ascii?Q?r6iZTMW85l+PpUYx2aPdxudI0eJ61FyY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FqKr27K1AlbDMKfkAdj5kSApO+mS5/ZzfEwzXB0OX+yxHxGeUi9gv+pYA8zA?=
 =?us-ascii?Q?pvM3QQmTrt1QCBSIaHy2AB0Ff9OsdKA1XnLY2GzTR1hFyHU8cjOHmUv+/yIy?=
 =?us-ascii?Q?luKOVGF8z6Hnjoktd3x7qE9DVgaUM+aJ3JYxbhCtsJXtEek+esVy9vCr9+uN?=
 =?us-ascii?Q?Mwt2u5vbP5TnT7Suj73LPW9NHzXUsSqNKDNP6YiedTYVrlHvJkXQIW4jNBCC?=
 =?us-ascii?Q?Y5PhSgQyIFkKThR4MRQBUnmiuWVmJu5wBQfPnsVEF9a3R9b6VX3dzRFuBhmG?=
 =?us-ascii?Q?jZqNcJQoB93yQX5kPVDA9XIlyqo3uWER6iPGMM//bCk9oo/1JXMgCVG+BEat?=
 =?us-ascii?Q?qWK0q/TeRJNJbrmZXtptoHRgTJkZSaQVG0hkx3TN96lyvBAFl+IyE3XciyDG?=
 =?us-ascii?Q?wqCN1QWw6xUUFaUgetNmssUQ4kI6FNEMAv3mELMlTl8F3/JSIA6ma/o0sBTc?=
 =?us-ascii?Q?KApfA1ZhMxDyLFcQZJs5a3bt0G/Iawc7YGI6OQ8+EzMt+y676YbqogN+l4va?=
 =?us-ascii?Q?rvU1yHPfSMGu7tgdU0w10Bi4L3gRNoGHUAUC+KaHz5LpbkU4bey5YN5SdVxd?=
 =?us-ascii?Q?GMT+dzLSeZEdTeDsbJoljPqgS2Ld5ix/B32YJXNNJj/6Z3BUjbJ97GRkuzOI?=
 =?us-ascii?Q?4bPzNubVXGitjycvxn15ggxNRzUXIu6gtmJYIErDSbzAV1wgyv+QBebVcv2o?=
 =?us-ascii?Q?hm0NQ5XX1iFig6OO0yhs5uRKNn8GVt8xD0af9Crod5qSCCP0Xt/rXCbZTqJ6?=
 =?us-ascii?Q?R2e+p/RFxW8Z5ynANdHaWL8v8k9hDvQsoREFwiPZBAxLPWah50iWyGdlnX2p?=
 =?us-ascii?Q?0uGJ/f/E4q/fBTgkaIjHNZfkUg005OS1I84w6L7/NddvsQ451dsgJO+omTNI?=
 =?us-ascii?Q?IvOZNFqU9tskKFOTGeq595R2Gi6c2y2ivSBoZ48jPl3YMs//FExEQaI7wQTu?=
 =?us-ascii?Q?dygAgZ9O11j8C843VFsA0EhohCv1vxfVviR1raNAGEW04hp2ApVnORzCu+H1?=
 =?us-ascii?Q?3fL2aXsx/NFiXi8dhfxs8gziNDQsYWlAu/4CzMoSK4d1nhsNoydEsd2GKnTk?=
 =?us-ascii?Q?qNh3nhG6q+CA1qov0g9IO7YMTLM5Ys+8OjhGU7Md5rbaKnhlYQu3X7vSQAQ2?=
 =?us-ascii?Q?TSNmMFnufvcva00QyFil3F+2w9vlZtvCejtLiTHp2eYSPXL2rPDJ5cXlyIso?=
 =?us-ascii?Q?F3Xc7IRzlGOhxZ/UkJALDwtaLUY3hIzUqh5EJfSbT5XrTSD5G51Y5vuz2xbu?=
 =?us-ascii?Q?7POn4T99/+YyHKTVch2VRpSP/UUXanPjj8/y6h41w+2sN/CkQL5BPlt0X5EH?=
 =?us-ascii?Q?wp2JL2AzEr7bSNdcOJmDgxzyNPsZhoHFBYErJO4o4edxxlBVtjgUpcAwnvBi?=
 =?us-ascii?Q?t/fqppbtSB9Vf4uZK9gv7IG6wxe0Qwbu8XcJe+IPodJDvYE10Pb12WbUVJWz?=
 =?us-ascii?Q?7rYJIkHTnKJBYIu97hjPoaB9MXgf31Dn4tjEAm9lQPJSCu1OqLOxp1ltvyID?=
 =?us-ascii?Q?GqX0tmvDjih5ivRFPA4GxXxC8mRrOQO4GFDmaf3KSROtqLFWshEyvbKlBTmN?=
 =?us-ascii?Q?qIkFxC/ksSo0J8oCJcaBKQFoBiyLcfR9bLE/6iNTbQZ7mTzU6LOOEQQ0Necb?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PhppQ1xDEvvXRfofaQR3PUVuUNXo/jY9DPsoaq8zndTem8DG1PJhvCiUhg6iPh8UZeqe3t4LSh43E040S+Zos1/cmooiUuSyvkZKKn1ZqmIGbkBysvCxM0rxZHpPEX+xNeaJcJsUOkFOYjMiONHCtr0gHFoOF2UYo0RulcJg99G8P2SSJd8ca5YwQotM79sL1/Wgo4xFMTklpF/3hPLcrouoqXCIGtKcV7NzGDyk/BOe+8W72zvfKUBwHKfHSppnGV+LBJ7Mg/WVFnLnpbhsYANm0YDCnjKpj6do6wVD2ErhwzISs7JrdG/hV1e4yYFkC5Vo8JfEnGBOztNdfj0DquMf5UH3n//n2FuLESs/pH4W7TmJNvdCh5pE+obNamesjVXY7F88Xk8XJEbWnPEtnIr5C2i11uUke/CD+iX2n8cErJ+IAgGy8ZyUUGgksRGSsJWf0NtomJio7SHSvN4S8siaYqrKDkOpijYZE9sunfT5PqTm8KwQV17NAwBJ87qhaa8x2/KBbEFy5Br8rhdbReyzDrEmKQUGJ7TE8AlWSuVBRmC+w48hZS1Lf2WoLbg5Y0//ZwqeM1xRvLJKQgR+7SipPM20TNAm487HXj/u1bQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4314e4-bd63-47ef-5cc0-08de23a6b678
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 17:53:26.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20Rzfs4oZ4D9q2fEPaz6s6JDpnIQ26/YYHMoyco40Agn+aGZ7k49tW8keq1V8S/mpoUvkkZh313pNDTQbaOdvLWyZHJqvhP+XV0ZNmK5DvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_05,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511140144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OCBTYWx0ZWRfX9E4CjBqd7GIt
 zkONP4AjX4tSjiJrLY97u96sxt2lU0xr+AwwLfy7UBJbjYAiwB4snAWbLBqQm3h+Q/MQfZtNI07
 kcRdhRaUXbGi2gNE0lNVv1Pcdpphq5Ef7/d4EJ+FFrOL76Xyx5K0kZVlq4RLRqV8A3VSa3fo8qF
 QrY9ZYmEJr5F15YVTY03HILxsKrJIFhbR/n4tAZ35ZukAmTwSRi0An1ge8s5csJNRJwnY4tv8yn
 qH6eI5xh9xPGoZQy9++M44spSVbXSBnrtQGUej9jd3ea4L91LnsISwGMH35sZ+2H2oavjtVUbL0
 C9rL1Y/v8H9/nIrDx806AnNO0bPNbR2Oyt7xDN91byW3l263Mf1Buw7lAO9EgB1+Ff9kMcjMYcp
 ATk/pmLFAIfSiU0gFqcP2VQlL0xXb/s2OVCls23QDrvh0xecEOo=
X-Authority-Analysis: v=2.4 cv=WuYm8Nfv c=1 sm=1 tr=0 ts=69176c9a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Q1rnGyXiy6mPtF9hYIQA:9 cc=ntf awl=host:12099
X-Proofpoint-GUID: 3nUZ65-lzW4aOfDWTSARSY5UASMo1h48
X-Proofpoint-ORIG-GUID: 3nUZ65-lzW4aOfDWTSARSY5UASMo1h48
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 57460140012
X-Stat-Signature: 4r97a5kgf7s6q5rmidh83ajecxtihkes
X-Rspam-User: 
X-HE-Tag: 1763142815-386525
X-HE-Meta: U2FsdGVkX185CpN/Pv0ihKFKUqMP727XnRJcgMzGBtI/M15zTRfvrB2MJbfd6ILz5rPmG9v2G0UexFe7BTvOwtuLtmPYaV2iy22jhy4CZZRXxaJ44TIH7owMTG6RMGuD01nqm0ugGiYbLi2Tp9bt51yqzbwQ+vVXZa0lko/BIBVnUE7qW5jxFzQKdxHmpTJVeV1vtfRleiu1LF82rIeolp0jixsQlTtsjqbTmGd68a8PI7GXKOjvbpntqnqBpGO8RO0LPqfmKCtF4OEP87sjbLiIX8o7VwltMN5JgITZNENSFruYqZGMtlc6KTeh5wIhNX8Oxn2h039i8cJyY0awiVwYPLMLl2kD+zHfGF3ZJZEZ5DdzygWazyajcfYXiygRJ9/x3sqEg1DeRRgG+KfVX+RMgxes/xdgP3Oo2VIjpTRyoEw0Q06258oI8pLw58X4nP/X8AT06HvzIGlbpJsSTHuIOaBWJm0i/UHmC5EktMOL+Lz0zNMcv7MWC0Qp3PElntmW1U/fb0GEN1pfBDuNlYUrmG/G14OajssLjeYhe/Y/takCgorkZhpN7Hf/wvp2fLy2x8ym7YolJQermfKtbjcIlw9H1r92k2wV5xxYSs8l+QeOZisB3oAlWEeQnKRWWZDy9n8jqEcJHgJXPFZC12M7M4ncsfP8Bhyv3QbSGVbgE1ObVSC8603qLLY3O4Iy4YH+8+TSaSq+YhTvrGjokmm1lYQdxsf72cbvyX/5IZnGIiIAMCnMm0hiEtwSkJgfS1YJyqM7M+OokQzdMeIEKMPG92840e58Pj26DbbYdzQlgewDO+nl1TGouTxD4yfgOL4Yt0xt17JQCWZ7IZdnKmWI4pLpKbZsHFxcaeyF6V80poPZ9vxLCKtbJUdFdXpSsj4NLlYXa1irZQjln0c81HwGVYqhas+N2oCAihMegDF3xqny0kpkjwDkBiGpPH7H5Xy8X/2Vto1t96+sUfw
 mSWe7u8/
 9/pU7GyhmLpNlpEpQtVLMO7Vl/ZfN0CAyjZZBl0Nsm8JT0zT7WlWvpqSczPzg2ZZ6xzYexrlc1FQdZ5PEw3ToSYJUn7hPYCFs9GTnhHECXfKkf7pFMU9GvIEtSOor/k56XD8s9Yd5n6cPwhjbBzr6HVG2pil83szUo2EkP4qwlOLmGXp8/yth8ZP7HMVavS9yT/hrspOGfmb6lYIo3ytv1qxmx37V6cOztRjn0jhMOnHqAdmWWlIAktT0rNQQudGSF+R3Ozvb1Q1MGIC4iPDTCFl4skqoDQN9EAyq9nY8ggjoBDo6EDs2oQShkBWbiiOZMRYqoJwB82Gx6dYIZOBjYE2x6lUbvcUhourqBYqGwN7FYgTtRsp8Vq75I1Di9kLUv2zRFfeaIcohS0Zc6QjS0EGGiAK+MQzBJYcqZGoAqS4BPzVpVNJRxlH2TXMH5qcMOtvZQynSznL9S8LufxmuGXQxN9hRrJjqV1nQYSI6FWFtffPFEp78edbDyYCE7UL8b9wh+bb7jvLbgONfHAg9pufP3DMRJqBDkkkitUvW3e869xUhVHh5z4sqjOQ7i25gbhlkrby10btsmysgNxLM70ZRApl4PCIthv4Skys+dQP8RzopgjF0ZOePp2f9c8iQ6FOLFh22bXWCB54V2UtZ8J+cJPqV9ERSqeKollu4UIGJZ+5rmfxdzoCKPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

This is because currently we simply ignore VM_SOFTDIRTY for the purposes of
merge, so one VMA may possess the flag and another not, and whichever
happens to be the target VMA will be the one upon which the merge is
performed which may or may not have VM_SOFTDIRTY set.

Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
which solves this issue.

Additionally update VMA userland tests to propagate changes.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h               | 23 +++++++++++------------
 tools/testing/vma/vma_internal.h | 23 +++++++++++------------
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 43eec43da66a..fd9eeff07eb5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -532,29 +532,28 @@ extern unsigned int kobjsize(const void *objp);
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *             which should propagate to all VMAs, but the other does not,
+ *             the merge should still proceed with the merge logic applying
+ *             sticky flags to the final VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index bd6352a5f24d..10f46a95a73a 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -122,29 +122,28 @@ extern unsigned long dac_mmap_min_addr;
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *             which should propagate to all VMAs, but the other does not,
+ *             the merge should still proceed with the merge logic applying
+ *             sticky flags to the final VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
-- 
2.51.0


