Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D98EDF020
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13B26B0005; Wed, 11 Feb 2026 21:59:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1506B0089; Wed, 11 Feb 2026 21:59:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23916B008A; Wed, 11 Feb 2026 21:59:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A06736B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:59:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D74851405EE
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:59:28 +0000 (UTC)
X-FDA: 84434298816.14.6748C32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 921001C0008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:59:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ra5XWimd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aWMdPqaN;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770865165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwOuyNXzTpfl6wU3T0pjeqZtVBKQtZvgL4jdgT8MR/Q=;
	b=a9jzhEQy6S9zzjtKOH6l9FPmzgOsYnvBkBReedHCsuYGi6s6QcNjDJqXJTQ0NxWPI0zsDA
	jYku8eweQEmd8HwOz+r7Yp0v1pPIAnuk4JTtbf2vNItvfew2vjl2aGqmJpgR7GFxZoNu/X
	8CG9cqcghTzUVFf3TnbVT5nkFrCL4A4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ra5XWimd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aWMdPqaN;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770865165; a=rsa-sha256;
	cv=pass;
	b=oXdhKQlmDo9I0CMNVD3nYLlVR28PZ6jn39LshXq22yAM5GBfQ0aPmZsINswSUuGKjULZ/1
	ixIzDf8CaAIErXcJ/ngt1b21Q4nVkzdjOI1zs+kVRc/GN6y1VgIESXViJa5gv6JldKt0ed
	+8mKJE6Ji3UsHpWoEfWnALRbK5VqVr8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C2Ckbi3840221;
	Thu, 12 Feb 2026 02:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CwOuyNXzTpfl6wU3T0
	pjeqZtVBKQtZvgL4jdgT8MR/Q=; b=Ra5XWimd9tURFtTeovRDzZtHG9nvr5YQjn
	lxmg4Y5BS3utTOw4jYDdZwO/3JCcKm/HkeexMaRxHSZZMcGoL0ydoxf6Nh00w86/
	Hn42PoUhW7a+1gRSHBcEK53XBUHASmFA5tW4YZtxj6sO9ZtnJdO6nRT2Vv1vxQOW
	K5FQwedpFk6cQMlIObZlL3lQZ9nI/MPLF6haQthwQfNiF8WvtqcH4+UCPiTW4JZm
	Cxwl3JAmF2gv0Syc4sGQyG8SAbxE3z20cAWDEQuF7z3fHWFRdHHWpPxMEIOHFnod
	aTnKPBBKOHIJ2kBQp7lXZm6v0eF7U7K3NKnG056FfY6XEszRGN8w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp75u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 02:59:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61C0UEg0030032;
	Thu, 12 Feb 2026 02:59:03 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c822acc1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 02:59:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ANEKMNHpUdIuiH4AzERfh/MoJb0QqAnhudNfIjI5xiMnxsSaveBisNRJ2vj1udAJn1AXG8y2k9eJs0cAJD5EyRHNY6wc16AL1RVLi8y1tJQm/f2WnI57dTwEwTmLkKzr6249bJfEFDfHqmctBzcDg4ka7hk0+jdh3Se4eJ+nw+5PnOLblIEsNpzPmZW0RjZKDRS7TeciRvJxqYMBbX56hpxX4WuRHC+Umoz3M3+X/Z7WymiCIpn0LkOxjn7hL/nfkCKOALcvhqUkQMX7B8eFulTE5arr9DxEOSoY17CKZNlQHEXjiLmHeRV4Q+ISLpVUvHrWxRCDXMYuFB6QVeb2nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwOuyNXzTpfl6wU3T0pjeqZtVBKQtZvgL4jdgT8MR/Q=;
 b=VYm8fNURcRh1XRObObq6RLJ3Lq+gJUT29XDiUme3H72sfHYNteO5iLYNoAm/FGmPTBdHovcJp344/iFVVd2Bv8s8Rf2iavycDJj8Theh5tH+kpvSOC8cSVTqFhwU4vUwjHbC91Sw7dVB/H81KRjAW6NISkBZW4BVqxeXZ3S3efSxKdlqYo0rAPCpscHVUyLafYQlZ6XfkMF7KoBT2iqWCCOzE+j7VFUs799ZWx1gs+Mz+EsMGP4We97F1HqkLSLvqDHiWurVmIvwJjzMJUxyHVBBA50gdXZJS+WL98bihhro1tmiZWGE1Lk7qmkDQ3uqfmBZ/Xjkh9PSx359EYGi9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwOuyNXzTpfl6wU3T0pjeqZtVBKQtZvgL4jdgT8MR/Q=;
 b=aWMdPqaNGCll/9Prj4y90D/om6KQRNaXcyJ9gGMqBNciHuzCWppgVcOlcVvtlo8wEjSQkTw/xR2iU/Ya8q89Xga+xmEuQLxGUYMxXUWprSCl+CgHcUpzp3iKYvheYMdUBtltAB5wGRy6Hbtc2IZgYH+ZTJusE4VTN0JXvEd4eRQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7133.namprd10.prod.outlook.com (2603:10b6:208:400::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 02:59:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 02:59:00 +0000
Date: Thu, 12 Feb 2026 11:58:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
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
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 6/7] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <aY1B5l-_sSyIEP0J@hyeyoo>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-7-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206093410.160622-7-harry.yoo@oracle.com>
X-ClientProxiedBy: SL2P216CA0222.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bea8530-38c6-473d-f87e-08de69e2aaf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M7YItHznbIqESipZH6eR2wb212sOP8xhDrlxets+2V0vNLD/NfhhvE6ENhzB?=
 =?us-ascii?Q?9sVj9ORZAOwraSS/Fq8KvdRLbnLVXcZqUvEX9QYOPGkG4EF86pK9DRDQvnGn?=
 =?us-ascii?Q?khyz89hA1VOnh9/WPcXoigjuBQ6VqvkzZgxi6vD/oRU0cK34z6Z42xyR4LTl?=
 =?us-ascii?Q?0nHFicvusDNazdpaHIIxtZMleAPKoJG8WwFssdNmhTIvLeNUC4Nfx6mcSIDP?=
 =?us-ascii?Q?FxYH9yOgAZ9DjPMx5dRlwVSujw8an30r7Lxdv00bdv7YKNAEdZnbYzepmdpt?=
 =?us-ascii?Q?Jz8vv89ObqsxAKH+IrVxFJKwAyKR06a7/W9azKqixrzVHsf1R2yOzuqDYM3C?=
 =?us-ascii?Q?0qE25SsaE2KLXC+v+Ulg/45aS/Hurd8BcJIAGFlQfx+j0sx50aHfy38Q/ZIH?=
 =?us-ascii?Q?I+llgtvDJn/OWzgixkY8myiiUE+iU3ZW7ZxOxRCAOuFTbiS0T5kHDN4RSdWR?=
 =?us-ascii?Q?3nkg7rRgOUkbd/ez6PjD+h6lhTPxDbi49XtxYFV55tMW2tJo7q+eHqIcb+1r?=
 =?us-ascii?Q?9c0jY8FywiPx/b8BrXQTcyS0YOLihgGFXRtWYVeZXvVD/0lsWET+Z6S2BnEm?=
 =?us-ascii?Q?S3gr9GMNbbiKZyzpdBpcyf4gJfF+dZfK//BeJcEUNjBvkhWwCKWdgOV5ZBWj?=
 =?us-ascii?Q?5pjcvyt92yPZmmGU/DvrE1lLgdX07nxY24+CNMk6ESQRYsHPjOfPrkNfH9eT?=
 =?us-ascii?Q?jClTSgEYC6o6bKYDFblw5Bvt5+bCi9ZNr1uS8veYem3/OkenD2RICdVTev5P?=
 =?us-ascii?Q?STibFcTSd50W0B0kIf/uSRzhvWzCdM5IFfMZqEw9mj81HRZc7mZFSIvRw7hc?=
 =?us-ascii?Q?jI7XRICXSoFtQDz9Rn74r4euy3eRg9atNKkRZhmw+bRJYKvss1iiZvYAa7DO?=
 =?us-ascii?Q?6VHC2nJs2npWQV3klP0w53283v04rpgUPDaSJqnCoLO/7gwtJ3uCG6eHKPTp?=
 =?us-ascii?Q?GK0eWCiKmr3B8WS/+SYPGIr3iSJXyLvkyecK55auqc1yYyTH705Nis+Z84Dz?=
 =?us-ascii?Q?EjXihULS8XLJi6VQbTaAY/5WCnkPPQ5bAu8R2q5D7sxA1b91R6ET0Vdiw2Dd?=
 =?us-ascii?Q?7wUKb2hf1A92uEX5I2pMbhrTSb2DaCrrshJgAWFz9g7q3FrmpGA/xKCm+2rn?=
 =?us-ascii?Q?HTGwwMY8j4YiFTys836R96My2/rbR6iFugDJdGjRiSwvC+xhXtQFifecFbiQ?=
 =?us-ascii?Q?dBVWl7fLt28McPYBmv5eyYM8irQUn9l42ireQ3Y+ez7PA3N0m00ijXt1hC5j?=
 =?us-ascii?Q?FzLA5mvpzPYOx/jKzNOAT0poRSvmUUrHVewv22dX5FlESnl6netnfjlI8ERg?=
 =?us-ascii?Q?7o+noUzgfycCVUYBsg/C0alV3r1OLNs248GqFvfCqrl/LAquD4OlS4QOoUYy?=
 =?us-ascii?Q?YtDL/9qxTpxq6UxBOQCnY+YsrOi8ZDzxEwiUfJId9OqbYgnpCO/VsLzwQ7Tu?=
 =?us-ascii?Q?w7HfK6HWVUA8AolUpGmFnBqGLEguUk1gS1mfKk8k70ePmhUWH7xdR3FhmRLt?=
 =?us-ascii?Q?05JCV4nf0KGYTaJz9RQrrUyxHqC3VPu3z+Xj2c4lvdq6JUhZdvwueMW434OI?=
 =?us-ascii?Q?u7htaKd/DUGFFttulf4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lTeZeQg7UTngB0ic/3nHrtG/AsG8Jgu7LEBoxEe4wjcOTta23JnZhXq+7z11?=
 =?us-ascii?Q?BULuEhV3+eDXIwKR1oMygofs0Gk7dc23k+qM4mhh5TfvxszQSRaq0qAEQr13?=
 =?us-ascii?Q?ZlI0ZZGpoZzPThYOJAMeTW1Sa3rGuqoSCNsgoJBltY571NGnVEDL3nj0pNJJ?=
 =?us-ascii?Q?qIik/+CHtNKVKiYa3abzUe7Bp0SNS/WqpuRzSvTEktvbWE69qZF2SL62ihI4?=
 =?us-ascii?Q?frCI2n9jOY2SQRMqTOhENMUJSiGfwpHC+QJnqOvSJ+7A8AO67/QQFbR4jloj?=
 =?us-ascii?Q?o0Tw1dtmPwxllF0kYw0XbCGZOWvODl6PGxqCLuBaM2SEr0O7chNRxv8R9Ugr?=
 =?us-ascii?Q?Qa+hdVsCN+D6kSXN7Lph75OPzu8PGfJNIMggTFKBhzWtLZBgyKASdXuyJ4rP?=
 =?us-ascii?Q?as1oVVof8WoD2JgLJeMInulYEE8yf2Qo2hiSBGTgjLvOOLsmZUrE8HEfoGEU?=
 =?us-ascii?Q?J5RiMT6/bqIcwQAiOcbfeneFAF9WwbIcq91eBtcsIz8uRMsMYdkioAm1Hwy1?=
 =?us-ascii?Q?BsjifjjZskNyNKapXndeOidDhCI06d4lgF5zxbEQC1taZrFeTL+NcdA2vs2t?=
 =?us-ascii?Q?eNwRhGMwHXbnGFf2VH8F9+zKniUDUHwbztgfHgz+jFuFA8Ib0PL89rnipROF?=
 =?us-ascii?Q?er8LWn4RcKhHPDGemK70tE5t7s+VrpvdV0RBMrDiXEV2xNUTcIeKmjl73X/Q?=
 =?us-ascii?Q?2J2/VX8vJWQ2/9R2Zy1s3Mnh333MfYAeuh9PKBpDRf7OvVWCHnVLHRz0FMCZ?=
 =?us-ascii?Q?VNKhNYJHWBLlYUuVYxgPwCB92kGN9VewrnEigma7dOzMunhtumRSKODAnRvo?=
 =?us-ascii?Q?inY1DN9Rh8cqI5g9nUkMUozt/l6RaSia5LZmwHMCZ8jaWPPNAA9nhB52Nbkw?=
 =?us-ascii?Q?xdD3xZbpiPei6z+B26JHX/RC8noDv/EDCB31GCd5kXLy+0iVbOW9AQwgTP8M?=
 =?us-ascii?Q?ntPCmTyqiffLcjkIG/RJtki4oc1mnF9LoDdiuGFzJiGHeBg3nYh/PKpmV5tM?=
 =?us-ascii?Q?E8vFfcxlQCNZySLK+xJNi0eO+WRtWT+UPXpo/bDFFW/jMRTRglJB1dtXDkxC?=
 =?us-ascii?Q?Pft0AMwAZvoFtJrEul0Iopkz9lXZIWq3Psh5R1lfgH7GpIEnOEgc+j8gK3Tm?=
 =?us-ascii?Q?YH4+CMsZK+gYKVhL1+nVHuX5QVkjiE0/Rj26Wa/WpEvY/spxMzu9HuNnO27+?=
 =?us-ascii?Q?BbDFM9MYP8gM2aZN8YI02YKmotZ7+fYvoA7od8uoXfOCIDLW5NDW1ONYgzQY?=
 =?us-ascii?Q?YQwsAsy6m2l1b5GNGaHfc1U4dm2YBObvEqCeswc35b7/S3hseOxKD+nTZMUY?=
 =?us-ascii?Q?XZg9iNUXzggYDzGfpQfL22NfoUsVhaNIOiqX05RQ6Kvkcz5w1JEI3tlpa9zf?=
 =?us-ascii?Q?l6kkQ1JiMpYLq0NFyjYpXEm5369PuWYONl2vTiewmeyT4hfNRqbrvxlcFRlG?=
 =?us-ascii?Q?phZkeXvnAO4/01PHVzeo3vIaMKx6UHL8pLd0n8QnmK/RsVjNJZmNDOAOnMF1?=
 =?us-ascii?Q?TGOr8AiqWLqm24tueAUU1RdIFOSTJdwLhVvefBOt8R9oB6xKITYDYADC7f2r?=
 =?us-ascii?Q?Pm4E4HDsjt9CkcSqQ8kXkyLIQ4GUtFdrEO+5S70+Qo13y7AQlLR5ufAmChc8?=
 =?us-ascii?Q?j3dz5DzS2oDWCvMYETN4F3L1O3q8CzMrIP06iFVKBgjSg3a4X4q1C0WRCQiA?=
 =?us-ascii?Q?yTEIISgaJ1NT5EcieyllgihBWxhPNEjrp6cpT+k5gpj506kfipE1rAzsLdun?=
 =?us-ascii?Q?5VEp+wjF6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b1otpTH+gJdL/T5k2hDDwUd0xdpMLeecn0iYbELCG3hj4NwLyQCbQnlO7arg/X00cCnknFyP9fBDiGgSk2aBMkCk+plqGRG3mV4nO/NlZiIlij41F8YWr8Kk9GePbauLFzu4y1HfB/Czf12bpGTV9yEYJL6siAxzVM8JSi7eeAfvxoXC+RXuqMbKzaBTihzlICoHsHL6iApkjMsPg9lEXJ1JuTBVJbVW1qYYvSA+XHzu6wVCOxMZHPcQgRFTPS9wz2S+Q+3kuMfMGLyZ2KBmxIeegSH4aJhyaFzPtgKsQg7sGCRBtPw/T4qe7XEHfRZMCQ69QZRawfyS1l7VJEFpLebjEHGhaAOvdXIPRUsKOpjsh4E2XlMjdYOrMd4P3ywo05Uj8S1WE+JlI72HQVRGsaOEgC6+Ut9GW47hyw98Lfu7TVpEU2jX5Zxd1IeRWLVMiFtM9Q6AP2KCjGcAF+nkWHwEfpW8v0kdD8EidiC+f3SjpjSciZBKr5hGxfmNYw0YmQ0mu439PvBdtaBUj4fB3JCuyeedZo2X6tAWj//8V5xJ8CG070l1o591rEtAcGbYluaNP7MU3m7gZduacT2Jj0THsdbijznmoljVyIPj/uA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bea8530-38c6-473d-f87e-08de69e2aaf6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 02:58:59.0153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLPoSELGQboXHlX6inJXcVygO6jWLeLNxCOHXNSYZnxZWuWA8ADq419tAE6bQCnwH2cQubKpk+42CVv9J78Jmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_01,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602120019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDAxOSBTYWx0ZWRfX8yTaDYFojV9D
 m2nneoJu/WdSoHQ7JBRGWEsXh5m7JzvyuQon9UrVd54dwhdG/utn9U1rhiXyfg4+vnFoBAyQALm
 U1dNVjXxgioRcihDxDL2Md3Jxc18SdVb7I5MO1lCBD4UYQZUtCwLv72XyPRvS2W6k0jUuMKz9uv
 M1mCkuRrIKKVH19/6jg3569qq4VKHd1F22Ysr4MehVeMpd/POVF2bmz1ndSNwdEhLe2PcG4K9TJ
 rgVnQ2NjFt6XDY/Vc7wU+HAWECcnZasRGE1DO5kmHawixJUYQbSf4JLBgXYkfFSvPTf6JSjCmyu
 knWseYHRyxUhR4y2waCa97rp4IYw0CBVbzCm1hN7Z93/Tw4ahCXGzG1MgXu4RT+/mDQtoTC64Q9
 VBiCAtou5f+lLljotj3w5lqQSxfWrKbMlOyPPM5o0aWkNXqiqKsBy/Pnk/0NKlAlrLYnmC1+bdt
 O3lxDmslolRmMMYhsxg==
X-Proofpoint-GUID: XJLiuhrsfqfTEid2kDfSH7aw4WztEAlV
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=698d41f8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=wwfd6SD11FlJw8uR8qAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: XJLiuhrsfqfTEid2kDfSH7aw4WztEAlV
X-Rspamd-Server: rspam12
X-Stat-Signature: 3e4kat7o6qwtsuxsj5d1z1yjkq94jkqm
X-Rspamd-Queue-Id: 921001C0008
X-Rspam-User: 
X-HE-Tag: 1770865165-630913
X-HE-Meta: U2FsdGVkX18oUH5xAtfDvrrNp1xnVcNFYVGTBiSFgwjnQvzJtjEcZ2nouU45Wj4RBo2J56aOehQ3TCaBJ7qgK8rTQayuH77OxoQuINulccRSuiSAj6QduW40FdJGkTsT6m/degj9xIXmJKxXJhBuHsel6HYQdJExpAKwDcxvUGkvnF6j3+qKgOBifuMAV+RkUexmaKNmysYxsnDfhSMy2Np4wXOrcJJs8J/W8jsNMyv4iL1mHmTaWhnRvkpsCh4CKUwBEzIxCa4fPhZNHHsXbC5ZWG7g3CyLXYJwxxtalDmfghRobl+bF/Di29gfEfMlXl2ZhydXOyt3LweHzvuGsvwS9HO3Pt3AB+UV+APZWZSMG1MS4LdZ9Ll1dU/IMa3epzD8C/1bdDSUnepZNNaoiIXhcb1Mfy7IoEFrtHhXDRvOpWAdTwD7vcvByYcg9Wv3wtXRDjEOthzyMrwF4qd1K0P3dvKtO6u6cInQmS4E8nazEkPbR5YDtXa7Sh54IjgnHDlLlxD41sXH3LZrve7LL59+x/fMbmLuzbImohG6FZyQ/O9QcgBok3wKjTgB9xzmF9bfSKmXVPd+ohyesL8fzhEEg1jbVD20+YG28gwssVrKsD2XTY0OSYpMvs9Js4iFFnKYawltsoXWDaSOIIghUJZrJt3gUdyn3nW/PkVfHxCV+mEfqZ2W38G140G7phdf+kVFO/Iqe4pLMp+KVwGPDiDOQmhbwnDYpkKpOlJ7OtcOLQzGm1Lowxw84oDZedTYtpDPPixjjwipAlSf9GOBiqCJy8xyp6TuoXfHb0Ozhdb20VAFGBh08QLMQWXlt4CW+1j9UVG+EuAAy2OovopM+MJuQRkfwaCeJKZ0qVfb6ugppcQcsVEOUefd2War8zdGIZxSaTfrooIK+rJSJ8v5aEKZPaJtvLqa3AN1xBb8ei+f3KGnu09CxEtO925kN87TOqOxn/+IxXlb8Tv9Kz1
 ANmgRp5W
 ABE27gqqTQU8a6sNS1gyP/WdQbaWoEeQF3hy5PAwHl8gzlxJ35Ig9+jwug+LnJiOqXxxYksOQKfOIcxo5SwyFw2WNimNtm86Dv8aiJN1bkxrRfrHTflOZA1UZQYon17lcRSo2BVOgijO2+8K/kelJZr1zV3/OjnovobO2oqGO6ICgQYtt6BOT52RWMsoXM77/Z0amYfYNVdLOWa4nMwifGam6JspWkOCJNbP3aLgC2sP0NNkkBw1pOzNfYILx0f0BLDh3VDHG5kLuw2kopPbaP6uYKABQreSrfTOu4Bs9vhmxHe6/O9PziA8IyiAeORQIxKlMabDYLn7zUZ7RQnovBs2Te3TjrGrnfxNy53nSGQ/jW4ScLFMDRyOno++Ink0j9L+JhnV3kD9I6adZe0FUuLo/EndF2O3I1+x8gN+jJokDrex1rdiBGosztznvwtc06/iAXBlndQLLafKnzf+qUBvhabnsjjC7Z5/uYaaH/CjsTqxCfCseCIGj1DUvbZ7eLJg+wBsVGqP1xFUh3iu/2+RnuW2fjNu3vYiY/KCl7heCwzEJz6lKTOEqiMb2TXLDgRF7WqvBdkVmk9MvOR5cfLPN9AWn6/9aHDjjlrunXRkUS8eQzFsIchltTwbKzQz0L2YeKswT/uEKJUFgv4nVa1DcySzwGdEoTd0bXj+b4aZ91/63U77V7k4/08HCYG/i9oVR7R3lMI6IUPXeWYVPWCSTzf7Kg/cLyyzCoE7ggB7OoUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 06:34:09PM +0900, Harry Yoo wrote:
> Currently, kfree_rcu() cannot be called in an NMI context.
> In such a context, even calling call_rcu() is not legal,
> forcing users to implement deferred freeing.
> 
> Make users' lives easier by introducing kfree_rcu_nolock() variant.
> Unlike kfree_rcu(), kfree_rcu_nolock() only supports a 2-argument
> variant, because, in the worst case where memory allocation fails,
> the caller cannot synchronously wait for the grace period to finish.
> 
> Similar to kfree_nolock() implementation, try to acquire kfree_rcu_cpu
> spinlock, and if that fails, insert the object to per-cpu lockless list
> and delay freeing using irq_work that calls kvfree_call_rcu() later.
> In case kmemleak or debugobjects is enabled, always defer freeing as
> those debug features don't support NMI contexts.
> 
> When trylock succeeds, avoid consuming bnode and run_page_cache_worker()
> altogether. Instead, insert objects into struct kfree_rcu_cpu.head
> without consuming additional memory.
> 
> For now, the sheaves layer is bypassed if spinning is not allowed.
> 
> Scheduling delayed monitor work in an NMI context is tricky; use
> irq_work to schedule, but use lazy irq_work to avoid raising self-IPIs.
> That means scheduling delayed monitor work can be delayed up to the
> length of a time slice.

By the way, this part is still not optimal. Unfortunately we can't use
workqueues in NMI. Need a trick to avoid irq_work (when possible) while
avoiding forgetting to drain batches later.

-- 
Cheers,
Harry / Hyeonggon

