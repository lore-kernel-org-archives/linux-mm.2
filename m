Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 003F7CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B408E0144; Wed, 27 Aug 2025 07:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502888E0105; Wed, 27 Aug 2025 07:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1448E0144; Wed, 27 Aug 2025 07:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2E28E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:40:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC52BC05BE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:40:48 +0000 (UTC)
X-FDA: 83822345376.08.245B552
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id A51A5180009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:40:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="mhTw/Kjs";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GYjzp6nX;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpUWRCvD9Tgm4vqEMHzfQrH0qACud1F7xcuhmA82gJo=;
	b=bFlNxyE4SciEd5VqNwwSc5rbKnMjxVfdHg6yhepHKi7zynojHAwH5SkOH9JwoVZG3cblAe
	gXJXPt0YUy1ZvtyfGm5LSOJjNmG/TRE6UcBofZLuTyBtsUTCXU/0TBVVXw7vLW7AhOG7Xv
	479KLqqizT3q/QtrGdtD5uIlcvvYZf8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="mhTw/Kjs";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GYjzp6nX;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756294845; a=rsa-sha256;
	cv=pass;
	b=Ujzyt+gShLERgNGvn6A2OhfQqOok+BR/79L3aVEoUVPPG1y+JTpE4Np+2nBt5i03RorIvM
	WYeuGPtya8qixTlG9oDCak6+bP+Rt/aPtXzEZNEn2BxADEeOfZ8i0TebuQKwHgPR7tZpYe
	tPTgZCdJ1DQ4XLlJgBHPFc7MhTKHnUI=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7uAf1008720;
	Wed, 27 Aug 2025 11:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XpUWRCvD9Tgm4vqEMH
	zfQrH0qACud1F7xcuhmA82gJo=; b=mhTw/Kjs+2urw+hCf35fjhSE9ExEULe6HG
	MRfi+jmQOKBN8eA3hag2a1xOSu/9GzEpO6YiNMwYnQ7zUqLLWR4EjoZ+6cgdQHJa
	nt7zt65W8jGD2SZiCJ/sZFRUF731B4oH7ScfcMyv1hqsnPc2Bpy9j3peE/at+FZC
	FIfLT9UU0gr4aUXirfBkdwlL9ezunOgdVheydcv0QdZnDyrh/BSOezq7ytEYzRnI
	+k/B74o7DQhNU1g1cuA6x1H6v10BgeqfpRSbbt8wJGlF9kfj1YXF93AHi2tOpQZk
	lsy6fJxc8aW9ZAWhycb/olUghx2vzhvdIB7VkU+tcp7oxpvxgyDA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt6bns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:40:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RBLblC018912;
	Wed, 27 Aug 2025 11:40:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43anjew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:40:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gKke2GMtnQ1xje9ClttRRRY7ROnv1qBpUJHnJhvErT9+oFgdMh6Dsw83oppq+FVEn+iChIJu7DLjxa7akHFxHkJIzt9x4YOsIYti3UyriMcycXRGjc8sLyOerCqs9Zn/+nRorumxQ/EE5bEP99rVwYj1vhVgK9C+qsjTBnvWlRI+djeUY5i3IckZw5uc8/mxqtyIYSwc/jaBalW0SYwyw6Jm+2zA7KIvCoDSHSmUgxxZDrZlVdmgIv7YGElh1+Tcg6eZiFZ+YvpyNIsVyABtQ21QmqASVef2mFVcwyaY48CnXfXwXxTs+V3n3FEzM2D6T4EF23gia2HkztOXlkPLJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpUWRCvD9Tgm4vqEMHzfQrH0qACud1F7xcuhmA82gJo=;
 b=btOBHbuXinWFgQr/CCOJzXoBVYjbse1513Bwk2Qb8nqbiCNqacsjV4VwzTEqBv4xhs2VtX1Kgn9daw6RYhMkcvcDlDRWLqb/7AeHdAejDud9w4xnn92j9jQBuJTDJYf1XiepNxJwVGhjvxtxQs3agetslS8+eOBeUCoDzh3CEpTDLBoX8bkXu1xk3hDXORP9c2WjA0cW9KwZ0TBKDw9EU+cQddlWQnlZe6MpsFD4CGGUSmEuJ/L788tdUmM2h/OoCxLP0GgAhdU7kSf5R6FMYjv4Goe5fXXOsHCKJup4CP9Xf7139DO5jrYR5YpWRxibnPU4yc30NThMkb1sm3vgXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpUWRCvD9Tgm4vqEMHzfQrH0qACud1F7xcuhmA82gJo=;
 b=GYjzp6nXgiShrJM437h1ZheilZsl8hjq/ADxRkVv4uq+3j/2LXKHoHOJf4LT8u/oQ0uSgJdKjZntLVE8+2ERl3qyQiydshymhxvn2CjExh6HvkyZCfvh0O8XK1Tq8SHR0TDR5BvYW9vCFp4E3upvZDXix+mRnmdDkLcnd9BEjL0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6077.namprd10.prod.outlook.com (2603:10b6:8:cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 11:40:34 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 11:40:34 +0000
Date: Wed, 27 Aug 2025 20:40:27 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/slab: save memory by allocating slabobj_ext array
 from leftover
Message-ID: <aK7uq2LwIf6g_YGK@hyeyoo>
References: <20250613063336.5833-1-harry.yoo@oracle.com>
 <00e91300-c6e6-5330-f514-4628ae2ba696@gentwo.org>
 <aExkJhM_P8mnLC12@hyeyoo>
 <bdf0af50-2e1d-4627-9775-ae62e2dee509@suse.cz>
 <aJHxsvU-77D3pfhJ@hyeyoo>
 <c05d3ff6-d668-4317-a5ac-c8943f1bb016@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c05d3ff6-d668-4317-a5ac-c8943f1bb016@suse.cz>
X-ClientProxiedBy: SL2PR03CA0024.apcprd03.prod.outlook.com
 (2603:1096:100:55::36) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca5eb26-24d1-4ced-defb-08dde55e88c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xjg8int2WnEUVpBks/DOugN7lirjrTDpxambayRJ1hIP7il8aAWyC2JZrk+x?=
 =?us-ascii?Q?rhRaKo+LOSwMm0OBYKKE8IIfP6QpyEatBVlO03pGjCulkqsxa9KLRpHuJc+N?=
 =?us-ascii?Q?LAJAutX3aAY/FUf/TZYvTphFW2l5BpWCUSdYlxLdD0Ct1T8hKttZxpSuRIjj?=
 =?us-ascii?Q?vGafe7wwv+qrgnRzxf0hyeKPVwkTWkwbRPMyHB/NIu/APnJhiV0kh150G/D7?=
 =?us-ascii?Q?pMQejytewqTKWZaMRlUoM5eizMIDGYy9moUIVWbjUArAc78j//Kf4zg/EiGq?=
 =?us-ascii?Q?y1Ye7gAYgSIKShDJ0cxF4BEPcsbZAVD4/duMAWwYHsJ7gIffcMQdzQcmbSnn?=
 =?us-ascii?Q?8Ri5eBdknyxWs8EJvgSd7EG+rl2Qwx6O4OSe56BoieOnfwJws27AgdMI4Xw9?=
 =?us-ascii?Q?TIMKmAiZEKQ7Cc0AKb4hIAQ79v8BOqlMIiPqcl0x6DN18R/EmUpdrlvcozun?=
 =?us-ascii?Q?2hzsNZfB8UmbQOikqDINEQuoIM3n56oRKVKls56tVHKqwOn4TUBReBxksiDj?=
 =?us-ascii?Q?3n0kaD9FtVEH4pgQSZrWFMX3bMJacH0cTXZdt4UZUQldkjO5RlvD0oeBazyx?=
 =?us-ascii?Q?c2nFuhWRsNNww1xEKZPohwSTJb/oh2ha8SCy+cmJDVsDoH9f3I7zxOJ9uC80?=
 =?us-ascii?Q?3rOjd2RoNOgk81fae5WDWaFJQpm4MfRQuDyqgvEwisaaq5M2/49vPIezz8lW?=
 =?us-ascii?Q?KIXWK6JqmxUH7u/s+dqNShW/ipAXfjdPPY5xlMHKSOv8W3i/KOjCh3lh72uz?=
 =?us-ascii?Q?kTc5TIL4pDcOD6j3Lm5yE7lnk+/DscRuZY6pR4Z8yDFd2fTVAPcqTuLSOKjL?=
 =?us-ascii?Q?yy9avvPVpcCrm1LoajGBz/RFG8Zrt+iXTJY9d0YQswkZc2Z8WCJw40tJYGZD?=
 =?us-ascii?Q?fozyHE6zYOujwbwi+zqsY+5nXr2VlQVKp6vpIYIVyFsR/gwoin/srG73DZZj?=
 =?us-ascii?Q?sWKN7PRBOGtKtTzZVlq9MTA0vbppTlUpWlYlVWe9c99G0G1DtpiSfXebDzFo?=
 =?us-ascii?Q?8N+Ca69HyeZPEyQ1wCmG+bHuByG4Vz07awS/oVAAjhTVmD5qysMDgaMoRvWR?=
 =?us-ascii?Q?JBUuRUBDpFyh9ysoQ0S3ceI/fsxRhxQFjxPxxm7eQbpwKe4G+5ye8znzlLmh?=
 =?us-ascii?Q?np4MKHFkxlW6MuDlm1OGFH2J3hl5DBgMvjA9eiUw84STYDwpNSEYbnLnYnrS?=
 =?us-ascii?Q?GWbZvde9XXX0pRcoZSm9wEzsGcbgl9YquPjvMXThqmllNyJx417UC6CCMWyf?=
 =?us-ascii?Q?UcBbnvkDoD0FHoJFBhTolONkiohnhZzZZsfqEYOXej9LKZFOwIrTeTvMim7V?=
 =?us-ascii?Q?/Q3FM8XMR/MFL8BwBnXARWtFakWhmsNwA29eDffMkEV2SgBm0ko2dbdQOyEw?=
 =?us-ascii?Q?iQPuL5EH4L+mFnUbIMXypKAOnIhktSnmPLUAyCcam4iDCuwtfQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ge3Y9vCPXXy8ry8thK9Bm4bqz2NPFAGzwlvAWhPxWBcFqVIWG4uk7O34G/iK?=
 =?us-ascii?Q?pHjW4kOIrLaMRxS5NU2hhMeiYGVevBA9ywABOno8T1aEMoabqHembGphWJmM?=
 =?us-ascii?Q?zwGNCAK/EjQXmFW8IQrXwcuuKogxC5QK/QH4CXpYHEUJl87YDtwVmmXf0bZH?=
 =?us-ascii?Q?haJ6Kn22Hap8KAEPcHVxR7PZN5IKfqHg125fTPqC9DyNe+SPx+lWv8j2zYlF?=
 =?us-ascii?Q?wPPW+rAE6vb+1yBUMvYgfzmjduj6y2mDBW/Yj9XoT64BowBC7NwWgNPyWJKS?=
 =?us-ascii?Q?DABphibjOFBHZW9+eRB51baofUVS1pGZbLNBTVIJ0t0MY6NZQvOKGOpYiKKQ?=
 =?us-ascii?Q?TYfPPK5fepGMm6kHlXZYVR2r4PEKxzCqHRap3KPSRP2Rb29+28qCjCjJ2BDM?=
 =?us-ascii?Q?tRrwE85LzdG5UPt0LUNLVo6YLzaZGStvg8xksHnvZ6vq3EGKx2vYwv64qVKW?=
 =?us-ascii?Q?YMGNJaaZzJzhr6SLE3nlvXy4+p2fonCi3kmItMw8mfUD+qct5/0ihw0qhna4?=
 =?us-ascii?Q?zExK3zdrwC5wUsNcfk5p362dOSy8xP9AiwngKVP9Qy0QB/tJ8Jy2J7XxsXw9?=
 =?us-ascii?Q?nv/y+FuV9I1+51P5LPBQElkhj5Bl+dW1kBABVckbu2Ndw6EEII7Caqv9mEos?=
 =?us-ascii?Q?EiAkOLmd+1L355E0VyWz4hbi8hA/hTa7ErDELyKI2IUvI/zb6r6kgRjTv3RZ?=
 =?us-ascii?Q?pKE+Srx5FiXj4s6ZWBWMCwmz8lspIWuwprpCdzdw5lxXrK82T6+ZUc70TCdo?=
 =?us-ascii?Q?74auGuiGVq83ZT+/SjX8skyMwbQzutLceGiX5cDGmRCvK1FcT12durck9X6L?=
 =?us-ascii?Q?/pqqBOE+V+Y0pPB1J7p26yGl4e+qxLSSwd1zLXK3E2A3EVoSM0gDCrS9uZ79?=
 =?us-ascii?Q?2jHxhkFtCddMTSwv03SJIPM7POv8D+1/S0C20H7NeDnwHJWsRI+xCIML3Lue?=
 =?us-ascii?Q?9UrLLV1Bgok49eq2/GWtJGCCEMw3h+KM7fqy+wTATeaP+HTN4r8kzI+QzYIO?=
 =?us-ascii?Q?97Zpd15RtC0rv3iC7g+bjnIJXiq/PfoXUVvf/i6lPt4E7dnmLNWUu6IgKgYk?=
 =?us-ascii?Q?5T9LI87YRtBdw+vqIlyzEg1Cw5YrdVyOXUnCd+jDKAMQdlNnQYwTi0sZtLAI?=
 =?us-ascii?Q?P63rwHJOvWzeIARBeZ7LeT1xcZkigkPkzHfFgrNOTxLK0RzKwD4zaZza8Xmd?=
 =?us-ascii?Q?dBJ+3cfEJ+IrtQrBXTrqVclXk+/1MH3o0RSU1J7URHSQ0kY+isGvvoPId5bW?=
 =?us-ascii?Q?PxLskfX5frmjBG4ltcabaohBlfgW9l025ZgNZ18KGvSs4Ni9BkSHsE/IwxXU?=
 =?us-ascii?Q?AU8mLijCxz3VvRaHWJicr/gSmTLTK8yrAOgFS53VZFyz8Dvbsoyz2C15C1k3?=
 =?us-ascii?Q?VnjO2xwgupZRd/SJWZlPq2svDG/WtaWI8bmCVI6Thv6IEEaFE/kUlLBBPb3+?=
 =?us-ascii?Q?akB0HitZUek1ETIPH3c2VwRSZMuEAxAVZ5HHPTEv2bRrxi7goqyrRMyLL5sw?=
 =?us-ascii?Q?D+M4Lp+O2o/Ggi8dFdILLQOz1Rn77bVWhuBbL3zm3bntA5sBU4qtzFISv240?=
 =?us-ascii?Q?SwAtpFCK5kkucUDmwi4K+dHMVv9qf4KIuNm9rKFw?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ERgrz6XXzDXdefMQMUI8l55IE2OOqAvYwxF3uQR6rU/2PaCh81lM1sMdCZYoNce0+MjyS0eE7socDCIsLNETaWWSygfQNSpsjOBVxAeDAWt2nXKr2KzSAHyK+9oYYjkVH0BVTy9zuHPlBAw4oSmQ2sbrqEr/OzhidrmXjCyGcchf/d1bJoneAbuV6d2uQTwM1lTYaQTgYhOl25x06KYhX9dUuX/OUDmLQzBvMGl1yvLJZz7/rBl1ziNmTnggg7pLap/ts7wbvvPOeNAMdCp7lhfo0NtMlberTi8BwsAr/l8uhDQ7/NeFLniWn3GPBH5KtXbzzkpX8PuRpBdGGbxBhTLmjNVQ+E6Bf8zI4bFFN2zHGcEZkqegSK+1ALki/mnIzsCeF3htHHrlLCU6zlyIbaW9vHXXeZPY1BXP7TrZgo8Zh7VV89nzNJU1QYeAWIljrHhTEetzVRHgtgDy6d1vfNOC0Q+b3IvQXo4k8E3xtV51S6tqgt/5Q0VcsEvBxptQtesfcaiNrdA5nAv1I/yMb0E+QQsyxrFC/SPPQOUzSaIhTeY3itJt9+f4ulmYn5C71Je4bu3hHZjXoJXI+bQNd1rj3oG4OJFZqKlWFZ7yjI4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca5eb26-24d1-4ced-defb-08dde55e88c0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 11:40:34.2293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MY0Uh+GwgYsYwZhS2SUElc3PJQgKBJv7OrvIjGn0/5BD4g9msnDs2Pm/ExlPTBsW+K3TVyNkKvK3xsR8CRz6gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=980 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508270099
X-Proofpoint-ORIG-GUID: OcdSGdWDs_gfJLBklQPSk2TEB04Rk6Ut
X-Proofpoint-GUID: OcdSGdWDs_gfJLBklQPSk2TEB04Rk6Ut
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68aeeeb6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=wIJiNmnV4Pw-4AFtH3sA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfXz5JYWgvkuqRg
 H8Ae1fKE+l6nJq2IEzZkpgz0Y7ooxKzQ7wgNZVJI2v2qpeItslnQ0Bf2Em4q/SSH0ZXaPSpLKZV
 ynXnowvm+PIBk9k/5JiEWISvCRFC7j+R4iqmSb0IEUkgPzQSNqKEOH8aHPi5I5zcM4if3dHKTtf
 gaXR8tcRKHBdm4cf/eIKl+Sy0IRwydfpzB34eMHE0GZe2hs6nF7WsYM88A4p3NwqZ0DinVXneDb
 GBU7Ey/qir5bpX/fc8yba0w6G8xK7hzLCo3QlAl/M0OZrGlYAKaj/0aTmqB7r/Ly5Nc1Yfdx+r2
 CIokpa9vlA60AkhqyIDWgIB7m41prOxfbJeGTLcw8AmyvzUIdH8/d0SjDq05hgTrLgXu9Fpx3iW
 Z870gF60
X-Rspamd-Queue-Id: A51A5180009
X-Rspam-User: 
X-Stat-Signature: 1bf53fgeiq3r5bmzroxgsxom1jqgbfns
X-Rspamd-Server: rspam09
X-HE-Tag: 1756294845-256745
X-HE-Meta: U2FsdGVkX18Wz1OrmyGl4hpaCHLkIUeHBcHRrRYQRlvOb3duO7HGuciIHgss2mp7L+IkVJu9fcRI00aGabWkC6QD1OFAu9OPOB1WD44Yr91Hlg3OoaSjJg3bzl+g0MSCNHLf9HetMBLnfeGfZerRlns4pEAKsrhCW95z8CrEcy7aVkk5DwUhO2OJNfUDAKG7yvMyqggXvPfyj8TOcvk4ZTfHq0cqk0Sx7vD0PKdjxkviYoW86B1RgXkfsKNr2yscPgJWqNmRt7y++2iG1i3lza1xF+Q+77SBYZZOIJKuJ2mNwPACwOjAtJKz4+sSL2yZnL1WRpd9Wrfydn0Acj98ZubNGRzTWHS58DE2kz+68I6+aZXDNJuG3U6h1Ki9Fq+CUAWMh3n9Hx2QPsjN6yGYmo8D2SREbICOjLhRbGeHu1boIjL+mz9JAvtbAG0R0moTRnRlIoT6Xq9Ma3/LvXH3+z7bTJClmGCtX3ClTGpIcVpEVOt+pv+nZRL0MRf3VUhGv2hvzzOcIM1G+ubLx5mWqAiebeFXq9Lp9tXkvKBwkSWi2BbKvvcQ6WFpgi8y2xmJSHCdQjD1ESGTAiGy+EdPYWvRL3olGT9TcHO/6o7A09CArQAp6joozOKC56rDvXpPjFUohpeXkRntHrmz/YCrt8GWTibhKGIwr0YFZ7oSdolGLb0+XXTH5GpY53umgWn+ypbXS1F5MrnsfYU6QxsEzXzqZ7eS9J6y4HmXhyZd3jWVjRpYPQtkqqHkgYHzw/kzbV2ivn9+EY/8AYJ9SwdZv3hMyjrpZjljqETwN48Sc6cch/AiOObSPQxgfawRmKHWf02sqlVdVawRBIc0xDQZ9PXspsIXclrMIqrbxL0Z2la+HtJR3veyKHBT/i9gttuJP+b/7fD2kRCGztKftUYc0cR8KUpQEGuWggjlOR80JGT2wsvFpovqPdY/ab+e2qhB+CyW0MmaV/VuClv4Vyc
 BQk7TkmR
 B4KyXg0wJJirKjt01wKFpRTuqInP4xOi6X4IqlULFfS1+7SukAPeaObssi6UDDWyuXF+kxpn5ZD9vbEuT13XEl2KsG5Xs4FjYL5/6W3AAger1ForG5jQPJ9//T3MPzc6Y6s052VNm/oNSolu6zOexrbM2GhCH8JlP8t1Gp/9cCsYAfwgVk0alV3aKev6aADYuslgi6gtR7SZathaCxQkR3dvJMgA7J2tMzBJCb2CfrVLdToPcNDg6zTqPt6xM3LHKtb853bdb7gnHhxwYy+i32h+ITh4Yjm7yZD0r8vanu/Zdh1/U/kKY72BEAkBPPpZS1LnUKCfZlOxQ/cfENtp6CaH5FTfAIBEzxxZn+/Xq3o0I7QyFt5Py/ERJitbBtQcIjbg1NivAWZ+JUrh5CWqjsXzU6EALn7Zpp1WDAAH+bBidBRwieMMtCk43oQXr7WO492RCmNQlNAac8weHphyq8+cYV28NlkVbTdX7wzRT9mqRH+hWNuZeVu3wwsaRbnTmuiXFTI9em/nuiYaaOKN92x0UfhtcQ4Qcmn6Sp/EFP8h1nRretk5VOonfNLLL9HkazkQTknJR4jFIZGzoHcKyb6OLrRP/d3czvMm/Myrxuj9k2umN6PPUbjJquEy/SMTTkumihHM0WFbZk7njrIi026Zlu7IW6C8l0ldclj3XcBXaAW96Q2iFLA2s4REkbOmffaMCLP9AVR1EjD5xx50JZw9oAqdPPinzqs7gmw5roMM2UdFfeAG7vTI5tgtR+LjtGMKZj2iQR2KqYPxhL+Ccx/B94ci7X7mF3gLpsMUvXGFAu3ROzhHW+Xn+jZN2K/olNrGIfWZRAS7weBM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 04:44:32PM +0200, Vlastimil Babka wrote:
> On 8/5/25 13:57, Harry Yoo wrote:
> > On Thu, Jun 19, 2025 at 09:56:59AM +0200, Vlastimil Babka wrote:
> >> On 6/13/25 19:47, Harry Yoo wrote:
> >> > On Fri, Jun 13, 2025 at 09:04:34AM -0700, Christoph Lameter (Ampere) wrote:
> >> >> On Fri, 13 Jun 2025, Harry Yoo wrote:
> >> we could have pointer to the 0th slabobj_ext (we
> >> already have) and now also stride (to support the "per-object padding case"
> > 
> >> - there's still space in struct slab right?)
> > 
> > which space are you referring to, maybe lower 16 bits of page_type?
> 
> Ugh I thought counters used only 32bit of 64... so the space exists only for
> 64bit kernels? It would be fine to limit the optimization to those only.

Oh, you're right and it seems to be better than using page_type.
RFC v2 uses page_type but I'll adjust this in V3.

-- 
Cheers,
Harry / Hyeonggon

