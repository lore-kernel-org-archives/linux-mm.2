Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D923FA3753
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 18:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F1D6B0005; Fri,  2 Jan 2026 13:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F60B6B0089; Fri,  2 Jan 2026 13:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679D66B008A; Fri,  2 Jan 2026 13:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 528C36B0005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 13:56:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E6E5C31F2
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:56:24 +0000 (UTC)
X-FDA: 84287929488.01.29B259B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id AF0F5C0004
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:56:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=paOMAgWz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PH6NzxTH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767380180; a=rsa-sha256;
	cv=pass;
	b=vPKl+JQHGhrZUoedzTjE62uvo/aLAlxbTeWR7iYuWz91JiZjkaJ4xBtYgqB/yALIP0SNWG
	jCf+sMRR9+PV65f0ehdNAvcDu4uXHz6udLJb11iOIK9FD8Nl0dlNfVoA+UaPl5QAoYEsl/
	KmWugIO9SKZxxwYabMOTRmF9tvEdRpw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=paOMAgWz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PH6NzxTH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767380180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TVmrfC2prSAkUdIiONZnN+fpnYtTz5eLEtHC8VlugU=;
	b=H6zKVLJ+5BLrcAVSh1QPstWLWQY1WmgINI+Q1ItQkQSPMpWOwSvVVZNI32CxiW9SXg8aQM
	QBLiVDu58ISVuVKkIJENYPObzJwtCDnxI/PMNVQlauglSQGd9OCN4iGAirrcdi8KGuMljr
	HPTpveUPGQXpsknQ8TfUwXTtclgyEps=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602BufcQ3049522;
	Fri, 2 Jan 2026 18:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0TVmrfC2prSAkUdIiONZnN+fpnYtTz5eLEtHC8VlugU=; b=
	paOMAgWzESvSozE2JOSSyS/PRgwZOBiAxMSBMYkqIY6BemQZV/4KjWJ4HGgLq/Yt
	lBRldJPJOtIRmOS5TttXqFWKQ03xY49r883dkcq2QPuDIUJgKeABpVfPSshYZCSp
	MDURuSWabFsTYAja91tPWYattReRxiWPmQU7BDr1+XieAiOVs4WqNr2/WdaXLGoq
	B0IM8e+fyYU8Mfq5wofGddN6LSoBaku55ZxKwWpJ+pvMN8hYsRn1DYMd0ISvi1Le
	8DRb3noLIksLRsbL/QvS6WpPqhY2/WJrbHKaCx3SJudcEymYskyZaJPhx1WRJQqf
	4VwHyYfoEOPzsbkdiyzbNQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba72qnax3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 18:56:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602IXohi024486;
	Fri, 2 Jan 2026 18:56:04 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011064.outbound.protection.outlook.com [52.101.52.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wmmstj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 18:56:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSksyqfE9ZSulLduq5p4+jcqRrNZhusibThGclwm1Tf6kTgv1OMoqr4GwAGFXQBgUTHz62hLx+SDCCrBt+xYuKDUvldZhsfYiHb2TUfBDlH6EbwiyqSBRWIePN7tsdpLUes5e7R908odbQvT05HLRHXZNjpwIdLLaVB7+6rladJgvWBqaZrNiO+YheVcyZ1M5kYN4bJ2BZlQ6CxbIgPD+FH6mEhvqOM5cpyzvQf5Hd3RLOL3wNzkpd7iLPxNo2vDWF6gWIyQPaPj3TWojdLKXiyEb9h983MiyK35ZqGSGozRWpm5asXqXxFRB6xFXvfYNz61/vU2j86rKNcKFASVZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TVmrfC2prSAkUdIiONZnN+fpnYtTz5eLEtHC8VlugU=;
 b=SCeQ/unD2rblnIJk8T1YJBQ8dscdFWQV7QfdAMI7LtxbSqHX4e59u1EuezHLX3O0nimvnRF3W10zPUYD/g3TYm/wvIsnj7FWtVSbxnqIFiRuo6blx+wcn359TgQIAGmo0/ejICRa2Me4xPw076dnG1F131z02yMQ+4xfXUD2gfRXMammQsG0GRej8THXQcD+21xRZPtjehloQZ1fMflSnowl7pdWWzgKsPPH8fcDr+A5AbQp6ZcAYTVy5GwkTR9a3hIJw7va6ztcrkxNnQ06o1zdBz2xp/cPHAgX7TFOXpml7FUzky816KqfbIgDTXEKe9w02MC7Q5sWpnb1U2D8PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TVmrfC2prSAkUdIiONZnN+fpnYtTz5eLEtHC8VlugU=;
 b=PH6NzxTHv76vxKcABLp0ubaG5ym0ogfyXQa3rg72bk+r2gZ670eSugK8Tlfxv/Mo1CCPg7ygGb304RZjuZHuZJlaCPVeuTxsZiZh7TQZ9GbnETaaT2rAv5jSLSo3iEVJDOKPpeDKYjk8gKagVsNHq8LkRe5vv3owmz6/A2JsIB8=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by CH2PR10MB4150.namprd10.prod.outlook.com (2603:10b6:610:ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 18:56:02 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 18:56:02 +0000
Message-ID: <e6330cef-07b9-4b4d-b943-7b391db7617a@oracle.com>
Date: Fri, 2 Jan 2026 12:55:58 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] mm: page_alloc: add __split_page()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org
Cc: jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Matthew Wilcox <willy@infradead.org>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <20251230072422.265265-3-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sid Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20251230072422.265265-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR17CA0005.namprd17.prod.outlook.com
 (2603:10b6:510:324::14) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|CH2PR10MB4150:EE_
X-MS-Office365-Filtering-Correlation-Id: cfdfc261-8261-4617-1a8d-08de4a309367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1N6cGlYYm5LU285YUxRNitKTUs1bys3SWxva3VQMmw5YldOc1k5MTV4S1Ba?=
 =?utf-8?B?V3hQUjcxWDd5eElLT28vcDl3TitEQy8rNWZhN2NxTUprUTlCQnFKTDRxM25J?=
 =?utf-8?B?NzJ5VmY5SHUxemhCU0Z6TG5Fd2l4YnZUOU1TWjd2Y3V5aHhDZ2xqMjhWdmRJ?=
 =?utf-8?B?YWtvb3pYOHFyVGdnb3NxdXIwc3VYeEZ0UWtMTHNnZzRCamRDWlNYdTE4eFVj?=
 =?utf-8?B?ZGpFRG1NYk13Z3ZTMngzNjIyR2tWM3g1S0pMM216VHRnWXhmMmRGNDVDQVNy?=
 =?utf-8?B?UUNmT013ZDhZaVo1dkwvQTV5aVNpQ1JiSllRZDBqL281RVk0alI5eDFicVZp?=
 =?utf-8?B?dHAxNVpCMkRQM09lS25JdVVWbWZmRjZ5KytIelB1R1pEMDd0K0VVRmEvTW1E?=
 =?utf-8?B?OFd3S3cwYnBINktTeUZQQkRuTERXcUZiRHN1aVFITXFDSzF1QnJibk5IYnY2?=
 =?utf-8?B?VThSWVNhaEYxQktnQmxaL1B2dGV5Yk45eEZpVzBKbEhxekhteWxWUWZ1MTJO?=
 =?utf-8?B?S2ZjOFFEdGpBbm5USTJtU0xrSlNQcmNFNnZiY2V1bXkwS3F0NTVaVUNWWGlJ?=
 =?utf-8?B?SWF3R2hROHhvSW9tWGswMTV5WGlua2hLbzE2UjVPbFhsU3pCZTVDS015dGsr?=
 =?utf-8?B?UzdxalJvalVuczNraHB6UDA3VlJaamtJT0o5U1FIWjhITXFjT01MUWlKK1g4?=
 =?utf-8?B?djFUUmpLNWdOK1E3K1hZZ2xlaytYZVhwUzhPSzM3MG5GNUJSZGE5K3RaaERt?=
 =?utf-8?B?UlZMbDN3K0FsaEV5VnRTVVpweTJBcStkSVpLY3dYWlBWbHRaODJNcllnY1gw?=
 =?utf-8?B?cVE1V3Q3NXpta0srZmpJZXlyZjFsaG5xTlU3WnlVU1BTa2tQQ0t5S0kzdWJE?=
 =?utf-8?B?NFQyZ3JocmhUSHZmbHArbTM0bGN2ZVFCMkltNXFyQ253SW5MTVFPKzM5UVc5?=
 =?utf-8?B?MHkzZUtkbFN2dk80VkF6NEF5THFISHp5MFdOcVFnK2dKeUQxZ0IwWGVWS01L?=
 =?utf-8?B?cGp1SHlxbk5qZEtFODB0eGpuWVd1QzFubi82bXdNQTBnOWI1RWpZWDJETkNw?=
 =?utf-8?B?aFhUME9zOWx2UjQvUDN0UDE4YmtRR3JJZjlDWVY0RHh2WEJqZjcwSklZeEc1?=
 =?utf-8?B?Q29JUjJ4aStRazhYWVhkM2wzU3hSUmx2MHVjY2xQVGlSd1piMG0xRVlUOGgy?=
 =?utf-8?B?RzRsZ3J4SVNCZUZjYm1CVXdZZUcrS1plNEtNRGRtT3FRZ2JiRTIyak1vYlpx?=
 =?utf-8?B?eFpUSy9yRVRCdVAzbGNiS29jYnNzSTlHT0NxRnMwVVFZT1RWWUxKNXZucWFT?=
 =?utf-8?B?ejk3OElPUFgrc3JETGNnUUVoQlgzd2VKNWZyMXFCY0dmWmhVQlRrOEJ6M3Bs?=
 =?utf-8?B?eDg4MjRSYWV0b09BNkFaMFgyS0wvOGQ4VGdCT0cydXFSNHNMcUJqR29UWU50?=
 =?utf-8?B?K3dNTUUxTWQ2Ykk3bmtIKytRclZEYStzTW9xOE96SWJJcGFOaEplU05vMGR4?=
 =?utf-8?B?QWMvbDJBcktMdkp3UDEzUVk5OFhMZFRyd0twU1VkR3QvcjJVd2hpY3B3RHVJ?=
 =?utf-8?B?WG5tTGJybFdhUHp5WlFWRkV1aStTTWlyOWx6WTNVT3BpZ1VqQ1BRc1g4ekhh?=
 =?utf-8?B?RXFrRU9SUjVvODN4dmpiTTVubm9LZnRnY1ZyRjFtSVFZS0dJamlZUVRPTkRn?=
 =?utf-8?B?SzhDWTJJRWFXeWZZaHhvYW9ZNk5aRkVDTEltcnphTHRJdHVScDl2UnB2YWdQ?=
 =?utf-8?B?aXR1M1JydGJWQnd0UnF2TkY3MnNLSnZMSytiam83cHZ4K093YTdpbEZWUTI2?=
 =?utf-8?B?cjlpVVJuMEk0ODhjOEt0Q0VScXVMVjlCWUhMa01meGdNcWZZM2ZEa0J1VDBV?=
 =?utf-8?B?cUw0Ly9aV1FJZmFDZm9HbjlsZmQvKy9xTVJjc0Q3N2VjaWptQlgwRk5aYnFo?=
 =?utf-8?Q?Wyp79Mym7kTvEi67jAmdDNBjBnQDjC0A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGZKYm1PYWEydjlXaUV1TWhUd0xEc1J1Z25FUC83L3JUOWNDVmNMa3JFYVdk?=
 =?utf-8?B?L0lIUUtDRVkzNGV5dXM2d1NSVHF3aFViaGswS011dFhDeHh3aTBFVTQ2MS9n?=
 =?utf-8?B?alpzbTYwTUZtZGpRUVVpNkkrNmpPeWtIVXFyaUYyRmJUR2JTZTd3MUFqRk40?=
 =?utf-8?B?SDFDTytGOVE5QzJmeE4rcHljOFd2d3Y4VzZ1bVFIVHR6Vm1XMWpGdzFWQ0Fn?=
 =?utf-8?B?WFNzd2Nia0ErS09qRmYrZnlXcFFqVGxWenpMVFRSRCtGODhjVGwxbkdWMUhW?=
 =?utf-8?B?OTZwWURBZlJRcUxYcnJzSFZHMThrOFNIYlJ5cHJQZGdtU2NJa25BMGVHZzZE?=
 =?utf-8?B?QkRULzRzSHd2cWZpck1vd1NvQzVXWkwrN3dMUktrVmZGS3BZVHZzejlnNEJR?=
 =?utf-8?B?dUhJb1pURllGWERFUG81VXlCNzQxWGJlZnhoai82SHBiTm84TGRicGNkNGZU?=
 =?utf-8?B?N1B4VWpvc2dwM1M1ak1VQWliTVpZaEppU0ZPTHhXT29pYTVYU0pYbm5Yd0xi?=
 =?utf-8?B?WGhPRjBJdnR2Tk43SkFvZWxNOHVwTmE4UmRvZWNvYU44czVFdVJGYWw0NUJy?=
 =?utf-8?B?K2cxMlpoR3JnakVONlpOZjZqOWdzY01oMFFUQlJuOGJoa3RuMmdiaFQ5Qk9N?=
 =?utf-8?B?OXV0NURsdkI0R1h6R1ErZUFpeW5ieS9JODZ0N1F6Vm9RMjF4UTlOSWpUWURv?=
 =?utf-8?B?dHYyTVdoVGpQSTFMYzJCMEhCNEpFOWhTQUU0dFVZZGJrZDA3UE9qTXcxVjhQ?=
 =?utf-8?B?VTNTNEZiTWY1TWQzSUVrWG5wbTZjVGJlcG80VWVxdjZYaE40b1JQLzdpTUhO?=
 =?utf-8?B?TEpzM1ovb3c4aTlhMFE1bFZwOHk3RzJzZDY0cFpObTJMRFdHTDlKZ0RWYkE1?=
 =?utf-8?B?Rjh2aTJxb05PTk0yZno1T0xUV29UVFlNOFM1ZHlvTEoxRFUySURNbmZxK2N6?=
 =?utf-8?B?U2FKWS9OQXdWSHU4bnJUSFJkMldCUEk5STM4OGYydVJlckpFem1TZU0rK1U3?=
 =?utf-8?B?MENwVVhEV2NPN0MremtXcEl0Wng3aHdLc3lGOC9FUzBNSms0ZDBVVUl1d2di?=
 =?utf-8?B?MDE5NTR1RTJzc2c1T2p2WFM5SE5wcGVIUHFRSUZkUy94RWl0TVBCSS9CSVRx?=
 =?utf-8?B?RmY4eTNxeDFGSW93MHFKWEY0NFo5dGlDOGZYQTBrbFB3NUpOajlVWGNtNXIv?=
 =?utf-8?B?L2dMQ1RXc3FVTzZINkd3S3FxdElJZHFTbzZ3WWV2eEtnd3VUV0svMGtQT0JP?=
 =?utf-8?B?MWYwYUdoS3RqcC9HV1JNb3BUSENpVnlnZi9pRWsyMmkxenFhMkttL3J6STF0?=
 =?utf-8?B?UEc4Vitqa0RCY2p1TjVWNTNEd3VaVzE2Z3REY09VcUlvN1dFdzBiazlSeVpk?=
 =?utf-8?B?MEtVNVdQUjBLQ255VWc0WUxGc3d3SGYrN2FPOWl6a0xBT2swQTUvaHA1V21T?=
 =?utf-8?B?cEk5ajNLS25mckM4aGZ3WnBKTWFUZWNpQ3N5K2t4UTZlQ1gzckI0SDJUSWJa?=
 =?utf-8?B?bGoyV1pucno5bkNoMURFMEZzeVNmN1N4S0l3Rks2WGg3ZzZoM0t5dmZOd2ZU?=
 =?utf-8?B?aG5qYVNrZitXY0dQT01rUGdQZ3c0QTBwNVB5S1p1OERubk83RUVLd3dBb21v?=
 =?utf-8?B?ZzQyOXdiNGlCTHBDM0lWUmpZNDhCbDlhQlk4STBzMjRwQXdXLzhwZFZWTHdq?=
 =?utf-8?B?WGlKYVcyems5K1MwbjdpVURDeldZTWxlWHRaRkJoeFFmaTZqaXRpdkxFNDVt?=
 =?utf-8?B?SThZazlGYlFDRmJhYTd2Q0NXa2EwczRHZjN3aUJFdVlpdnRvNjlKZ3E2MGk5?=
 =?utf-8?B?a3FYeFVjeHNteHlKVVJNRFV4eUdOT2FqdVlYclhTeG9aL3dBRDd4Y3F2WTcx?=
 =?utf-8?B?Y2VYYWZhZ1hINldaRkorOUZVUWtVNFJQd0dLQ0VBdDZScHdsaWR3T1JrRTJ6?=
 =?utf-8?B?YWR5SXkvekE3MTI1U0VGakhlQVFLc2xuS0FtMHlZck1NcnZrb2gyL0ZDMGo0?=
 =?utf-8?B?aHVuV2ZuUWJyNTVjMWNkWW1qMkZ4Q1pIWDFuU04yK3BWL0NEdjlQaXdxQnc3?=
 =?utf-8?B?K1NnWVkxc3pIQkNKakJxK3VWODJmVDdTQURaNEZ2OWtVZ25VM1pPMk9MM1lD?=
 =?utf-8?B?S0IrSUNQeGlzMURzL0M2OWZmUXo5MHNsZUdRTVRXWXdnRzYwVkRWTEw3L0Vi?=
 =?utf-8?B?dlZXRkEwVGl6WURkTDFtd2phTlYyNTFrMm1SakdtSEVQamlrSkZzVnNiSW1Z?=
 =?utf-8?B?U0NCc0NwUENIMVFNeUYxaUxaY2FaWEJtMDRjM0pLRGxLVEZHNS8vcFZSM3Bi?=
 =?utf-8?B?aGp3UG1aWFp6WVNXNjltanZ1RjY0WlRHV1g5YitLT3dYTUxXSGdrQXFpeDk5?=
 =?utf-8?Q?sRytvy8L5Hrhv86M=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eSwWZgWqG0xq/AiDCO4tJ+sPXSgt8UWUnkXNg/KBvZydjTEs9U3RCvTTK4SFJNgbW2ZRi9sxMDSGv62Jwq/wItmDtjURmnL/EaOQJAvsA2Z3Vh0Uz82Sy+Q/lWbnErHLYSCz0+WpmNOziYuO7NT5PV233pXdaBtH1iw7o5QWOPsdWOPBLS/yC0RcxbLGXF/c2qOzYyeNRcDNPTURmQIIIXq0IhBrwm9jG57M0LGLKQGaDqid8yESh7Ncc3+HduKgLLVvssN9LJMAdvwIpVPDfBSEBa+jvyDUOKpu3YoN8OO0OloYedSrVegFX2+v86Tyif0IPsrRWumSKPmqm31xUWSulpxgGgBTlx8xKUoDHHoIt87J2IP2CqK4VXk4+Ju1Ugy4KhrbiDu/x7Hw/qJhTftrL30qD01h5hfsGpI16kqxUVd+BDgSbs54UDNWZRhfJzw0O8a6D+XRV1TO5unxhrtndm3aP6aYnpcUuXEPe/XJVZ5QmcNdqifQ4YRkofGwIt7YOtmFCQm2kOIfkc85H9xtNCuhS/nzGmZU7Dd11EZJBMvxdamQh6pcnQuEALswyVE9AolRNdNnkM7tO1AiEcNSEqG9S2t++Qj/9ZwFOh8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdfc261-8261-4617-1a8d-08de4a309367
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 18:56:02.7021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPCzj7JG1HrX/QXx/XvuNGNW7Ab4F83RWRxkb0ayjgVTI3+LQfQIyTnZ0umb/D5NVMNTJHr7gB7VZXZBhc6VUtVtpohd7vYxGqYmclIcMQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601020169
X-Proofpoint-GUID: joG1bf83QyCwLucYQ6-NzjL7TVVqqqe1
X-Authority-Analysis: v=2.4 cv=MqBfKmae c=1 sm=1 tr=0 ts=695814c5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=2GcPbhs0ry_LVNsDGJgA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: joG1bf83QyCwLucYQ6-NzjL7TVVqqqe1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE3MCBTYWx0ZWRfX5FpbmfLs7fc4
 jywgGZYwfpJzqDUfQjeb5LZhUnJIj4GlsTcL7SZ0gs62SijbbEH23ggI5uFRk8Y+jg/eYp08Da2
 0twXpQFD9zeatYDnaD2aAzbrupxopj/bbS9wJO1PnvGPn/cQtg38wQsiWaK6KdbMTvfrrOmvRIy
 Wrj/49K2oHUGuH/MenBqwXvIA/Z8CWmQJaaPQbUuPGv8KdLkwVYmGSyEOBmhnV9kLz1c+yMR1ii
 ekkG/I1yU54DX5meQU45aGJs/xVNb1SOkf3cZYs4bXNZeuvWMhMHkmIOLJLYgy/M72ysguLJZkh
 96PTpxzanHOc3Mp9GK151XJYCCPHNU+R3Ei9TNZMh6I2iLbpct3fpCOJmxTF1e86hqPycfrXCo0
 OaXd6fBbaotdVGVp+sW6Yeh2ko3VIVOBQb3hmz8yS6skqxLas2PFkLDyWKi3sycgm+fmGmS80mp
 byww0s4IAMhThq43us0U2S57F5fJwUvT9FFtGjbM=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF0F5C0004
X-Stat-Signature: zea7pdjebrcc55ni4atm9drgxc5komy7
X-Rspam-User: 
X-HE-Tag: 1767380180-660820
X-HE-Meta: U2FsdGVkX19hB3IR1ycsqONWcAhsHtAWuDlqFFSZ9mlgHjIIhPoOE0B9WfXhNxbhPIctm23BUJaHfUQOi/x2shgCcOCToDiTnPlwPQU5K4TSCMhdZGo8tsPHUJrWitKxnH8QpiAOl+Lr1HIFF/qAj4ycsB3WL6H47FdudTGswuVq/6XT4EJ3b0wPb3RoMSfqFG1Mwh1s8orw/ESD5P78wtAl0AD35iC/tJfFOUJZY8iLd/dxaYDKpvBroGqqVV5vywnzrfgjIpDYoMrlb163l8vVfv1m0OdFwIsbziKo0puZxs+VHw4gP8mAvI8W9lx/DwIUg693qVFmVyyXIqIpTMmMtAvzqxCPwGzQuVVLrfEZ9wn0Qey9BVy2LOnZ4hd+xshYMo6sLBVRQoQUknOU2ZJ6QQ2f5ApFAxw3W0HJkDiGz8Pvk+j1hRzaeI4Vt6lE/ibjmhKoOU32ZLCA/IJtDfVWR3ka50WVuk6Fb+OZ9I0M7dhqnOIJdUy7DVxMkM9GjMO8oAGh09URKAPfw2DIn91Hx1xX6FjnlMpk7SeVFZe1jmsqIFjKduvbC1Lldm3B9tgrP+iKc19Q8fNw1KNYYgcraI70+1T2OvmjPuRgTvVJWElomCWQ1M9eqS2aIcfoalnNVb73fI785RdRDQIPqcd0/q0t1+Gs7VRwCSdZJudrgRbuoRVt5TlMRxqQUlrdh6q7cX79yoNO3x2O714DpB612ONpREi39X2Al96IchAdVJMgBtd0VBbUYyiHRNd+E6w2zvxyKY9eR/r+nWBSukDrth31mVhli9iF4+j9coKqLt60CZC9TpL5zmhNun0x7f8NuDPnRZUccxFDzK9OTEFUKW1Kopxz9LEmgt2Xjac/TH6JFnMf0eGItRvOnxVGGaylXQyRkwB0Z4JHnOeNXKCLvh+NwoIbMJEcaHYOnlaqu9C3k9yKgh2Zg2Oqxnx9DzNTzLrC7eRnAdP6R1i
 1yUY6DSb
 tvqy+wnMN2Ub+x3P8fojrHa4kyUBF2I5tUVpe9xyiNOVYoiuKrc4yhQy3hBflutElOxuEXUFqpTA25PVLFHo1fUoNBedv2Til22+y10+/u9sCw/HgGTK+WOneOSBrD8o41hIEVT0doMxgDWrf+l/Zh92i40MGBU9LKO90VEj0witcJYeBYZbAvKLqMi1e2r3uBJ3djspPxKybFfAZ1mRTkbFaI4SuTSoUu4UYOkhbVY59w21WLy7MhDYWjTLmN7FNHsfDFxs1fIqkpIwnJyORTESs3UY+gNckoXBtM09UubaJPpgGj9dRiY6tEsmgshewGMZuHLvqxBcAStv6pn2i6y1bfM7Rc2gi9bsPXkYKNeosiaL3sAnysNQliKitx/0utLOZN3uMHi9IoupKp5yXM4XERvwSiEM6jgaMciqJmXfUvuReuTFDYD/K/jmjUSg+fBKFRdgMHhjovtJyFQWyM1BfmSB4h2VB48UOB5vLilqT5L8Jf29+neExzr/xjVGKGPgZcGp0bZoLnKbPA26i+gfbQmlSNfrrVIVXzi8PPgxZo81hYkeNozehEBdi22/BMsOqvDBZLuTEUKGC5Svee8nMxxMUNbHLS3K6zUilHdaHkAiLHtrftlsXcmoZ2HD1KrK8mXom5Ny4gyjbec0x5S8sq98sxv9GWJHVaVA6qrWHqeeBDL9s6Ecby8r2KXfLn19tBZTddvqs1LWHFMPDu99xHbrjHbObW46YqtmhVrFnVfafHwOVcTCuifos6cyDnivkoUtJkUZNxOU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/30/25 1:24 AM, Kefeng Wang wrote:
> Factor out the splitting of non-compound page from make_alloc_exact()
> and split_page() into a new helper function __split_page().
>
> While at it, convert the VM_BUG_ON_PAGE() into a VM_WARN_ON_PAGE().
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   include/linux/mmdebug.h | 10 ++++++++++
>   mm/page_alloc.c         | 21 +++++++++++++--------
>   2 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index 14a45979cccc..ab60ffba08f5 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -47,6 +47,15 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>   			BUG();						\
>   		}							\
>   	} while (0)
> +#define VM_WARN_ON_PAGE(cond, page)		({			\
> +	int __ret_warn = !!(cond);					\
> +									\
> +	if (unlikely(__ret_warn)) {					\
> +		dump_page(page, "VM_WARN_ON_PAGE(" __stringify(cond)")");\
> +		WARN_ON(1);						\
> +	}								\
> +	unlikely(__ret_warn);						\
> +})
>   #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
>   	static bool __section(".data..once") __warned;			\
>   	int __ret_warn_once = !!(cond);					\
> @@ -122,6 +131,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>   #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
>   #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
>   #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
> +#define VM_WARN_ON_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
>   #define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
>   #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
>   #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 206397ed33a7..b9bfbb69537e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3080,6 +3080,15 @@ void free_unref_folios(struct folio_batch *folios)
>   	folio_batch_reinit(folios);
>   }
>   
> +static void __split_page(struct page *page, unsigned int order)
> +{
> +	VM_WARN_ON_PAGE(PageCompound(page), page);
> +
> +	split_page_owner(page, order, 0);
> +	pgalloc_tag_split(page_folio(page), order, 0);
> +	split_page_memcg(page, order);
> +}
> +
>   /*
>    * split_page takes a non-compound higher-order page, and splits it into
>    * n (1<<order) sub-pages: page[0..n]
> @@ -3092,14 +3101,12 @@ void split_page(struct page *page, unsigned int order)
>   {
>   	int i;
>   
> -	VM_BUG_ON_PAGE(PageCompound(page), page);
> -	VM_BUG_ON_PAGE(!page_count(page), page);
> +	VM_WARN_ON_PAGE(!page_count(page), page);
>   
>   	for (i = 1; i < (1 << order); i++)
>   		set_page_refcounted(page + i);
> -	split_page_owner(page, order, 0);
> -	pgalloc_tag_split(page_folio(page), order, 0);
> -	split_page_memcg(page, order);
> +
> +	__split_page(page, order);
>   }
>   EXPORT_SYMBOL_GPL(split_page);
>   
> @@ -5383,9 +5390,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
>   		struct page *page = virt_to_page((void *)addr);
>   		struct page *last = page + nr;
>   
> -		split_page_owner(page, order, 0);
> -		pgalloc_tag_split(page_folio(page), order, 0);
> -		split_page_memcg(page, order);
> +		__split_page(page, order);
>   		while (page < --last)
>   			set_page_refcounted(last);
>   

