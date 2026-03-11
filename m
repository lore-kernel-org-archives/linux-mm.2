Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B2CFD88D8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 02:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909516B0088; Tue, 10 Mar 2026 22:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2306B008A; Tue, 10 Mar 2026 22:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2AC6B008C; Tue, 10 Mar 2026 22:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 49F8E6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:28:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BACD01B76F9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:28:11 +0000 (UTC)
X-FDA: 84532197582.12.0E74E33
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E8AB12000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:28:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KCRtQv6D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ebSp6vQE;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773196088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okJATdvHKcpjH2/qDWA9g2vOF4f+raST2YS1yBnWpRI=;
	b=q0bdwtY0kItuhgk/yH8wLozdpvI+jZaOeT8jPmy3pghXAfSixh3irEjqZLPwQts9VwNtNQ
	RO9wHizD92VUijtn9cVAD9gTl6HMftP/Kqlk4SD8Q2S5uPyK0eAZ/+5V/0T/8kl0QAJTuh
	vUU2wSbyqMVs8YkIH0BXHl6DQsmq+xE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KCRtQv6D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ebSp6vQE;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773196088; a=rsa-sha256;
	cv=pass;
	b=1DjnOcOD9yTU1J3AqJo8DRP6Ssb/B36nQ0wCb5IJeYti17w38M8eo+meYHBd+Kiva+RWah
	2EQLBe15d8dkWLVq4WW6dBkS0DpoJxokUNE0M7622DXEDimb+epJDIk3MME7Q0prCcp6gd
	PeTVl8/vSlQf8+yPTLT5kBEdbkVXvOg=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIpWtZ2910590;
	Wed, 11 Mar 2026 02:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=okJATdvHKcpjH2/qDW
	A9g2vOF4f+raST2YS1yBnWpRI=; b=KCRtQv6DJmseE3oGFcQ+2oOC39nzupJ484
	6ywMmBtjcfoKCIriDqF6dBtwordlhsY/UGdwbOok1pbFT+gn3FSKlwU5rozTTfK0
	ddjf/k3kswf9EFT5T4292XERltxDESxE/aY/870/s8ADpLL2NxMMngJdxiTgYrz8
	rtfW+Cjisvieisybmx9b55up+nzZl5c4KQrA3dJRJoIbnJKDsPWbWHPXIxdI/zyX
	goi4mwbkHcd/PFUNBYrifNH0F4anDLLZf1Au29NKmevGixctUPbq/vbmOeyvCtq6
	WTdho69gjbRqNFkTDwP3pkRsrZgg8jwrv66t0HKZ3Io/GIKgABHA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskua45pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:28:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B0q1LK014825;
	Wed, 11 Mar 2026 02:28:00 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010020.outbound.protection.outlook.com [52.101.201.20])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4craff6a2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:28:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yr2IYPf9S4dOyfsg0wOTAieVy0LaFZsqtaR6dLfDcrxcuyafDQi3o807Bvn30OMaAAQb+hvdz9AIzJSXy5RoJjqsKuu8Z2UozEBGYAn+S3Uq2b0C1vMM1/i5RWZeKvMvNbNcellUrnuyuvmsdyi4GN8m7H09qLVKB5qC81mxecKB71wCTQ0J3YuUD4CHx07ggY+9SoU32uCp/jaEsFFeMlQOOTeOcJuj62PYg5UO3eRSONrU2nNAD+L/AQjTmgpp2m5LbchJ5j34d0JPkDigzcz8NI7coD4GkApXxpJyMMG/OI0Qerf8ArdGJInNKpWk+CSursSBC+7pmQ17GurxGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okJATdvHKcpjH2/qDWA9g2vOF4f+raST2YS1yBnWpRI=;
 b=KCV7xqsdJ/9hb566IbyRTRo6ZGhEP3+uo2mFcHp56UnfXbVD9zq6p3oyErA7QRhXCGF8tQraUJ5g//gqFcHa2sigzD6FEiaG9nGsf/PAKbynHA2k8err6KnX/avrfyRsebRkYiUE4cLbVAntyUhk5ljDDQJd7N7KvjbwXv56WNbpo3l9iCVWQRqLI/KYRnjLaYLX8R3Eh1Bh85B6Gg6D/v2l/34kJfaUU6+t/pAuEUtoqRp3DcuZn0OFQPNj8VaFJD2NMCUdPN4lBIX0NcRlzQbrZAclHeJsdgF/kYZ+gX7ePT+iZLBLN1FuWWfq0Ip0mJusEprhc+0//25A06EDZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okJATdvHKcpjH2/qDWA9g2vOF4f+raST2YS1yBnWpRI=;
 b=ebSp6vQEIE8IfBes26XyhdgrOzxOs2dMeohlUzG6BB+ZjY2APO1GFZJkP0LctYczPfoLEDsZ4vzDknCys6CZlvqYj8l+YBkHizaamFzaddmao09dq1CGvzmJIS08+hBI6/ZF9R604msWlIuTIoMl7Ag+zS0UfNzQT9GT0WMKLRw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8614.namprd10.prod.outlook.com (2603:10b6:208:57f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Wed, 11 Mar
 2026 02:27:56 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 02:27:56 +0000
Date: Wed, 11 Mar 2026 11:27:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Yosry Ahmed <yosry.ahmed@linux.dev>,
        Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [PATCH 3/8] mm/zsmalloc: Introduce objcgs pointer in struct
 zpdesc
Message-ID: <abDTIomKbKApju6d@hyeyoo>
References: <aapO2Pd9d5B6MEtu@hyeyoo>
 <20260306154806.187506-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306154806.187506-1-joshua.hahnjy@gmail.com>
X-ClientProxiedBy: SEWP216CA0071.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8614:EE_
X-MS-Office365-Filtering-Correlation-Id: d400969a-0ccf-44e0-e7b1-08de7f15ce0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	uqbP8+nazm9P6U7wGOQPdpqwX/4qaUjs5ELuvwkRH73Mrak6mTIw7tae0TlKZ+G/WvyGHRRH++8RBBSJD50msA2nDrEXZ8bCrWO2wf5EhODezrUcRJfhdnzrqfW8L/v7IxqqNN8mJs7sfwEjnB1qwWlFctXTI5yD42CCcLSdHxNeJgqPu3J/Zmv6b5z5Y+Xyl6G+w6MFbDGImtKXkI40iOkksfFKrjP2L+3kpEezFm3ApjvliTViIcV82AzEPUpvawEMotF2Ib+lHmMGiV0g75Cns3n+2x5scQtsRNb4+bHt/Vskm1m/NNpY8/ZE39lkNAhowwQBGluDJgZmQjhRNRl5k9Yi2VIbm/3jvGgXFlo4REcTEk3bHhAWS9s02TpJGEoBp6akJSSG5a/AAtcT0qOwmL5b4cB50PpbbRNUEXfrpwmgvOqNHSXvGGv1tUCWHeysrzxqC8x56aojJPIocTUSLstRgvCKpXUSAXeCD2ax60bqwyBMPy+UScbzIYhMbzwgzO0ptxwIQ6b6Gy2fUYb1Ig6R0yliuzS5bu8W1BVLJ0y517Eu6MURwoJGZmY7dd6UKxTvwYetcO5xJ44b/Alb83F1P415CpUXX07QbQpIZz5a6x/AvzzbPBXc3QJrNom0CiVQsgiO0P5IZs+tn6C5kFzS9s2kxHrp+tdfkLwP+Z/CvmJV1XpedzU8GCo2AR7IeyMSE9+4tuAWHxl7FutgBHr7rrwHG7oKPJy47sg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wscsPXtLP8Lw8Np3dnjSS8BNYRmefRiFjQuiM+ikbULRhzyv6yKFkg8eZwcd?=
 =?us-ascii?Q?xlhcS/36+ehVBI9xGPzV7PCpCsN71NCLhtpAY9WTHRnU8K52bR7RvXNLHE6P?=
 =?us-ascii?Q?aUFCK+hpIfVgzmzyeDHsyTKj43bpTsQbTLuLQpZ6AVRZlehWJBfmmhY2NMrL?=
 =?us-ascii?Q?/fdOq1KYF+FHPXLzB9+pLSHv7nEi3l4vllkva3Hw79eFnTxLqeB8tQ7QMLCa?=
 =?us-ascii?Q?BWtmduYMQMPCgiav1FoI/B50aCnMLKkvctu6uQXpVMEC41ydNpbULQ+3myAf?=
 =?us-ascii?Q?8Ml7wotr4iujbPBaAlISE9jtnLTR1mBin5niGa09hm6o0NR+XoHjxHlX/Kn9?=
 =?us-ascii?Q?BAP8YPlPfFv4OZZw2DMZW39HwrDbtnBBc8bPY/pH4/Nc9AqrAsA9yOI4nDp+?=
 =?us-ascii?Q?Ban/7ZFunCVK+bqeEyQb1fEWRCdSxWv4JekxBEe1MrZzdYeRfa+CO3zN5/K9?=
 =?us-ascii?Q?N90p1fbakye90clO3fwJU9uorCn/ZIKElU45u00U1zZWTrcxd6WOM+czpdNe?=
 =?us-ascii?Q?xcJ6MQMEuDhUclWEh8smLpMb/+1FWKdgPcERUQ3Qs5AjFaUcdLhp9+Erbhzk?=
 =?us-ascii?Q?FAxY3gUBMicQGyqzqDpDMylr+c9VMucnleB9Ul5afyGgkJaaeYfIt8ZpoFBz?=
 =?us-ascii?Q?FjEm+P3AGmYOIFKjftJEpf7DoX8xZZTaO4S8gGOhBuv6hBwQAvsiQtykNz1T?=
 =?us-ascii?Q?wi51HOqZnj0fiK/7pdIYyIE3bnU0gEZB5p1HV6VNcmE0q/tu1ebq4Fcr6uiN?=
 =?us-ascii?Q?jN+s+rlfRL8qbgC2LDk0zkh6t9aXqQ6lAIwu1PDOaEu4Hk+HJIAELxcCtWuD?=
 =?us-ascii?Q?Qesupa7aoWVb9kYOKwNFSWKndML0bH/hn3CEPsjJKH9bChDtNlouVLbY4iKG?=
 =?us-ascii?Q?RWLxJgX+WoeRvtkdwFLVD1gs3jpGWNqJj3MNnIkCPs1TfxuKaRq869TS5f0J?=
 =?us-ascii?Q?EQ/u3FICHzJJ/u0pJbDuhoqNiFc9qTm2h123teZerZpUAzhNlwLyFAnG/grL?=
 =?us-ascii?Q?wJe3hbIewWNKjmepmAVB8U7p0S9dNOJYc8eUxrsHYwt9x42Uw93ChQgHjPhd?=
 =?us-ascii?Q?Q+Hrqm6cIz6Arg6C8AtTm81D5cSPn/PjgQIcEmUJKz/iQ0rYimyt0MWAhnst?=
 =?us-ascii?Q?uPmTD4t6fZP6ij/OVG7N6o7IyctjYrDZwx7W3Bo84F9ZW8s6GFPdolQOmd6Q?=
 =?us-ascii?Q?STjMrqgj2NTcy9UYinKXhKhb8SXbULx1F7Ojx32DZi3b7Ni234qCT7qP/B2G?=
 =?us-ascii?Q?YlgAvCMdSBvn68NRAHHr52oyZ57y5zob3nZqx8xb1xusT79R+Q3kKnowoTZX?=
 =?us-ascii?Q?1PQwjv51G+gRAAtLSHgH0vf9jCFO7PUfr8dL3fqatCkUHIQtuQJAsfK0lt/j?=
 =?us-ascii?Q?7uiAKIzJZhrFI9xGBEEC5B4R/VIxeuAa/m1GE+Ts0Tikuk2zn3KJ1Es7DezU?=
 =?us-ascii?Q?mdQM/mzMI/XcBlOrcF6E0c5nklcMx6aO4eoGzMPb/aUNOjyqz4N4oe1Hqf1Y?=
 =?us-ascii?Q?Mt4SwQaFNu27Egdn7+3y8gc071kpGhk90cOoLUKcQvSPyAsMvKghWDMjwoub?=
 =?us-ascii?Q?qQO0gmOoRQPXqLeT2VDbvk29JrnY0ql6rovyQ1UcM2KyE6TgmmCnQXRT1DUF?=
 =?us-ascii?Q?bzC4VvbhTHZPAtNJhrzHKH+WAAsLgs6MIqFpD4F4eJjzNUs9EvOT94TvkTrD?=
 =?us-ascii?Q?DejOFwQDkXyTw2mWVbEGVyQEcjAXMPrVwjzD3tYNJkCAKPob6Odp6WnA2dgx?=
 =?us-ascii?Q?wKCNpGrBwg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	UMNPBEcvQDVKVi49nkAgZCpLWmDeXNdx0uk1QZnFvZlkczX4c6aSZSRFoTykaCfpAjfas2DqXKO30cYJxeg8jBNJjPZDXEg8xkpqLr/9kuQHXVwJ5DrLXc80OICh0HWgsw9nBzwBAMtBLqb7aRCQn1afM6ahdq2ASeJ/EV+J6rY9fpQKsa2I3LR1nzeeII1kbZOEq9Y/qUxBBDSvl7P61XfQP9Lh0IfLlaOL4zDaoO1nq1kF3mE74skAHw6DbG0hhhQmOuXK+ut3AU5bRtZ1JVty43clK904VhvDSWY4TfHsyM7mx6OlUUibEpn9vJmBZ+pwIjvtq3IWwhAG/Z1HZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QNO97CTsdwUvqYMyWDs2nTDqp5pI6cOWpF0Y8+fYloBxGYfactrqDm758XR+1/l5pOGGQsKCD3JOtUWa64aDJ0qEBTOvokv4bSt+XO9ZI8e4fcpL3bF4Byf3/GTt6F/d5OW9qQTZope8zrx6RPOamkkN30QLXmKsl1w6WhxW7JtXLwu4lHAiezdgSMIC+f7EXxF+12vWZJrcUrBgt+xzo8lNKp/szU0H9QHAryBTbW3FZfFeodwTjIdXQw8+vktAGa/VCd0bqozQylOdtF8blAAFATg7kN5wYUBY6CviDEBx1XwOK1DnYXZ0X81hG2guNyEowxrRWzy9T5KMlUNo083xg95taAD9BKmgfWLF7rIZegtkSZPJ/TbFw5Aw51hP/pxoShwNRms8HMSDqRnnX70vCqer8Hb1cGnzewwf3zseregqKislFyBnqkTaElPMsAx1TqKXsGhmUeeYOkPx81s2dKkxc4OjJItYjkmC/pS6OP+ldNekgzgV7/KMsabVUIS1bFIjrIPJbMgRITgz0Lohoqdqs8tqYZJ0uI2QZm67l3SwX+siTcew3Zc379ZhODDlSzfMeSUTOfM+rCasobig7qjKp9JdPApuIHq/YOo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d400969a-0ccf-44e0-e7b1-08de7f15ce0b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 02:27:56.3453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBp8GKrnTUCVedEvm5TyTPMQNh2Eq7bpadk2L7Yt/2GpwWJftVjHuniJ1NGOFlwZZfxDqnaX0X4BGfPOd8q0Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110019
X-Authority-Analysis: v=2.4 cv=Methep/f c=1 sm=1 tr=0 ts=69b0d330 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8
 a=ufHFDILaAAAA:8 a=pGLkceISAAAA:8 a=c9JkxeOKgptOmh70NcgA:9 a=CjuIK1q_8ugA:10
 a=ZmIg1sZ3JBWsdXgziEIF:22 cc=ntf awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxOSBTYWx0ZWRfX/cnQQTZ1oA8D
 cmXDNW8bxGXYNoJwLfojtYwgID1WlCM/RNHgHze+XGnPEDMedqQeuQOBghaUqIY3sq9sDUPGKAO
 hLjvxzRgTPXizErx6aCcYlVQzkC2cz1pdXBeKzo5kBDMEPxAmKnytPM6PmQqtgm4f216DN56wei
 noDzEbCBuP5k45MQUMaEkM8x+AZ3M8k7BarF2RSgadFoPnxcUFTOnDjyLRbDafvoBUQ9MfZs2eG
 FHtwnuiRw9fO4tXK9DP92t57yqZMs452arTDKoNUXN1hf8ypopmKf6DMvGlPaYne60O34YNLwy8
 uqXL433fGaz07nu3W56uaVc2URGVJmhxDGkjjKcpYuFreoz8Vh+qUNe68Q3TOY8bVyygkiIFp3U
 9RybkKnbsyGTlfRZVi+nvWgvjTNKq+jDxX6ye73tuC/T9VUan2tQgN0QMvtFc2mgWrE3LB+DtOy
 5z0ZVLOhd8hyDnON3IAi4mHWzdhvQA4JULVCCHtw=
X-Proofpoint-ORIG-GUID: Ci_KEMtX5PTM1eixVrMH2ur-N0XalLFa
X-Proofpoint-GUID: Ci_KEMtX5PTM1eixVrMH2ur-N0XalLFa
X-Rspamd-Queue-Id: 5E8AB12000F
X-Stat-Signature: yqt4u45dwqr5be96skr8znbqnw7bhb4g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773196088-134086
X-HE-Meta: U2FsdGVkX18STQcBs+fKYUr7swen5Mxsxo88gsGZy6A09WregxELLVsryawpkiaQAnMu/txjWgEdo/8FwOpP+f/A2nl1tPi69YfJzXNmosrnJOzIMyvWXyu3TbziWC2Dk+Q32U1nYmWbckOGUeb49cL3I6PEXrHz+QL75BiBSX9pnfzwkBuMbvqyRUYOI9YxfX/tBsHW6XKc/3kIWQhf1GVsWCqBFRudl/M4tvRqC09oElg0p43d8UQSk2QYOYo4w47zlrGgFQKBY25OMn8qEarPETzjOIuZQDscSYFQeN6DRwsNnJ1Z0JOAnAgjW4SPO5iZ1VRmedDMUeSbyMhSPQFCvMm5mA0lpekPkjDjIP0uvl4ERi50szdG1JxxTQsiUrJrcjeRWICDYMap4nk9dlVhe3A9BDsHvl09cGsxyvIrZqej2rNCvi80bpJlhVUFSrDono9f4Omz1hkQ/GmyEFR3wUoReYNccpQEjx93FMJjf2PcGVgJt+oLSGd3MdRgqaa0W4BKOTYmoJTAgFTMQ+olEM/AxFGjOu+g1WtEz7Nc1PDC5gXYyQ6xkeM3urTanKm+J0wlKKKMo9rdQfFUx7iAREkx03kOs0p1YfYeKd2bJd7AbupVSMtN33XpnjYBdule5GGX7yOA7b9QvotXsIFEAIppOKKbivQDq83/VcXx7qtbZlM/F1PJ/YMtYpUOBxuctLbBn0E4GRDaoEMZNXPeNM1mXKx/f3jzDmFcjNvWi0gv9YVyRtomzlHPclUMIcfqCYpDUOh6jSwNloyNP6Hqt4vN2zwFz14GhK3oe82WFkKKmptAvPfkkpSuFyffeAeUyOFO04AjJw6bAB6UraEyjve3ocdzWQyEYKL3V5UFnrB1Z+av63r6uI4xRcfbK5XA3NRECMJf8NiH3WrfVxghM1pEgpNa+yU+SGc03Krx6NUMZiXKaSP9dsL5PiiifKELyAQqBEvKnnd2bzG
 eS9BiW06
 lIWGAeQhsLi8KJn4h46IuLOw9J4Fc6oC0R0XpM61DwgL3k4HQbhXuXpUBjb7rBEvPKRR0GlWFB+UKy6aDADeensNe1xoIeepTBaEbmD01JSpVKUjVtJMa2uNrkTQh2rGhFR6j9Xg9rX53cS6PhwkmrxWQX7Co9GZ8nHN9nA4oemhBmx1i3MuY4g9/h5puxXAkfTjUPudw3YVXoqXD+nnyyjzBgmwTFJixRfqJ+GedSvFCwQh21Gz5eCtRjFfKdhXtlswY+wkupo3DCfzjYiQ3S9KY1TkAcmW7/fKH8JfRLNhV8XdXdxZFOQ6DyW/fXAnVAaVsw/w5Rj+/KVBZ1MqUFP0Kay5cZ6toc5s9Mx3pRRFCrJP9h4UssMTR4kFaxjw3OTYxps+7pP/4c51bRdeTgJJIfwLrmi4oHJ5qlwXjHctWy3Dbjeh8W/Gea9bFYaQJSYPNyNI7sDeRa9znATab7Zxu8ZDU5sXzBCxxb8cm95xzLXijA/hP3+iZezhTvr7pZ0sVrAxg4HRIvfYxhtL/4eTfE0oUA7KWq8zhyDCs/M3vU5eVZdFCgZ+EcrBuEApxpTSZ/SYKGLdxwl3ofwXz0ATowunJj2vAhrK2AchjP4KUDpCVyEB9VBnCb7WW1DigD4LOqLosEut/0qII+835Tx3z9QV4HZ9zV/mRawabl2QM+leLan3mi+BFHLynWiOg+9Eru/pXh2biS8C9hA8iymSGhxqyxRuejF8gmvJJjWaBMDncMO2nSORYU9KwwSL/38US7NUyfR3IITmf0ZFLN09epy/Hva5J0gWjbV6wk9Jr8nALNx8faSS6ozvBjNPmmPnPfBUquyqmMxbWJLJLFg2nuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 07:48:06AM -0800, Joshua Hahn wrote:
> On Fri, 6 Mar 2026 12:49:44 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:
> 
> > On Thu, Feb 26, 2026 at 11:29:26AM -0800, Joshua Hahn wrote:
> > > Introduce an array of struct obj_cgroup pointers to zpdesc to keep track
> > > of compressed objects' memcg ownership.
> > > 
> > > The 8 bytes required to add the array in struct zpdesc brings its size
> > > up from 56 bytes to 64 bytes. However, in the current implementation,
> > > struct zpdesc lays on top of struct page[1]. This allows the increased
> > > size to remain invisible to the outside, since 64 bytes are used for
> > > struct zpdesc anyways.
> > > 
> > > The newly added obj_cgroup array pointer overlays page->memcg_data,
> > > which causes problems for functions that try to perform page charging by
> > > checking the zeroness of page->memcg_data. To make sure that the
> > > backing zpdesc's obj_cgroup ** is not interpreted as a mem_cgroup *,
> > > follow SLUB's lead and use the MEMCG_DATA_OBJEXTS bit to tag the pointer.
> > > 
> > > Consumers of zsmalloc that do not perform memcg accounting (i.e. zram)
> > > are completely unaffected by this patch, as the array to track the
> > > obj_cgroup pointers are only allocated in the zswap path.
> > > 
> > > This patch temporarily increases the memory used by zswap by 8 bytes
> > > per zswap_entry, since the obj_cgroup pointer is duplicated in the
> > > zpdesc and in zswap_entry. In the following patches, we will redirect
> > > memory charging operations to use the zpdesc's obj_cgroup instead, and
> > > remove the pointer from zswap_entry. This will leave no net memory usage
> > > increase for both zram and zswap.
> > > 
> > > In this patch, allocate / free the objcg pointer array for the zswap
> > > path, and handle partial object migration and full zpdesc migration.
> > > 
> > > [1] In the (near) future, struct zpdesc may no longer overlay struct
> > > page as we shift towards using memdescs. When this happens, the size
> > > increase of struct zpdesc will no longer free. With that said, the
> > > difference can be kept minimal.
> > > 
> > > All the changes that are being implemented are currently guarded under
> > > CONFIG_MEMCG. We can optionally minimize the impact on zram users by
> > > guarding these changes in CONFIG_MEMCG && CONFIG_ZSWAP as well.
> > > 
> > > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > ---
> > >  drivers/block/zram/zram_drv.c | 10 ++---
> > >  include/linux/zsmalloc.h      |  2 +-
> > >  mm/zpdesc.h                   | 25 +++++++++++-
> > >  mm/zsmalloc.c                 | 74 +++++++++++++++++++++++++++++------
> > >  mm/zswap.c                    |  2 +-
> > >  5 files changed, 93 insertions(+), 20 deletions(-)
> > > 
> > > @@ -893,6 +898,43 @@ static void init_zspage(struct size_class *class, struct zspage *zspage)
> > >  	set_freeobj(zspage, 0);
> > >  }
> > >  
> > > +#ifdef CONFIG_MEMCG
> > > +static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
> > > +				struct zpdesc *zpdescs[])
> > > +{
> > > +	/*
> > > +	 * Add 2 to objcgs_per_zpdesc to account for partial objs that may be
> > > +	 * stored at the beginning or end of the zpdesc.
> > > +	 */
> > > +	int objcgs_per_zpdesc = (PAGE_SIZE / class->size) + 2;
> > > +	int i;
> > > +	struct obj_cgroup **objcgs;
> > 
> > Just wondering, perhaps it makes more sense to have an array of
> > objcg pointers for each zspage (of size objs_per_zspage)?
> 
> Hi Harry! I hope you are doing well, thanks for taking a look : -)
> 
> Hmm, I think you might be right. For context, one of the first
> ideas I had for this patch was to have a per-zspage array, but store
> it in the first zpdesc. As you can imagine this was not a good idea...
> (head zpdesc page and tail zpdesc page? ;) )

Yeah that's not good ;)

> But! storing it in the zspage struct makes a lot more sense to me.
> And I think we can actually simplify the migration pathways as well.
> 
> My immediate response to this was that "subzpdesc swap ins/outs would
> be difficult" since right now we can just move the pointer, but
> if we have a per-zspage array, we actually don't have to do any
> objcgs pointer migration at all.

Right.

> And I think the cross-boundary cases are handled a lot beter by having
> a per-zpdesc array too. We also don't have to convert the per-zspage
> obj_idx into a per-zpdesc obj_idx as well, I think if we do this...

Right.

> Let me mull on this for a bit : -) I'll give a shot at implementing
> it this way, I think it makes sense!
> 
> Thanks again for taking a look, Harry. Have a great day!

Happy to help (hehe, it just looked a bit more natural),
have a good day!

> Joshua

-- 
Cheers,
Harry / Hyeonggon

