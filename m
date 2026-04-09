Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D296AF364A6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAAF6B0088; Thu,  9 Apr 2026 13:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABA26B0089; Thu,  9 Apr 2026 13:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C7C6B008A; Thu,  9 Apr 2026 13:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E44E06B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:26:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EAA2160120
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:26:30 +0000 (UTC)
X-FDA: 84639696540.14.167264E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id F03EF4000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:26:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JNLW8JEd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kN6oEZuJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of joseph.salisbury@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=joseph.salisbury@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775755587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZSlg3gNW6ky31AiH3JZgnOzUnfWhkkWuPkHlk7BuGk=;
	b=1NwP0XAk59bbvieNKUoX3lvckHsFC3NGmQc1JKnYCHX98DOnCgMwgJrHz+bNhbLJ3zpmGr
	SzKvG1lcCNH4E/3oFohqqpk5pjzD+RSUVAK8wu+O3xdjBTfWESp91l0C/hT0YlIQdeV62c
	XyGw/H3y2dayhTP5NN/sQIhlEnb1JxQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775755587; a=rsa-sha256;
	cv=pass;
	b=w2qgykXSQe44MEWEDZmG+X574MgwwD/Lb+ehPDWP+N9ASgsqWgB99YhW60FOCiBxKe33dn
	nu1lrabOLL36PCmx0qt6Zg2dJjDt5n55BQ/RQ8zGL0SM22LVPFFjEzHDAKjM6wye9xDUUj
	oFzAmbt6CXkdJGvK57q1mubHWL4af0E=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JNLW8JEd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kN6oEZuJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of joseph.salisbury@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=joseph.salisbury@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639DXWR12628123;
	Thu, 9 Apr 2026 17:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FZSlg3gNW6ky31AiH3JZgnOzUnfWhkkWuPkHlk7BuGk=; b=
	JNLW8JEdDtzKG7y4nA/vMX5rISvNZJYesyx86cUKcSrUc5yAMQlChHyttEI260kX
	ETwcpNW4uYaHmzORB0u0okzuwK9bMgx9mdc92aKCWLL7uUWeTd6nf1BbaynFPe1N
	U8PyuVbtk5sVUmtU2s69jNKeuTPFZwBePbs9QLM4fTmD6gMtsHDYq9LrlTgPUgp+
	S1+6DHO/6zfnUK2xdeizQ8R7/dZMb7tB77RTPmLf94uAopZ4/gwKeSoVZ/GE2Rul
	vQ5TQoU4Ao3rhh+CLQT7x4v27SsPBghzclZFaXYDno3f3TAl/PO1X8S6AhDmZVSi
	wLvD0tfZKmfyB0r27sqLXg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqaye6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 17:26:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639GbBOS026116;
	Thu, 9 Apr 2026 17:26:14 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmecyubg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 17:26:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VJHVYAkoK+XGVaxhAbW7rjpJV86NVw8daY/6WqSPhuVoQXiSScrdhIdeAhP7WXnC/xfhLf2dfdHx3t2FYYfmWf5Ji+SF+ej1bkp956azHopiwJcarhQYttaD2P3lculxtUDB1VoRCKnglpBmOF9FNDfwOJirz/7tIYHPhEIWfmaxQ5fxAl/a/UN24l1hpy4CoOpfsDYJXjGeNtL18CN/1orl8MB5oM2PYwfT+hnBHsg/7fstCJFIJ2UylYtMX8WcXFG3n+WvH0BMn+U350mOoqln56pefFbgVqqKOhWrtAPOrZjTpJLvhPybK8gWBp33p8lzfKSN02stPDmZT+ZN8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZSlg3gNW6ky31AiH3JZgnOzUnfWhkkWuPkHlk7BuGk=;
 b=x+jZcRvS9xAS3XNlwxsLkxTi3IiYfmnrfZhV9XTrQrv6CY+3QrUSBG+WC7CESyh2dOvTpvlDoFWyi93YnYdAIfiAP71Ks2ZAumkOKmMwREiX6g1BnFeUwN34RUStRdZ2c86S3JGhWdp2Wiyj+lq5aZmqIK/84Emp1wduUJZJpUsT6ssQgLcRpQry+9MVwOOHH7zcMmftbr1r/oZcfJbS9CSuCFWEZYprmZONR3Rc/thkQTtsGDIsdnkhoqvDvX35cIdV77i/bfLUpmdVLo0FQFoP4N4zFqqEFcR8lGZdfsBwMfTPU3DA6b6s5kFcOVH6PSMdpy8iAoZJde32X7We3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZSlg3gNW6ky31AiH3JZgnOzUnfWhkkWuPkHlk7BuGk=;
 b=kN6oEZuJyQU61F4/uE6g4RM4NAZ5AjXvBOi8ma4GCXgtKyYii/9O1sdJwt0/dZOR5hYgVtdXQXbIoFJXxSbukRFyxLs66ZEr31mZKICVGJDBtPI//9Cp0Vf73+K5FRQtIX84X9yUQWtZJvii77qntYmmGLUBncBTVnds4hSrgmM=
Received: from CH0PR10MB5131.namprd10.prod.outlook.com (2603:10b6:610:c6::24)
 by IA3PR10MB8139.namprd10.prod.outlook.com (2603:10b6:208:514::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 17:26:07 +0000
Received: from CH0PR10MB5131.namprd10.prod.outlook.com
 ([fe80::ab76:24ce:816a:8307]) by CH0PR10MB5131.namprd10.prod.outlook.com
 ([fe80::ab76:24ce:816a:8307%6]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 17:26:07 +0000
Message-ID: <30bc7a88-a8d5-4eee-95cd-c0ecf70ff66a@oracle.com>
Date: Thu, 9 Apr 2026 13:26:05 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
To: Haakon Bugge <haakon.bugge@oracle.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        Pedro Falcato <pfalcato@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Peter Xu <peterx@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
        Barry Song <baohua@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
 <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
 <ebbd4c39-859f-4a10-a9e2-c0e9cd1013a9@oracle.com>
 <F72E050D-BAA4-4D5B-AFDC-5F8A20D8A70E@oracle.com>
Content-Language: en-US, en-AG
From: Joseph Salisbury <joseph.salisbury@oracle.com>
In-Reply-To: <F72E050D-BAA4-4D5B-AFDC-5F8A20D8A70E@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::13) To CH0PR10MB5131.namprd10.prod.outlook.com
 (2603:10b6:610:c6::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5131:EE_|IA3PR10MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: d24eb31c-55d2-49e8-4dec-08de965d15d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	3/9jHfxAifk/QS+tHdN556YrLsTmuPiN3jynoET8cbN9IVQ43WPZnjHHhJ1aSqu2MhpRm8StMPGfOIn9fIhoLqIQt03hrEmO88fBnpwvso+EagwJn5IFkvYAgQGDUTyrcsp/6K+H8GsgrkAe+HqS1bdk9QSORQuOyQnjWRyLeuXxMJJX2JVafFwXt8dQ3duYeRPhy0s8PF+m4sRRIO3cVpowHEMmxXQL5YyaleuLf5IS1JRrMGdEwJ7ia3paEbAzjJyyAOyj49GO9NBnOJD3PPfmndMbub4DO2m72SeBLv3LHzem3OCj1O7Z7Lohoi6/YyCk5tzO/gKTNZg4Iafh7GsoP3BiuMHvGimvwgWRaHZlXJwLMuRePDIWg1wU3vdKUQKUPcABG8t95TrZdbS9gcS08PeEF6JPMRAL9XjzI8QQuNmEPf+BtmvHb7k0R25oBkKSWeRRjtNFgAY7AUHrqHrMBzWERCLmzCY5EpNBu8bXGPMyCVHM/3A8tJFXt9iHE95AdqR7GGkuoEXgzPqhu5ejtOApXpRbpKr32mrooxRdTTVywTUfdZtsGwRMor/NP+t48nEVQEh+8wIlyBf2IrdK7i+oWdteC3eJsao2GFAYzh+2LK7jaOKlUUrTq7uXjE9/X7B/PT69YBmYbU1QFyX2l3yxru5lfyxRUixokiywTjgyTqqg0bU7Vni3dkqX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5131.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1dsZlNlc0JRbDhFWm90ZHpjK0tnTnFTTlY2WXQ5VXAxclB6OHk1VGJYRXN0?=
 =?utf-8?B?bVMzaGE1SFRZbzNVYXdiSnhmOXE3UkZ1bHBRcGdkaVNqUENUdllmWFRlS0cz?=
 =?utf-8?B?cktORmtzRVJDVXRxUUF5YjkrT0lrU3kzRW9RNjMxVnRuN0hieTlESzRGTUJH?=
 =?utf-8?B?SFAzWTBJdlVWem54cG9GNlllN2Mwb29RRTNTbnhqTmgySE5NL09DVkY0UlBH?=
 =?utf-8?B?ZEMxWi83RDJvbTU3MzhkSG9acklIODVaRzd6NGlwaUlYMnZ1Mm9JSHF2WVFP?=
 =?utf-8?B?OHdxalNrNW1lM2h2anp2ekVkdWZwMUJzbE9wVkxNTnFSYzQxUTVmazJlcGNr?=
 =?utf-8?B?KzJZSnNma2hYZHNiUnZyNjZaMkNyWVhYTjl3cVVsQmJFcW92WDM3ajdNZTJy?=
 =?utf-8?B?cHZIVHlaVnUwQ2NZVzFVdnE5YXdqQU1abWc0OVpLZjZlaTJ3S1RpNTN1V0dl?=
 =?utf-8?B?a3krOCtLZ2FvNU5heGwvc2taUkpobTc4MXoxdnRVcjFDb0ljWmo3bUFsWTk2?=
 =?utf-8?B?NFhkYXNJbU96Zi9yb3J0VTNjclM5Wm54NXRoTTB0ZFdRRlhkRkI1RGVhQ3ZH?=
 =?utf-8?B?OFR2eDJyaWVYNmtFNXlzbFJtYUpOOEU2T1d1MlVNWk85NUdUb3J3b2kzRCtG?=
 =?utf-8?B?L0N0eEgydlpOaEwvOXFBMUZTM0g0T0dwTjVHUjgrS1E3TDF2ZkUyZ3hzeDVl?=
 =?utf-8?B?dmpxNjc4TnRJNHNkSldnSTVrY3pQenRkNkQ3TUlEcjFWQVp5UlZQcTVMTzBo?=
 =?utf-8?B?TE9xczN1Qm9TVlN1ZGlZSkRpeHZBd0c0aWxwNzdJQk5hZ25OYnBvcnl0dzV6?=
 =?utf-8?B?dXpZMi95NVZYZGYzOVRKVUtFWVJUSzBTMXdsMTVsaGJ6c00vVTlYdjRFWlFD?=
 =?utf-8?B?WlBodytxSDlyTWZNdVdvU0JmQ2xDQW4reGdEbGJvaTlsWUMzei9mdDRRdlRS?=
 =?utf-8?B?d05ITGdrOUpkOG1lcDVrb0FYZzhEdkdPMk1aMEhVNjhkSHIyQW9OT0Zrb3BT?=
 =?utf-8?B?MjZvNzdHanBZN2N6V0U0VGkyeGd6TTZSSTFENklyQ2dSNUN5bE1UU2hkNEpo?=
 =?utf-8?B?UmtYUkpjNUN0R2NaRTBnM3BabG5aMXF0azFJakR1elBYYktzWUdSdnUxTGhN?=
 =?utf-8?B?UjdXME9VTHIrclFscno5eXAwZXFvdThuMXNBbFdlbEE0akdXTllPS1IrQ2hY?=
 =?utf-8?B?S0krVmFkS2Y0ZU9jbVlNZGlvUk9IR292a1BYblUzVThrclJJc0tjVmNSME1N?=
 =?utf-8?B?L2crc1JMcUM4alFsNmtJOGxGQ2hocUVBK2pOWGdKMU5DRlZhc2JudHppNDVv?=
 =?utf-8?B?a1grWUJLKzFoQk9RSjcyb3JsM0dHZEwvUjNweGZmZzNYV3F0RnVoSWhubUxR?=
 =?utf-8?B?UloxQXRZcHE3VkZ6RUltR2FXN0JDVnl6NEdTd045OEZURGNmcnhtSG9VZDlG?=
 =?utf-8?B?OWVWMWwvaWJlSmh3TTgrWkN5RzYwRFZQSFZ3S0hyRDlkbks4L3RxK3U4Nyts?=
 =?utf-8?B?U2c4bkY0dVhjdk9SczZjWGxYTFNRaUdkQ09jQjhqanhNbHBUVEZYL0VZTU1Q?=
 =?utf-8?B?Z0k4YnNhWGd0MFFwcXZWNTFNMXRLMlB2V1N6ZWorNTNLcHc4TlZ2RDltOWxy?=
 =?utf-8?B?eFJWdi9jWUw2K3VwWnIyNmh2UjhhOEo4Mk5YRFBzUjFnU1c5TkwxTGNUV1U2?=
 =?utf-8?B?YlpLajNMV2hOYUlsUHJFd1gybjg4eXUyNEFEb2xuREs2aHVKc2REZWV6L0ZF?=
 =?utf-8?B?Y2tSV2xmNVJQcmtGNFF2Y2hONTJtbE5KQVo4dVhrS3hENHY4ZmIzNkFRMXRM?=
 =?utf-8?B?UjlEaStFd0RKcGxPblNhVjBNNlh4UzY5dnN5cWNVVXptcWp6aUxGNGVOMnpR?=
 =?utf-8?B?V3FOZ095bkpqS2JGc0lQZ0NBV1N1OCt4U200YnRyYkFlVXZFYldIblZIOFZ4?=
 =?utf-8?B?TEJrcXplbDdlQTAzeG5QUURhdUl0QnU2YUZDVmRRY2N0QzE3eDIxTEpyMHJ6?=
 =?utf-8?B?V1dwY0tYTUlHYjhESDUzVldYT1Q2cWhMcWJMU2hRWWxPSjBWV2dxM2taR2Rt?=
 =?utf-8?B?RHRkdFFBMXI4RGIzMkhScjFPNzZOS1lCNS9Sc2xyS1VRNEhhR1pQanh5dXha?=
 =?utf-8?B?ajcxdkhmV21EZmdOQXJrOS9ZbmgvSGRBenkzRFN0WXA2cHAvNUhQckpLK0Zi?=
 =?utf-8?B?TUJmL3IvQWtXQjFZaXRvWGlyczNLYWl6MkRnc2RQejdRU1JkUFYzYm9CZHlz?=
 =?utf-8?B?K3ZBaWs1UnkrUmVjWVJXSzcvdEc3VElYWkpkSWJLdjlOMG1rSksyZ2FxeEQ5?=
 =?utf-8?B?RWxlb2dwWWN5SlQxUVN5aFFIM3dXMzhGTHFJc2NsWUFvN1ZzazVNQStibXUw?=
 =?utf-8?Q?gfvTSnQyLEonfzc4=3D?=
X-Exchange-RoutingPolicyChecked:
	r7ahkHIOSVjYunNJ+WfPvk3djfJrv6J5jOZhN2vPdnfWzhUKJd/UWQ3tBXdV48gCWK2aKr+fKWZX02Iq4j+5O9q04NO0trALWsq+HCeM0q44PZGzpzVfLh/bFCEG596FPRLcmXu35a+WdmOR4G7C/IQnKX5hV6n27HgrOxkDNEzfyHvIL4j6LgsVwKfd10InErtyWbfACRCPtFDacypgXXSFVEuJb4VBDIuRi5O+dO1m0TvxnmlUSYgOCeHfr4tXAWi02zJJVdHDHuNlFUPpVwH5on3e8J58dKcUOFu0CoiH1J/cUPgKHhG6QEIvoCdVDo0G/+4kH3K7zalj+2Liqg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I7e5VFpdvAMyNiBppUWr5Ba5TTXBZsBS2wQGSFBSygcHADGIhwOjrzFhGwoX4gtDvPGrTT4hSEm9nknRADJ4eJ7vW7DEw8H2hJAZEvehOz7iKxeZxJEnngJI9aPbPJ/RPmXGVri2C0o8+uZ/GipkkYouAGlCxthkuItaX5+BZ8o9Ah4WA0M0aRPyzrvZTGTwQAgG5b6pMglwURr5yXoaLzMnaRNNL8YUGpquo/2oXOze7EyFWzQ+a4Jr2PF3PL+IWIEN1ewLHebXrCkC06HeFSjs/j4QbCMITFCI0AFV8LJ5lICFhpA3mcijchdpfd/v+GcOBDozM+NekX1TKLOcThtkH2F2OW9bnTqtWY/oLsPbY4YBIfeeYiVnZVDbK10i8VR7qMMjAyOI3NL2Kpge4ZxOsHqPacGPKPHsJCh5vcxSX7FKke3c8yvrMsXjp0Zq3qgUIpF1YPmG599gSdvdlGF1EA9owbzuj8WraSSZ+7w7v8ciHhJrqOnY+kdoC7sVpPXdl560ZBGF6Odcttue53s9c8oUlxvcWCuNGApjocTsgbJmJj+2AcPIsMuHyEKOfUoB0JEDgU2AmzYktbWWk9DPyGTDsNB24N9Hb26ouiA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d24eb31c-55d2-49e8-4dec-08de965d15d7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5131.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 17:26:07.7084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PLA3XVVUA2CY3CB/0oVrz7mnTgnWVLeGAvicxNLC1PWsVy6d3oReBg/aps+FHapKF6/SiLdLXEnx028HRfYZDDtW1ZsRmyC8d5c5p8JWDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090159
X-Proofpoint-ORIG-GUID: 07Xt-z0Gv5Olx5xcOFbwoZpahs1Uy2Fm
X-Proofpoint-GUID: 07Xt-z0Gv5Olx5xcOFbwoZpahs1Uy2Fm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE1OSBTYWx0ZWRfX4r5933aZ3eXn
 o8vBI8BFKiXlod0c6eWOlxn8QWyM4W6JAHJ3pL8hmgYOG/B06zGkcggg0z3l/rMkGSCJAFIMuCE
 7tOCLK4iYE5SHq+uF3Vq5Xni8zUrmk8WBd5WoqoTuqkHv47EB/sxtOiRst1HiD7NhCL4yHEArMX
 bWyfFwR0V+o2dUQBcLJU6JavQJCS+7YMNlIkWHZ2zpmQh4zaYupkQ75JP9sFske4OkXzPDiZrf4
 J3OqC1KkwJsZ0sUVrjTBG9/1Cwys9mF7plaNepkdnJELGPCqFFcYYCjU85faszMW1FA1BU+/q4Z
 Y8oMp2q4KXoDtLX8SyJXQ6ev+NeSQBbCy0mbpOA2WVEE3DHr0raKgELAPPeQHFlp+HBIvy4yhcs
 f7ErrWAfs42Zy6baDOFmt7Kumxi00xqlJl2KG21amqRSFHPTEoMbDQjbi1hsADF6N1VKwai0ZQf
 lsuWZjaFFEDEBaoYEj20kCCeoRdX3Z9CeLHAxyUg=
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d7e137 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=D19gQVrFAAAA:8
 a=yPCof4ZbAAAA:8 a=Wqcp8ErpS8dgCjOzjDEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=W4TVW4IDbPiebHqcZpNg:22 cc=ntf awl=host:12292
X-Rspamd-Server: rspam12
X-Stat-Signature: tfg6itmepb7x4gmewky4tx9zd6k77nki
X-Rspamd-Queue-Id: F03EF4000A
X-Rspam-User: 
X-HE-Tag: 1775755586-414970
X-HE-Meta: U2FsdGVkX18IdG6v0DcGx2ULpeeIoY9T9PG5GRRZrPP7regkPBUzQc1psjWol4pAgHJ0guEKh4ZpiV1TXrPRJbBDQyKZuYIdzSTVzsRNDZRxC3E70f0J1ma0wj9MVLHIugYc8TngRZkLSO8zyyVe17qm63Re1hMk1TjSSoaoZquYSnZ1JeBDdI5HG0zcJ9JAScj99u48lshEpwJ04MLdk3LjTr+giNhhsF3Ar+MluGrt05L6ej8C/yiAkSqRKZBo/sF9ici8D46K6tkhZYOnQC5ofP1ERWjruRO5eqEwshWgRdN34DCdManJ1btMtlwpiKNaDTAHo/RWTfBsDsTjJh5zGQFMdbfBCAot3fuOPYv1kJDFSS2oaJT4IiypZFK4f4/I+UY+y6R6wxCqkOIOWBL9JABfuJiMRTh2nrmDchWcEIdDLv10BHr11kvmLgPn7S7Ka1W4/hTsZpnQDNqDWh3jlwy8uP9UNOhLZELlmhmUOIpNHIklZeZ64HvEaLITqChNJsgzNDblLZJ+mNq5menM4TzY+P4nHTl1ftf3SJy5Qv42JnAXyaWxbeAO9YvgZv3W9k2kntxcLu0l7EiqOXnG6UamYUwXfXH08I1ukoIpLBRUnOSBr27Ync0bFatk0nYvJvS01OnlVvSiUixzwDdQV5pJ6pwfcnPbf9bAo3F6yVCXjiRax209c9zNTomlwcSrpUQpQzJVj8qmwKYgG92xWvf/IX/qHLYNPnUOH8lZOZd31j8703OWi3sKy8W9SQOrK7afkKd8bnuem6ykj0FbrjIT716omNsD4CVmg6xwM1xv4XXj+2udiRyfnvvlvVJkuG9Fs7v+8bhvjeQuyXqzHAzK/b7Y2vq21yW/dh8DAGV6WqCbCLZz+z55js5gj/rDAZDhuQd4yiJqYjbEmzonII8Vfe4M885QP4Q07VZV9IIj+U4TWHGAXxWUL7+/tmCX+sYtGwCwrmhTGOb
 vKsfmti0
 Lo2M+11/Gh1ObkwtC8YrHzU4zANIh3sApVqjRd6WgoM9nmF8I0vZt6N8nmc8/OKRcpCg4+7uWcKoT9eFSdEITGrCEMyC+LTSnY5EsqQy8Qbb2vxELlrsaGNMs3ife5/EFBhYGNoO1s3mGeCOGSnrGuyqJIQBfJPaH0/rqjO8E46Xt1wz71ARoGCv23INJ1+UKHB1vP4mYQOsH+PMoxW1Fu37wytvecDwhW6ObtjmHaYU4BOs20L2eLMUs0a3AUfCC94c9NZb8B0FU6YKh7U5Qs2ciYNka9P1nC6d5vqdHnmfLYVb/Z2UZo2fgJ6og3FuDYR8JnSdLV3em5C58CwpVBfc649LMipqjcaQBok1EepLfvp1RBs/g2jM3QFmacN707waB9lyFeYM0ZnrRLBV70XKunIjdnkw3fC5oL0kzMDloOuaaT3Hl0NNvDZUupT3FQd+hSOi00PNjXuPxtZqI1XeHvaLYx+a13ePWG781slAWRGzGbKN5lXCe8drHho3wKKAx+aAVrcoylFWcEBaYEYp74+hZuZ5l96ynwCBGj6WpDv4W0046703ZE9RFeIq2PrLKoyoF6A/ddIJr4sc0vFn6jbnVmibu8yOKdlm7vNLjtddlljAXujoNqyaBuS0Wkok1FOAbtNgN4GOIhq02Gx+nSSaA9+dMAnco4mnXm9iY+OdXEvL2yeYrnp+3HIRUbUt9JyQvicyOw9mYb0Ppzynw2XfPXZ3sbjMymERumRaVhMR6tjRt7zmmKZalL80tHrAqauJyENf2neFddYa9gZesQAXlxDOgsaBDI8SNvlmcsEtKfljqK//01g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/26 12:37 PM, Haakon Bugge wrote:
>> On 8 Apr 2026, at 16:27, Joseph Salisbury <joseph.salisbury@oracle.com> wrote:
>>
>>
>>
>> On 4/8/26 4:09 AM, David Hildenbrand (Arm) wrote:
>>>>> It was also found that adding '--mremap-numa' changes the behavior
>>>>> substantially:
>>>> "assign memory mapped pages to randomly selected NUMA nodes. This is
>>>> disabled for systems that do not support NUMA."
>>>>
>>>> so this is just sharding your lock contention across your NUMA nodes (you
>>>> have an lruvec per node).
>>>>
>>>>> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa
>>>>> --metrics-brief
>>>>>
>>>>> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
>>>>>
>>>>> So it's possible that either actual swapping, or the mbind(...,
>>>>> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the excessive
>>>>> system time.
>>>>>
>>>>> Does this look like a known MM scalability issue around short-lived
>>>>> MAP_POPULATE / munmap churn?
>>>> Yes. Is this an actual issue on some workload?
>>> Same thought, it's unclear to me why we should care here. In particular,
>>> when talking about excessive use of zero-filled pages.
>>>
>> Currently this is only showing up with that particular stress test. We will try John's patch and provide feedback.
>>
>> Thanks for all the feedback, everyone!
> I reported this internally and have worked with Joseph on it. I tested v7.0-rc7-68-g7f87a5ea75f01 ("-"), "Base", vs. ditto plus John Hubbard's patch ("+"), "Test".
>
> Stress-ng command: stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief
>
> System is an AMD EPYC 9J45:
>    NUMA node(s):              2
>    NUMA node0 CPU(s):         0-127,256-383
>    NUMA node1 CPU(s):         128-255,384-511
>
> The stress-ng command was run ten times and here are the averages and pstdev:
>
>     bogo ops/s   pstdev  system time   pstdev
>     (realtime)
> --------------------------------------------
> -     3192638      35%        24041      32%
> +     3657904       5%        15278       0%
>
> This is 15% improvement in bogo ops/s (realtime) and a decent 36% reduction in system time.
>
> I shamelessly copied and modified the fio command from [1]. I ran:
>
> # fio -filename=/dev/nvme0n1 -direct=0 -thread -size=1024G -rwmixwrite=30 \
> --norandommap --randrepeat=0 -ioengine=mmap -bs=4k -numjobs=1024 -runtime=3600 \
> --time_based -group_reporting -name=mytest
>
> (that is, one hour runtime)
>
> - read: IOPS=14.0M, BW=53.4GiB/s (57.3GB/s)(188TiB/3608413msec)
> + read: IOPS=16.0M, BW=61.2GiB/s (65.7GB/s)(215TiB/3600051msec)
> - READ: bw=53.4GiB/s (57.3GB/s), 53.4GiB/s-53.4GiB/s (57.3GB/s-57.3GB/s), io=188TiB (207TB), run=3608413-3608413msec
> + READ: bw=61.2GiB/s (65.7GB/s), 61.2GiB/s-61.2GiB/s (65.7GB/s-65.7GB/s), io=215TiB (237TB), run=3600051-3600051msec
>
> Also, running Base, I see tons of:
>
> Jobs: 726 (f=726): [_(2),R(1),_(1),R(3),_(4),R(6),_(1),R(2),_(2),R(2),_(3),R(1),_(5),R(2),_(1),R(2),_(1),R(1),_(2),R(2),_(1),R(1),_(1),R(2),_(1),R(3),_(1),R(3),_(1),R(1),_(1),R(1),_(1),R(1),_(1),R(3),_(1),R(3),_(1),R(1),_(3),R(1),_(1),R(5),_(1),R(5),_(1),R(1),_(2),R(1),_(4),R(2),_(1),R(3),_(1),R(3),_(1),R(1),_(2),R(1),_(1),R(8),_(1),R(4),_(1),R(3),_(1),R(1),_(1),R(2),_(1),R(7),_(2),R(2)
>
> when the fio test terminates, which I do not see using Test. I take that as the threads do not terminate timely using the Base kernel.
>
>
> Thxs, Håkon
>
>
> [1] https://lkml.org/lkml/2024/7/3/1049
>
>
Adding Lorenzo Stoakes to Cc.

