Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C069FA3755
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 19:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87CE6B0005; Fri,  2 Jan 2026 14:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B4E6B0089; Fri,  2 Jan 2026 14:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EF06B008A; Fri,  2 Jan 2026 14:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 920AC6B0005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:15:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E5411409B3
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 19:15:16 +0000 (UTC)
X-FDA: 84287977032.03.5B62492
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C6B9180010
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 19:15:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RRgyzXri;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nNF2U8JD;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767381312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRdfzkNTQv+INjsNfoPqDQPCMd3zdAmrvTzrlCX5194=;
	b=4p6YZ1Jdd+lu9eQReSW9S82fn7c0c1TdPzWiyIjmG9zVYh0yYt1Mj58hf9h5/GalgYzmmR
	XhDIp+f9BHXk2vwiGhZRLsX2LuIDomaw72zU/PCZV3DW+4d3hV2PQbuj6bl1IQNRok3CDz
	SRgk708y1JTuygE05tj4gFGXkhzLNTE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RRgyzXri;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nNF2U8JD;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767381312; a=rsa-sha256;
	cv=pass;
	b=BGstprhebCzA8sUpSYcAcAwoFCw5XHY7nxkUIKqlqYZ7tmEvPLnzADymevAOwDvZGOjut4
	TxHMuO8Gxrg0vSLAmPvh2KLXdi8hWBjdSrEHrSiWiJDkqjjr7mH75vChXDK7LkCMtmzmIV
	7VT28bQB1bpFAOQhQuxk6COFEXui0i8=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602BuiMU2955168;
	Fri, 2 Jan 2026 19:15:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oRdfzkNTQv+INjsNfo
	PqDQPCMd3zdAmrvTzrlCX5194=; b=RRgyzXrixI1BxNOeLF597WKY0CCyaa2hOH
	ZKt9jl2ny9aNEG4AiycArBEKY7E8e6PoIPR/rf9rgLlwXL2WiQ+6jwJq0p94CgDy
	4KfJvqgUQiS3nG+jv/aFYiq6M45WyHhSX1ybOOeOy3uu39uBHRchItNaAqh3IoTl
	fA3rqK3wcsH8S01KLjPxGaMc2L6y4Zaf3LFsNlf7y1hbcXa/AncZ5kJv/c++aPA/
	EfjBhlt+BafI5LG9OBFEQoawQ9QenzCPxgeZjdd4woRELCAUprbk/W3jWfgne1ck
	aMPeiuxC4T8HSwmy5R2ailxwHyYbYvG2Y70xG97FHJk8Rk5OHqLw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba680ncp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 19:15:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602Hq5ln039034;
	Fri, 2 Jan 2026 19:15:09 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013042.outbound.protection.outlook.com [40.93.196.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wa3q8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 19:15:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ge3lsls3VVOWlj8mLrhuHcr8OHivxPyyGp9Cbr3qyqjp6xUgxZsSgPGKZICXWRZvz9vACoT9RT2+ia8YeORG87CgXiap8dwWM3u9fUz6FWjDbzYt8rPE6RKof/xD7YvZ+tTi9G+NAY6SWj7gvCxdwRXDvz9WX60fpavE5L6cTXC3wHEwa5E9k/5SKmc96IurHkVzGUXEUWhqtmYXiK87OKzrb0ytapFP4gO//N0N5jjKaCc3rtjAT2xYw6xs/U+lh2EPnH1r+EtDoRkPfIrxa5GT2wLoENKAcfdTnGQlClBKXXFoFpoDI4XcU/RkqQbRMBbxrVDiL4XVWmTzpGTXLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRdfzkNTQv+INjsNfoPqDQPCMd3zdAmrvTzrlCX5194=;
 b=JnxTN1BGbIAMVflViLfKTeRxGdOMFIgrFOErLcbwr/EdUvbkwdHYmWqAp/Lbt2hQU9PyhfYdQiefc31VnXSywiGqkS4+GJhTy/7gmyHXJ5RMehxMDv88Ic0cijiZn+rxl7kSSP/vuS6DBRlznww1zgk7fJj/fPavl+b/ycpYVhKk6ogPTFolD2hC4kdztdwNKeNvL4M4JLoqTupjP1VPn0WuNb3T47f71WJpD8Cq5cW+6Q1VvGkj1hJbtQ+LfsWXBI7Kl5b6whEmFkQn6UVb5ZqDQJaijc44RknW0k6HyGaPZD/BgF0qObLj4fi6g3TYTXUtazlfkMLNDNMiCno/lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRdfzkNTQv+INjsNfoPqDQPCMd3zdAmrvTzrlCX5194=;
 b=nNF2U8JDiZizoFtwqVRLQ4q2kv/i8VpY565EC6KE+W4kMz/gighLd8WG/QPCEV1dRc7NITqlj29+kVysfeiwTBd95RwlPTuXcNOvDBfJx5IicgUpA5HyktzCircO3KeXlKYNfLfc9p06xC2ZODinODm+1C8ikV0kmMApCsrK0dM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4810.namprd10.prod.outlook.com (2603:10b6:806:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 19:15:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 19:15:06 +0000
Date: Fri, 2 Jan 2026 19:15:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <c5f64872-d812-442d-ac41-f237d4d59c5a@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
X-ClientProxiedBy: LO4P265CA0194.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4810:EE_
X-MS-Office365-Filtering-Correlation-Id: eade4cb8-eaf9-4f76-c10f-08de4a333d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HuRG3mA91cU8ZQ1H/NWSYP+VlT8ZQh0eooIkQNjqUnekvZ0De7qLhHCO7xGv?=
 =?us-ascii?Q?mAVZkPf5AuvxK3fZRivUsGXowsGn2k3kS3ahGr3b3k0Vsdy9ikgkSLdekg9E?=
 =?us-ascii?Q?hin/UYacxprpUX6B7PeeyH8PCjs1qyEEJQJVA4aVkSXZxou5+Nld+lKUbTPQ?=
 =?us-ascii?Q?Z3+DBkqRK3P2lib1VJ7LDm8Dhm1YeJPPVjlWfvDa3gKHV/KgbXH4qxHcENl/?=
 =?us-ascii?Q?K5erzYsOYsJDvDfwwU6XswVlLMMbMnL0iKpmfBweVjbA8RoFcpGjlEZ/bij7?=
 =?us-ascii?Q?hQ1lOznTQ2Kfk+OIDq6nIt1Rdt3a9tgcnpDLktfyotiJpQLmDL3m8cjW9QKY?=
 =?us-ascii?Q?l69rAOeL7WbjFMeQ/jGqobr3fHxT7Z64K0RlKneUuj8K6uUykubeWInhCNZQ?=
 =?us-ascii?Q?34C7WgSNkCGC040zCJDGEJJ5nornXvSw/YMbbi7QeHGHesqUD2zXDXHdOHH7?=
 =?us-ascii?Q?sqjTeMXveufbdpF8zPEasvSsdLCf+Xzgm7Jc9/AHKwDElIcNEbMcEPeQjx4d?=
 =?us-ascii?Q?X8HzjASQvn8h7VQgWK40L2XuhDlTiophtQQgbihcuGqlsAeIWTZxcCGMEqRG?=
 =?us-ascii?Q?DQdmxnnfPiQNqjE3FvOOL1tfuUvQ4d+V8qp+WY3Or2EFVj6TaABblH/HUMAY?=
 =?us-ascii?Q?8L5i/1V9T961ERFHB/ABSTeSHQcrZI9uamgwEirbNFVVk+5rC6p3xa0g66sC?=
 =?us-ascii?Q?F8Rm24wYouKyt9qsejv5d3IN73xp45lKGGpF7JQU19ZkYa8hRkq+6b8SGMbT?=
 =?us-ascii?Q?8Htu8huUuGnPcjAbQDNVBJovABMTnQKehco5JduXldUTle6Y+qIdmbJPMN+A?=
 =?us-ascii?Q?kVLq7mrheJxlTDBj9NrqyJcX9sP4sjsvLUpJCpiP22q9JOgZsDuamClJ+L2O?=
 =?us-ascii?Q?nxow7tWlOxQzbyXvx0ZOmyK/+eY+R8hfA1gH/eh5t8wJdx6Fm1T+JPEWwmJf?=
 =?us-ascii?Q?b3NEgapP0t+nNb/2yReTEUscFJckNLI81KPhyCZZL+oyb+hs4tkpQO1whNjB?=
 =?us-ascii?Q?RMmG2nQfO4SniqbsGEzf45i8PcQRC3o3QD0eQTTyzcwMyY5R7613/1J8Q/t3?=
 =?us-ascii?Q?gslTpDePR6hbNeegYX+F5FITewQjZ4nJPZbTeanx3T1T7CFoSTRvSjgu5yJq?=
 =?us-ascii?Q?wGNHZ1a8maQf0WqtHfOX5W+/SuVuqRJx0vYUDdHQP5MtxfTyRRSE31rKdpA1?=
 =?us-ascii?Q?h6epvQqL1J72oP7zdLqt0n1gv+OmAJCF9qfnB3QgUHt+1s5bVNb71U1fWknv?=
 =?us-ascii?Q?ZoD163rLSc0MbGzlYJJsnRaTq6Lt49Bxw1dDttbCvGpwWteuS7qMZvdfxlV+?=
 =?us-ascii?Q?qDGZvz0MHROvN/O3wonWgJxOxx2VIWafcx3+oeu5+hmpCBkiCtaoU8HCJdEi?=
 =?us-ascii?Q?zrzGWgwTckW7RIwPcrdyL/Z0eOBSvLevyMU9TeQrwK8ZwUc2pQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2+9A99LzQ2EiqCTHjJlKkUSeF7bgUNiA5szXQawIJwiN91itsS5L7Yh2wPkD?=
 =?us-ascii?Q?Z+IDbZTBHiUVnAIRVIcRULw5GGqmkO2zM29Mdknj4wFEZOFBivnt1dRKFxB3?=
 =?us-ascii?Q?y7mHc1OTI/11Fz5rWjFl7C9Q548mZB2sJAZctRYRKYabOSKBaBICDatPDiGr?=
 =?us-ascii?Q?XWJwzWFW0BeRHundg4O9mkBpGBb3bfMqSRSREl08bXXbhCFV2iSV8ybd2gu9?=
 =?us-ascii?Q?/GcBhm+b7UTYGybv//GIUjmJg/yWiIxwwt+/FCACYt7p1I0zwvvwwNi+etoe?=
 =?us-ascii?Q?Iownjz+ks91eyplKfJN1jZjg5rwCCl4+QuqAoKreW1JR4yboFredRXtH3Er9?=
 =?us-ascii?Q?q9Y+hxS0A9dxgVgtsMJ1JDLIdZvlqToMOvnWjG7elXNOzVkgGA83WLKd6VLy?=
 =?us-ascii?Q?iA7eR4N51rn2nrsUB+QGli0NLfZxx285q8jQSFL1PN8O3euXGiYuPPGQP3yg?=
 =?us-ascii?Q?fBeXwgu8cHDoIjHWlUSSWm/HyX/8zXHiiLX5cfvkQiwyl8jbf4WleuE/DiZT?=
 =?us-ascii?Q?hf1XTPllemuZWgP2df0CkZlSldjfwj18In+6svv9B9pJb8YAZ9zGLexKOmfY?=
 =?us-ascii?Q?jn2kJuFaaR6cfulU4oBg6z4qvyxTAReqzdG2E66KD1UH+BNeaYsIdPvJzoKC?=
 =?us-ascii?Q?n/4Z7uJEprYHt+gtaVPC3v+ZrBySQlSP6y94RdkFh3K5Ihzv6e6p/P2jxKoK?=
 =?us-ascii?Q?8BzF4mLfz04CYVruR0zrrH82ZTstEGpH1KIS6JO4JvMgfW0FTVIFF4fMPtqb?=
 =?us-ascii?Q?98Afz9JX9dNjIU/dlqhK0Ahngi4mHc202k1lu7qTTpLn2WZJb16liDOuH+XG?=
 =?us-ascii?Q?v8n81v+QGxhbvbYU8+aMptsY9DjOfPo2DufScRHMiQfFar7zgr9ft3dAZeGy?=
 =?us-ascii?Q?/GIPTRcw70lBrhbckgIErMu74KfzeJIXoZWidG3hVaBxaIqk3L8xO1Ntyfnr?=
 =?us-ascii?Q?sCBx4lY5KezCy53bLOfYfmlgiPowI2crF9SvgDznH5+26lj9OpZjzThYLy7p?=
 =?us-ascii?Q?fPNmIhDBXfHu64nOJKcIzAqGroxAS8rBoguv2zOHC/PvlMVC7Uo7MwGWW6k5?=
 =?us-ascii?Q?0j+kL2QSq25mGtj3AHBUag0/wPIio4akwLgXLHlXxKq4Caj3x5IPu38I9ygw?=
 =?us-ascii?Q?KGgykFtrI//0IGrgUWru0TBbgwnjs7TlWJ0BalHCp78hTqL1MTdDvSq4Yx/B?=
 =?us-ascii?Q?ubVOReNGrQLSKhdAa/XXFgjBGHbKXkLwq7oOXZJfsKgChFuU057Bm1jKrrOs?=
 =?us-ascii?Q?orey1ZoIEFRg6XJQpc4HfuHAuOdaPMLQrNgPGlaKQwwPzheeq0HiCaawtZNZ?=
 =?us-ascii?Q?aHY496cmvgwVWU+SZgUMLWY319Sva4Ntov+QhvvqtirbDatuO3K3rFN3TKUd?=
 =?us-ascii?Q?LfISVk2Byr2YYzZ+9IfBpp8TSVdd5FVdfhwH69f/5tRcubdXxGl4e8CMG4Fk?=
 =?us-ascii?Q?A3sR5CNovfkta4rtin0aZ9z15harY310D7D6zUFXjCQTT1HvAvHojwxvk0NK?=
 =?us-ascii?Q?4WKR4HH2vXTZugNlkYv/DDp9sjxutPGoetqCHtyWpLCiEU/Dt5+OlEXpjfNH?=
 =?us-ascii?Q?S2kr/IycgmyGkozFi1Wj3Qlm6ZGKOcmwQFYr0s3CIlN4Ocopg6vK6SNB7nZV?=
 =?us-ascii?Q?SHpx2e0hq48ZpKQtHhPVY5L70HHHLnsEbyfBWaqb06EKLcK15FolA4EjPdkU?=
 =?us-ascii?Q?WjhXcCMJcjFbW3qdkctq3/PxjJR1WBy8qZCtDLFiB+d+bb/L3EflDAsVrVP4?=
 =?us-ascii?Q?DEuG4dwt1jfjUd9kRMeUvYrvZKsdZko=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aTXq1x+RCzMeVTVu8eoCxAKt44fqlz1blZ2ohxcPq8irwXmDzfrh7tYNqQYsaHQ03ronkzMjR3GHEIbvUXLJ6iLETADussoFxsYubcLQERlYE/zB9H2gmhfGAw3R8o3mz80HO5298rH6Agf425E/yA7BOdksNjRdw4k3L/eAuKox+JXVxyAKV5slbzDJ/6LO1qEqow3W6WBBTrNn/QNmWxrNuiK6vwKx2NEAqlIQWLqHaeYWiDDw9sMw4LD8NsC3FR3SBdWWIlzivN1/ag1X1Dd1GS9VY0dcAYKijHFRnAwMePfQRu69a3rPm7CYwqADVEMIyadPV/ED+XVmtMhuzWg3xC2vUgl3xr9J/tT721LZFb5Th42YNawU+sLsv+3Iovx1wu1zyfy/Kl5XXsUjt70jqOG3WmA1t/nAZ1e3rI+IWQJepwgTP83xss52v5CtUIMu8cZLPM1SSai5tBNQreTb8ZdW7t36EoCLiAauE96r++3xJ7YKeqvL9SERozrDxMgXk+H2U9gVcco/O+DapmEIDZNGZN/m2xc3HpUrzycKRIeyJYcc5ycnyb/5pIWh+dweL1hJV3K3tXrZAWQtfsuPR+yU2A9zHtbwsRstE9Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eade4cb8-eaf9-4f76-c10f-08de4a333d43
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 19:15:06.5858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4a2Kj4kUy09pNeEvHOtXSMFies40Qvr9qSyf0zh++mKj+OpenRA+n+OJil6hBBnhQiDwqAdUu4daf+5KO/upLWj6hHntqlHDLBEQarsbeg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020172
X-Proofpoint-ORIG-GUID: 86UHXs0YDGeDsF3XRNW4WY0Y8bXt1fYK
X-Proofpoint-GUID: 86UHXs0YDGeDsF3XRNW4WY0Y8bXt1fYK
X-Authority-Analysis: v=2.4 cv=HPLO14tv c=1 sm=1 tr=0 ts=6958193e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=cojg3PkHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=d1t6VLClrKT326t4wSAA:9
 a=CjuIK1q_8ugA:10 a=DJ8J2fOkDkLJcQ4mR7rI:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE3MiBTYWx0ZWRfX9U6A5lhdfuRf
 8KsiJymM1sdWQXsEkRUZ2FpuHcOpcLnwrfrh3qQZ4unT7Jvr86q0zBtmO+KEnJ0Htnd4rbpcQPm
 JDv1FfZxPrG8vBeyzZbQfuQNONEqtk3FRwef2F9KCbgBJGDamMuefa4DiT6JJpo/5kGKpZuIbor
 zXMFygT95yIZM8+GHMfmLZRoJ1MSmw6GinKr34XIdGZ3ChSxm+tbytIPHbDS42jS+4OZ1y/Nzpd
 qkSGl5z/FW9DJ2sAF/UBTo6fpLx3p70rXhB/qYVEr0fqnKLQjmxemJdNO+PqrKRbKXKe3SZ18Mh
 eIeY9t02c2DhwIQOhTo4sqy/CMXPqehRIjyKlQCrUJJM76jQ6lsrINuqp73Vjl/T1ypeGCvlT1C
 BcQLIRT4bE7GY++osbKhAA/bwm8pGV+sen1OV0mpaqu2O7R000GxZqhDIUE6XNKs+r7cVQvn4Zu
 KUi8EcLyT1FxYgh6fEA==
X-Stat-Signature: zy3o559gbnpggksy8d98fdbk1joasu6r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C6B9180010
X-HE-Tag: 1767381312-773818
X-HE-Meta: U2FsdGVkX1+H8SbevlB/8diaAhnnjk48wgKDAIWBe9pC3nIOGdX3LIlqJ8QN3YY/VhB70olIDvIcQMogL3MakFZAOAz14zIP7WkZTXeDLG9xHa/8uWGWEQ73pQXnXC3GNDIIsxCOaWoyhi9aDEjYkDuKZ0M1NtorevulqZVHqPZ+ByDayEaLXLCDe3zV+c4oNGu3H+9CdSvYTsSlDzxRm184fWIItvijxLLQ6lflgAOr+ZDdM8zRXqwG+DXxIw5CbVqcVgEE2R0Mu5swbJ9InbfOSRckBD2cF+pqY0xYiuR1yLtaTtqcnM8vUxD7teGjxtQOk3fQAnnqhzL0C/VLxKh+2naO7VBOUHtkEo69aKxLCynOa7/NqnQKAf7hEHWthE0J4Nlql6DH2OU+K0KFbheBYZOVWijiJLsfjPYGBKuizRJN7MmlzHug4VFc5TDlc4DLRKEInuSRIQrVF19cgHRjhlFuJBpZMO0nlv8tkKiooiQhodz1R6+DUHIX+RHGMW28Tk4vKTkzaQ3WumV3Jlu3kdVKi99AdN4EDQfSyozI9UkwLVUeJC+fSECOt0fcLDoY/sz8ak2H+c91+gJqqetsN8rCXHfW+VDcx3QQtIP6RnsAyszGZA7iESBS+AzzocqNEEyjHMvDk/0r0NjEUm0AxRlzcT1bTORL8/Gk43tQqC6vO5t/b1Dkdt2rKd+d8XNf6di+5nXn9JLGm+zwI9pW7klauAUetpGFjB0wBAE8cywcUW9dn51VKht5LCqomzSYJx56TGxAiaJsGt4OIJQTghF7vuopvHYPw2qfnTiHAz67iHRElnH5gdQH+LASI0bsDgQzbD35CCOJi9QLvGB/JEOO0aC06NJugD27Edg4g7paOvNKTjsVmKxdmxQNH7uRl7teWkVkl9cU30LHwojchc7y8dhIgm3KSTFGS2kMaufsjpYQHNe/doTksxDD3lkypymVFxEWAZdowpp
 ddxfr6na
 7vXlCeTqAYptcZJZmGnk4ohYAsl9k1g/rSlB8oWafkbgUrjo+fprg9H/l8/Ll6Pmxk8KJkNifU9xhiz8CwprvxQTNRd93QAhNeVG0REPRYrSvCDNbX52AvpPf4X2dVSUjcOYLoXOat2WBmqegeDtUaNrQgl+iJ0mrZOxG9O5a5VqXDhCO+Y/MvbLP2CSpjZ9Zw9WephqKeiir2y6H8F3+4mPDRxNb8PIQj5h9pR1UVnNf2fZWoiGVv5a9HIiFjjCfpnM7Sjc5NiLohroSLROpVXDHTTGhLhz8KyjXnuOxCp1mD24ZxYBkQQJcAp0yTZbSl3LPBdoAlAcwqafIWsBrZZqYrg/Q6DYaELD6pgjKoH2FlFMyPlBOb05VPHIverJSClquaAsxKSRN1egOdV+uyx+OnHAWWXpWx2XP+QJHmxKz/cQSmvf9+thzYlOr5bTa8tYXaziUks3e0nNmPGg53EKl/zYJsPPWFpTGmmXIhaWvhW4l+VLx6cRfKPmZy7FwiehKI7+yiVZed0meJ8irghlXjwTFr5PqhgtJTrbDzqCem/pPKbIlrsFBTE8nTvOtyg+M1rpRv5CplhEnSv+uqogdPk2VyvfkK4b0gRC7ynvc92Q4FuTwq/SnziU/6HcRbCfx2fUkCblzWv5Aql0debXAgmEB2AJQ6ShWrXkknrkzb4Nw6qzaqyV/TQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And now I've become aware of this patch (!) some review...

This subject is weird, this looks like an mm fix so the subject should be 'mm:
only interrupt taking all mm locks on fatal signal' or something.

It should describe what the patch is doing in general (hint: it doesn't only
affect AMD GPUs). So this is actively bad. Please change it.

You haven't provided a link to v1 of the patch which is not helpful.

On Fri, Nov 07, 2025 at 06:48:01PM +0100, Mikulas Patocka wrote:
> If a process sets up a timer that periodically sends a signal in short
> intervals and if it uses OpenCL on AMDGPU at the same time, we get random
> errors. Sometimes, probing the OpenCL device fails (strace shows that
> open("/dev/kfd") failed with -EINTR). Sometimes we get the message
> "amdgpu: init_user_pages: Failed to register MMU notifier: -4" in the
> syslog.

> The bug can be reproduced with this program:
> http://www.jikos.cz/~mikulas/testcases/opencl/opencl-bug-small.c

Please don't provide random links in commit messages. They die. Just include the
reproducer in the commit message.

>
> The root cause for these failures is in the function mm_take_all_locks.
> This function fails with -EINTR if there is pending signal. The -EINTR is
> propagated up the call stack to userspace and userspace fails if it gets
> this error.
>
> There is the following call chain: kfd_open -> kfd_create_process ->
> create_process -> mmu_notifier_get -> mmu_notifier_get_locked ->
> __mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"
>
> If the failure happens in init_user_pages, there is the following call
> chain: init_user_pages -> amdgpu_hmm_register ->
> mmu_interval_notifier_insert -> mmu_notifier_register ->
> __mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"
>
> In order to fix these failures, this commit changes
> signal_pending(current) to fatal_signal_pending(current) in
> mm_take_all_locks, so that it is interrupted only if the signal is
> actually killing the process.
>
> Also, this commit skips pr_err in init_user_pages if the process is being
> killed - in this situation, there was no error and so we don't want to
> report it in the syslog.
>
> I'm submitting this patch for the stable kernels, because this bug may
> cause random failures in any OpenCL code.

I mean, in general it might cause failures in any code which relies upon
mm_take_all_locks() or the mmu notifier logic you mention above right? I'd make
the commit message more generally about how it's sensible to check for fatal
signals, and then reference your use case as an example.

You're changing core mm code, the commit message should reflect that.

>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

No fixes tag...? How can the stable guys know which stable kernels to apply this
against? Please fix.

>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
>  mm/vma.c                                         |    8 ++++----
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> Index: linux-6.17.7/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> ===================================================================

Whatever you're doing here is just wrong. You send mm patches against Andrew's
tree, mm-unstable probably best branch at the moment.

I mean this has been taken already, but now no tooling like 'b4 shazam'
etc. will work here.

> --- linux-6.17.7.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> +++ linux-6.17.7/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> @@ -1069,8 +1069,13 @@ static int init_user_pages(struct kgd_me
>
>  	ret = amdgpu_hmm_register(bo, user_addr);
>  	if (ret) {
> -		pr_err("%s: Failed to register MMU notifier: %d\n",
> -		       __func__, ret);
> +		/*
> +		 * If we got EINTR because the process was killed, don't report
> +		 * it, because no error happened.
> +		 */
> +		if (!(fatal_signal_pending(current) && ret == -EINTR))
> +			pr_err("%s: Failed to register MMU notifier: %d\n",
> +			       __func__, ret);

Why are you doing this here? It seems to me that this isn't really important,
and the bit you want to backport is _just_ the mm stuff.

Since you're going to be backporting to every single stable kernel, I suggest
you drop this and do it as a separate patch?

>  		goto out;
>  	}
>
> Index: linux-6.17.7/mm/vma.c
> ===================================================================
> --- linux-6.17.7.orig/mm/vma.c
> +++ linux-6.17.7/mm/vma.c
> @@ -2175,14 +2175,14 @@ int mm_take_all_locks(struct mm_struct *
>  	 * is reached.
>  	 */
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))

>  			goto out_unlock;
>  		vma_start_write(vma);
>  	}
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->vm_file && vma->vm_file->f_mapping &&
>  				is_vm_hugetlb_page(vma))
> @@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->vm_file && vma->vm_file->f_mapping &&
>  				!is_vm_hugetlb_page(vma))
> @@ -2200,7 +2200,7 @@ int mm_take_all_locks(struct mm_struct *
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->anon_vma)
>  			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
>
>

This change seems reasonable to me at a glance, I don't think there's any
legitimate reason why we'd want to interrupt on _any_ signal here, a bit of
kernel archeology suggests this has been here since ~2008 so people probably
just assumed there were reasons (TM) why we checked signals in general here.

Others might have some great insight into why we did that though...

Cheers, Lorenzo

