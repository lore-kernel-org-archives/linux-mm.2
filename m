Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E276CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 17:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8778E014C; Thu, 30 Oct 2025 13:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0891B8E0089; Thu, 30 Oct 2025 13:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D1D8E014C; Thu, 30 Oct 2025 13:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C78338E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:13:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AA6F139AC0
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:13:44 +0000 (UTC)
X-FDA: 84055427568.24.A094B26
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id EFB331A0005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:13:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="gKG/E66i";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rqjsYEjm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761844421; a=rsa-sha256;
	cv=pass;
	b=NGbh9ggm63FzsORKdO++D6O7BOSCLo76dSzRprz/K2c3PySxUsqvPQDOosDCEGmIdpv3Bs
	RPu1prDak0uxJDaVXs+O/bKwu0KpgVeSeNdktahF66W1G8as+aY860wLMLc9qOgJTyoCiS
	3pga9o8XuzXCDwYdtgrz+TZ7WfzLiKw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="gKG/E66i";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rqjsYEjm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761844421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCXgpcLJfuG0drut09eMWPma7X+bZJPTSyC7fjX3q20=;
	b=B7TptQDwCtMhiXcZG5tS9tyO0QTaGUGIBjiOe8S1Yb8TqHHGkqSI0ctVpX45UDv6zvRdJI
	wTmRLipYPKG+9cZHs+yJIVPQCpY92vFomTQdIdRX9ShWB1v9acLYcSEigRd3CvpT0B0Bz0
	lIR8lvWZuEfgw5yaMtSQE7yw5OCGDzo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UGwe2V028048;
	Thu, 30 Oct 2025 17:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VCXgpcLJfuG0drut09
	eMWPma7X+bZJPTSyC7fjX3q20=; b=gKG/E66ijKN0Ki7U/4gK2jB09kV1AxAyIH
	MFtRIQp7PUsOb6Hwa9bnt+7I+YYMj5Nk5W9q9MinSmS3MmMlcsgHAWaD8uZJLzow
	agiUmX8GNGWbaP78cSVt601U0aDnVc34YtoYQ+NtHXbo29Kpz//qudgo6+g/D9l+
	T3faXGiAYF8xs71LgRDOmwt5tmb4oS+scHcjwgLWXLfIGrCAYEvqhfBX2TksY52k
	hnhxrSsjkwKTLUOFhaamGW9U8ylep8CIBCWBwlrOavVkW0yaIi9kBPaVJvyEYKr7
	+CQ5XzaqWG5SUd9sS/Q7rUGI77Ddg32pWipyR/UPu5zG9Yf5BwTA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4bngr2y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 17:13:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59UGHVav027632;
	Thu, 30 Oct 2025 17:13:33 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010014.outbound.protection.outlook.com [52.101.85.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34q9ckfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 17:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=svWBVghi9QfRr781KFLsGAPqsV6OsOAZuET1IKPofalskO+t/n4l5xYXYWQs2L3sZJp3VJgU8vkzV4/zUqQfZpljcDNadbWww/E0AeHwbpSyhj5fgzqpbB53TK9q5me8OKrZSvfaWLeieD66QjNIUOUG3rLRPSTmRCqm6WqYIu/R/vv16VMOuegx/0inuSz3+llq8tYTce8qAvVCuex3mVeSFbIY0vBl+9qTgEncWQYPkjpvB9vpuZc7rUeWyku3jAAUwCbWeKWh6LH0lnLg23IK7shvYd9/WL7NMpts66Y7vr57pFKbkvTFlRpLlbe3bpXcREAff77EjnGna7OwHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCXgpcLJfuG0drut09eMWPma7X+bZJPTSyC7fjX3q20=;
 b=kvYGgWLl8Ly3zXuBLN62Yu/uhzW54XRU8z1cI7oWwVgHa/2CA4HDkUFjl+tTx+Pz0oCbErOr6I8Z8YuvC8OEvb7CIKj2hdFg8wi/aUSxORDlr08UEf+60mkeTgX3ZKfsd7O7f97tqx87ZTWqgwKZdZEetDTzpu7uTOI5Z+oJOl+tlM3UWWN/X/w5fIYbC+seFDb6NnvqddEEPPpyBPkrZl1f5uTPoi0aLgLnYm+1VwkgtyHF00RgsdngqHeeJMRyazt/CCuz47aXmg4NOOs98OTk/AQc0Vr6JDEABQAtBEo2TZIBKvdxR4clVij++boE1u9xjAOuawiv2xV/cOHTAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCXgpcLJfuG0drut09eMWPma7X+bZJPTSyC7fjX3q20=;
 b=rqjsYEjme+UUmytOexqU9+GBEwcSIuWrDdSBLxxYB8iFbjIMDPqdg4Dmwlfwx5I2zaCaznOHHk5igakhvHuiDgntARwX2Gq1F46tuUsv+RkvsSflTpwY/QBH/cMSgxjImkju4ZncZeAxmbVN1q2C5ewW6EbN94gK0gS30viRD1c=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BY5PR10MB4209.namprd10.prod.outlook.com (2603:10b6:a03:207::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 17:13:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 17:13:30 +0000
Date: Thu, 30 Oct 2025 13:13:24 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPe0oWR9-Oj58Asz@x1.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4PR03CA0351.namprd03.prod.outlook.com
 (2603:10b6:303:dc::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BY5PR10MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e6ec4fd-8ac3-4b8a-4997-08de17d7a576
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?03R3JuN2TmgoIH4Zz4cY9wRe1IjmJxgDdEqt6tGN4jyH/UmbOlUJ5n9+ZUW6?=
 =?us-ascii?Q?9aBbTsuGUuPuscTsTcxRi8FQ0JhOYZcU4zLiMiinsxsAHVuYFi4DjlWHSHu1?=
 =?us-ascii?Q?oyvkKXvAijgbbMxLZ0rRYONbUGXDvNA7ew5e4H4/0qvGwItK0nTY73rSL0F6?=
 =?us-ascii?Q?nUELqq3TGpcMpvhNbZ1ndYq98H08ex4Lkhzul77YkkO58ceQuntR9iSfV9WQ?=
 =?us-ascii?Q?yf82OYJUt1rMC5BN2xu8/uPJHi5cQZ8z2KIRTjVAveSUD92lKCsIKwuvG67R?=
 =?us-ascii?Q?9iBmmLeyG2+GJi8hY5x4D8kNqrx4dgfdTP+Rlk6V75FyspA6/2ewy27zgeda?=
 =?us-ascii?Q?JWsmJlb9TikUujzGs2bQo5gx7pV66FfO0K3IU/2M+HSZEKL/P7ixetpVW/Y3?=
 =?us-ascii?Q?259mv5B/PQvZJr4RWNwXwOiDAtQK5V/s+cKOutL6yGzyDaC/ODD6lz77bKWq?=
 =?us-ascii?Q?hxymsV+/fCkH8NtB67FA0hI9SZ9R62mymJBZRumg9cZCABqQ7PbW50BOL3CI?=
 =?us-ascii?Q?0QlO70LJuqNjDBhjd6NLnDiS2paGVBCIVz2ySpiWxErFYQiik34Eq2qEHW/g?=
 =?us-ascii?Q?98IdQ8PewomdhVfem1j8YtS+2Qzzg/dk6kw9KBuP3EQipIbPgI9zzTi83sE3?=
 =?us-ascii?Q?LKZRKcZ4GFMOkw1dWeFgFD23AujgLRnTZN8VFc02jaRQAUpDk+lFGeiTMMpi?=
 =?us-ascii?Q?mbESLkWrDYPPbT5FS+QTkt6CDVqpHoVDvVWrk5EaCvz5qcC7ztuP3/ph+XO1?=
 =?us-ascii?Q?prdqWHubMIQBxKAVn5gj6O+17ZO81UUNMk4WK5ww6TuG+kdJCf5uLfM3MPzu?=
 =?us-ascii?Q?E/PFc5cOAFr4gUlhS3z0lm9IxyYFapg37WnbLRgWOQNs/pitWb6IOrC1Af4J?=
 =?us-ascii?Q?6qYQcElKIlTYrcMY1ZsQ7z5gjPzoZrrGX+iUhexM/W5HvE++MCvc61lvubeI?=
 =?us-ascii?Q?F3R0QmJ9XClbWXLT1bmpeXDIOrTCnZn7vp3SZyf0PQJllCFSPuR5wYwdGdk5?=
 =?us-ascii?Q?ksg2/eKSpP++qDT0eHzx1Cn9Tu+HlJzowWyLSWC52Hs0WPy0elcK0qvJMyek?=
 =?us-ascii?Q?/NS7k+mjc2wh2zmqo4j/GKb/tDODMT/XL/djy7P4fkSyy74YkHyE4smEKESK?=
 =?us-ascii?Q?Zlf7Gs7OKrl0UqJq9iriA9jhFiwY2Lk9IoNfOHVDVWmiAEDU1V6L4VsGJb/J?=
 =?us-ascii?Q?ZYtlSr0oKFIwWaDe06TvS9Lrt0miYhvK4HTmVonoghXE8SRRCaMprl8cFbzJ?=
 =?us-ascii?Q?4ozb5rTfG6IqFAI3OnKRn6vHIhlHrzuHUgpgF5VFtDg5r+NQvbQzGzHR1zqQ?=
 =?us-ascii?Q?T0dCTCOdP9+wK9Cjc0kF9grCtvtydi+5PpeUXKuS5nPgi0ORE0Ua26Jr6Jr8?=
 =?us-ascii?Q?3WUfsmnZE5zkfpj7tzrgGajBChjwcvgLZCWidYQSLmCWVuVAxQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3COqyjiVVcvmLA6bhpwqN8tSN44FUH7qeL0fIWZ/wBw8RIHMXl8iGzkeAt1c?=
 =?us-ascii?Q?OIIhdmFS0pREcIVOFfKzTXT1TvrVsumqkHj5i+oFYSMWwMrfi/L7n4rsBDAk?=
 =?us-ascii?Q?MdPne37mOhp0Dkc2TevfyHeNDiCjMY+Lx3UD2KjVTYZySv+K5gglbuFR+Gq0?=
 =?us-ascii?Q?hhatszzfKVmdZA2cpOtXtXMSuzFyuWaQY6GOK0tg/xd4+OPF6RJetNIPohDh?=
 =?us-ascii?Q?yYWoeI3QfAFmP9mKMyMZuRczomdlQCmaISjy6tTB8eisHU1KjEYwOXjeSGtD?=
 =?us-ascii?Q?FGkEetiDVSB8V7dqUh1aIEnY83UeACf0WqAcW/KmBfpXFzUveXYwQSGuDWA7?=
 =?us-ascii?Q?IEspAECRZjsyWZJCNNKuRJmuAtbBmmLrks4sU4OJfOuqTVZoCnZw6Y9SIgEx?=
 =?us-ascii?Q?6ClsKyuJNEpnY895Qp8nI/LlHkuJuW5h1AmXJpdEj8XjwcLVf/gXM4qIJxPE?=
 =?us-ascii?Q?DNt9kL5YMjfvAfl6NqH+DGir+VR7AoPWUqiaQYXxJEqpKEzqdMErUM4qEU/x?=
 =?us-ascii?Q?foMmXNrloMH+AocLazWHRBCL5m5zGL9sK3kcqDZtsI0unyW8ltiUGcnQlBYe?=
 =?us-ascii?Q?y9m1zx9DgUDfQlgmH2zFryyP/xZANh9ae/1SfXAkjPOLH/0NN/35mUhDefY+?=
 =?us-ascii?Q?VX/PkBJFHRhnh+P9JeaGsKcZWPumG5merVuThZV3WCKQXekV0zoomMom+Q7x?=
 =?us-ascii?Q?sjoVRrEoR7vEJHpSCz1tC7KUXNWI+RAWg52fI2DURPyQP2te3s+mrVtnlEHx?=
 =?us-ascii?Q?Su8rR2IXr45eUrmoYMkAoaz9wj95eGgPNoCkihkQvYUI9k4Cu1BZSmAXJ689?=
 =?us-ascii?Q?F3xyN+2jNxxM4RoKC9p5wDPkj/ptlIW759+KZUf7xWXHo7T7FtrwlW1y1ULO?=
 =?us-ascii?Q?wPky8hX7SvcqOZpbnZnoGn0wyO19c0o/JR6y/X3OnLAms7C76oS5P/YOiB/J?=
 =?us-ascii?Q?MMpHByEfoTZ+XLHaegcdf8JONCwv3H5SrvzDlxrySbdQtxgwjsufL5S1Q0nl?=
 =?us-ascii?Q?gKCXhTkKvTeCLofMOLaDFbYgqmYQqFxxzZYgpiKE0hW4UDjMTwox79Px7Rch?=
 =?us-ascii?Q?w9LV0i81lW1eH7daq56l1yXQfUUElBeQ4wk0QLxvCnU07b0dzaWKpH4ec1mZ?=
 =?us-ascii?Q?jOMS0qO9+n5mYZN5OKSxUeFObrb7X9hvwyVIB9/HLuSo4utxJicYg9CeIRes?=
 =?us-ascii?Q?ZM0q43E0LDvlfDXqdQm3+Wv2hQvieZ1Ntcb+s2/EPBqB5B7tSTx9FhShO4Sn?=
 =?us-ascii?Q?LddlqOtCFVmC82WlETriKsIflFnZwdZpEuKPHSx/SDDeDBw+Hc4xNO93XoAs?=
 =?us-ascii?Q?XO4CHdPfF1/2YRU541faBZh4GsFbyfuDluOYJi/vjeI1NHpxU8BUEJK5AdXd?=
 =?us-ascii?Q?IsiYhhIAgMEqjgFK8fw9ZEtZ4dUbSUYXdIv+Gyiiwrf8hGnEY8VvUQp/FmnX?=
 =?us-ascii?Q?F6vJbIZHkJjf8jj/iIgL5JZDIHNq/AgNOCDsX7+zOiHxzJ18pBMRT27FQaWF?=
 =?us-ascii?Q?vO8rBmLGigZwJXSMuXjDrWg8pYxmbkKEbLV54hj+G+c7nfgkaQt1IJerb0r3?=
 =?us-ascii?Q?q8sj3f5ak3z2HjNyqHBTk3Hj/W0Ddi1f/DCeb0mU?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZbZ34RRAZXv8kwjeG8HgEueheqDIo2j0cTqoXydqWmg2h+8yENZa769gYMB+da+G9hyoge7AZDL+AYhkYQ6gnHCr71ds5/8kUT4iPHySbeNyIkIXhWglH6Je4YnxewJ7xxoc+jEGtuIBbCVKTjUXbLe05YBfYk2I/eB5dEU05QnRVRBYDoAmqieZXqWatu5I10fvugdsEqZwWMu6bWIdedo1/x7VCIoSeoyfBYb0cAW9rFkDYRmrdwjpglgi3eNKiNAA7AWuSUbyJJV7jyZD0tEEO6K/gii0X5ypMkdsMY71ZEJDgPEtmJVLt1nARfMmhC1W8DPdzhWQ46AtuX9AkhOVsCmHqmXdUH7eYLlPe1OQYDwZoA+cVfzJ9SQ1Hll9krWDeZ9NN18D6WWgQjTH1Ef/NXnijPN/d3NVRAjlmbqX0HCBW96aRjCMk5lVpAVP8JzQcDal6JHle6POS5mAOQ3Kqn8/sSP0jdIWwo2t1h+ZBPTYhLayPm2sQKw6lf4FvBbYnvYlyIgyEzmQy4ORw83mGtsVjk87gHtB8JIYCbT/eaXVSj72CkCBENdUgej2QQpgEOFpWcsWJf+zVz9Y3dM6Zbkf4Z26IRgKiQR+FV0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e6ec4fd-8ac3-4b8a-4997-08de17d7a576
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 17:13:29.8171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUVnth/tWawJBcPROamB0uJ7eu8VqzgXJHZs60HB3mtxzOJ1fFacrmr1ggL7dNVL8TbBbhm8x5AF4U6F9NtM2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4209
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_05,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDEzNyBTYWx0ZWRfXxY9Uh4+0UErj
 oHOdiVOR4ltKyG/qOVddKk4v9xLpbtTYemMJSkCModFzXS9sFLQTvYa8kFzKJwiSCVl+rfchTk1
 dFXjJ+thrcZIjsxqSRi1b8/sRgARnKUo995RI8edgy+YEYnqHjZvso90bzR4+oULkW5AQ8Ds3Xx
 gEXsy0VCcYVEEmopE6tmCEij2sfAr/kKulqfyemXeh96xHhkOr5rpbJweGrU6fQSKwnlqKVKqU7
 XVhL12T6Mpo3c1rnlPoROuMzqYLJr1SgywsZ5NxnWNHH/dxfSYLj2jhNDb/50A6mrkHAsfMRJOp
 EzXIvqzQI4qYvfWxo7SIU/3EY4EnChpT2ja6uJHjPLM6/XaACSr55imvqt/uPp/JIuI570G5Oax
 QgbC8sgXVxZaNJv6pkd3TWIgyn755sIzJeZ9JhoqT1MF3dODES8=
X-Proofpoint-ORIG-GUID: FDyzxIgnEX3WqFR53sRhAjue-4KRV5ra
X-Proofpoint-GUID: FDyzxIgnEX3WqFR53sRhAjue-4KRV5ra
X-Authority-Analysis: v=2.4 cv=M4tA6iws c=1 sm=1 tr=0 ts=69039cbe b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=pYDJ_CTZW_XnOM5KomIA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12124
X-Rspam-User: 
X-Stat-Signature: if9jsd7gdmha51eybrjc7gn6xsx3qh4x
X-Rspamd-Queue-Id: EFB331A0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1761844420-964213
X-HE-Meta: U2FsdGVkX18wXD74Ebd7j6YajED6bGNcBzITUtSMmwonK68k/3zM9q4U9XNVq+Hel+BqK1WU5N54OJW/qadJ5R9ccQWvyOPpjt4Bx68bMF7V9NDYQGHVDHmK52Tfj7Us11UN0G42FZZ9NTYqdo3pWEKfHU2d+KwVRDuhh72fhUZtY8Y41c5qXCzq5HSDMi09Q6cllUps8hk6wQmn/OSNZFQi7I4CXf3HAbyBb8RhoeJwPTo2WxdrEp1+JGEP0x+WmSUQQKMP2ImlCNRtKbUMddT+ac7EKIoISXnQ8BOM/YQqyvlIPoXc2LPzzQoZ2/zH4XTItAwpX+fm3BUNm3O33MTsewTeDNmY/5yDwyDDi8Nc5t8HvBbrC/bTfS6N+1FPE4H8+lr2T9Wh/PROF8vK+VjKCMRSrJTHS98sXdjjaiwZ7VASQhCoQY4QsxE+dBI1ydgHqyITJH0zjXT9GJDoiYNGg0Piqnxzass4+aaNizIUeDlwMk8Me6QgSUKDQmCyQ+Lp5r9OV03UxzP/phfpmOWvsViTdoOEc5K/mYn5Zo8McO4ju8Dcv83mrovz+vrcyJYCBYb6G4QufysZi0kPqhg89uWi5yJ0sxMGs3kaB7XUa3h2/RnLIh4qyu9UMdukc0Q3faWfTJPl1uhBb12wh3x4DKC10DO+rj/TYsZI/JnOZ0g/3Zn8FoMt8CTCS9I7EEH6AuY9zkWAnDMTuSc3nL58Y1ehPGezecEOxSp+rbQ5t3tyoPCD/SRjFVA89eMhUUObdokv0YINXySvIPEq14X56hAtd2qWMnE/Usgx7FBvEeIzozwk8T1HDVDPbtL/UjdFY+efodOt62DSWo++0s3gFPbkac0f/zsdJunLJpgzV3Ta/q5q3K++YkFL2pYQn2AqnxQNBHMtFVN1qTYuF2QWZLcW46SY0Enp6/LQeQe9Zmol3l03rZjuXtlgyxIg6f1tOr+tcq9DdOgTrHa
 duqbAwNq
 jWXloMU3YVXDzIEMDhs0YdaK51y6/2+bXd+Pmgjl57/XDSU54buhrfDm0EckAPCGeoT858SqV96Z1LmNiG+FaRGsakfKkwnfPMQhJqp54r8komjhPaYpK0Ug8cwxfpyFUZyy4eEBBcsTywYkfbBhlnkDMWkxSnMiaJVjV9f2RsWyCZ1Zz/BCRkJlL2hRqzgzxpEJeiWFq8by/VCicnFpGC7nOgAfUzVS5d6RO95KwYHpR2WX5+FsxcwwKuTYWHl1Mxtym0oduXp28uancrjkUCDEVlwXjvshSTJHvjuj6ELLs0BbTaORCkUVCtatC0qFj0LSd/yScSfSFciIqiPb7vcU2BYiljDUiqfePA+l1hVvfdH2XmjdP6CeMJn+pTr7TF7P3cD60PDnm7QOmIT7gH88tFdln3XcD5rVuW1faL6qbMRkrWOQs7BSZ0JPLTrX2PTmd6lzspKJvinb1YK9HfFJqkaYh+3lMuTfrCzoe8Jz2mbbbQ8wBrItvkKRaDgv7q9AXGTaApt3j1rQXLS53dAX62mqj7O74yhNNwiYwbH2Y98Kv1lTPvoPDtDfGtJ3ZngcMednGwjq61eDTrCMcDT5inK1KGvGdHjhwY8XILwQlQkXBPM7/I4JOANBPWrwAKrMqa2QC1TqQHKSR9OxreAKw5U4fhVRUtgBaaYmIyPAiH5HiOo3z8k4mnG4+ls3cPoix5GPdX13iPffsM5kH0IIJbFpyv3eXaOD9Hhyn/db94VjyU1jcI1I5hiNchaK+poHKf6cF3cN+4Px8DEm+ccsdiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [251021 12:28]:

...

> Can you send some patches and show us the code, help everyone to support
> guest-memfd minor fault, please?

Patches are here:

https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem

This is actually modularized memory types.  That means there is no
hugetlb.h or shmem.h included in mm/userfaultfd.c code.

uffd_flag_t has been removed.  This was turning into a middleware and
it is not necessary.  Neither is supported_ioctls.

hugetlb now uses the same functions as every other memory type,
including anon memory.

Any memory type can change functionality without adding instructions or
flags or anything to some other code.

This code passes uffd-unit-test and uffd-wp-mremap (skipped the swap
tests).

guest-memfd can implement whatever it needs to (or use others
implementations), like shmem_uffd_ops here:

static const struct vm_uffd_ops shmem_uffd_ops = {
        .copy                   =       shmem_mfill_atomic_pte_copy,
        .zeropage               =       shmem_mfill_atomic_pte_zeropage,
        .cont                   =       shmem_mfill_atomic_pte_continue,
        .poison                 =       mfill_atomic_pte_poison,
        .writeprotect           =       uffd_writeprotect,
        .is_dst_valid           =       shmem_is_dst_valid,
        .increment              =       mfill_size,
        .failed_do_unlock       =       uffd_failed_do_unlock,
        .page_shift             =       uffd_page_shift,
        .complete_register      =       uffd_complete_register,
};   

Where guest-memfd needs to write the one function:
guest_memfd_pte_continue(), from what I understand.

Obviously some of the shmem_ functions would need to be added to a
header, or such.

And most of that can come from shmem_mfill_atomic_pte_continue(), from
what I understand.  This is about 40 lines of code, but may require
exposing some shmem functions to keep the code that compact.

So we don't need to expose getting a folio to a module, or decode any
special flags or whatever.  We just call the function that needs to be
called on the vma that is found.

If anyone has tests I can use for guest-memfd and instructions on
guest-memfd setup, I'll just write it instead of expanding the
userfaultfd middleware.

Thanks,
Liam


