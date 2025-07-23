Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFF5C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 04:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C896B0088; Wed, 23 Jul 2025 00:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD1C6B0089; Wed, 23 Jul 2025 00:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3462F6B008A; Wed, 23 Jul 2025 00:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9916B0088
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:45:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABE341A0547
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:45:11 +0000 (UTC)
X-FDA: 83694290022.06.A6884C0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3C61B40007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:45:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eE+hdoM+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sA1a1zBr;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753245908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jD0mdzNlcMJbJBdotJwBqJK0o7KLPmXDEWEBpIPQC2M=;
	b=mfKvCANqu6RWFTCZvNO3OR2H+p6Y9RNoUhXhvwLpWzXi7udcHA/Dj/qwCjZ4JyHvyyLCza
	GwAmuw9NWAV/6eKWGsV/+zul6rAyfthFggkmiN1bUTlQsp7gsMYlEI8FVLtmdxXPIHCCli
	RAz4C7lcUtY6lahxiUuqGfp9s2iQ3/0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eE+hdoM+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sA1a1zBr;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753245908; a=rsa-sha256;
	cv=pass;
	b=y3JprUKaZ8udZic5jzFx8OuMwlOmE/JlOBhuPENWSFvMq8hBlvXa2ac1hsmnami5hdhjQw
	2x4e3afjyXEkMWTiXy55i1fhWlv1sMgxONEW+707vu0HKzzIdbz5lyQJi8IuZLD6IPlIK3
	3dih+F4iooJZKhvFmLAyEEv3PiLvXCQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMQnA1023250;
	Wed, 23 Jul 2025 04:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jD0mdzNlcMJbJBdotJ
	wBqJK0o7KLPmXDEWEBpIPQC2M=; b=eE+hdoM+bvHnFYqp5RRE/utUc0UrxBqB2v
	mDsX6r/lEn2KrQ8MzumcX6mNbHpPUK0TJNjwRNCab88gl0b3Hn1kNOuv9ROGC6Zu
	ugcOaqVymFGxbk75aSuE34RpHVN/oUMO9ebwEI55TPKHyF0nrmBNdRUZRI9BzwaO
	Sf2y5CNiJUUr8UtXdT1BENjKeEzVsV2ABqhDRyjOGsyHHok/J1dqlHHyWZ8SRaBN
	Xw6QvSQrbLT6pVXKGTFRNOwhz2CLOw2dkPN4VySa28RBeDDwfYqOU8s1D3EdFEsF
	c+P5nyMS/eVnIZyLvkLAWLYWHK+lr3ZI5u+ftygFDcHg8l6hpr5g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e9prv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 04:44:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N3G3DI038374;
	Wed, 23 Jul 2025 04:44:56 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010059.outbound.protection.outlook.com [52.101.85.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801ta57y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 04:44:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iIn+J76ZA6gD5YZIu5yiOaPC6+p+sIfuZlPi8HEzGCGBtlHTdDB73Bn7jmc6QykZt1vrvPtOrf6RdKqO+viBTjdvmLtpALeUDflz2d/8emlQZRMPnIvOG3g3UsTqIRkyDZUbOL6itAaZbwkz1qlfHTlzYEb6PjNqYfvD6S5wJiD8W1aG7wAGxlkLHJcH8kXpDVD8kIwv7jhllNhIlrawc47WZcGuLKsepvDhEH4ManXfc6FUTKpAZTQykPRH0S7wIMJZvfx/+iBDeO5Q5rx62wq5ehSELl/Z8v8XnijhAni3VRs0Y6OgpIPZzaiiyawfSyiemWKHUdk3HH9k3Ji/Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jD0mdzNlcMJbJBdotJwBqJK0o7KLPmXDEWEBpIPQC2M=;
 b=Jwami+b8PXetk5MSl5DLD6hOi85LLIxZjGFg9icH+KNrGxhBmk5sj/IY6INbLWKtYn/u+hSj4ffuSX8y7QejqkEE0ZqZFrjq/9rPW3igPmS1bJDQ+JgvOVpLdB9F0cY9W2Qpk3yTPzhdkiLb2kaqksM+6OhX3mqaJIX/V/0wzuWDWlKp7O/JtZSsLGwrjFEf7WhWKJ5gwohu+SEA/FM8Rwm/4lfTa/tnXkEq9FyzHozi0iC61Hvb6b1kVDcQvodKIPDkDQf+SvwjHZZliwzxm8WgQ7rtWOAdQ0mhCeW5DhaaQlo+fVykmm+hG8RAatyYu+7ahKkG8Qyrh/l2jN1HLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD0mdzNlcMJbJBdotJwBqJK0o7KLPmXDEWEBpIPQC2M=;
 b=sA1a1zBrF14a9R6yqlD6LHpFYO74lrxYtqruvAqaf3ZwVcZ17n2aFoMWEMKqhGWlEqw8vyL40X+UzW3co0FE+KVCOCI/3qW28aDUjJrsaj7rpVMmCNYktwbUMAgbBSV/32evp/DdQ18Jfzjs2JAiqx/MFY5lWLzh3HDe5btIk/w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6110.namprd10.prod.outlook.com (2603:10b6:8:8b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 23 Jul
 2025 04:44:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 04:44:53 +0000
Date: Wed, 23 Jul 2025 05:44:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH] MAINTAINERS: add missing file to cgroup section
Message-ID: <cfabd481-deb0-4362-88a5-5ed9c0e818bc@lucifer.local>
References: <20250722181409.154444-1-lorenzo.stoakes@oracle.com>
 <bdetq74tgtlekfzxjzfpv2cu6kgwarzez6tfzui7fopznzpn53@x3kjfgkggjua>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdetq74tgtlekfzxjzfpv2cu6kgwarzez6tfzui7fopznzpn53@x3kjfgkggjua>
X-ClientProxiedBy: LO2P265CA0400.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f5740f3-4c6d-4858-0aa1-08ddc9a3aa78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fBPH8QcCgZw/Vt1W4zx1Pi8JYB2azksy7cltoIcS5g5FBwlO06C1QAMowlDH?=
 =?us-ascii?Q?jtGdsJ7ksQkS1LyAgr5EfjYPE/gphs3LsxcLcBtvAQQLZJyMTt5pRDituRIg?=
 =?us-ascii?Q?doS3HwjoZxIMbck2yJwC7qJ8oV6qYf3Bl7k8PDs/v9yRcS1FlREZopipYV78?=
 =?us-ascii?Q?OWZ/6k2E8LGrA5D91iBvP46+BgtIOnjaJjp9deSSUTiZBYGZcVBA5gEaCB4Q?=
 =?us-ascii?Q?WGjdGPaOQ4jGLUXBi+OxgL3N6pReZ/ffrT771Ea/vGMBcZ64IvZ5skxm3kGU?=
 =?us-ascii?Q?n/FEYcGfv0FH68/XCJ1T7+B4AtNaYP4An7AAsGz0NzS+6cNNJoYU/JTgJyUe?=
 =?us-ascii?Q?nR0hYIiGxusmrVIJd1LlscJjXz4OT6Cy9EwgtUPLJbuEOPyjXAWcYP9c3dMD?=
 =?us-ascii?Q?KgivDyDF4eA+PWl60My4CUNDiFRJQNETjrJ0F4Rz7V8uf/c74EcU2NVz/ih0?=
 =?us-ascii?Q?VJVrZCRR9FT5ulwoE88l0fZLJUC0NrfS3rcE5RbanB3BsLbBiAAOdPj7TqIy?=
 =?us-ascii?Q?v77kuDro/y8yefG44dh37wjkk76njckmUiO7hd/iyaUz7amkpusk6Bkt+sIE?=
 =?us-ascii?Q?Qybmq9Vh0CoJO8Wxiat2oWWA5YAsFwrkJcNkGJbOVvJC9lsl511A6YFRm9dA?=
 =?us-ascii?Q?xx+o/2ZO7W90ZawYr72E5pKosuyzVkPhAegOU35ihjRceTQLLRGuG/7eobuH?=
 =?us-ascii?Q?Fy/E1AbImoolLBhi0hgLsxtgl70gLdGvGjfOUOmF0mpEXqXrb6ZqVumh5YbP?=
 =?us-ascii?Q?dPlhtKWrc7PVQjCKaQuiBd2UWmBp8HWRvhjfGeiPqtMfchWJ9ooZAnGJ0Jk+?=
 =?us-ascii?Q?JjewNu4uJVc95Z/nmiAcWwGrWrSWi3cb0jLLAzP0aTelCe9LboYsrLzmVJhc?=
 =?us-ascii?Q?JBBcZNcSiDqZvcTrSGkSzc0NS7FQuTkLydzFl7tp1dokGNnyMOGKnRRec21S?=
 =?us-ascii?Q?1HlYQSslnSv9FmY+LWboOMha5jaFst3TRCObZufoy7vurx22WUU0twcBlv9F?=
 =?us-ascii?Q?3z05Ku63CWpB3uQ+f4GvPKQsYF3+7O+TaezJkdiQSPaxanrfYHME2AbCZ5KH?=
 =?us-ascii?Q?Dlk/lj6p3qFSpK2m8iu3lEr0iFNAAKY7bOaypo+SjfrD4PUgs8WMa2/ls7Lx?=
 =?us-ascii?Q?tIf0YHdDlw3tCHMmW94uneYWAM56pV9HAIa4leiXW77saCNXjVVRFYYPhuZ4?=
 =?us-ascii?Q?5NSUrdVNqzyRPyh128DLbO5lP2iyVCkY0j0GGyZgu/T1tMtSOvTlDQuLQBal?=
 =?us-ascii?Q?Le9fEdBy9ujAGOK5w7xp9L4k4uit5epCcAU+h0ONHaLa476sDyP16Q/p7yEJ?=
 =?us-ascii?Q?5uq3MEATVgbSdh+L32Tim+q7PmLhAk0+dyxL7XAJk45qGG6ISslmCs91SPUS?=
 =?us-ascii?Q?PThh9Xc/9JL3rvpeQh8PKXsmmEI9CQJPs6Vpl8bB/aVfHvo3KjSlAit/u5M8?=
 =?us-ascii?Q?q5WePNqfUWU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rX48UCyTqnoa1DJjLhPHp3M4Yj1kdGRlGZuXQwOwSA0rjmnjShTEC4kiBUpf?=
 =?us-ascii?Q?bjmvmxUskRgWfywHTWnT3W5eW6nIcBKcETY7TQ3mLs20MgbRClZFNB7YWuM4?=
 =?us-ascii?Q?6kiVQYaiZtZ9BAFSBpO+ICrY8kyAhMRRNWpqYiC35J7DqqY1t+dAqXlzsHZ9?=
 =?us-ascii?Q?oZQiatXwCmH/Hl84HfqiSl9HSUFd/uGAHzdQkV+MfmB8n+nkyxMFECYtLbNo?=
 =?us-ascii?Q?uIbq+RXIatLfXXC6a1yGmVv0VlJ9Am2WcuqJCHcM/LPSX2kUL///T/ZBldPD?=
 =?us-ascii?Q?Lvi57/3gopQq3rROjQlqzav8jYSUSqOXXeL0UhZ3BY+5Efs632aznV+E7Crx?=
 =?us-ascii?Q?oQBHHxetIrFYKh0f/xrdSoMFYqSkItUqvYzRD7ZxY+8cPQNJtx9dG77cpXqi?=
 =?us-ascii?Q?3EbtWEkHE0sA29lkwgCFFwrcaXTj7ZRTlkf+NS9G8I7wdO4wku44ySd1YR7p?=
 =?us-ascii?Q?bteUtrUf83LOxEt0k4G3ojoL3GtPEEdv0hVKIoIE3DVhk+SCshXRdvrHjn4Z?=
 =?us-ascii?Q?IAOmgNlLmG/k9IXYoQjYFuXJZ3TlDfXG08OQtKcsWJCNc/U5n2sOFHh5ARny?=
 =?us-ascii?Q?wuH+DppICjkYdTOXAmg+Mg4UHL2R/VqTG9Os7Prl9ZJZimrTPE4dwvPRK+jT?=
 =?us-ascii?Q?vzKui14M5x8W+mwBoH+hfej7wCEynCAJ1RiUPMspEDhwAA/zwQZITnmKEasN?=
 =?us-ascii?Q?Q+lPsPRzMjxaWF+w2kz//2P6Ao0QbtBF67HE6/e4AVm2fQ+8DjjxW171YXwf?=
 =?us-ascii?Q?x2uHajE3sLqy6HQHphFBQ/1ch9AUrePubwvtPIZ+aUWlvwzptp9Hh9WpVHQ1?=
 =?us-ascii?Q?pGdBcjGZeeZTLtkqLNwqnn+wR0dJwUfwHZYtRjrIEGfpODZLw3iI36/zxk9U?=
 =?us-ascii?Q?7W+68a29cNIW+4AEF+hMUNuiAp9aI7CR6K/fUpKjGSS1hs/QglgRS8xsv5gU?=
 =?us-ascii?Q?h/6pJrlJ870S4ffqc1Bz38jiOZR01PMhGjYGim+vNHXcYrcq43DeQFIyfB8K?=
 =?us-ascii?Q?Ghrd1iGxGC3u2ehGN6Fb2SzUy/idSC/QudUHBhGrzUGgxhVoNi7dXcAS9YxH?=
 =?us-ascii?Q?wjP+0/sTcwg7tm6TpFVe8jH06xqe65sKMWPxET9gmZ5jqRZ8NkxZ79fRhoDX?=
 =?us-ascii?Q?1+PeZifrmzlLTyI4frsaDLS3UNvG9+sB4Z5CuyEOwl1vn5ZgaRO8vX4cNZr2?=
 =?us-ascii?Q?AeuiUuMxNXkkp8xg9Jj/zsXYJeu4CPtWjjk60sMTtqSy90ksu7O1XhcKqw5R?=
 =?us-ascii?Q?/8i1sDoNfxFp3JcAjwcCJGveia/WBr4/heWGcUJZ+wGROwn54aomcjoDaSPY?=
 =?us-ascii?Q?ROwdwcKtl3IEwm9QlFlTLRr8FyCVEhl7Ovo2nRbjxEO+OPyPX2ZntciiB5nQ?=
 =?us-ascii?Q?Dwi2ikolkF0dR+B6NyNYQekO2HCTBC7M6tgFzx+3THwSk12VcYQYBI5H2wBO?=
 =?us-ascii?Q?hjqT66yQl2ySA9uykEZFRo0+Ew2m3dGVEaLoul+CKnxf/+MAmwk9wRKOucX+?=
 =?us-ascii?Q?13WsJwP9DG+SMq6oB3+Tg4dUt6BUe/D8SV279ZMEhvJFU4ZAxt/PKOkFU0wg?=
 =?us-ascii?Q?RRL5PO1n/3JfNSZuhch/Afa5uh3n+X8VKsbp/+RnJ6GrS3SpXIHcs9nymtm1?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ea8LEtEhIunQb+70QueZieudkQ+VrgLRWPmWi8Pn2yDGBsFKZKV98YJcERMuFNgZGZjLnbmJZGlE6/Q+wXp+D7sCO4B1GRj+IKmxPkTHUxQgyBOjEvpDXv3Cfrxt5AOCf1+P1tzVqJRnfKb9T6Gt0OuQda3tD7qd68Sdi9beG0A931oPfWr/jGtJ+tVeQ5CHZjb4juzEaW776XEgf2/5HxFNDlFHhhawfUjNHyBKqSw5W6wr1XHPePUM3HM2qJZPOumPp7IMHJjvV8LPjvgjT93Y+Bho1/buysUwULT92driMoZS+ahZyZ5SDGDYz6VtXCP/6nTjlks0bUDSYg19cnEM/aqjKct0TlX+kiGRTEGXWS1K8pXK13EW9yCH0B9j5Fl5iad7Dezgp/IJmgFh8FyExbsrDJgwSa0kp2JhnzI4JL2aFkywjIi9cAogphM6xWIYPqXs461eVZwFOT95LWKOp9Hg2Bu96gcazxi4lpro5HBi+cdPmIbaIGuuIJz5yQBMs5m3oGbxOLvMAxwXnHOsgdlFoU52aaYX0+zjkHAxhUmCy+cM2SwaO19w3ZId6OQqMTLN1ApBolPDvezkoGaHt6UGWENCCbDsIvqKWMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5740f3-4c6d-4858-0aa1-08ddc9a3aa78
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 04:44:53.3975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBl0WTwUL5vNK7qabnwGIfUdUsum7wK9peTp427ezelMgZPoKaJ8rc8aUeIAsyAnSqMRpFi1naJwKQ5TcHIhCG+pgjd5FCC3unIc4UL2PUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6110
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230037
X-Authority-Analysis: v=2.4 cv=eqbfzppX c=1 sm=1 tr=0 ts=688068c9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=Uy-tprXks4bE9GmLsj8A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12062
X-Proofpoint-GUID: 9jrtGOBkYkBoqZy8dNm-YNdS5-7KGXIv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDAzNyBTYWx0ZWRfX40vQzrIa7CqG
 hN3lPPSAZmCajy+xcvkueiqBA5C/NOp6GIQpFjIoRzmRwQ43RodUrqx2QE3Q6rqOOGWK4gsnv7N
 1KPgAel/PYC8CZrfUXMLMXgxYvG+X2ogZLcLPPDRNJ3WH66u3FrH8wabvo9t19QxChl/LQdITxY
 IsHV4DajjQTJg/fOLXmFJmqrvFgpqV4RQ+iN0s+giNRFNPwrnhPHua/AK+BQmF9ptQgBj3V3KT2
 aLg137J+LAImdECBlkvxHLI5JUB1Ryy/9jXnXopLhaj4mZaSHAzkOzEu/qyhl2Nq9bGGzfZob1p
 OSULZw6gHDW6fd9CkPu1S3h6f89LhKvYSHu/ZZzL0WYOgEXusP348EEay87UV6HqSf6fW97jWJZ
 EdzFyNyhIjscsUpYgvkZhp884TmbljmW1XvxqODGV//SeQQVxYETEski6U7VcN1xyxok3oVz
X-Proofpoint-ORIG-GUID: 9jrtGOBkYkBoqZy8dNm-YNdS5-7KGXIv
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C61B40007
X-Rspamd-Server: rspam06
X-Stat-Signature: 5985b4honc833qkj9ybykiwhnab8kcec
X-HE-Tag: 1753245908-969271
X-HE-Meta: U2FsdGVkX18gyEwifDL72eRH2Ch2puBgOwTkhNZB3gdhuHf4D/W79MAbXejU50vsiz3nQs49OyUdx+/Al/TrZG1BpR2kZ7zFsy1k4PS7FbK32i0wxkHHry8oq5FWWxXf/AEQBY3Tf68M6E7Rk8d3Nn37A+Q2/l/e64TwyFksrKKhsfhLLJkLLEr+hb/7WrC4h8R5F/mZGsxqn3FxoLfoEcbpz2u5Q7YpdOeGI9zlwkEQm+po6Jv1Hbydro5OJIWyJiGHpm6wvAbQvV0z+tn4PP/W/tTDiFkW/U7iP9TxgDg5hyTqhfveYusnSNsUuSbTArWft4A6BPQUYTwZHi9HZCWcrWc2Ds8Pv6vyXxIx0SuwulBn/PsjApcGwfd8GdveXIR8FJ9awYwRvoiPJWBzv+a+pxLXNXGS2rOXSAJ9LRJvHq+BZHOB6vRYD1BZjUZV1Q513zoF5T4A5SFoBSwZbaDkY/oGd8cH5/j2mPhnp2OXFkwvNvqA+GPQTK3w5f59TL8LXmdeHHCtIgHd9+bxvTlADRZamyBwxGh+hrJi7Ewz8hFuewiA7rHBd2QO/EkKH1lLDzOcZQpQWt4Yfqzsg3h7EmDFo4TxgPYF8JngbYmRd06jvzVhqRS3DGB2zc3QmvgZtCcBQJM4Ox1eW7sbLbYWpO8vwDW7LDrYJ2LK/Xv5s/XMBCQ3q6uY3jp+5Kkj4pwUUzNTwytK9BXOaYpyOrG5ejRPjINZ2aghhS4AfBzGFuJ1Wg72xai+Jis5GIuRPHqDQghwNKVaqyk+2FR5MUPsNemg5MMuKiVE7/1X+YmoHcYDH8EJe/d33+Q4ITiWyJRN4CIT3kCgtF6MFv623UgKoSix138nFa8HMdme3ueE143YxWsnm9/1olsoxV4yMUGDygg69igeRRhDmbaVbnBTHS1mKU9vlbh/VCzG3ITiD64aVZqabdGIPTfvVmHSL51WImSezCFG2NLyduy
 NNMWh0VH
 JKayt5Ekdl6KSvaDEt9H2PtWIyIeWKlzT1Gr0tZon/Nok4XRgn324kKBd07qs71YAZGr9OlL8YAVCvEPs1X5XSRzBkkSsqASp5ym4UI0fi29pnwgcGu59pY9Cs1tPdoohRbcFtQgEEbcAFka07BnQe37RndHuTIGLAOWtENIxjeZceB/gfntrlN/Br7o40nkQcz4yCbvbz51ryicAjMb+HjQJWg4K+GU+5OOEaAb45cljqcSEDV1eqM47aZPHwD6CIV9WywvGlc5Uw/epf6mNNMoWkxUbc8EH+++NNIaQsJJy00lKjPDmujgziZt0PSoieYP0Pr9anaIdx8uRm7/BSmtdtRw/QMO9k3GG7uCfNIReKUPqKsFlLatlFSLjmJDdg/TIGrtlxuBqPdCH7frDEzTYwKR7fekZNiWOq4szIo8FWZHr/OqV3UMGJbBeJJJsSer/Obuv4JS7v7fh/UMDTbZVhlr5JnPYgLlOpHlxPvPdIPhqtDcA9bh98H2jzONHCJTmXRvbxwogZ+NS1tTJMGHvrIS7bFRjWdCXY1k2FbqSfk/1PLITvnWsR5ETfrMDyMm9ECv1l1SuA6viIvbto1z9YKHoAikxGP6+2ZdrHwunElUnAA4mT7tcmp2wW27pw4s6BqbL2t/to+BsIyCQtWTUpRWDMsHvsubW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 01:01:13PM -0700, Shakeel Butt wrote:
> On Tue, Jul 22, 2025 at 07:14:09PM +0100, Lorenzo Stoakes wrote:
> > The page_counter.c file seems most appropriately placed here.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Let's add include/linux/page_counter.h as well.

Ah yeah good point, thanks - will send a fix-patch to add!

>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!

>
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 837bc5cd6166..d062318b6d09 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6166,6 +6166,7 @@ F:	include/linux/memcontrol.h
> >  F:	mm/memcontrol.c
> >  F:	mm/memcontrol-v1.c
> >  F:	mm/memcontrol-v1.h
> > +F:	mm/page_counter.c
> >  F:	mm/swap_cgroup.c
> >  F:	samples/cgroup/*
> >  F:	tools/testing/selftests/cgroup/memcg_protection.m
> > --
> > 2.50.1
> >

