Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C76EF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 05:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233466B0005; Fri, 13 Feb 2026 00:18:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E18C6B0089; Fri, 13 Feb 2026 00:18:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043806B008A; Fri, 13 Feb 2026 00:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E50206B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:18:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 597C65869A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:18:19 +0000 (UTC)
X-FDA: 84438277518.08.4177863
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12B7B100002
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:18:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="V351RN/C";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pv3zDg6a;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770959896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CSFwbHcjy6ywjUXnOCDKC+9D/ycjTVqpgiVAQn4DAY=;
	b=OJGjHD9r7EzqQYm7HKvTf+mjoHkAk76D6N7UR3dKIdZ+I54wV+I9ms+NjiGBIk2s0m3JDQ
	Y9CzDl7ehC/Mlz7pPornWfzvl9DWJXrMxeBcc9ePHZY0XQEiot/Y5zfX0MvNqrfYaqGFN5
	LZ43kChqXRWiNTFZnINZB22fHUZ/WE8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="V351RN/C";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pv3zDg6a;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770959896; a=rsa-sha256;
	cv=pass;
	b=RwufLfBLJwEFGRsG3tsL234wn2/HP8/qApqPaaj748/4tcF/gAd+DdAhu/pdojeN1IED7U
	hzti8sZCEsHlQ7GcungZp7jau52Y9EeO5urJ3uWOjhqQaYVCRBj555HIZBqMJU3kPKywyn
	rOzdrvxmfX1VSeFj9zhuCEIVVXUruq8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CGNcnu948770;
	Fri, 13 Feb 2026 05:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5CSFwbHcjy6ywjUXnO
	CDKC+9D/ycjTVqpgiVAQn4DAY=; b=V351RN/C6JUlpfR0oUolfgvLxXHBdRBvZP
	CbzxIPhjnKk2A0cYuOoUJVVwRo4yRA53KyO/Gn/tW2LJDTZQh1Qer7Hqb5+YZ0m4
	JLuhTkjwVIcPObRM80R4seeuJ7BW0X2krAwiIbLR0FyPWkooawo24IOeutPCB1Pw
	5f4QpAEaH/6Y9bXXiZuudjSJ7/i17SI0gLWGvfqlxGkGjNP83gBGS4zRFG+k50d8
	tTBZe9eCO2z4WlFpqVqUnghA6qCnJUKfgSJxzYQpDowgwTgpZMNsGSxgeBxZ7Bzm
	NBX1PlHHNOsFhR1/7G75EkUDPavLP5wUkt82Bka2sfTpWi6fkEZw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88n7mndm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 05:17:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61D25ElB033687;
	Fri, 13 Feb 2026 05:17:48 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8248kvcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 05:17:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qb51umx+x7cskhI0wGbawDLv0Cfm1wWIxopBCZoA54W9lXWrwpxW1W56z5Yi5w1wt1McFYVgmvm6cW4CwmRIq1iETRNi+0rKAqSjjxGC3BI6+qUBIYP73LAeTgPKf5O33HODfE3cD2pEy0/2WTDmV7HwQJK33Nb5WmPChiatoOfRdarW19IxsjC03zPPkIB6YaHXhWY9WiW+HqnIfowDw0KsHuGeR37BuFyRr98KJ4TcP526V7goEBlLAMx/HTH5q5nM+BHMFwQwiEOynXYUmuKsfvKNdjhRVY8kRBKpLWCLaeypaPmv+9WZLSqrcZbhOtl9x3LpAI6vtfBL5nZ0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CSFwbHcjy6ywjUXnOCDKC+9D/ycjTVqpgiVAQn4DAY=;
 b=ADUtJpCx+ojKO8b+7DJjRlaqvQNcXKfqwGlytH9fLoKN4xJfHgmnCoWFEEjnJj07sF2dHfkP0p5vQycpaFap0w4UOcvD5/yL5WRz0g58tEv7yfVPuEcQ5S6KwvmHqyGQK6DsLaEBnWzl5gapFA01+uznsdP5ApEg3MNznG7XeSHWbJXznK1dB2ttOcg82FNPrnGNa2oUsE+0fbbnl0rsAzLyVLjw4KZPXS9wgfNmLqNGMvW1lHj+1D/C+AOjUtNXHk+QFryF0U1tE742296KSh5nOhqebfrSiw75oYCtVz4a8mn2eUa6F/6Hu28sMkNQTti6BHkRFVeUE82ISILE6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CSFwbHcjy6ywjUXnOCDKC+9D/ycjTVqpgiVAQn4DAY=;
 b=pv3zDg6a+K3chtw6RKZOIXP4+M2MgoTKWYu+jyxoCBm3SxJ2/EZecesN1hd3n7JjCJ9QE7L+ufkJTYq3waQdNj+PKqCiyKaxEg4zFArB524IZuV9Am6kAeq/jgzoGmmYEE/3RvY+KzwadOKJFCHHazebvOsUYd2ctriSGlJC0R8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPFCC6481C4C.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7cf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Fri, 13 Feb
 2026 05:17:45 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 05:17:45 +0000
Date: Fri, 13 Feb 2026 14:17:28 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Uladzislau Rezki <urezki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 1/7] mm/slab: introduce k[v]free_rcu() with struct
 rcu_ptr
Message-ID: <aY6z6GEi7IXQ_XuG@harry>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-2-harry.yoo@oracle.com>
 <aYxXE6CC0XQr1KNK@milan>
 <3b9be1ce-ef00-481e-b36d-5b843be55d10@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b9be1ce-ef00-481e-b36d-5b843be55d10@suse.cz>
X-ClientProxiedBy: SEWP216CA0132.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPFCC6481C4C:EE_
X-MS-Office365-Filtering-Correlation-Id: e58900af-4786-432e-6cf6-08de6abf3830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U2SFhu6e/6teBV+jqcan7NDqR9XupmXS3sfDrMq/zhDoBwL0vBc6saSJOioT?=
 =?us-ascii?Q?4gzmjpkOxW5C2yfRG3idDlBL0zD3dHHwMwUU4Djhuw8rOAvF7PcKiHjuKkfb?=
 =?us-ascii?Q?jPNyEVjGxlrjQgYuWiUWKR1H+a+ElX/UgSUbM6xIsMcYfDnAjnZXEo+9O7hn?=
 =?us-ascii?Q?fm4PoeozDIUqAWkyXwLDJrGLsEwaPt3HDGDFvNTsY5ILQEnhuU/9Mv0KQuuH?=
 =?us-ascii?Q?uYQ1HJ4FIbZceSaim6EYLL1O+af5vEOuruQ8H2MV3IEzMc98wtoxU+PzCr9D?=
 =?us-ascii?Q?WogkWF3gHqNRwzIcCRkOrV89IsA2WN9xQHc2GuJjnqbNr+BFofOg41yZnBxs?=
 =?us-ascii?Q?GBHBzE91QZNbGDWRWXYxyUUO5CENjonv0vepcS9O8tUk07v/L9bIAr3anXiR?=
 =?us-ascii?Q?I2YLsvZXsLtpAG+ebPReKty6afAjsW00gHbMSGTlg01eyhChzMRbhb0Q6FMR?=
 =?us-ascii?Q?dBOecZ6JV0BVthHctwBci4bNazAtPivrOM4S6h9urB/e3klqFsJqE9egYQkg?=
 =?us-ascii?Q?4n3sC+tA/CX0GmXqHD5240IM1Ui+BVi2qP1AnvhUKDeuepPeMnqxwGgggX1D?=
 =?us-ascii?Q?NmR6vSctp9aRpb6aPRO5WnBQ7HBNs9PvjdpdmP1kC84B6IFs04b+Cc5HbrTO?=
 =?us-ascii?Q?U2nurShcf8qY/3jjzh+VOtDshZPckrjrpJ1R+HVGHNT3tpBEhdKv34SL51w1?=
 =?us-ascii?Q?GUquk7LUYm/TdLIN1SNgOFEr1YRPEpb+u7zgG2Ca08wyMlCHuclcL7y8N51A?=
 =?us-ascii?Q?RrPX+pyn0DOwLH6LAvTEqahDkMw9zE5ySCWWh2c0RXBJG3lNTJqMeoVH8fal?=
 =?us-ascii?Q?dZwu6qvZ3kU0Ei74ExEeO8ciBcEMCL7SaZUdqBIMpB1PezisUjzK+rIo+9jV?=
 =?us-ascii?Q?zM9bTLL2kafA435Gu5zXOSOMd+lNTSP7To6qqPnwAJRxcoZFLLUtCeYjVyVW?=
 =?us-ascii?Q?f1HvykHL40StLh2FyY7qxTpoPt6yoLbDT7tij34It4lDZyajkkHtzytOqVYs?=
 =?us-ascii?Q?r5MkDM16XCTG6/nHUFs2kjrKJA4TKMbX400KcfWHKfnidBve2g7ISnNCVbuq?=
 =?us-ascii?Q?Me32U5rLYbLrCJSEWnX9Tm+RkBTl7OUNjbXTQpNzErvQWaDY8Qag21qJtKSk?=
 =?us-ascii?Q?ueR89AoSnLwnpwHMCraDxCa3L0keszR3TKFK+pVc/dE5OCQrW5CYixRQLiOx?=
 =?us-ascii?Q?vbA+LZJZ7rKi02B9RCEJY5Cdp86gtuFWzxtH28+PYjlrlRioxcrl+aDx/i0G?=
 =?us-ascii?Q?vwMNYUBQasmdfV21gRD2UQLvHrhxag1Tq1tdnuxtvk3KtFVuQghvC9cbFwXC?=
 =?us-ascii?Q?jGHlDWoQ5WB77Ybdv+y8NgF9cIz1xXDlp62/i023awaT39VpaKRMq718MlRB?=
 =?us-ascii?Q?+RdkyjgpM+gPHfI/WU04XWYMjG9nIRZPnU/xdKBl69GTNQp2Zc+UVODDgqGr?=
 =?us-ascii?Q?L/OYEubok+K+W7iCG+4ePrGKAXoUih71VdeDYs0uhHgh6n3QZ3cLUkOQs76N?=
 =?us-ascii?Q?967yk6Pl8dQ/oTufQ8/A8bSMlK+xlqhNilKzgoJauHx6NaT/8jQ1CVI87kdw?=
 =?us-ascii?Q?cUlf63dqrd65ggGE0FQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QsU/RV/uBPrdiWp7Z6IQBmXG5F8ivbMNJptQYwCT32NNePlVEx/djkJN3E0W?=
 =?us-ascii?Q?MMI0GdkNCN/u2y6JK7xIfFDmX0Oo7OOoZBDffcUQ+dPZWLWMekmPBA5UB6GD?=
 =?us-ascii?Q?Ez1x5hQNsrDx/ST0uqo9KB86AhzMO33JxEEaK8v5ZK1Lyc1fCt6FI38JadvH?=
 =?us-ascii?Q?pb83mYJFTwYim+inAhKfP3W7DHkTqTQlMYPyR5uPA1HljJbkmapzPIZrX5FV?=
 =?us-ascii?Q?b7bpxhbhFF/Laa1BHNCIhr43kVB+eylj/FOqENpFA7fZdy+PgkMC/x6LgXbO?=
 =?us-ascii?Q?GFQXcdJVt30+S5bii91qt7YqcB+yUpDpYcPWg3kVWflwcF2WDKf77u2PiqdU?=
 =?us-ascii?Q?zYFDzpMGDTzmOkC4Z+w0FaUxMnlEe6XDmtK8yqTSaHVcxVjVl5srb4Iz8qi5?=
 =?us-ascii?Q?iqMOcSHd+AsYZg0gJpC/f14cA8zjc3mwVn/iV9wXg0KkvsmVO25aTch0MPw1?=
 =?us-ascii?Q?LuH+zFc1e8/QH3k+AFQYqrmxEHZ39yv6kQOD/UbGEGoq+Hx8nFzrDeM9/saD?=
 =?us-ascii?Q?XidMAbO3l0o7eOUFi3/aqGFYD5My2dZJorLxBoKgXiWUAeChFgN0QKxRF7Jn?=
 =?us-ascii?Q?JcOtHuLRGvgdhE0htdzRGt4E9BK7N0k1QNd1YoRZK0h7Zyqvo8NtkrgP/iZU?=
 =?us-ascii?Q?6gha0qlt6AB0AZBnmSAoXQVYp4y9yF8117JWbORn1VYnz0vdtRIljc525SMA?=
 =?us-ascii?Q?C07sDq/PCU/LHo7O19IypfaFKFbvLqTubj80dN80w5PKMzQxf77BEMfmqRIP?=
 =?us-ascii?Q?4+Ms4c2JhNrP8f4en5y8vBRl+uxR7MZ2yyXhRv3auVS3tn5bmQPtgVh1WFq6?=
 =?us-ascii?Q?avSxtpzEiXBSaPXY5E2SBhopXPcv2Qwgqu5T2F/H0Qmx/7ElQAaS8G818wau?=
 =?us-ascii?Q?yk9PeNjjmytbGAzSrVJTAJkTP4IIJAnXnAolrdqiU3k9EvxwmT9lx2D8HcZw?=
 =?us-ascii?Q?w7xP/LD12sS4++5jTHpODQUh2dv9TBwKGypdu9KMdBkWlScQPlQ/DkJco7lb?=
 =?us-ascii?Q?8nQIQoPiBfPl3mMnNzYlqEr2c0eOELygtQbdeKZHVJioLodPTSqahd/JiUy/?=
 =?us-ascii?Q?ctQuaDld/mWwKeUkhFiy1N88dpHooBNpUKFIrOtJZet+FLhqK89/fBazv/+G?=
 =?us-ascii?Q?QiI9S2vtNrJwQmpMpnJ4RywJQVy/YJUJVJ6AkitBSIKQ/082U10dzPRO6j/Y?=
 =?us-ascii?Q?isyIOnDMGX04p9KP9IS4ooNI5WAqIM5Vso8QXxnSSaRw2YpWSCsNP6vEeZG7?=
 =?us-ascii?Q?I2Vx8yww1yubApjPWEd1gwfHd1w2F7NG7pL+px0KOBUvHEAuXei9wFUA7+fv?=
 =?us-ascii?Q?vIxW2LqnqKiJ8LmVSPVTscYq2PNXShrt5pgAOw3zkK3zoC0ZaY0g5FKUmDox?=
 =?us-ascii?Q?6EXV6JFs5jUFlfI26Bp2KFGrQFmbdqIqXs73P6kpaRLUQAOXoGlwgVDv/EvG?=
 =?us-ascii?Q?ShBa9rL7/jGYTRgpEL33fVoYwQfxWslKThGd5Pns108BMa39/57zHwEjquBq?=
 =?us-ascii?Q?+9WsuJ6W/xKh/8gN0ljwLYbM00iqyI9wj8m4IIiQhzWIE8GK82yQ1Incosbw?=
 =?us-ascii?Q?tNKYXscQ4vYY2/2Opv5v/j8VyrcKn5MGcE9XwYVCQinSVON5k/mr8VzNBfTi?=
 =?us-ascii?Q?N2BDYE8+digUDRZSui2NTCkkIXvTF/++5ZDQcy/ThQXwYC9HRcfZL+IWN/r9?=
 =?us-ascii?Q?c4bwvFNTX2jbVSlq7iyKs+bpS+E7M7p5ZUtp905YNpDH+KJxszhBjTjd9jHd?=
 =?us-ascii?Q?xulB83aPwQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vBjwLocU5UeQFm82BTXpcVQmJq9+z/nMnz2rb222355SNW0eYKG9QWCVrHVrTpn8Y7+VmMgxRcxxvG07VjuONcd9miAPOV+DuiwMNxN72Fm4pbloiiO4y0FdTb3x9i+JcBaVn2ZTfWJIe+s9A7QbDPASrFu8DDILeTR3ci5rN/qDECFOc2PC9SiGYjTQAcNm/+H/BtIKMiAq2AbNUluvvwpY8bQS60W9X8WSJPfqakbfIWAgforTBuLgM6BgD649qsraBCoSqx/KKX2AyokQdj3+bbhYc/I15DMDpzT2+SNtxjCnx7bET6AyAOdfhqOZxS9eu5clzRrfSTQemwcDH2NgPFmsYc2NlsSEkGiTcIYR/D8NQ0/cye+5icgTwgOiHGtrdqqMcvJaKDGl/I3lKdB1u4iTftaQ8k5Mdq/twE7hWSpiWNp0AFZExXE4udC7eEeiOj4aMd3JQQ8ULa6qBIQ7TWhFx4rgzDgJEnyI8TqGEA438OSpHD9VVWSFhFKhW1R2UzAAwIkhOpIEkRN9JPzpkgHECMIRxXoAetP9flbU/M2b18stdB+g6QrYvLXGSpuDkSAw2lOIyDHRgE/o1aH6+8WYwzifhIX0d3rQsZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e58900af-4786-432e-6cf6-08de6abf3830
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 05:17:44.8823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JAY2FS06U0eoHfWkCjNa3GkXT/rp/roXRhXDk582cFhnRLjM+rGMBK1X33cPhNTtUybTlOebw4rdTnFbKz0eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCC6481C4C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_05,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=910
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602130037
X-Proofpoint-ORIG-GUID: XSnI774Jf_x9WevY5ncUvq87wfpJD-Xd
X-Proofpoint-GUID: XSnI774Jf_x9WevY5ncUvq87wfpJD-Xd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDAzNyBTYWx0ZWRfX6eZyuJngwqDv
 qVDmZmf6jzMnCROV1aneXpnc/KSNvee+He4DWuAOTOw/h+YNoeae1FUBG4KzLS1gDMbTcV8Cw/x
 sCJf6bpy4PJDrVrqY6Y1B80LgMir5tTYGKTPdORLu4VEfexPsbeRoZsHcmGEez50ucs4f7cc4N6
 +Fu8QJ6bbumIIryPVFgee4Vfp3warIu6gbhXtvfaqdNuWxzPf8wGgF0+MmtNk4twZZq3jptvZrY
 r2CZTKF3XlmqE2VVCCTb9AGbSjPFU/76kgrdFI1jWVInhXp1YFBB595z8RO4P2aZx/0AYM2V0tk
 9eGMEpT8LCbyL0X+dCbk8RXNULNXj6fUEdf5fdhmBK2He/b2J7dL83A/lIPI+CZby7jmfBC5AaN
 lAeLRf7E8GyvytRh2CXsGzFVN+iFQkv8xqigv5YTMGMQ6JTYR6cuayHpCkHBH6ZT+jlhxasT0OB
 fE8aieSnHdDFbY7Cmmg==
X-Authority-Analysis: v=2.4 cv=O5c0fR9W c=1 sm=1 tr=0 ts=698eb3fd b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=viN5hBHUxDwx7j36nTYA:9
 a=CjuIK1q_8ugA:10
X-Stat-Signature: n6tyxq98mzothz5k1ued5jmekobffre6
X-Rspamd-Queue-Id: 12B7B100002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770959895-817666
X-HE-Meta: U2FsdGVkX1+eVueIULWwJKZRjLTq7ZeScuVIcMlaf7cN7R2S8PWX3kuyi7FagFUZqZTNTrtbu9BSAgVO0+ObdlFdPgQ2Z2Y+OyqSUxYrkOHSRkIXrAR0CPoNUbmVxKVuJaycYbOFv1BtTwnEltiUryobhUeobKMW7xt7JXxsPSrlg4ebaIq2dtTrklysr5sfJjDTDzVRa+JhFHLGsWnbaef5rOKrBkESuiWVUZHSf8YfqjAagSeS+rW48Kp056GYewpTiLoyGwTlI0tjsRgczH+Cp/mjZFG/P0NDnL6uDdu43QU/PiHfxVfa3rF8HClwarosgZnTLCFsZbAtyCphqEK0SfGTIfpUW/oWAOa3EUjMqwW++vkyLloHivXqChUp19AlQByWCQlejTjfKn3ZUEtpql5L5mPKuJR+OT8N9MCb6H1CVX9aYUIpiAp5K8Hf/Uy1ZbVtKzDbSiQwjUSG8aXI7rGqft7drDf9cuBB4PEx1xMrEExcZHPKQIYEaHgk/5NezUL8vzrM7TaKoUw8sLufU0XcXUg2WxHJ61+S+yGHjo/n9R9rZhpPkyfPB06cuBvXTEPWWelBiB9Lo1sprX630AJSk0LY2OapCClWmxldUasOJLfOcmv2Yr1XgdxRKcK6pPFR0bQc6AymKfBu6xPKJ4NK2VArQxGKMqCZH07aFpr35Lenkd/EnZdpYhX0DKAHEqBmMgUZ+z5f7S9i6AyROt6IC1ld3HXFdOAPnlLrwzknhwphP9Uo3Vp2jwQnaLGNVihnTO92HZ0Xp9pIzX78TAMM4NiwEUbV/0AI8mWm7L48NX5Cs07PppN2qTkCJUHb39wSIOrqMVBa9WArKMfZNkvDA/Y7SBQajtlBEpwt2R7vMTPQTH848NXr8xCYoLtGnmYnduyCpMiv+ly0Hfo5ZDgc5E6Vn7hzcQB8CmRC8kgN5liGlE7OI45kpm8xhot4zdWq4wOpnrG+Zgm
 ZiNGmmXs
 RxoEAd84BfIL5KC43D84Eo7Wfxb880mrNkjV79wjTYLmj2QrfuS2+D8A8zqAA0hzWm0JxMgPSGQL17QQX0wwDHKFI+Y9Vgoyg7A+OM9Uh7ZjDRT97pw75t8JG1RE1fCHjWWv/Ydsy+2UI1U41xVKvqi15QkAF8eYiXXZmuDwnrPUv1RtwSZUoPIbAaDCb+fCHdAp/HHbn6AAAyJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 12:52:46PM +0100, Vlastimil Babka wrote:
> On 2/11/26 11:16, Uladzislau Rezki wrote:
> > On Fri, Feb 06, 2026 at 06:34:04PM +0900, Harry Yoo wrote:
> >> k[v]free_rcu() repurposes two fields of struct rcu_head: 'func' to store
> >> the start address of the object, and 'next' to link objects.
> >> 
> >> However, using 'func' to store the start address is unnecessary:
> >> 
> >>   1. slab can get the start address from the address of struct rcu_head
> >>      field via nearest_obj(), and
> >> 
> >>   2. vmalloc and large kmalloc can get the start address by aligning
> >>      down the address of the struct rcu_head field to the page boundary.
> >> 
> >> Therefore, allow an 8-byte (on 64-bit) field (of a new type called
> >> struct rcu_ptr) to be used with k[v]free_rcu() with two arguments.
> >> 
> >> Some users use both call_rcu() and k[v]free_rcu() to process callbacks
> >> (e.g., maple tree), so it makes sense to have struct rcu_head field
> >> to handle both cases. However, many users that simply free objects via
> >> kvfree_rcu() can save one pointer by using struct rcu_ptr instead of
> >> struct rcu_head.
> >> 
> >> Note that struct rcu_ptr is a single pointer only when
> >> CONFIG_KVFREE_RCU_BATCHED=y. To keep kvfree_rcu() implementation minimal
> >> when CONFIG_KVFREE_RCU_BATCHED is disabled, struct rcu_ptr is the size
> >> as struct rcu_head, and the implementation of kvfree_rcu() remains
> >> unchanged in that configuration.
> 
> Won't that be too limiting, if we can't shrink structures (e.g. BPF)
> unconditionally? Or acceptable because CONFIG_KVFREE_RCU_BATCHED=n is uncommon?

I thought BPF would be the primary user of this feature, and I believe
anyone that cares about BPF performance / memory usage will use
CONFIG_KVFREE_RCU_BATCHED=y.

But yeah, if we have more users of this feature beyond BPF, it makes sense
to reduce memory usage for CONFIG_KVFREE_RCU_BATCHED=n users with some
complexity.

-- 
Cheers,
Harry / Hyeonggon

