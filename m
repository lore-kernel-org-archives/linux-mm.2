Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB077F459FC
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 17:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC366B0088; Fri, 10 Apr 2026 13:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C2A6B0089; Fri, 10 Apr 2026 13:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D266B008A; Fri, 10 Apr 2026 13:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E05126B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:51:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6643AE33AC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:51:40 +0000 (UTC)
X-FDA: 84643388760.12.CA099BF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8A95C000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:51:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IGWvxYZs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xj0J6can;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775843496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXZGma060EGhiyfnf+H8YgVPRdZWhqNOTRM3j9VeeYE=;
	b=RxO3Y10A6CcMj1QVxALo6QyNi522SnlxMur/VOrMAnTwcEACb8Fy7OlYaIxmEiojUlw70d
	WblOlYu6guUts7gSLJ1DHQ4gwFhlZgAn36RbOg9z9WhcDmuYDUN8sBB3/fEWEqiLdnYzMa
	IoEuDkC3W00ucxW9dp+8sJz5H3fEJmE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775843496; a=rsa-sha256;
	cv=pass;
	b=h6TeEI+1kRhsQ1ggh2O1mbYLNLYTlDfVne8t5bKeExNpctIZfhLk+ZWCFy5DbUClUbWRpO
	UGXPGxCltNRllFFKHyX/wSLbtOh/4zBa4DQBHmvGzuMEPgjF3mUHU1Ek91GcYj/7yhcWZ0
	pXcZg9I2nCxRagUNwOhVMkOOscQALu8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IGWvxYZs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xj0J6can;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A9137C3133335;
	Fri, 10 Apr 2026 17:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lXZGma060EGhiyfnf+H8YgVPRdZWhqNOTRM3j9VeeYE=; b=
	IGWvxYZstGjGKh9TDKdNHgBTLwEu+46n3qHo6RPbqqmSlZt0igW8FEEP/MsHipzD
	sr7WChLApdUneA20IL0k/whD+HgtdjXGDGKmpUYPtAmz96BbESgiktNIjLy0NRDl
	CqrTJPu3xpjRsknGk7HbkL8d1t9Hkz6Buk5YFWdGxtFDV3vjODIjl2QyfScHlsHe
	MkisxtFLUf17RKJuadtO6TKP9Y+habKlfliB0IAIW9H4Qf/MOfjdPXimL06Ug8Cr
	3pVL2PYKJjQ1H10T/BBQROT0/KhmFf9Z1XLrmMBZDCy5rjcyxU8cnBRJ2UcraTAE
	ubATNl+Tgjwspkt5GZgN3A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqbt29s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 17:51:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63AGgVa2026147;
	Fri, 10 Apr 2026 17:51:31 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010059.outbound.protection.outlook.com [52.101.201.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmeea3y8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 17:51:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IdoLk5TiRx2eLTHSklqrlsbfoW5mnv3ZcPoNhF5q1+SiSnPq0sCXxPQiuN2CplknJlXpIc/RIJN1Dmqo/kmY5KNsF7Gn5oKUUFsPcvdnhDUxI5I/2xJ9BzVyk584kA1ne6p2TDG8qYJUERR6FKIweK+VsD36ycQnPxesPEFfMFCbZgxMInh7AC5p+BL3MJnoinhiK+cGNrog+wZRepnXH4OZ/P5HyYq/HKePCPGhS1KLaNsNRltLNSsukEcw4ldP3BQT9Kd145wLA6o0+j9qXjE7BffHbjvLE5I887lf4024xvoIDPPl4NZQj2pXtNMTEA2ghou750RhxHybktcwZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXZGma060EGhiyfnf+H8YgVPRdZWhqNOTRM3j9VeeYE=;
 b=lJoq11XeyLA12tKEyp7/kZ6TwvoF2Z1XcTLw/IPy608I3tMaUvJKAg6GbqvbpVghAVHGJjrShLKghO0r4D5mwYzr9BCz7X529WRR16aAzfgI+o2u0anjeH4Z1XK4dPgSDD+CHv3r7zXQL4u25SnGWUj3KgqAqNSKSa9gBmLJRltIIldeeOUCEL8ia6Ebp5mD2GmEQKNjALb34B/4gH0bhkerF9HqzRAz9kjjLAL0J8Q/2Y2rH7oPex8HkFl/ptVTe/z1g/zJtwUk7CMWBFxMuEbRFkv1qdJZAPxuT9GSACRJ3aF4y73Eh71Av5chtJBo1iXwlXNnf5eynL5OgCYYGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXZGma060EGhiyfnf+H8YgVPRdZWhqNOTRM3j9VeeYE=;
 b=Xj0J6canR1Rv33fJ53ISq1ZiRwiE5c4EAZ/54FQvnv8ntiDXFHk8bz/Bh7b51oVRAMNKZSDGp5PY4scXoyXLZXp3AEo1DJW8VSnEtHQZvX3rkpE8iQn45eteVNVwcqcXqaAOhHug7ZoO+fsf6Z3oFZwwq/j85AzpVJO+/KzgrmY=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA0PR10MB7621.namprd10.prod.outlook.com (2603:10b6:208:484::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Fri, 10 Apr
 2026 17:51:26 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9769.041; Fri, 10 Apr 2026
 17:51:26 +0000
Message-ID: <d8dde603-f75e-4e2e-b16d-23477e802dd9@oracle.com>
Date: Fri, 10 Apr 2026 10:51:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take
 PAGE_SIZE index
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        corbet@lwn.net, skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260410112433.3248586-1-usama.arif@linux.dev>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260410112433.3248586-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::22) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA0PR10MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: cb60f50d-b334-4a0e-32e9-08de9729c91a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZQugijnLAEJgcvfliKZZPZCflSpqQD7+z/afdHWnYYJoHzFhiv/0RMHRu4XtjceGrAxD11XF0OToR47Ntgmqt7sE/oShV9C41fse3XADqNJTx4MTtr9DxG3isRQm9RSLPc1liyWZl7ErOSSglDMkOO6Yg171iu6xWg4sFISj/RMYVMA7vUVZLCVojRLbDPLaxjveF3j+ovBRIqDtAsdJZlmek2A9Xg7at1i59jbL+LE5F+lpN0kiF6a43hyWr8zsG6VxS8G9WkL+Xq67svNkkv/8/hkEBDsHOfHFgDSfFuoSd/dPj1+8MXCRx2965TKR9b54rOI6CrW7v0BPKXym2egXdkTEvLZZ8VLCBkbMuXKkLC1lghyqq/O1Q0b6ZSioPplJ9ypvsjuEuwh0mOgLA07tUvD1N9yDnoAGEF03LyCYTtdQygZU3HSvtXguQ6yShHwEpAeJqT4OYg/3wS188GlCd/jp/NMsWSQxOFgfLHbr6jr42aELI+PEBqutLfrD38fNG0rgzPPGTrbesFhsYvPVH1y5OfB/rIXu/Zc4V43Sq/ziG/miJlHyzBd/3qNJkBb0kxyEkesE2iFVlqb7PPI28mFjveTeMdREMA14thxim92iP3JOBfQaIT0wPV092mIgK3e6d/2AcURntVcRd5h5+m3KuK5Co6qssVcj7iheX+PEc4vjPV+Rp0S2ly2QCqUxQGogzyOZ6G5KG/dx2A65mkX4q3lnwRX4hyTmprs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEpjSzVjY3UrS1Jwd0hHTldQZWlpRXJIMFJIamNmdER0OW5FaHA3MlZFVTN6?=
 =?utf-8?B?Vi9RTlIrVXVwWWsvOVNLRzlISGJISEthbkdlMFBiSkEzOExvMEtZU2pERGdi?=
 =?utf-8?B?YldzZ3k2bElab3BPWEthd2lHazl2Syt5SFRtYWJlME5rODJ1L05LMldQanZF?=
 =?utf-8?B?WUY4T3FIL0c5VnRPN050STdSTmNCSFVuOWo0aklZT3dOdjBaSE4yNEdHZ1VD?=
 =?utf-8?B?NkRoMzlMbTdFNzUxdE13L0RLaExvUkNSTXhUcVZpMkplQ1NzZU5DdGoyUldB?=
 =?utf-8?B?WW9tK2tlL0RoVWIyMGJnKy8yQytxNTNoWW5Xa1NFZmtaQXR0dHovM0czNTJw?=
 =?utf-8?B?YnkvUm9XVDlXTk1GSVM2K0dMRHpyVUFPcGdLYzdKTi9ObzNNRVhZQ2x3SHlD?=
 =?utf-8?B?SnNuUXMwemFXblhPM29neE9xbWJQbTRMRkV0MmxLZWVaOVIySHVGczl0MFFh?=
 =?utf-8?B?Qm12R3VwSnd6OXlReitrMWcxeElnTlc3VnRLQVpWVStnbUhHK3l3V21KV1gv?=
 =?utf-8?B?Y21RcDhlb28zdGJUT2hJblFhZjFOdGR0dis1NUF1TWdIYW8zczA0bnZRVWUr?=
 =?utf-8?B?T01qT1RneklNZGJ2NDd6Z3FtQ05sNksrTmFDUGw4cWc0SURNNkJLKzRNeS9F?=
 =?utf-8?B?MkovR2Q4NU82KzlWWjRyM0Y1UEJEWEg0bmQ4ZFZDb0RseHBRS3FJWUZCOWZm?=
 =?utf-8?B?R29xRWNQTFJoMS9HNUp0ZjVSQ0tNdnRpNWd0R00wZXozb1FSN1ArS292Nkd0?=
 =?utf-8?B?Y3o3amg2QVdRREFFRWUvQVBUcmRlTVpkU3dSMEZQZW43UUhuQUdJNDZxVC9v?=
 =?utf-8?B?WTE5VEl3TVlEcVRYM1N1Tk9iS0ZpRUtOd3FKUU0yYWtTNjRjNjlpT2k4c1ow?=
 =?utf-8?B?U3ZpTnRWSXloV1NXWk80K2oyWHVSRS84TXJLeGgrSWVYYlZ1WjBjRU02MnFa?=
 =?utf-8?B?ZmFmczB6SmJLOTRvNnlmaTA0aUNqVjh5VEtqUkFNOFJ1dnpMUGdSeVFKcTRV?=
 =?utf-8?B?Uk5GS21XRnlGZWxyQmxCWVJGaGtFUE1VWFFJdjA2R0hVT3FzaHQyTTZFb1Jv?=
 =?utf-8?B?ajZuNSsxMUR0RCtyVkFPODN0dzZEY1FWaUVVU1NNVEJUeWtUaWRBQ1FUVnVC?=
 =?utf-8?B?ckFkNVRHN29iVWkvb3hhWTNIUVVmUzJTWTAvcEladno5SVc1T1diZzN1cVIz?=
 =?utf-8?B?K1l6MUhEQ3BMWlppeHFQQy8vLzFjc2xaMk4vVVRZblNWK3BzTHpWa1J3SmIw?=
 =?utf-8?B?cyswa2lpYkthSTZuLy9BVHdoSzIrVDMxeVNEZTBqbmVuMnNoM3J0QUY3VlVs?=
 =?utf-8?B?VzFVSDFTSlJMYXRpYlhKVk1Cd29tcHZ5MFhnNExRMUliYXBaYWp2YTgwcXBa?=
 =?utf-8?B?aHVkdCtWd1FaYzBFN3dNWStydk54aDE2dTJ2KzhPZ05CSUtUSDV2Y3Nqa1RH?=
 =?utf-8?B?VGNRdE5qNjRxVGxoZEMyRDBpMEt2VDB2OXJwalhpc0FyZEFOdkZ5aGFkZTN3?=
 =?utf-8?B?dUVYcDZHOFR4SFg4cnBEL2RHaFFMamhiUk5MZW8vVnpJNWhzZWVVbThHWHdx?=
 =?utf-8?B?MkFpV0NkSWxmclcrTmFTY3Bsb29YRnNYOGNYZnhLdVY2aUZBV2NXUDNxV1ZO?=
 =?utf-8?B?SXVOMjJ3YURWcFA1ZXFMbUxCMWs1aXlhUU5iZDgxY2ovcVFIRnNCcTY3L0hH?=
 =?utf-8?B?aE4rL2hQWVYvMUFCVHBmMStLNDdMK1hRdVZmcllEaU1CaFNNQjdLSGVqRFp3?=
 =?utf-8?B?ZEhiYlBDVStBM2ZLVTVaNElYVjdKRWpSSkxjQzlwT3VoYjVFR3ZDMnlCMTRp?=
 =?utf-8?B?a2tQQXdMaS9QVVp4SVZPWEN1cGlmakhhaWpKV3c5Z25US2F2QlhFdm1TdXlR?=
 =?utf-8?B?ZXpIZHBNOXRTMUR5cmJYZGxzc05kbmQ2QWtoVFpaL1U3YjRyYlBGU3hSejlq?=
 =?utf-8?B?a1p2MzdKNHZLamtEUXBzL0ZNak0zM1ZDODNWNTBncnRFdCtvcmhsUThvWnU1?=
 =?utf-8?B?SHFPT3VHT0M1bE5VWm1yd1RhNmJkdE81UnNiczRzUmtXMkMwSlFrVzNFcVVl?=
 =?utf-8?B?cDdmTG0vaWtJcGlBdlhLV3czNkRkbVhhOE0xaUhaZlJQcEJQMWxsejlxTWVC?=
 =?utf-8?B?RHM0MFZSOUZON2ppNmdCcko0Zzh1SzMvVE9YRHNYRkdvdnkzcmxUbnhkMWNZ?=
 =?utf-8?B?dTZ0YU1SWmhKQWRrN1ZQaisvUC83NGFrSGV6MEMvR2JBdTltUWtvWWJtVTEv?=
 =?utf-8?B?aENGci96V1FQWld5QU9xTXRab2g5UnE5TGNFYk1xUmxFUVowemtNL2VWSm9D?=
 =?utf-8?B?bG94UDN2S0FXOFd5d0MwUlpkK3c0dUdONTF3UEd2ZGx0d1NGUGl2QT09?=
X-Exchange-RoutingPolicyChecked:
	HCEBaiXJwwrrNUJPo4GTTjzEY6d5qnhZ+EJSQx+TXTQXrsNyhgrAEFS46u04ahh4s9dSCmcMdtNkoc0bzFeAmq0q5uvX3HnjGur4B+pYAzXi6AB1FJTbLiL8YXuSx6BcTowaUnN6sa669OViNBste0cLkk78rj2LQYaL6LNPb3HKj/0sf7TQND91WxExKtP+vUbxVwsUqfpTJQrmZS2qUeRV/TNYujJ0kGqzNOEbP2q0jOugvlhpuFf4YXXVb9v/fN5Ql/u788NxkfYC5ddllu+Osp1W2PPdm5IxCGipgPNT5m0gssBm+niYnK1+OPB5r7J6+TDDE2lPFJBdhiIV+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yC3flM+rg8y7RVfFpqtXgI7itWBzFw9TFCRM0kVqc9yN+ieSNH/pyjujXMrCCE0tbshM+I+MvAclxjUx1DcP34b3oXO2sqH5LKocpLtLLl60EBQY1+OqeV/HodeJifJMyWuCHLk1pwXpUvaj91Jgwn65fZq33DfNf9Y6RXrA0EHEq+2/1rQm8Y6dHrjbEmutk2K7geSr1YXRrQFYVWtMGv7pxyfuWi9ImS8gzgaFKwtZLFZKKZnnMFh+/RgLLLvxJTfJIYbwMriwZ9fRDKASA3Q6ybRczd75nq8jYwueNeNeaZ2lGeNx15lXM5iMTNM2hbAZxAN6hX1GZ7To1Y6DwI/DRgbfDy4iLUitjr1FMHQHRs13Q3X+VOsNYPw946vSgUPcTepX/7uBhg24pk4MMA1whvBaF4ntDchecM9u482ape5kvWWBujaTcHo7S/iJ5j0cSRKdOyh3FtV83gy9/3HaHcN1FjwajbjyiN7EXn8OftVa7njEiIyeaqInt6TTOquRP/04d923drxOsE2RD6NWLz6Q6a2JnXsx+ppJn/P7fir5FvDxOmN8xGDS807KevLhUMFb0sB+d7Y8ZLl5SukYU3wsagRj/46yTP5o+l4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb60f50d-b334-4a0e-32e9-08de9729c91a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 17:51:25.9118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ss/wUaF8ymdUMDeybxRV6wZ/YrN2yYdDyoohjLeRywnm6NdWhZIlX7JDUGKcasnzgCU/vhijGI7mZlr5UYJ1eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_05,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604100167
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDE2NyBTYWx0ZWRfX4KkyRBKxNp/v
 nl4mRqpg1Lo5LmSu1dgEltG5YZ6vkQ83XpPwExzMYX23TzF8QSh09fXzfMQPKWL82pRbwXXJnWH
 XS1vHZMAoNaTR8E+0DbKaiiFU6ln3deX27nOppmae0V49gRL/ohXK1AJL5rRgwGBhtb67t5HDAt
 TIisDMwaCQP7vmAKHobCIpy2nSuMU926UbKzncaiICuJ+nN0zv8vt2PzUc1LbUlPn9ERdIlEfuR
 Qjp0UsGTvS8DBGlHqisbJ3qTax/CELGVfDjUoErwEIEHoK7ugYlTvYhYSl0A4w8UnzCvLWHNY40
 ED7nZWvXhGdcLSP+SybKA1K32fmxYtVsFVktSfXUtPjvqUPPMHh/aLzhfk7RfbQeZjVGSfz6WYv
 dBSEgABeCe57pG+nEeVRXLrpdzCv0oZKwyv36k5uYDlziuZ4ml7tE/Pm8odzJ8C7c5O+ORbI2TH
 KWv/0CgYlaFrYECFvVf69dSUuyDGLToF0Z0RA6P0=
X-Proofpoint-ORIG-GUID: 35gmcV88EVNN7CrYdU0g3K72PgPnqHRR
X-Proofpoint-GUID: 35gmcV88EVNN7CrYdU0g3K72PgPnqHRR
X-Authority-Analysis: v=2.4 cv=KO1qylFo c=1 sm=1 tr=0 ts=69d938a4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8
 a=CR5ZJFBvRrtXDVaeMZAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12292
X-Rspamd-Queue-Id: B8A95C000E
X-Stat-Signature: gm3ga6r88y5t15rqyfmi3spmmkzhp5p3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775843496-836816
X-HE-Meta: U2FsdGVkX1/RLFwuhF1FTxq8gxgFVPjYWYbpZJNU4PzVu7vCo1Xem14l04kKkvcDE2ql4bsZXAqp0HqReN31ioBre0fdcf28HvufvfwgGWOLN+YmhqJXEe4Hre5GmqjjrQC7ZO88Td3oq0BCtcWns5zl1xdo1UiQiDLUImRpKHArByChSU7YY3ciudgqA8JhjgC6Gk0cgTPWxieqpvJoQXvso04bTRZAFVbHb0gn+AuPMD2ktFJ0fZe49DnOVgltV8eMxl8MF/SMUfcPNM6AsDsjhmu1H8ZweFK8EYWZCA1wkkXKaCUn+7OGvYADTMyzsrTjHJK+zH0n5EhFFnStcuHXRkaXWX7nb8R2hlJFBYii19hoYeLrqN7yYiZVz4e1lyv4mBGgzgnIwAPCIw8aHBhav7Eq7nN9F2BA5qHSr1S6BdGXb8zYzedmpB53Y7MiXK/XtYHOfaK/YDFukgV2NuVjj7U2dvQQ0y9GH8Tl2wRfOumPvvxY+98rodax7Kh7whBOebSVk9Q3d67oQ3Z1Db5Wwls+CwyMcT5T/SK5SGrDEHOBS46vSjDhNULc3L1tv8YMjD4JvIoaXmmolktujSmPStpxnmo1FyjnnoRu0Gh2X4rBBP7n4ZdET0V1K3SI9E2xPr4AvDDVLTR2MMYCA69vvoXkgHYBdTYctl/hEBQB6RycF6JsnV1hnyQThcACGAvX6ko4dHJNPz2Qa3EKrQ18iciOvOA9k8h532gKH7FYWK3MoLTyiumjqydG+dgLK8GA+xyuQeXOFOu6iHRgho1yfpZx7qnyFZW9nH+axgl7Nig/0GwsvGy4WH2B7U1LNIIhdXr97wG2cKRD6gPUU++BLkXIHnSb/54qlAbAuMnZbJJS8Fz4XR7J2lYZflgAYDMr53qsFKIf+8v/QoSQWE/P0i+bedgAPZ53juIQx/n4jPWceQa6oXppzBiX2chPPaXa9hHK/RVo3zMneYr
 DcUtX8rU
 KqlAFPtleHViS6P6Qpq+RMkdRJJVAo5AnXRM4dz1XIBJY8sMhhaZJQGLahtFcQGvYdFuwhpraexcAxAuy4ytmnhXniXkJfchtIXNRmJittfhad2pXAyw5COzk+VrbE2Taz/u2WXwZW4VjkEoh6oJuvDuVrv233Al53SJ3BuufhaS3UUFUkL3J9uBgeJoCu30ZrtylLJypT/QiUZ6hYvq/8i/h49uiexU+WhgP1DxMMxDDb8e7W4o3pM8xskVxgC5GuaMRRRhFdiMVwMKgjQH0Oq8vabZKMV6+k7jLMtFVw4giEF+vrxQlB6bSZOCoYDqLI8gZ8DED9YdTUJyBVcoG2iZW9SFPq2vvRLrQsPpWYlm87PZgIDxKW6YWRnq9/+avFNt+QLN2AMuEgjEcrR0iZvu3EF2hJPdVsVxwFoJebutpXzgxmZkwSAaueOn0c3FUuG/1RKnC+QZQeFsX27nA/d7nzJnzfHAxzko3WfVP2xoGMbhVkHlPponho1XqMeczANjhkXBre5LKxVr4Fq3ENDGYL/21c8AU38J7Uf+MRMjZHpqppL5BXp30ohyXXpRVbjeJHYNwngiUPilKtdvMD3JCNs9cwbtgrfPHfjvCiJmlF/XX4cb4OljbneoJF+CqxW+zYYOomFxGH6lPJ0y/LI9mXNp5rodp1ChK4pLrYuizleiVzWJB0F7D5f3tnaFNQRBrMPugozx4y3PTfQ/D+uyh5fdxq67pnpT5ThDpWm+pjcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/10/2026 4:24 AM, Usama Arif wrote:
> On Thu,  9 Apr 2026 17:41:54 -0600 Jane Chu <jane.chu@oracle.com> wrote:
> 
[..]

>> @@ -5664,6 +5665,10 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
>>   						  unsigned long reason)
>>   {
>>   	u32 hash;
>> +	pgoff_t index;
>> +
>> +	index = linear_page_index((const struct vm_area_struct *)vmf, vmf->address);
> 
> This is supposed to be linear_page_index(vmf->vma, vmf->address), right?
>   
> 

Indeed, sysbot also complained.
Will fix soon.

Thanks a lot!
-jane

