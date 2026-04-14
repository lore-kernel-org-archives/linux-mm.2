Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDE4F531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 00:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383F66B0088; Mon, 13 Apr 2026 20:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BFA6B008A; Mon, 13 Apr 2026 20:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24AA76B0092; Mon, 13 Apr 2026 20:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 118496B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:43:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52943140353
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:43:34 +0000 (UTC)
X-FDA: 84655313148.02.CB5995D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78CD5C0008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:43:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mo2cXwOm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=I6D1b1XP;
	spf=pass (imf10.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776127410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMuFEPdpz/t3lAQDu53Jksk8WJWawLRdLkGfOZnSAWE=;
	b=ERrfzvbtqlvG1cL+yir1QTROvL6qUpsGfw7/NmCYTpdI5IhesjG0JTVoAE8RdaMlIuS+Bs
	TJm4/2obdFrl9iyhwm6vMtBn0Bo9M5wquovsR1me9aiQ8KuzN0OxzTi/o6Fin7UyjgExpV
	5S+pAEDG+6UYUczopN6YxwX316MWxC8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mo2cXwOm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=I6D1b1XP;
	spf=pass (imf10.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776127410; a=rsa-sha256;
	cv=pass;
	b=DmUIO1TryX5Zz4r2xPewMQHa26FkeTEnfwPZAs5LRycO+YqaGKKYgyEnJIKKUzY17Ovzmi
	d3LePpxlHYlmowfYofc/BUwiDfalxFXpEI/OyKO4HI4vYI3KCfVsDQLzJqb6cA/Jk2SBj6
	FAGrf41KbSgWoPrtsecJlADeUug5FrE=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLA27s778579;
	Tue, 14 Apr 2026 00:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QMuFEPdpz/t3lAQDu53Jksk8WJWawLRdLkGfOZnSAWE=; b=
	mo2cXwOmGHAtzjmvHXH1XEIMg3A5v7Euy6uiBIpL0v8TUF/t9zyG9q0wCxlBqzdF
	exbNB9OVYCsRx0WOtFhewwWMwmzxk6OabnRC0qnJuAZm1nPnfsIXuYBVE+HAVXRb
	D0pY3n+XDv8IoQIdh9jcXNbAKZ6Akaq2ppYlleVjTivjYK7lfO/sj7JtlnbDiQ1J
	pPq7mnDm+rIlYDf0WDc0bhD7KHdLauUoqmy2zMebEpuEJFs/qKj9C4f5SKgWgLSQ
	FjqZ/YbTVkKBmLpvCrEGVkF6daOLU58cEkDr8M2xZB8jLMVMIwjFaFePjQOA7+kN
	zgfl0bd4VeaM/Skk/OnsBw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qg98b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 00:43:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E0YLjk003596;
	Tue, 14 Apr 2026 00:43:22 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011002.outbound.protection.outlook.com [52.101.62.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nje069-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 00:43:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykuNnIQNZZEue9FMFCb2ozwg4eFKlV90M9XrAjowniEyOwm77njHolmAAlvIOK3HZjx4xUBzJI5uobKd+4sGBddDXgCNn2CUJhIW5fJ1InVAvTuOKlauHtOq2uSXsI5fFBfqFx1D43yAbNEqxveV4LXbVr7tMbtwRws1bVm6bVw56QaMZlJXW75806186leLrrRSSBOFdu6V7cjEVYb9LEu213MvlaUADfrZwWpFcJ24vXzNVtz6OsEmE46QPcFyGi3aj/1EMOFKGWiD6dTRMPE/LVgmORJcKYrz/tsBTa9RXBKDKIDGfL2/QjipBDY6lWpOTrxxe1nVX17KfvDr3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMuFEPdpz/t3lAQDu53Jksk8WJWawLRdLkGfOZnSAWE=;
 b=RrOld3fikw6keJIiF9PurRAwBtFQTCN/5ene35BpPvTlyPTLhkd4/bxdgzagzAHFUa/L5sowgsAYYx5I5NWUsEbE6sUXRtQlyENx3UcaEeMS56HF/DnFDXbsca510QyR74G62WS5cfdgbZjDWG7JDD4Wwx86NrdM+iY2SgYpUbLT1/GJECdN+Q0HdzCpL3MoG5aU6UZ6I2QkSdBOAKNyreGMhWNaZuUtnkTOsLRnofaLnFOrHe6xE+t4l2tQuy31eQuRIK/XrjIajTCsp/sCRNZfs6995Y9s+InvdNbxdH3wIx33/Ei7u4zYWv+1bVFBm6V/CvoSvUDdud8CxmaIHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMuFEPdpz/t3lAQDu53Jksk8WJWawLRdLkGfOZnSAWE=;
 b=I6D1b1XPmo3LhL8IU3jFUsK109dmojseYNe9E/YNN9HRUwEe5cRMKl6VSm3kUxkwh79bPkZbPvyNaG6TNfpYZeS8UvCcjCbjQ/5XbEgXhOOjkq0GtfSAePTgUVcrUqUrNn+ldoljCjFqAV2l2XBT+foYPq0ejbbdQaZF+l7X9X0=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by MW4PR10MB6581.namprd10.prod.outlook.com (2603:10b6:303:22a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 00:43:18 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 00:43:16 +0000
Message-ID: <43370425-00b0-4853-bc82-63064eae2b8e@oracle.com>
Date: Mon, 13 Apr 2026 17:43:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: fix mmap errno value when MAP_DROPPABLE is not
 supported
From: anthony.yznaga@oracle.com
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
 <20260402003417.438037-2-anthony.yznaga@oracle.com>
 <20260401174440.0f85ea303f0a027b50d99e5d@linux-foundation.org>
 <ca14b239-26db-479f-ba58-11e15f2379eb@kernel.org>
 <2f59c4e3-303f-4e13-a0a5-e1b5e5c1a37f@oracle.com>
Content-Language: en-US
In-Reply-To: <2f59c4e3-303f-4e13-a0a5-e1b5e5c1a37f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0441.namprd03.prod.outlook.com
 (2603:10b6:610:10e::34) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|MW4PR10MB6581:EE_
X-MS-Office365-Filtering-Correlation-Id: 878a842b-ede5-4217-3e8c-08de99bed090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8h6zm0TBBpAzoxaezHoJh4/LaCf0UKtzIR2jJXHrPQJHFpcvdZnVSjqA/XLub4X3iYzO9kGnvP3qHahE1Otdmhx10a/QsRW6heWfKyJMU10G6+P67gXiSKoT1/dOEfoHQgY9lKeCzRbCnQ37bD5Yg3p6TYbdx6y5NVG9ILW2WZdJH969DVGv0JJJt7H5nlzfI4Pzoc4wEFIsHcRg5uQ4ggvgVyZIRu9Trj1bTeUsgEWEpsCBGnYVSaMUsEewcBabaqcb3fDAflQaOEp/WicjShNd49lhGTYDF0h7t3xhqr0+XQbWo7RjqOXBnydWkO6/KwuQ9nk1Iyh7wRZz8cPA7Dzp0D8A3twjhUQP8MvCMkev2/r1VhFkVU1U3/zvq62BimwPfsP4OaQRJZXw9mUqnnwJ8fjtf8Mx/7Di4/5C2cDHzKU2c12p0UXXZz8pxw4Ift0qDdzkoXf1MFSfnd7OfZA/uubAIAmyIxMgBc/aZi+cxsUkQiJ9BweXqEZ3zUYi5FIZRACizvsrsRD3JDzj3hy1rzkgCxJHSHqt9OXjHemhLDisMPgSJ+XezoUwrZx5UOoTg8vRVCLF6JWUfM0hTJcCJ1UeoQYHC9PffhDm4dM2c/4ALCSutilLZ9TUVp8cSPsYflleWQzwnBXj80TMIWLYPR2kRZCVDZwQq/6+hWFnvcsyw9ZFA4oeWxILiEX4MkbV26pglkq0XydreJpL1IndxdQ+lotkQQBRfFFMZ9I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXBzK1ZUaUdPWjl6N0VyWmZRU3BkMU9JUVZqc2FkWFhXdVYyWDQ4VFB6WUgy?=
 =?utf-8?B?MnlEVHlGdUdrdk1HQmlDUHI2aDByVDJzWkhpbXJlckJkTDI2ZmxFdUdDU2pM?=
 =?utf-8?B?S0pLc1dYWU9WZzZ6WG5tZW40UmpFbHQ3WDN4eXVwL0k0cFNvQzluWG9ZNUlV?=
 =?utf-8?B?Zm9NYnpIaWhvRnk1RHJZQi9GTFp2dzFIc0QvanBjalhGUVpFUFYwMzlub1pH?=
 =?utf-8?B?WlFkMWVpd0Q0SE9iRnliQlJvS3cyZGk2QnBNMWpKZ0M0RlJUV3JnQmoyNGZs?=
 =?utf-8?B?TkpMenJBNXFDR0RRV2ZWaGpiTThFTFlsVnZoclNOeXl4RHZDM3B0OUw1MTBs?=
 =?utf-8?B?VnBJZTZZSkZYeGppTFpsWjlSZVNMNHNma3VQdGIvVTFpUGE0U1o1bTdsZ3NO?=
 =?utf-8?B?WkI2MnBvQlJNY2FjUHhvMzdiLzdKL29uR3JIUVVpUk9mM2YwU21SMVBaaVdC?=
 =?utf-8?B?NFF4eVpmTkJBemFBWGpyUk9OS2gzRnFlTUVYc2lsdERTdmRRVVFENWorODBp?=
 =?utf-8?B?MEcrbUtVREQxVUZFWXViMzdZK3UwTUk5RytUNUZEamhReHh6NGpYZld0ZHRM?=
 =?utf-8?B?TlZheC9DQTJVYk1LMzBvVnBLWmlqOVNFTG41dFhYR3JpNmFBcTYzcjZUSW90?=
 =?utf-8?B?SS90VGFGbGdDU2J1MVBMeDFDNWU1cFRMYWRYbHFPeHV5K29FRzhLVU93Umha?=
 =?utf-8?B?RlNUQzZWUHNGSlRLT050STIzMnhMMXRFZzFDdlhKbUZWUWdyYmE2SklrYUtD?=
 =?utf-8?B?dFJWUDJNZVQzajBBQ1M1dkZqV2FYazU4amIxU0RxRUN6UmNyandwaXZ5ajNt?=
 =?utf-8?B?U3Z1QTQweE1nVmJiL2Y3MUIwK29sbDZBU2NQalRBUHNHR0Z3RG9pdGJOK2hS?=
 =?utf-8?B?QmJwcEh4OElZUFhLcDdhYkNFN1ZSQUZmcStNK096czh3TlNwNVhDdldILysw?=
 =?utf-8?B?ak5sQ3dkdkFMRXl6blhRVC9MWWMrcFN1VU1USU5MaFNaUnE1MHVQR3I3OWZ4?=
 =?utf-8?B?Q1pHVFRzZ0FYajI4TTViSGpJNEZjQTI2RjNCdG1wRVg3MjdsckZKUVVXa3U4?=
 =?utf-8?B?QVl1ZjQ1TnFBN2VxU3gzOFZaUkVvYUFFME4vWGJNZUhzNHZmL2FJUldwTVIr?=
 =?utf-8?B?bTgrUHBtcEFMZDlXQ2ppZHhMM2p5d2lqWkRzdzBGRXY2eHdaZUNqdDNYcnZY?=
 =?utf-8?B?ZURPZjhPanJieEFMUXBiOGdJQmZPT2RheGkwODRwL2tTREZqQnpvSlMzNzFx?=
 =?utf-8?B?TWhKZVpZaWU1UFBjU3UxSWUxOXh2WThBTzZUTGRPNUV2MEtKTFF4d20yNGg0?=
 =?utf-8?B?RWtHRGIxbnJNS0IyZEU4VGlSS1MvS2p1M29INEIrTXJvaFExU1phL1J5Q21I?=
 =?utf-8?B?bllES1FaU1J2RGIxUHY1N2pBb2F3OS9TWE9lNEF3bEdkbTVWQVhXSUtRQkcr?=
 =?utf-8?B?anV0V2pnYndaVzFWcE9vTERqaUVUdUdza0RDZlk3d0RvMUx2ZEJVVEhMY24x?=
 =?utf-8?B?RnFwZE9XSXV4SnhtS3lTTDFyTWhtMnJkU2xKdG5mKzJ4d0c5MEJVT2o4UzZP?=
 =?utf-8?B?bk8zRVJTcWVidG9UaUNWaGtxa3NDSTJ2M2ZJeWkyY3hxQktLMFdRcmsxbkN2?=
 =?utf-8?B?YWtNUjlRTTR2Z0pTNlhXaXc4VlV5Ky9hWXM2elE2QTRZYTRRRk1KMVFlQXBy?=
 =?utf-8?B?bnBCTi9URkpib2lBSjVCNEg3THl0U3NrWjJmN0toNXU3QUZWUWE0NDJNd0VW?=
 =?utf-8?B?bFgvazJFV2srcGpMUmpTd1BwcFZxRUYxUHZqbVgzWmZUMzNITXZQd0ZyVE4v?=
 =?utf-8?B?N1Q4bStkdjNaK3ViSkZMcTNFNTQwcS9oUlBQTXM5cHdQcUVoek14djNHUm0r?=
 =?utf-8?B?djlPcEgzN0p3bFNkSHlGMDNhV0MvV1cydjdxMWJ4eXk1RWx3RHI2aFRaaVVa?=
 =?utf-8?B?VTFIK01mMjdJT3QxZFEraHNBL3FHcU5oTTNnbHFkWGZTdTF6QXdIcW85THB4?=
 =?utf-8?B?N3p6VlJJdE1lbmVLQjZXNmEvSjZHYmZnY1MvYmdobjJJRm1vTzhIV3ZNVEpx?=
 =?utf-8?B?UzF2RGR2dWpDbk81cTdDaC95U3ZmRGJvOHZ6TVBNMzd3K3N1ZGpuUHJBUjho?=
 =?utf-8?B?aXhNajZpdmFtZGUyUXZ0dUIxeFhkblVnRE5GTE16SnhhL1RtVTV5S3p6Uk9D?=
 =?utf-8?B?VmFTbWtNdDVIS2ZkT1kxN2VEY0ZQdTBHemlXc25BRXkxdjZueUxaTTRWci8z?=
 =?utf-8?B?bjhTa2N5V0Zyc1V6WUkwY3l6NEpYZlVjU2RUWXAxLzIxdUxpM1REYW8yYzQy?=
 =?utf-8?B?WGxSQ09ONFhjK2dIWENIZG9MeGkwT0NaZFVnMkFaN0pqREJHcnNFcjYwR0Ir?=
 =?utf-8?Q?HaCI0Ga3MnRluJLA=3D?=
X-Exchange-RoutingPolicyChecked:
	NSBIS7/t0Ax4bc0lA0t1HEIO2EmlnM0hlg4/cXIhU5ZzbSfScdn1vybD4LaxFv487wwk3xFKIHZslVACJbzGp8jxWqrvVwQs2BLCPG0O6qWdAY0qjS/vLc7cesob+c1ykg2Vth8fjIZT6Sx+wU8yDy9tSYUQ+Ep6LFFbqK4bbnQK2PuGjXCN+OAMS0kvSCMAS9gSQ7FDJNmeHq5DiW22LQn5lb7oCwEm9epJZLQ6gr/ugCkF3uRLXnrtpl5L66CGt3BnWKJ7nIzhU3HQ00T2H5fE2rEjKtfHm4BTbL7+8W3PHZG7H03+KhRevn/UDFKIKkrR8NxoM0Jue3fuSSMHdQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cJC63vp7bJ6P2XOsVWI3clnDcx1AOHErBe9jGOKwALa63mtr+rz2dvCviUAhUnZf2WWsMeElcvB3R9nujmrp+RrlzpOjxBfFi/p91UqRCf1phx5tIgWlShRnL41wwX1qjYkzS9kAUCPySO72XhVn4RgswKQkgjGgKVUKCm7NqsODz0MQwwC5eGLXQjrY8U5aiznn9kEeymryZr2mpC6TUDNCgcUqiLYr9HywNzHBEXiGXEzcRhWSs07MBfo+/H+r3Hh8UIdR6WdWknL8GRYbx9tZXBPqgyAmGuR3ztxSSrk3tvz0eu81E5G41bLE9KR/HN/h5g4K1dnsg5kOh/vzlWFEPID2XGvIdObSmxF8EJxdhqicFfKIkDtzKFskncaqPA69MV6C2FmXOdHc+5P3+m0ksbzCt/TGr+PQSF4yObbfHGRhxkC6pn/8Z2kgJNjOQ3Q857kZyeRszExnHKzO6H12PMNpfiJUNPf/eAElacnd8g2EaONV9cE8exIOxeLGgJtWufoAl4Z4pdm3B1gd1IfPWyts0eW8opPl0KFHvZ+e8vqRWOwmE9BcaRIA0LjLiL6HsuclLmQmkMqCEKr1j9MB2Zfla43OWnQ3nLlr4/o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878a842b-ede5-4217-3e8c-08de99bed090
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 00:43:16.1441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5P4bWGODnAT4xxeXjlIxgfAD0j09z4LSMTPJuiCnV7hVIR+0XErRoL69kD++sLA8ZxiwrzAl2LyK6BIqlq3lvHo4tZK4EUQuArQ9VzFAY/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6581
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604140003
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAwMyBTYWx0ZWRfX12cg94teNKvT
 g1g/vsNrPPwyfhJRxfNDLPzM8JU+n0NHwvkUPNQD9YdK7zDsNZiJ4CpPcJ+gWBccSQRfe9MAc92
 ww5aqNoJaCX03mPYKeYPCHFvhm220dAo2HFcL9kOq9jsD3RnyH+smdk7qNw60UqQyWMk4ZM2Arf
 vpN/k2/NsxqBZR9eRG5NEzUfgpv3TMfwhrourKWqr4iwM80j0x13Av9eGJniT7ZK+A5ymGyhuOq
 tNYYluyFrIZoas/Tfo8TL5U8389+0wtKxgGlp0COOI+hZ3WggTAqosiiHNo3jrIXZR0ZVzgPbGw
 sblgZYFOie7/DH1RyWS2j0BuoiCHREaUU4R8tOgV9xhYhpEssWDlpPQt2s7dFfA+dkP73pNIZoz
 37x53ZchuJHqTn7MF6eF6V1IsnFzVhSdkWGE1DZsa5KUBw2Jhf8iScwH2KDOK0hV3qXx20aI4KG
 0JgEmhAj0UdMlpYNYQw==
X-Authority-Analysis: v=2.4 cv=Lo6iDHdc c=1 sm=1 tr=0 ts=69dd8dab cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8
 a=VwQbUJbxAAAA:8 a=1rGnPOzLuFrcfCgf098A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Ea53KvOTKi5cCesd9Q9iSQh3hm4sNqCl
X-Proofpoint-ORIG-GUID: Ea53KvOTKi5cCesd9Q9iSQh3hm4sNqCl
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78CD5C0008
X-Stat-Signature: zqqfwy7m8fn46brrz3iezjrhbehwpjj9
X-Rspam-User: 
X-HE-Tag: 1776127410-221629
X-HE-Meta: U2FsdGVkX1/FBf25iTZTm+a+rwWv6OBGFYbz7P0ayUpDb7+GFEk7PqK5iAnJCpTXBHZuxuwgsntVxbOtTAX4gf0ObYizzeW/vOgRnRnr/R4VcAUaZbJiL58qMwDjhdRxpEQbkcd3S6vYRoihbwdYh7yBXFDxx+8O+JVUw+O+joXVDcLdduKfCfhhZOTfryJqQAx89gHNWhRLKykyhv6xKj+COEx/PEmT5EA+2uoWLBbyUo4Ss298lPK78uPrGMeb0GpG2/usfQMVvFMDIR2U+sDXgqx2eP7w39P5ic5qGjxUsFj2hH81RYUQJoxMUzJuVw2Eyx5CpVEBg4X+ruRn61GdWkyQx9GGe1EnLavfK/t8Kzy47vdfBqmo9giCnXuHkc6ugKuqATvlK+JmdtHxf77c1+jMwz0aOC4ixtUDi8HJScLspkrS9fiU0kKR0jL41O3CLqqd271uahsE/8k91C0+2nZPf39Mw9Mx7V9H1gZx5LAY6W7sPHaiThruQcisjMexNfy/5xAaOBi+GwUKOhv0cOK58WVop7U43fSffajvjFel8IwRLtbdaBk57q7JCcPa6SAUyV8dIFfS7KERgaLcSnDa881zKwZok36vR4zRF5DX5N3FdDSwewziTg4KmQhuBfEtL2nJDK5l33R1+gyUP1QkGZ7hnsX4pf7pE+n3/KDJZCkkU7SHhK0UzKo98V2YSjqLiUUIrBLRsFPnBhKiLRS2lSULXOxCyIMC4sIn4KWkEeGCqtJ1U84Eo+AN1FG8gOaThRE629UTqyL6H6Uwa7upVJGKFWNXMO3e2/JOEQ/lavAcVhZhRV6cx/QbS8nsS/PNHED+/wcxtiQ1AhESlN4LU5yrd8sgUfWEJJ44xWJgCPVR6kB6tAal5S1QA0E9xd6j/lqlL6jgfxCAWQ4WIpxtkS0hfLLo+3t/Cz7aFbIsniO5Wup5u45HPvje9zNnT1JMar80AZdMdcn
 LWfC+0+D
 onX4AakL5LPgA5RGA/sUmCToDdPmDnLDzPqIEHWaQNneAK5mnrYH3ivpki/+xWO6JxDkD1EBeVUfzKcvi4hApGGdO4I22R3gmPq4qyJLnZXe4X9MGBWedpPf47WsXcJHJuxPKyqfaWpUBRG9HcTmuyZ+OCTvfWOyopSztJ9NUOaFdKPh90av39EsthwUt4z9Q87V3z5AXeYrZE/eCnr6EYxptOUy/oV11n1EJm9okd9JdZdxMz+RiSBDXCG/8AkUIrGDetHluNMCFjXSVNA1nJYYj5e6eIGHparMyXHMbJlT/0SaV+wlOB7dYwKFd2kz4/isLDY7CykrT/MXZz94DaZ//LiB3DbriEulHkCzR2X1grSR53wPltyYrq+d9OeZLSX980BpBlHqy9Jd0+ZHucZYKPr2Re31O1vGW7UAchKYq6v/PljFPGRQXGk8sx9wKttKoGBYZBDq/3hGAy32NhuL5b2eZLNg7I5vC4iYGg/ohPz+rYh/ZJWjFdjjOGh/FYZR+1U7Egxnv02cx9bPeHTD97LmjZQ4JRrBhsttw8RS2M0C9ic/awNIYdAwKRCN+JuPMFLc66tVFep6+rLLfRnAkPxRQVrkrM6daW7LZPzebk/kY58JBnj9ao9Zd6pZcIunxaUT1MB2Voe8Zd3EMq+cBrqpNKM3PP/ijViQYzciafVr5e5n9eyGZWoa4PGzWuLbMUSBlKUwLw+02F0OG0LmT67Gzd3jl9Rmalg6ug5v2Zr8U9Rc4MYC32g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/2/26 4:13 PM, anthony.yznaga@oracle.com wrote:
>
> On 4/2/26 12:17 AM, David Hildenbrand (Arm) wrote:
>> On 4/2/26 02:44, Andrew Morton wrote:
>>> On Wed,  1 Apr 2026 17:34:16 -0700 Anthony Yznaga 
>>> <anthony.yznaga@oracle.com> wrote:
>>>
>>>> On configs where MAP_DROPPABLE is not supported (currently any 32-bit
>>>> config except for PPC32), mmap fails with errno set to ENOTSUPP.
>>>> However, ENOTSUPP is not a standard error value that userspace knows
>>>> about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
>>>> checkpatch.pl has a warning to this affect.
>>> Sounds very reasonable.
>>>
>>> EOPNOTSUPP is clearly a networking thing so what on earth is it doing
>>> coming out of mmap code?  Our poor operator is now looking at a 
>>> networking
>>> error code and wondering what this supposedly non-networking
>>> application is up to.
>>>
>>> But just that's a pet peeve - I lost that one decades ago.
>>>
>>>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always 
>>>> lazily freeable mappings")
>>> Nearly two years ago so I think I'll add this to mm-unstable for
>>> 7.1-rc1 and shall let it trickle back a little more slowly than might a
>>> 7.0-rcX hotfix.
>>>
>>>
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>>
>> But
>>
>> ~/git/linux/mm$ git grep ENOTSUPP
>> hugetlb_vmemmap.c:                      ret = -ENOTSUPP;
>> mmap.c:                         return -ENOTSUPP;
>>
>>
>> Should we fix up the other one as well?
>>
> I'm looking into this. It's returned for the case where vmemmap 
> mappings cannot be split/freed because they are self-hosted due to 
> memory hotplug. Many callers end up ignoring the error, but there may 
> be a way for it to be propagated to userspace as the errno for a 
> failed write to a sysfs file. 

To follow up on this, the ENOTSUPP returned by vmemmap_pmd_entry is not 
propagated to user space.  It is used internally to ensure 
HPG_vmemmap_optimized is cleared for a hugetlb folio when HVO cannot be 
applied due to the vmemmap memory being self-hosted.


