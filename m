Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C46F55104
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 21:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B459A6B0088; Sat,  7 Mar 2026 16:24:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF37D6B0089; Sat,  7 Mar 2026 16:24:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980766B008A; Sat,  7 Mar 2026 16:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 816706B0088
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:24:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 176D41B7D93
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 21:24:03 +0000 (UTC)
X-FDA: 84520544766.16.8DF86A0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D02340007
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 21:23:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NP8YiDE+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="mtAez6K/";
	spf=pass (imf01.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772918639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNwgIH9Hs5L3ZKglu4kUuCMCz0rD3MbYG9nHolTAc8M=;
	b=xQYAJjpnTq8llCMbysrqq3oVrGWXMLqknfdSLu0m8xJa/y8sL3t6h5XK/PJNDO55bhvY9c
	SkOYBLyYt1L7kt1q9P+cc5b0aCZP+3xHQMy8rz4ditWYGwHgbepCcb0bGZIjxJNg9ugwqd
	cJ9lwGaawdV5WKt4ZI8exyk4TfhR2qc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NP8YiDE+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="mtAez6K/";
	spf=pass (imf01.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772918639; a=rsa-sha256;
	cv=pass;
	b=WPzLC9MHaAd+ZR38ZYhHxYQ3bC35cy+cVQw55bf0I1AkF6PjIELGJvFZEWI/M9Rsy5LMEP
	wW+sB/F7RtT7pF4LxfgdG43AaSXvWWuD+bHUqUz8vHH4nXM44GR5KanfscJwioQ97Jd86S
	a6PNoVjvxWBi1mwsHnbUoO7+F35njdA=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627LF2Pf2183723;
	Sat, 7 Mar 2026 21:23:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iNwgIH9Hs5L3ZKglu4kUuCMCz0rD3MbYG9nHolTAc8M=; b=
	NP8YiDE+inCqXD6NbV6Ca/H60o7Abh4J2Y8AM7Un3jS/akyFIdq1pN8XH9j06600
	nNp2g9NoQyeJXO0uliimVqYkuE+sG+eKojjflJLEh5So+PTvMRHu7Nb4kskUpkz4
	RYBC6Wr4CQFmrKTwwQRIB5wwcUA50B2cUoBoTsYgarnnBQtaa8L6woDhO5I2yufO
	ZHZr/+Ex6rnHdAgAN6xEhse0WTsirgkpV8DeWLLu1A0vvJ6tq8jp6xyK+Mo0Nz2P
	h4hgcq9qn84Fuk118Wxy7N/lylfYS0SGMmcDTMWZiI1h2D75Rp4KCkKV4bGkKMCS
	UytXBHefoRDOHbosn8XH/g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cru5580jm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 21:23:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627H6gvh022748;
	Sat, 7 Mar 2026 21:23:54 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf7armp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 21:23:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EfG/jOTFg7XjQ0GkNLFD9UDErC0fFBDht0z0nB63V/4dl/mbMLbld6EKU3JmD9XKJmLf2HRGDEE3/PbP8m77flthZ4Lq6B876/VJVhT1pYJExsY4N9iBkvvNMEl2CpR/Vyvi9tZIk0WseqOyNxRJC6C3n2Bc+BbIHryOWAa87qVDu3gZPr0eSBsZVLbAtmzk7GidJc/5Yd+2Rd/SaN48hdoRn6spkTdCDyMUCJSs5FD0ErlywVSKz7B+cuS3GrMrB1qGjPWFxxrNFB7+OzRn+4iQhyUlRjs5IA+dfVrjDuuIzmI3NOpHuJCqiqAU2kTEmwUUA6dChnRbvXfKMpEhfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNwgIH9Hs5L3ZKglu4kUuCMCz0rD3MbYG9nHolTAc8M=;
 b=C2dmk16U2b2VjgMHcFtgABtCTEcliOBUqsXNuA/wJTjwaQYhd38XKbxQzUP2M6XZ7+D88XFOUZTvAhc3PQ/ogpWkt270etDDZJJj6YRV5yygbgrCE26M7nPz0uHRSEdtae0KbeiBoGoIoAJSSKdnP589PzdY+BgSOHSA0Zm1ohlLjUDuD0Gf1D+Rjnwr9Ni1MLAwPQULH2TXWvMVOOw1PSA0n+9p9GvHUEgdx22jwP19+QmgVOMCl//xU9RmwL4ozNcVj92QBamv/DYuKsvtM5EAdveYlghSvfnKVGMqSqMXdzdRdtFLbu6feRzbrRE/LZAt7i/ezK0GdVtgL+pfZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNwgIH9Hs5L3ZKglu4kUuCMCz0rD3MbYG9nHolTAc8M=;
 b=mtAez6K/J1dgvlvBPFKdXhMfaHR9wOvrIQo3iFVlX3gUQt8UJittKPPFAZDXwBKYcwql9eZaAIeYgylzkqeUOT9ARO7YPfatypf9XI6rpXxGKTF6fFJfDS4kGcegSEdQiJFiKzl3wnxb68cICW2UnGw2qtxmb0uqN6fNhylqB5I=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by DS0PR10MB7203.namprd10.prod.outlook.com (2603:10b6:8:f5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.22; Sat, 7 Mar 2026 21:23:52 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 21:23:52 +0000
Message-ID: <dae49547-48d9-4abd-9fb1-05250fcd7d23@oracle.com>
Date: Sat, 7 Mar 2026 13:23:50 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 285/313] ../../../mm/vma.c:2592:33: error:
 'VM_NO_MLOCK_MASK' undeclared; did you mean 'VM_LOCKED_MASK'?
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        kernel test robot <lkp@intel.com>
References: <aaujSXGjGBv5NVAD@rli9-mobl>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <aaujSXGjGBv5NVAD@rli9-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::18) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|DS0PR10MB7203:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ecd2855-b056-497c-6288-08de7c8fd48b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	0zcQiPHhrVIsoHVMPR67JuwOxAQ9ODeK/RZIhg8D/INquajQUbvisN195w8TIXo3F56W2EVMNU2L1UoF4DCb7LsiJnRXZIbu2S4eWPgH8XNTAxJQrciLoC8BZHZT40wNMnwSrXuhFCsGfjRJD4SFHCxi2wM+dlb42IdFwQhynhzqjH0iRawxr5BIrsPc8CEZGeuR0PNGnoWK9NS8+fEUDNtz/BXQJhZidjv4kJSk/VUMqjiQGXYRzJk54u+54B5Ih7JPb6W5CMaVWW8OdRisT4a7VdJTrzPOF/fy0ZO4YLdBpaS1ozR58MSZ6ESDkEQ/l2REeXkx/+lMXqiZNSk+bRJPDt21XONSn4Ys1m/wBayNBtUQfz0LYZkNgI/Rl2W7YBiFoPSIPiBhB+1Y7lY3DUxS+rmPmiVLJSNlpSxBfsyNjkzUlZtmCalzxfgFtLUVr2STUm+nHAxMt1+aMEhnOnqunH9Ar0G7gsdmcJdSgX69MjYefsBc9pFmh4PnPRJ1XbjDgY2dQ9cEcrAv1SbEG15/mVspjcygj0chflEEFgsgq2KvmmO5tEK1xDkmU1tbUsmEfZqCJHh6O5wIMRvUQdTrr1zTGusx+5nKOoF8dWFX8hI3PCXskJIndAkFVh4Gp/aNI4Xk7UqHVsI3B+VN3pqlcq/Jrgq9BLbOj5oCC8/5sKkWVtzzm6SCGNQKwecN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1J3WUpLdjZ1M3FGZ2lzbU9saTFyaVBxUmorMUxLLytSSDVtL2NZNEo0bnJO?=
 =?utf-8?B?Rk4xTG5MS0I5Z2c2YmlNVVRQbGZtcnJRWnROQklSUVNaaW5Xb05pWWlqaTlW?=
 =?utf-8?B?Q3AyTFBFWlNGYUxLeWlxYVprSkY4citOb0hOYXJHOThUb1VnWXZFTjJKRElQ?=
 =?utf-8?B?RWJIYkJYOE0zV3JqRTVXVzVvY3pkazRybWNaQzV0SXl6dWMrTkZJYjZMQ2lE?=
 =?utf-8?B?clkvMVV3L0xsb016TkJzUjJHYitJOWNpT05VOWJxbVJVeWh0UnhaT1h0Mjhl?=
 =?utf-8?B?ZFkrUnZKM0VQZk5WVGVxREwvdUZ1d2hKcnhQcnQ3WEF6ZmJZNU12Z3hUejIx?=
 =?utf-8?B?UWtQS2tmdHptV2hJdE9vaHZoNFg2S1Fzc1lyczRJNjV4dFoyNFFDTFkxS3Ny?=
 =?utf-8?B?bVBQdEtUVzhRQS8weEN5V3pRYmhmV1lGY3VYTXJTYjIvdUJ2SWRrbTB1QVRY?=
 =?utf-8?B?TDNhNlg2OFJzMkEwV3R1NmlPU1p1djA1ZTNwdlJIRkh4U0dMVW94MXVZSmpR?=
 =?utf-8?B?V0JURG1VNXloVkUwRVFldXNDZkRLSGhLUFhXQndNZ21LbHd5bDBRQ1ZmaEZs?=
 =?utf-8?B?SktyQ05Wd3VPSFk1eHMwYkswNEJVZjI1VGVWNXp3U2dqSURvY0U2cjBNZEZM?=
 =?utf-8?B?c05IZ0todHY5QWF0ZG9HcjJTQnQ0bVZKWTJHYkhHVDZ0aXgrWTViRytPeDY3?=
 =?utf-8?B?OEdvVkZkNW9lM0FSTVlGVzFtcVIxbGZWVkJ3OTJyZGhtUmJtTGMycEJtQnlj?=
 =?utf-8?B?Vk0vcDJJL0k5Y25PYUhodGh3SS8yN2hBaWRJajhLSGdKWnpjOFcrTWNvRDA3?=
 =?utf-8?B?alhxbmVOSWN1TWhzcXUxbE1qLzFjWjJQdUJKM1VtQWVKejBnM2hRWFU3eldU?=
 =?utf-8?B?QU5OR3lrREo3WWFiQ25TejFRd1Q4Q3Y2WUNYbFFtbTVtQVEzKzRtNjZlTlJp?=
 =?utf-8?B?aWVSQi9LOGU1TDA0cVVjV2FMdFFuekgwSURsajZkamdGWlhtOUZtajg5YndM?=
 =?utf-8?B?Wk51bTBaSzIxcHRCTzM3OFF5QW5UN0xDZWFVamhMc1Q0d1pKN09NbjlEaTVm?=
 =?utf-8?B?eG92ckc4aU53OUpuTnVKbXlKaFVmb1kxeC95ZkJwLzJESlQ3cXZiSGY4bDNm?=
 =?utf-8?B?TTFSTG9kMlByaHdtOVNWUVY2VnRnN1BGM0tCVllWV3JyM0NweXF5QjV3ZlFL?=
 =?utf-8?B?K2t0UXpKekdJRjhLSkJGU2s1c2p4TU1iSlV3ZG4xNm9idFZtSHBWR2M1eVFx?=
 =?utf-8?B?d05mekw1czhuNld6SjMrL0pHU2pkQU92dG1kUUowTEY1OEkwTWlRaW03UXhW?=
 =?utf-8?B?WHBmOVVUY3Z5SEpaUWFSUEwyZWhaK1A0cnRFYzZvSXl4aTYzWWVCYk54ZVVM?=
 =?utf-8?B?VmhWNUR1STUxSWxDK2V5dk8ydnhHMTJBc1lmTDNFOCtXUVhmODJYSHBTYTVn?=
 =?utf-8?B?Y29RVHhENS8zYlBlREx5MTZ5U2Y4YkZQaXQ0ZEJBVWN5RWtCb2h6bnVVa1ZE?=
 =?utf-8?B?RWhQcUZJSWV5Q25ZQnJrWlZ5QllBMTJ3MFlYejNzTmorTWlOVThUYzAwWExy?=
 =?utf-8?B?Z3B5b3JuUktRM1ZSSmNyb3FWSW5sb1dKa2hDOU9xT09rQ2Q4RHRiSER1M0Nj?=
 =?utf-8?B?eFF3QVJUUUNPZlhSQWczUEpxZ05sTjB0dEJRa1lPaFVEbUFwRDhzQm1ZN0x4?=
 =?utf-8?B?ZEdESHlFd3UzbHhUUndHWnFOOGlCemJ5RlhCUnQ5TXFXa2hreHgwZTkxaFh6?=
 =?utf-8?B?b1NvSWtlV3c2dlo2ZERtTDdDVnpoRzc0Q1QyRERNYWVTTTJ1cDczTXVPS3A2?=
 =?utf-8?B?aFZHZUxDY1ErQkVwb1NHekFWNUxxMmt3WUxCZ1VNV25xZ0FyOFdsL3hNdGZS?=
 =?utf-8?B?Y3QzK1lmQndlUmlnaSs4QUNUTG5ub0NOUnhjclVOTDhRa1dkU1liZk1xZXJK?=
 =?utf-8?B?Q3hTcXc0bFV1RkJhNnduc25QT0g1dDkzSy9zUUVIdzZWRERvbnIwQ2JCeWYr?=
 =?utf-8?B?YTNidkp3bXNpdDFoVnpnaU5QcXk5eWlxSTJ1SnpCbmZqZzhURXVudWcySW8w?=
 =?utf-8?B?dGNRZHBFclBkMy9FTVVPYVRZN2k3bjg4KzdkOW5qY0JHV1IwRVdLOFBBUU1k?=
 =?utf-8?B?SWUrMXVlR0gyM3JPanh3Qm0rZzJSNzMyZitkT1FaMVU1MGEwOVREaUxiazBw?=
 =?utf-8?B?NmRzZklkV0lCR09nM212Z0xmWGRiMytWblp2YWUyZnFZVG1LR2NnR3dRVjRq?=
 =?utf-8?B?cFNzeXcvaDdqQWVHSWVKY2VFdG9yOUxxTllUcjFHU1dzZFNSTWlrZUNjRUFv?=
 =?utf-8?B?VUZpUVkyaW1QQ052Q21HVkFLZ09PVkR1d1pQQ2FBYVowZWg0NkJQRHBaR2VT?=
 =?utf-8?Q?teuH/xCeATdKIPSM=3D?=
X-Exchange-RoutingPolicyChecked:
	LFSBvUPJ6DukUGrEdABU1OMGQFJM9WwCGptRssC+o8H2JN0/HvVJ0uVWeOJu4kHfDlZuP6eNh2gTrpg3oYdo/Lf9ucmTlcqYkEsJTeRPA2dZzqAoMaYIUnXloR34nAk+IHV0dhFAgvvnMNCo3HgNmvdjb6cuKyMgnTZzzJ2bU49Nge84KXGFuusoHb+wXDFzabfnwEA3rntNwre/Kak5FnkYllf+uuqLRq2dihCaJl1uGqJTMCRI9x5oqUcqOnH7wh7Gzrjzsa2V3BFE9HAGPMR+XTyEtf88xhBRjwnkU9+TVY35jw+pZow/2Feh05TUoi8t+8Ku7FJzsqApaiPuqw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5pI60GGxTu0/tRN7Bq+s6J4KDA1IDoX5m6fncc4Kwh7QMQ8o2PGhhzaq3xklm2kLBWkl8DKegOcf8hHXFYlbbyCMOEGHs34Do/QE+dA7YBob/gncXAxlxUBITn+NDTeIYhjijAwZMnuIu1KzpRkOm8mZCVbyZmz8nI9HvO/GjRSGrHWJYhFTr/i1hOj3jTc6HNARYG+lSkCWjVEvXlO+BLUrVfwA9fbnSFflSfzO3JN2/ows3OyAGB1147kW8ElFwmr8z6YUqMkqtGlhBwmEtSg72IDB89unrjguqPhaG2xEJlmCaWpddZ+HLt16Rr15woqhPH3ZiRYWnRq4MxldlET3dbAbTStFrMEAIgX3erNMY+d3ifF5CHOazagITcozcywRfnEz9bThyXvYxojWIiW+veDA58SGjW3XWu1jT9Nf7CgunfsPeeBzTQZwuYG+rL1uyh3K3zrHlZSLfZpyUgr9T4evmsJ1gifCtXpp4dG5bqi4V7ihvVKA2nemnIprqPaG521WCM1hgJZtAdw98zoo/h+802R+EB4heh3dpjP7nOe8nX4uLJypxIwta0l5GQLoqsX06JXLKsEnKehaglvSZJAAWDR9BMNJJibE2B0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ecd2855-b056-497c-6288-08de7c8fd48b
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 21:23:52.2805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnw0HU/w/ksp2UjG0M/7IVoHnQXRfSLEzLjcbIzhwy6bnVy5Q+e0XP6rc4mAq//0vgBqQrqDo/wAQarkwG6cJlMAQtY85G9M0y7KnCl1mZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_07,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070203
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDIwMyBTYWx0ZWRfX+Wgnuawcv7gi
 gsAnzLUMP3qzLImNzBsKTZ4naGa1MGpkp75el3Msfm6tZcqz0wM5u3KfwKWDrY4P6DieZRT05e+
 0OV/1Z/OP3u6zq3foXHwlE9xiLo4VIXV3guGpKoDUzmVDBm4Uq9BM+miuUEYzWZ1jGzWNGuQ+s6
 0oJ62CmIl4JB7IwB1vQHQgnepaa2jNPbv1sVIQAIfbg2iDFJ73uFupPOREXLjaOcO1Swn/HoLG8
 qHAzwUJJ7etoTfEBeIrFIUWyCCaH0pgdgkgryvefj6+ur+gUXpOx1+x9AVG6NWG9MhlBdyQrAGZ
 l24f1sUi2QeY/34aEggcE4rZ25t59yjQBOmbIiCDt81CjTD6BC0h5vmcmj+ASP61JAkeNi7HZzs
 NU/qC89tqvarV78mR/vzz+dkxjxINyeqcqQIzk3+ILS91mswfECUe5xV9jAjgEOFIFZu/rzgXb1
 1EHaUXTP6o/PNutSUxw==
X-Proofpoint-ORIG-GUID: Gdaze3ARyjex6p79S_ApVb04SItQuSoc
X-Authority-Analysis: v=2.4 cv=ApPjHe9P c=1 sm=1 tr=0 ts=69ac976b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=Z1n2yWA9juTRFitNWfYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-GUID: Gdaze3ARyjex6p79S_ApVb04SItQuSoc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D02340007
X-Stat-Signature: 8i8i4ixsk4wa4k97qm5zmfoiqbrsn6mi
X-Rspam-User: 
X-HE-Tag: 1772918639-548949
X-HE-Meta: U2FsdGVkX1+b/8rptHkaVDhTk/0hnMcJmDeqZKIXPaR3DqMZeg2rv05BVEqxOGSQFN72g0PC/V0OTX1nbH4cKvZBJ+4iVlWIXfC682VMZE8exMF4FGOmmwxqqgpnTWz8FYTagCFGpPp3bTcb0kL3dgYUhwB4oUY0E2yOL7MwWerQYnv50CXAKTzxiiFcEZk4/mJOey8ZSIituY4ZUyCTVV2OAri8FOSUEXohw2h2dQXLfr1KhCfUMgXpsW1V42J+u0YPH+ZouHndGNyo/0Ov1K8IORyroW6oBwtUUrI01uAD1h/tJBc/dSLwKy3EM8ym92qjSHpXF5vgBo+XWiv6kWeVNk/bDj4LOwjfcAXWY2/P2sIlWQkJsI2Ii9I+PNbaM35g6TMCp5z0onntYw1L+dvv0cYR2b6GD3whJleXO5WwJyMwgTfb4SJ2eD3eTG/yvCb5xac28TRNXJXEgzj5gMa4e9Jq1FxfFGHxMhvakDt+FcW1q5MUQtnG9XH/qm4GaUuA11qYH94HGNtC/5Zot62ctQsH3wgCLEPJUDkP1fKrF7yLQ0Eqe5AWHDG5qB013YDrCrwXZeiv2cDVkH7TBntWAJ0Mpx/To0eAfIfzbHJVqtSFra1/FJdHc0PqGBcFHjShFrtBtm4yqJBQGAS9aC+Za0uQfgfwRLig5+q5SJjldaKg7NdN91Xn6limOBKrtADbTJEBYHr1kJLARvUcDyxugChqbRM6zWBe1E8h3c2P3kBH4c9lkMExJIXrrBHRaQCLfnM5PKobh994KB5rqBA96+MSFFKp7t2vqe+ItYA28DIFQHqfevQx+MuxSXyJB9CD3+pGY/ZDy6At8LAhfMtZ9dJ5fpOtw4W5a7bMOjFOa66IJz84S+bnTEWD9uAjKS6ZvPtJwAKAz3dMqy0VGecawgHrVMm/5wdKjrQoKcddvlEFlW4+9izNSjte9zNwh3C0CbLaKEXMIlJ1a3M
 oeHTxwSp
 spL/OQUgjjm7cqV+IDFfMrvlJmpIQq9WGW/wqJ25GsS8mIGeYUzLeszivFgz9NNbyMvGcyVzRHzP8tVgI+1xzozfsww8NnTulG2a1/1+WeZJZUyWGoffB36PUuZDpkiDNM+b4oUTrp0o4lWr1o21BryAmj0aDNR1WeP6ajrkndn3UlmDAFJugVZY3BxM37WIzai2FqR6ex14sV4Uuff0qcv+ImFWXgcooxd1IrAt8AWBgU5No5YjdZk1pOniTKd+uHbc0B16sa5vHAU+YnEomKJZxXg5fj5qAT6SKkaWk1QuPrwQ9PWPVOq6A24ar4DFHMzauYi3TlUMd8+rYIQ8GifRIk7L2WcaMw3caSMDOQEfKa9tAqArwjHKcta1BXmpT7Zv47bLfGQ9XCxZBqxQGSDA6ll1F3whQVw3TaZbUk99fl/2eV0rUarj+MVsgaBK58QyeN2eCRKc9DMVhxT4Pd5ew8GusCF9eJZY7w78wFimKCCmuA9K5neZbPSWbzG5j79FgHQ9oCZoUMpYX16z1GJtkI4PlUmzjAXM6RGV+Wzy+ZhFdRW9HKTtzvSaK73v3T34qVmebtQUQh/M0nHtVaJvvCjkMIoVO8SVs/MokxkVME/XWorV2akqyua6TGrPs0j7E1OseM5rfy1imq2nySU4MRK76ha5IxnwBDm/Zge9pmzLDGZiEQuZP+ZLRk9hLWPGquAsVFB84wAVbeFvfp1dJEw/Em8lMauBX62sx5vaeMMS/Yneb0vp5tyZlIgDSevrpAvxWWneBH4a47HO65phnLLH4z80HqSCRju+12SVeXQ40JoF3bO6mvGSJ0P1QhQxdL9BWE4M7YXY4NWW4Flw1xrC44TiH6082i00ofRyR4s1VtmyFTjLCeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/6/26 8:02 PM, kernel test robot wrote:
> Hi Anthony,
>
> First bad commit (maybe != root cause):
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   fee41c6c27b01fdd910a9d9cd4f3b978efb92ea2
> commit: 6c41b23d5f57f306c940c65a2a5240bc20a95659 [285/313] mm: prevent droppable mappings from being locked
> config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260307/202603070433.MUXyiGWN-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603070433.MUXyiGWN-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/r/202603070433.MUXyiGWN-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>     In file included from main.c:10:
>     ../../../mm/vma.c: In function '__mmap_complete':
>>> ../../../mm/vma.c:2592:33: error: 'VM_NO_MLOCK_MASK' undeclared (first use in this function); did you mean 'VM_LOCKED_MASK'?
>      2592 |                 if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
>           |                                 ^~~~~~~~~~~~~~~~
>           |                                 VM_LOCKED_MASK
>     ../../../mm/vma.c:2592:33: note: each undeclared identifier is reported only once for each function it appears in
>
Andrew, this can be fixed with the diff below. Let me know if I should 
send a new patch.

Thanks,
Anthony


diff --git a/tools/testing/vma/include/dup.h 
b/tools/testing/vma/include/dup.h
index 3078ff1487d3..1dc66b8ef959 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -350,6 +350,9 @@ enum {
  /* This mask represents all the VMA flag bits used by mlock */
  #define VM_LOCKED_MASK (VM_LOCKED | VM_LOCKONFAULT)

+/* This mask prevents VMAs from being mlock'd */
+#define VM_NO_MLOCK_MASK       (VM_SPECIAL | VM_DROPPABLE)
+
  #define TASK_EXEC ((current->personality & READ_IMPLIES_EXEC) ? 
VM_EXEC : 0)

  #define VM_DATA_FLAGS_TSK_EXEC (VM_READ | VM_WRITE | TASK_EXEC | \


