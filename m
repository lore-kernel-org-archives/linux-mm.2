Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0F8CCFA19
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D838E000C; Thu,  6 Nov 2025 11:55:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334808E0002; Thu,  6 Nov 2025 11:55:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FC968E000C; Thu,  6 Nov 2025 11:55:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD828E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:55:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8A1B12B546
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:55:28 +0000 (UTC)
X-FDA: 84080783136.01.1AE60AB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 24CEF1A0004
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:55:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cFTX8Zb5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xZAENyU+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762448125; a=rsa-sha256;
	cv=pass;
	b=hg4BEGUfcJcZ76EMcpreXxsx0nUOa+s+wes0/mHKt52pjkJ5egDblYJEZ8XxhCMv3IJdpO
	qTdnt0tfM5K3xfU/Wcvk003of3VUa3bWaW7e8RV31f8d/CeHWI4Psf42fCpjNxPeKo6g9u
	k36VxosZpbYT3gDTugRVz0+wxwyhwwQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cFTX8Zb5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xZAENyU+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762448125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mu8WVmyG0VE6PELAkerzN58OYLaSbLHumIUlbbwrySg=;
	b=oHsXKPHsI1OCSX7GFMZe8Krb+SEajBNwkzyKZ+r+L/JhK17H2cxVsDvn41QVdWlgP5FfUC
	bypwk1Mv3fTd9azeeJNGV1PTCqI1jsqZVN1GnucyJ0Q/gdK42ILnE1P1WwWoP/dvSJGWBM
	tbGk8pISF0fQNP4QdKxO84sVK84ydAA=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6CA4uD000476;
	Thu, 6 Nov 2025 16:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Mu8WVmyG0VE6PELAke
	rzN58OYLaSbLHumIUlbbwrySg=; b=cFTX8Zb5qDY2MHl87xuiETtC4ZQv/NXC/s
	/8oWcLkt8q2PaHkAJ0fcHLTaM3XmVkCFpEGzdxF7NvLCnITXY0QSj5SXuXdch1V1
	OHdF/3lNu1T6m6+NowwGC4C2ORQD81+cp+Cl2HLnFT1QqInrqVkTpalUjuctWGax
	pcDGpU1pN5Tg+x6qk2uxSh5JgLhgpFcY3K4fgJlJjw2DyiWiIkcytE5p07cKW3sk
	pvsWsu9KhBxrXdoElOZz9hsbzlugb2W73zL5CKWhRY0f14wrowO9AUyKL6JmYP8r
	B+mPK/z3RTpmEt+cs1eXn0fNx8gzpmAKKZqiwdrclEuKWNdubjKg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8at92gq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:55:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6Gj1gU035877;
	Thu, 6 Nov 2025 16:55:13 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010008.outbound.protection.outlook.com [52.101.85.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58npfw8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uH6hpjtO1xuvZcgqiio/STLPne/fL3HdYRIRn3qyzn4ajAYzeCMH14Sk28CY2tkfdqKfR2usfNtZFKnxezLh1wyBisaGrd/ELTbTE7qtMTybfvmbTA4aq9quR6PhSMpcW6PDndKL5Qe8lVGUlbQqHMjZezmOpyaNAOaeWvyhvria3Ph7enII5tbExZJTdTK35t1uPB9m7NmEuDbq4+3ZCH11K2+qgqxpK1KXIzqVbMA8PAA4lX0+w4PI1OOB+ZPJlj3bz4TKk11FLo1lDkyYodK87VgXKQVO4akf81F3G1a+fHksDiYSycGn8zsc/B+0qSvriiTJR2X43JuKnpw09g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mu8WVmyG0VE6PELAkerzN58OYLaSbLHumIUlbbwrySg=;
 b=oeDFlzGiLDIMPzvnLD5cgkgESPvIGv2NECSd3996mIJKoOZaXt6bFsd8Cm+9CujUkbiR68GkVNJhyT3WSeR5g1etY+YyeyBwpYeeNtUi3ZGh5YSl6i35WWYna60ujjbh5cqtQc5WAJYtPueGbrHKYE/RmfdbiGTEM8maqWnEl6TUakyB01Pvwlf/OECUNzd5ky0eWmqG5xqBhKer1r3I+4r+sVTbtgshe8qjDpUC2ZomiXWMhjt+ESf1/cECiyq17Qkd983NksVJSrpmEwwPj5oq7hqrongHdlmI712Tn1YKIlT2ovKpo+4PKc5EWS/Q+5pcW0LxtbPIdl/el0wHSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mu8WVmyG0VE6PELAkerzN58OYLaSbLHumIUlbbwrySg=;
 b=xZAENyU+lyCwR/UGERWvAMWJLr9rcXjN8MwYZhkF1dZInZG6rXhOhcmBsN+Xn56k57l+hWEBOllWwMY2pPx/8a1tFO1uQ+EBV09sNBCxNG+Hooeh671sEtpD/xlCLJVZDZ/AgEF/L0PoKuWWESjOLsOTlFKgekJ0KRdYYoVcU+Q=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB4621.namprd10.prod.outlook.com (2603:10b6:a03:2d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 6 Nov
 2025 16:55:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 16:55:10 +0000
Date: Thu, 6 Nov 2025 11:55:05 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Garg, Shivank" <shivankg@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        zokeefe@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
Message-ID: <ozkb6mcxuymlz7tm4vcnqf266gd4ruiik2zal2koo5ffprgxfk@35godtyix2cf>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Garg, Shivank" <shivankg@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, zokeefe@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
 <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:303:16d::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB4621:EE_
X-MS-Office365-Filtering-Correlation-Id: 23f62cb8-21cf-4cb3-3969-08de1d553ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K8QzeFSjmnuLqU8uATrMZIWfh/kLBfFiPbMrNfvmsGFaqH5iMFgYlDcYImk2?=
 =?us-ascii?Q?39RPv5JVTwgVs+geMQmFXGszZVf/JXSNId1ZAhkoQ9ua0cIanI+lhWr9rsq/?=
 =?us-ascii?Q?SsLU87nTSPbyIQje9Xg2ACXsTJ2NSrIxoNSRhubsfkTUD21fydLAQduqzOSs?=
 =?us-ascii?Q?mvHQzAQsdCT6c1jsgOjrR1Gjz+Nvb0Fm+vQjct+KMR1UetKGss94UpgZdA7p?=
 =?us-ascii?Q?0G1FwsTSVRdc3+fI0mVKMkT1n34g2y1fDnrj1ezosoc3olBGM9khgH8qS3kA?=
 =?us-ascii?Q?FRU60nKGiSEMNm4+zU32xb0ukO+yC+2o95n16e2GVQ+RFyezV0r9VfbdDL29?=
 =?us-ascii?Q?3EhOSAWZSZlUhxphuuev3g5pAnNlN+S+jew3+Ve9o6yqTUnwsPT0JCXdXjW7?=
 =?us-ascii?Q?0eRYGphYpw0eKom89jEqbf/3vmbSDWmJphvrgR3m4wQ4ZDuZn6ZcOCq+8aVN?=
 =?us-ascii?Q?kQZOtdMb5/LasNRMdBlgbGPyPayDQlVHl2cT8Dit9sYNquNaSdu8Ez8iJ8xO?=
 =?us-ascii?Q?0m3M+jEltzxrN4OYWVzNN+vV/3uRZ4K+zZB9ytXVHivSPoEmLrZjztesGmJj?=
 =?us-ascii?Q?LAwT0SqIG9AcoUooUOuGlYQAoNa7/c/ODuioNft9bDBAA9Lr5qbUAumcQspL?=
 =?us-ascii?Q?5id+JPxgzw2BvtCqEdK+TIBMY8BUeNqdp/39SeLzJbSJu3om9MiZwROZwfbC?=
 =?us-ascii?Q?Qg4MXKknzuRK52EwdStbnq0oUfoxKmTwEIWGK1pOffKYvHK8l5BUwEMqBeHP?=
 =?us-ascii?Q?TyPSEK5uKm8z7ecgwtActHCcz6ZRGncmSkzW3Pl11LE2VoL5Sphr7Mi4QRYk?=
 =?us-ascii?Q?h9qV+FPXB8jXYWjHRSpLV5VhK2aS0Viy0NGoHIytUZ3RbmDENRrwSqKWCKCW?=
 =?us-ascii?Q?kSNVD7hmIwuCDU6KTE8ArlGG/1QhlXAj2if3SPpKi/ug2oTywmoaX7ikvH+p?=
 =?us-ascii?Q?mMYyU/Av68SsC1CCNIydXNZStu5Kl6HIBh0+SM6jRRH5VGgEaL14RbFCwdUO?=
 =?us-ascii?Q?WPJTApiP5L3xuYKqygqz4NtmpGZP9nWmXqawdG+EI/eU14E90kbP9UmtTU/2?=
 =?us-ascii?Q?shIkLc7ssZ7b6Jg0nQhUOYrbIV8I4HNuWsB8BRaGzX47PAzfIpSIN/SHzN8x?=
 =?us-ascii?Q?3cPvwmavqd+3Ns3fxpaVnF1pB7SYeqoS1owPQ/9qagFrUdmJ1BIg7IEymD2R?=
 =?us-ascii?Q?cx/jMOt0QAU6oTDGQc488pL66QnTgdAr8ZJAB8cYqPsEmyAcqqXLHgvF8Hg5?=
 =?us-ascii?Q?uEghvmuQSU0POu4ZNaKlbhSBPtFq38fUMApcd4zKwXcJpiy/quCZQuruUpgc?=
 =?us-ascii?Q?I8ZD8eMdhBWU6YiDZp1wbnfHWHHLXVhKCwPmvBcPqyYT9+PHVOwCtVmF4XlR?=
 =?us-ascii?Q?2eddv9G94kAYS56uNJ0Y7TwE15BJK8UPhSr/STBSAVgXMLxnGMVRBmry5BLc?=
 =?us-ascii?Q?prJC0AJ3sMLxamvCPQPlKtfQe7j/mKLM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bje9Zc4Bd2rDYMgdr9ZbZyC5xYZt7ZZC5Y/MyOPmZcEb65p4BcSXhtiJ73rz?=
 =?us-ascii?Q?wCSmYqBMxEqM9D3i/FPtk+ZXbtDs6mHJXcyxwLUM7Sn7PWvKKduhwWTWMN1z?=
 =?us-ascii?Q?pj57Vw0/LasfksPI+CRsm2gY5loFC0Rb1VIZv9JiLgSUk6V7kHtPxwr8Rj7u?=
 =?us-ascii?Q?i6+FEn3O7Nnzgq/xLPX3fk6M8ZBQa11veHQMlFf7Suc8T7X46SkYlwGHUnTY?=
 =?us-ascii?Q?PMuU/izupwVlQF+tY7JLRP8QusP+WRWYncMeuy/+UPdktKVGulRC47FgsqYv?=
 =?us-ascii?Q?zwsLCkgaein/DiPsoE+Pq9wjIgcTDwkzQHPz/oL8bbH09Tbc9XgzRFfhYOcJ?=
 =?us-ascii?Q?vCpDD0zs5gdx7yRN3+ehLmL9LictUv8gpm+LiMBNoKYfHufooOm9DdCz/l6X?=
 =?us-ascii?Q?42Pnafil6apzOywwQlucKlVg45tIiZjaGa2OOnIL+7QWwFSeErhgH4aZiIF0?=
 =?us-ascii?Q?2iZpSS35B83R5q7SMb9ceAwou8NOPixQWwtPm0Ggy2JM9LQgVuRjtcIBZb3x?=
 =?us-ascii?Q?WKIfA1TEK+TaeM02T/eaXrcwchyIO5hug3oFkT7iaDgQvmfsOhG+EnqNDb+t?=
 =?us-ascii?Q?qFlPSWMx8aUIg6f/f5RLjmGlPlgzc1NvRjizx6BiGV8mYTqqhmfzBAodBHmt?=
 =?us-ascii?Q?skHFimF0tpyIcIByc1VvRU/g4/vKN+o5buRuzOt2HlcXL9rd+ydEEIjy78he?=
 =?us-ascii?Q?FqPMWxKUDoaPmuJQ6I1+Rd+KT0ynmavO+islnBphk8gB49ABTGymEayci8mO?=
 =?us-ascii?Q?thVab4Y4egRFAl8kXCdq65prfe72ePbJ+KHBm5xRBx0ppQYehTUq700/cAzL?=
 =?us-ascii?Q?i5bqHq7IXiqYG8SHseoQeTl+vZQ5ZsvN1ASWOaWrT++Po92AoXU05LE8w+7Q?=
 =?us-ascii?Q?M9jfkeeIqHRV03vgPbVIiY6kjOPd7VoCZEyvrP0/5mUp+kLnL9AToclSWw7p?=
 =?us-ascii?Q?e8+LVj/grpL276uTzvZ1KKZrnPwlZWaJtsrpK2KIekpl4O1QbLAuLwp0c9Bc?=
 =?us-ascii?Q?y+L9cr52D9FE6fKpkMxhKJua2BjB2p2sq+Hz0QoBuDZ8+MnyTET2mBiB+ebM?=
 =?us-ascii?Q?nqcyQAgwCpMVZUvQ/s8Y75yt41lv0sqDRA1D+lTncOlU8WGnRP7HS74kT10K?=
 =?us-ascii?Q?00/oZyVBdMd6SaOORDZyRZazgqmNNdflNeolaOBnCyWVQm52gqgEwZI/3/M9?=
 =?us-ascii?Q?Bi++lboc6tYG99aOfrVdCqwTWTqODoe/OoUGGv49BxekjoIPmIhYJ/t8rB6Y?=
 =?us-ascii?Q?RPfMpW2dFDG7o2OxvkBJa9Qyfok9sD/njIRtDNyY4OczHLDRSUYIss8HV5gs?=
 =?us-ascii?Q?MOWaFRv2FyCR1TLG8y42XjX1HdColHx39k5eHRXES0UfCmzPX/vAwBH9J4AC?=
 =?us-ascii?Q?HjY3tyOQnK2zltEwSxhI9pdtzLyYm7UyyO32mnIiPpdu5yfSwLvFTzSUdMei?=
 =?us-ascii?Q?7MPE/IMzEryp6D6mY8KxbuQkrfER/Z6ektr95SG+YdbML+XM1x34GzUEfdcZ?=
 =?us-ascii?Q?zk+i/K+a+teCZYxyAwQ0Tp+YXJgtHtfGhpv7CDsg+yzjKZ0Fu4UwpfkIDXXu?=
 =?us-ascii?Q?0Hr+DpdltK0CyKjxwh/DTaFZT0QmDgT2D/YbksJF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PfvJ4/MdpmVuid5jyniaot/iIRa+ZHsJGEiItkN5b9uOtF+pXYr16Rp5A4MPsCfQ/HD2xc84YoLG+5U+er+VMjnnuOHaFzOYg1mLNbJxVnr+ddivTnG8mZcs2mE6AFqHLL5V20e/fZBAbLNY5tiBF5CRm5lUWgHy5SCdavARZcjBoeLLclz1zKZthjlOuZMHH3IlLZRqvx7NF1iEqyh9Cg80xoz6IuHcWIR3zvq+vK2FCsdDsHR3bJyu3hr7hS7yh1sYlgmQMm/gS2VnjmAQw4ofK7Fz2C4K78CVZ5Lwxa/6OzCn1MB9nRtcW4n/Cu3oV9NYuxr3dzgFPeVtMGbCMIuI4w2oJl236E4nyEFmsUtD1E2ykqOKfCq77TqZttKqJdKJSILOT/UVCHLhhC8cLsW2eOFIh5hYvT50Y9Nk/573vO7imyGtdY4Flh6G80pkNr+msH9pZ6EEaP1fObY1gfkYztPIKBzPBFd8JPzuaqDv1c2+fvhYsAJk+Kjy1r1PU5P8spAx1Hu1+t+BcrvmolzxDa40c02zqx2gpZWM+sSnIyvzZFRuLHFXjloo1F2hLiYGtKzeEM6VmwhYsU5f+D0OSkk7J5Du7dci1YSIc3o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f62cb8-21cf-4cb3-3969-08de1d553ecf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 16:55:09.9004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQLP3pELcDSeuDRvq5L+m7SRx6Qaq1ghSU2x/N7HKLaBmL4nYIz9DXDjgZ9JUH52ihs5R4Hhggmi9mSD7rFh0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060135
X-Authority-Analysis: v=2.4 cv=HPPO14tv c=1 sm=1 tr=0 ts=690cd2f3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7CQSdrXTAAAA:8 a=pT10WjuGWfTA5hqc9-cA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12101
X-Proofpoint-GUID: KpbHjio0GAbsAy7ozptAJZFofRlqk6x5
X-Proofpoint-ORIG-GUID: KpbHjio0GAbsAy7ozptAJZFofRlqk6x5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzNCBTYWx0ZWRfX4hmwS7rUt03/
 c9cDYF5+tiLKcG3NwSt5SIBAJFSwpbKoqI99lEe94itIMQadCT/juXsKNhrLG0xFnO/OEhRwIbN
 sqPt/I8ArN1ySsncgpXqbJJknTLfZkwrYWHKdZT8cn26IlLj3/3lrR4J2N0uwk2FCUFRiIRi0SX
 w35EvKTAzlMZ5y8RRWDNbj1wt8wYGSzp3npxyM3DtQGc7wRirpEG3wHEcpB0KcOd2boUCwII19V
 72mgpV4taDWsle5C19p6tKN7KwA8HwhyUBZhUgBjH74bIcVXuilC2J1L3Gt/nqHKidU68Us97LB
 RH+0qFZC2l63knYPL/mBNE/njK9mWtP3lo7/v1cJIudyy+vHnHHQQ9327LiMtZ5qo2F9xK3rhtw
 Kn8VpabEytWwagg6wchg/Hs9HfjIPn9ihQx+ZFZMAwnHKZ7bmLc=
X-Rspamd-Queue-Id: 24CEF1A0004
X-Rspamd-Server: rspam07
X-Stat-Signature: fftnjf4goztfepmxf3abrkcka1oinjxw
X-Rspam-User: 
X-HE-Tag: 1762448124-205723
X-HE-Meta: U2FsdGVkX19PVsTjGZbIl8z/M2q/DWSAr2DyKsk6ebWwhA73q2RS/S/96bKE0bqIIEgJPPHYstOWGZGeFQz4ygNJMC27vknhbnIOHPAizzMOFQcAV0x0Yro5PRH/xoEn9djk+lh8jNLJgioTFwNJNG1rFwg4oDpbvYB4H+qheJmvqHzW2TDczogoFh/tMXurqKXxOmtmX874SMzz+xVRiD+0Oodpa0AoodQ8OBweNRMA0G9ydkKsdIYrWQYwjeg5W27IoFKYEH33eP5neobatDaBZgWCplKLK3a/MUkHP8CElTs+XhZ8pBbM84fGsU2DKxVOsmdqPyPQnzqcGswjhQ0uyOsW/T0Igfw+CquX/yv6TbRg0MXTD69iNIntljzOAqS5KUK/dN1KnM9+zavraact4DEwvlslOJsN6E6OoFzWOqvIcGPQjG0euIZXlxE3VB8h2BYVwKYMK0N+b2FZbw4hncJvr195oXeraFgMOO1pz54ysp/q9nOVVVQn/xWPUVRtTf26TJUxkaUx0GQ5OCSN4TJ5Asg7U2R4fT90ZgBSqopml8f64CCcpySQFF/6jZfV/C1NUZ0IZ2HC+pDdtinR3/dfqMNU1haVRpSa4xjPnf7sOQgCgVaCnhYcsvHN53J1mQs4HCDJvDTKyXZ6WAUyEkbeSv8K58gJr+reLZFf98ZjDv76wCEzSt7AVx23vwJqaMbfPwt+ZrZ/FWXqXjiQRUzayFNNnRvVy4sU4Iv133gwQzH83Wf3hoBgDEOjQRiFv9PlsO8xOftx6vFJgYIjIqNO4lafhS5sVggrnaEmy9wNJwaR1XITROqmnF8kc8UKiDHuMvJdaE35abg3IJj0QNO5J8tbfdbkdrsPwh2XoUShAWpvJbVCW2xfFkhS65mfe0QF/3SK6v4wX4jFPvGi+BIwXC2eg+jXdahBgVT7SVWGsYEecb6LKeiSr1oldAaqG/SGJWj9x4dTnvy
 RYCfGOS8
 uEkJXt8XKcj/4UeYr4AIezfsVTN0j47qhBYx1dtNJccFEFNYrMrfcLboLL0ZusEJQxiNbkKZ1IFA0FxRrqg+a/EpNgOldBBXrdpkrwxLEMWItxi6exYw+MMvt7HVXrUVO7DcefXLngnYFE3OaRSl7RMqTOHXFX4rD4AOrH6k61EQvr6BEDeKqddSTW5ZMMnLolcs10D8uN1dnm2riZ9LJRHMhmyRoYt8GuoFdtbpfEvXlrwjxP9QAbu2dKGYsfqb0zcDXaFmvuHBUCsN/UdBBs0p51ZU8TUkE2yi4OvXLWjnMPnIlyy9utMyvRNU3uAfT5bscGkIsvgljYtxt8EZvhqeUTpoaUlFvOFCZNg5akU3Tvh5BEq85g7lXYfPvdfahui2fP3WDxa4hGu1xi3/wiRmXKYLwk77P6DEhn+AK1c9z3uWmsf+uEfbFWTkJgcoRfSTALbRrmN+Ze4GgzSpxNIcwTe28tSHPjCESLTfrm6Awv4htONdvMecZK6W61JhGG6G5sRYawRL698MWd3HB3JlqwfekF+Vp2U6vKaAYrsL2bJvplTbLTeWWzN1e8ml8L9InbPwcCfy8bo7DFxqu+5ia1msYAEidZVn9u2P70B+vux8XEU4UGUBcbJEAKAPtx1Y02bFSd6/bIRIrxdTAHMOXHU8PbIU6aZ8GMO5hq4R01dYbXPeMKKx/HjkPHL2sLOW+0Du9nOsIKlUkbZniF8pbz5VexjMiyaP/bpDe/fPs+QE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Ryan Roberts <ryan.roberts@arm.com> [251106 11:33]:
> On 06/11/2025 12:16, Garg, Shivank wrote:
> > Hi All,
> > 
> > I've been investigating an issue with madvise(MADV_COLLAPSE) for TEXT pages
> > when CONFIG_READ_ONLY_THP_FOR_FS=y is enabled, and would like to discuss the
> > current behavior and improvements.
> > 
> > Problem:
> > When attempting to collapse read-only file-backed TEXT sections into THPs
> > using madvise(MADV_COLLAPSE), the operation fails with EINVAL if the pages
> > are marked dirty.
> > madvise(aligned_start, aligned_size, MADV_COLLAPSE) -> returns -1 and errno = -22
> > 
> > Subsequent calls to madvise(MADV_COLLAPSE) succeed because the first madvise 
> > attempt triggers filemap_flush() which initiates async writeback of the dirty folios.
> > 
> > Root Cause:
> > The failure occurs in mm/khugepaged.c:collapse_file():
> > } else if (folio_test_dirty(folio)) {
> >     /*
> >      * khugepaged only works on read-only fd,
> >      * so this page is dirty because it hasn't
> >      * been flushed since first write. There
> >      * won't be new dirty pages.
> >      *
> >      * Trigger async flush here and hope the
> >      * writeback is done when khugepaged
> >      * revisits this page.
> >      */
> >     xas_unlock_irq(&xas);
> >     filemap_flush(mapping);
> >     result = SCAN_FAIL;
> >     goto xa_unlocked;
> > }
> > 
> > Why the text pages are dirty?
> 
> This is the real question to to answer, I think...

Agree with Ryan here, let's stop things from being marked dirty if they
are not.

> 
> What architecture are you running on?
> 
> 
> > It initially seemed unusual for a read-only text section to be marked as dirty, but
> > this was actually confirmed by /proc/pid/smaps.
> > 
> > 55bc90200000-55bc91200000 r-xp 00400000 07:00 133                        /mnt/xfs-mnt/large_binary_thp
> > Size:              16384 kB
> > KernelPageSize:        4 kB
> > MMUPageSize:           4 kB
> > Rss:                 256 kB
> > Pss:                 256 kB
> > Pss_Dirty:           256 kB
> > Shared_Clean:          0 kB
> > Shared_Dirty:          0 kB
> > Private_Clean:         0 kB
> > Private_Dirty:       256 kB
> > 
> > /proc/pid/smaps (before calling MADV_COLLAPSE) showing Private_Dirty pages in r-xp mappings.
> > This may be due to dynamic linker and relocations that occurred during program loading.
> 
> On arm64 at least, I wouldn't expect the text to be modified. Relocations should
> be handled in data. But given you have private dirty pages here, they must have
> been cow'ed and are therefore anonymous? In which case, where is writeback
> actually going?
> 
> > 
> > Reproduction using XFS/EXT4:
> > 
> > 1. Compile a test binary with madvise(MADV_COLLAPSE), ensuring the load TEXT segment is
> >    2MB-aligned and sized to a multiple of 2MB. 
> >   Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
> > LOAD           0x400000 0x0000000000400000 0x0000000000400000 0x1000000 0x1000000 R E 0x200000
> > 
> > 2. Create and mount the XFS/EXT4 fs:
> >    dd if=/dev/zero of=/tmp/xfs-test.img bs=1M count=1024
> >    losetup -f --show /tmp/xfs-test.img  # output: /dev/loop0
> >    mkfs.xfs -f /dev/loop0
> >    mkdir -p /mnt/xfs-mnt
> >    mount /dev/loop0 /mnt/xfs-mnt
> > 3. Copy the binaries to /mnt/xfs-mnt and execute.
> > 4. Returns -EINVAL on first run, then run successfully on subsequent run. (100% reproducible)
> > 5. To reproduce again; reboot/kexec and repeat from step 2. 
> > 
> > Workaround:
> > 1. Manually flush dirty pages before calling madvise(MADV_COLLAPSE):
> > 	int fd = open("/proc/self/exe", O_RDONLY);
> > 	if (fd >= 0) {
> > 		fsync(fd);
> > 		close(fd);
> > 	}
> > 	// Now madvise(MADV_COLLAPSE) succeeds
> > 2. Alternatively, retrying madvise_collapse on EINVAL failure also work.
> > 
> > Problems with Current Behavior:
> > 1. Confusing Error Code: The syscall returns EINVAL which typically indicates invalid arguments
> >    rather than a transient condition that could succeed on retry.

This is also an issue though.  Reading the documentation on my system,
EINVAL with collapse has two meanings:
        EINVAL addr is not page-aligned or length is negative.
        EINVAL advice is not a valid.
Neither are right here.

EAGAIN seems to make sense, but the documentation would need to be
changed too:
        EAGAIN A kernel resource was temporarily unavailable.

> > 
> > 2. Non-Transparent Handling: Users are unaware they need to flush dirty pages manually. Current
> >    madvise_collapse assumes the caller is khugepaged (as per code snippet comment) which will revisit
> >    the page. However, when called via madvise(MADV_COLLAPSE), the userspace program typically don't
> >    retry, making the async flush ineffective. Should we differentiate between madvise and khugepaged
> >    behavior for MADV_COLLAPSE?

The collapse documentation states that it works on the existing state of
the system memory, so it is doing what it says but the EINVAL return on
dirty pages is not documented, afaict?

> > 
> > Would appreciate thoughts on the best approach to address this issue.
> > 
> > Thanks,
> > Shivank
> 

