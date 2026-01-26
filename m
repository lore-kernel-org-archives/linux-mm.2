Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E313DCF65C7
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570C26B0088; Mon, 26 Jan 2026 04:46:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544C76B0089; Mon, 26 Jan 2026 04:46:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416606B008A; Mon, 26 Jan 2026 04:46:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7D66B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:46:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E22AB89DE0
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:46:09 +0000 (UTC)
X-FDA: 84373634058.17.D6141E5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6D860140008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:46:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kP+7usTH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SkFc2SPS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769420766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASjKzlvLLJ4QcSh51vOaAuqK9wYVYxOo6yIcCXkD4Kc=;
	b=tsTdGZ0BwR9nXqK4aFdls06uXunsxMrQCLLYHZ1TnoaR4YGgCh6AnG3043AnbWtzzfegQ8
	e2jix5U5jmUx5mpa61SK1OJcvkjSxJaIOTGVS5CkJdnNeB6KhQGg+y7n/FJ0bjGCI1Z1Ub
	qr9XvKE1m8FO/LL615fqaDEClhe8JcU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769420766; a=rsa-sha256;
	cv=pass;
	b=T2ayuUfAazc85khjKPE16KhOKBVi2nIDyX9h3B/cFebX/YQyi5y19z/A1DBh4gLhK5sJUZ
	OegjzMifTAYfrd6BbyXwS1FxqUPTobWB+TLYuJhVHnwA2NhsLG5zy33M07uGUBTvaxBbu9
	Ne6Gn4OxBkID0/u1RTcRwvjS1mIjk7k=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kP+7usTH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SkFc2SPS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q6Q4mn824986;
	Mon, 26 Jan 2026 09:45:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ASjKzlvLLJ4QcSh51vOaAuqK9wYVYxOo6yIcCXkD4Kc=; b=
	kP+7usTHPW9OnuE1VXUiCAAwxdNwqY4EadV2+qv0DBAmuK2SqC0ktis6E1gs187Z
	3F/BfOfBf6FrSzlj6AHgR9WSm+ML0POsJuj66RIeXa8+5N3wbOyRV0A36MwfuXcy
	9wIUwVI6gkU5Sl71ZCzalBCl65PcFxKo9dwX4x6CZUxkGqaUPrxB9Tu9zum7mR59
	g84hChFc66hlGmYsIaZNPxdTC6SCzgba3gV6NiPjVwFOM1lbI9MVAxWchpcF9KqH
	lCv+gq6k1mVKXRCSC1vIWfMedlGjcBjCb4wBUNCdt/BGyr2uFQLHY+s9TWLyXzVs
	aJPfnHfPZfmpb+GxeFcl2A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvny6sjx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 09:45:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60Q9EQA4019799;
	Mon, 26 Jan 2026 09:45:52 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhd1p0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 09:45:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oqTzNGrzebiXk5U7GnygHkvNujDDbk9AHx7EHrUzR4nvztmsmTwsM4Zj6PFlmQwlr3tod2sXjXtC5IyeHKwcFOkhg4Juz3USg78+JzG5xJyDLT3LyY90hHeFAkFEh6G7rbfhNLxscjgBngyFaIz6a4ftEfFYTTMxDr3liBq7Ta37c66WEq0wn39wXhtlS3BKIU/ZayNXPrqgP9MUBTeVA87Bf6JapnvGXyARk8KRWzx0XYq3+GCanB+jwv04JK4oAJE/ydf4OYm7IJHGOnLJ1z4hqjQA7kU8vFRGKxsQ5iWw8mkAGcOM0Z3Qk655ck/xlCgH2bSMXE+2djhm8ifaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASjKzlvLLJ4QcSh51vOaAuqK9wYVYxOo6yIcCXkD4Kc=;
 b=oXGvTEc9m/s7I/m1YwM2m8OO6yKijPMhhmILYxjxMBfD3doggB4X+YM7vpRvhoSYKJ0yZ3R0pGVdFTUahgSg+zSQwzKOOOTSuubQyS4CQBOL5FrSup4SUEdNOUJst9jiSFmddhkvh7MAqLUezM/lT+kf86qOkZfKJAjZMCYKq61MKguMPHXofe/bbo32tbjsUnzK+qwCUh3rs6kRtQ8aEx+Oq3ArNMcE4RuokHLhpPxvTnfwl3Bq9ee3lAOIQ60prvpNMxxJctCdBYkqHcyNVpVFOWFsLlFaFoTbWmKfXuEV74GZMhSwdaqi9AK/20VZ8+JAepfYI/7xoZKOGescsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASjKzlvLLJ4QcSh51vOaAuqK9wYVYxOo6yIcCXkD4Kc=;
 b=SkFc2SPSoeLhTceBgtGpceNMVgTEGBH6CqGbT9VSSNbzwTb3O8MOelfXQIiEV1WNJtxB3n6FR0ptGa4DTEc5hBf5eLa53nOBVdMjQGrwy05e8pEuJGyMhMMKqm/8bZ2v58SmERK/+zs4bso5Q2TbMd9FbsHbE1nrLgLZbIJSWeQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB7578.namprd10.prod.outlook.com (2603:10b6:208:491::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 09:45:42 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 26 Jan 2026
 09:45:51 +0000
Date: Mon, 26 Jan 2026 09:45:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 06/10] mm/vma: clean up __vma_enter/exit_locked()
Message-ID: <0fff3ad1-3411-4e49-bac9-028151364155@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <33273be9389712347d69987c408ca7436f0c1b22.1769198904.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpGK63E-EtX4V7+Mgf9-KdBfvb27kzyZH6pYoYuzUQPnxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGK63E-EtX4V7+Mgf9-KdBfvb27kzyZH6pYoYuzUQPnxQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0462.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: 7156bbcc-537e-4e76-9d06-08de5cbfb0f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFc3MmVTYUFNZVRnSW1lVDlDdXpqcThZcngxekFVK0Q0QXBpZWNIc1R5ZDhU?=
 =?utf-8?B?K3JQQzdRVFEzbG9UM3p2WnpCQXNTOFBzYTUzT3hYVEdnSmViZEMrTnNyU2dJ?=
 =?utf-8?B?QXgwSWduZ0sySzNCZDdHa3M3VW50QkRWTzEvUTFHWE8waHNsYjRHTnVxWGto?=
 =?utf-8?B?U2xLWWhmNlluT0R0YlQrK1RxSGtiSjFMTU5RY1hrbExQUDhZRjAvRmFoTjNF?=
 =?utf-8?B?RzJNZUF0eXVMWXIzdVBVUzRYOHRLeHlqOTYxbEtwZVhQYkY3VU1LMGsxUHl0?=
 =?utf-8?B?SWNZSGwwSStjazNEbGNqYjZvdENOOHQrd0dUSHM4YnpXd29qdVRGWkR2MEpr?=
 =?utf-8?B?NVZaUEREM05LUGJsQzR4Q3ZTTWZmTzNNaVZTeFlaS1RLVno4SEcyYVRxQ2lq?=
 =?utf-8?B?YSt3dW5OUG5SWkNTOHR0anBtWnR6Y0hldHQ3MFZrNDRrY3RheUhkbm1RdjVp?=
 =?utf-8?B?NjZoMGthZFcyRjFQRTNlMzQ3dHdHSzI4S0NSZUVwcWpkRitrVE4rQVpwRVhV?=
 =?utf-8?B?dytseENwMWtwWDcwSHJxRlhsY3pXUENMMi9TV01SaW1seS9iaXBnaDVyTFFP?=
 =?utf-8?B?WXdKRi9PVFR4Si9pMk1BekxReWhWeWd4c2pMNEtwQUpyUjd0NUJmUm9HM2ds?=
 =?utf-8?B?UkVnakNDbzFQVUt4aFl3alYzWVJwK2FJTHc1eFdPaENmZksxSFNydStPTkJV?=
 =?utf-8?B?eWlXMW5mQWR0Rmw0V1E0SXlxM0xJMjlOTnhTZExHVE1KelNKZ0lBRHIxUXJa?=
 =?utf-8?B?SXdWSndUckg4a2FNL0t2N00xdWxOeDQ5TnBkdHV5aWdkSlI0ZnFYdHdBeTl0?=
 =?utf-8?B?NHpPbHdPQzl0bzVOTGhpY2p0OC9QQ3ZJRGx5a0l1azJodGgzNmkyYkJBaVFI?=
 =?utf-8?B?b2lJR1hpaHVRY3VTeVI5TC90VXhHcDhuSy9rZCt5ZDlDcWc3Y0sxVGVOKzlt?=
 =?utf-8?B?azI1a3pyK1p2bXkwVXNkTEZSaGE0RzJ2YVUyeXBUTEhSZFQzR2gyaDE2L2wv?=
 =?utf-8?B?T1hOZCt6WUVJcDVOV1g1M0JIN0t5TWdmMDl6UlMvTmd3ZDY2MjVKV24xbEtS?=
 =?utf-8?B?NFQvbTIvMmtnWjJ6RWlaVzZVbm1WTllaQTdyK2lNZXJXakI2Zm5JK2FURjds?=
 =?utf-8?B?czZJcGtwZjNPN05GbkpUbmZuaVFGRERjVmltamxNdU9WRnl1WDJVSUVqT1Rq?=
 =?utf-8?B?NHAyamJtN0RYWCtrS3FZWlJGQy85MFhtcTR1ZWlqTlVrMnNObCt4S2Ewd1M2?=
 =?utf-8?B?bnZNK2ZqS081bElvb0ZQc3BObnRXeTdsdlk3U3YrejYrN2lHSE1GbzZncGhw?=
 =?utf-8?B?N0U2dUliNFZXUXVhZDNDa1NiU1RmMkdnSXphWnVZZlBwZHRaR3NHaXFUQ2lF?=
 =?utf-8?B?d0tIV2U5NmFXYy93cHE3Yk03S0VUMzFDMVIwZ2Jxand0cGpQeDk2LzJ1T3pr?=
 =?utf-8?B?SDBKUjEwT2VZc093djFSWUJETkNiMXZzVW5hSC85d3lOVGVTbGtPL1Q5RkxQ?=
 =?utf-8?B?VThUcTBUcTJoTC9pUk0zZU5oVXFBblVoL3dBU0xvWWR1clp4YmJTRXljbTFS?=
 =?utf-8?B?N2RQTmdGMXBBZ0xuWkI1YVowTTd5TkdxTkcxSDdtdEZNR283Y2VnSkl0UytK?=
 =?utf-8?B?WksrejI2YlYwSzFhajR3M1h3Sm9mSzIrTkNVOTQzZTdIa2t2dFFXNUhUcTNp?=
 =?utf-8?B?ZmUwU1ZjazQvWnZEUnk5dE5ON1Fad0FTblgvQmhDcjFPOTJSazRPNkJDM29s?=
 =?utf-8?B?cHJTajE1a1htd2VyYXRhSmlrN1EyQW5OL2Z6MXhUeU1TL3hlUlJJKzRtNm1W?=
 =?utf-8?B?Uk5TQmQ1dWFnSE5LdUtzR1FEWFZjdzVxZU9QakZ4RmJVTWNqak1DUjExSGZw?=
 =?utf-8?B?aWxzM290NTQ0amk1UTFQWEJNSk5TSFNObXNzaTNGdVVLK3N6UUI5TC95V3Jj?=
 =?utf-8?B?ejBNbHhMTkdhaC8wdkZOYllMOVhhYzQxekFUOGVxV1NVWlcvQ3ZiVUYwTVQz?=
 =?utf-8?B?WnBjYTFFNlIxbWhTaHB2dnJLOE1wMjFsejI1YmFWaHJzUVhwMzRSRGVua3NW?=
 =?utf-8?B?cHBOZzhKa0NKNjZpRlc4QzVUdHcwaVFMdTJGSzVkTzc3L3hvMFFqa3lMTi9C?=
 =?utf-8?Q?nA0E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGJXSUhaWGlKTTBuZXZDeEJmaXRmVHkwSnBDaFAyZTU0ZktRVlV4Q3RaeDd5?=
 =?utf-8?B?RUZWdllRS25UMFF1NnlMKzNHRHNKbnVuQndqbEFTc2dEdFlXVGNBRkQwRTBV?=
 =?utf-8?B?VWgzbkp0QWFzYkR2RGNQTmVJSVltTXF4QUJZbnJEZHY4Sm44dFROanMxbHdU?=
 =?utf-8?B?MFZqQ0swVUxmQ0RtaENHa2pRYnMxUXBJclRZOWdtRkhFeHBLbXQ3Njc2cnJR?=
 =?utf-8?B?MjAvWjNscTNSVDZLRGl4a1JkdUwxc0xnUVBNMjZIYklNN3c0NUhZQ2RKcTdL?=
 =?utf-8?B?VmRiU1BZQjQ1ZVpWOUtQRlQyOGNrcVhhb05VVmNIT3hrNjh6aDNRR0dSVUN1?=
 =?utf-8?B?azk2VUdaWTFSRm1IN1ZkRnM1RmFlOWhOUW1sTGphUi9WRXNkazV4ZWE2R3dB?=
 =?utf-8?B?VUdaMFFMdDVQS3BQVlBVa3AxVG56UGpyV3RkYUJxTjd4Q20rR2FINzFnbmF3?=
 =?utf-8?B?U0V5d1lraXdhSjdIMTZwVVJUdkw0eXFaaEdrL2w5djBJNWdnaXYvYUg0dTJP?=
 =?utf-8?B?bFF2ZzF4UGU0clVtN05PMnpGL1F6Rkc0dXVDOXo1QVIrNkRuMGJVVWVPajkw?=
 =?utf-8?B?LzZLT2ErREJhUWhkMmFEb2VpaUpuK2ZDTW9uUVBRaGl2MER1MG9QNkorNGt6?=
 =?utf-8?B?NExybVNiV1VXZkpkcFBUaFBJTGJQeUZCSjFoK1pUQkw2Mm0wNWJQbE9Yaktz?=
 =?utf-8?B?L1kyVFdkdC9Oc2lWRGhhNDlIdUhPUHcxaXZISzhVRFFZNUNJNnZ6d2JId0Ji?=
 =?utf-8?B?aG03MWdYQjlQclZJYk5ObnBzbVpSSXU2RUNCb2lqRk82L2d4M1ZOVi93UFJH?=
 =?utf-8?B?NTFaZ0Z1SEdPcTFDazJrbzljYkpzYVp3WlJzOGYrN3BoS0RBOHBoSGZSUk0z?=
 =?utf-8?B?VUp6a092elpYK0lxd1VoMlloQkE4MjRJakswa2pCMkptVnU4U0wxN2E0U3My?=
 =?utf-8?B?R0JVaVFqQ1VEV0tkRytPR3R0SEZhcFIxMHUrQk5HRjFWeFB1U05NWk9CWnBB?=
 =?utf-8?B?RXRyMTFHRU5RWm9QTjEzSTNBRnNVd2FGS0s3R0FOTHRGQk9SeVB3RHJDaUc1?=
 =?utf-8?B?RThQZ1BzRnY5VVJETnN1ZzdCR1dyQ2J3VUNueGpFS3JFbFBRcDlrSG82eUNp?=
 =?utf-8?B?SlMyVDEwcEg1ZWU4eHZRRmNtemdsclc4RlFpQ3IxcjFNRVFIMzc0K3NVaTBT?=
 =?utf-8?B?SHFUM01oSFBJeFFvSStFcENQS0dwOG16TWQ3YXNxMFpSL1VFY3V5T0luVGE0?=
 =?utf-8?B?YU1hYVVLWG8vOG9lZkhEMUUzN3JLRXkvUmpYOTNPQmFFendDazJPbkRQNWR0?=
 =?utf-8?B?eUxkcHQ5citLZkdpTzhDeEFPbjlEZjhkYTNadTNMRTdBRXpjY2dnb29ZTzBJ?=
 =?utf-8?B?dlEvdWJ3ZXJyUzNuSDc5RFBPNDQ3SlhJS0NQN0dKcVc1MUlrVUxTb29GZTF3?=
 =?utf-8?B?bDE2MStqVTM4cUJwT1g5VExHRWpBVkNLNzlBYnlXQkpYSjVrQ0dSUFZlMUF5?=
 =?utf-8?B?cXp4RThwUUxKcndqcGN1NlJlVmZGU3MzR2p3dUdqU1Z4aU5CZUhFRjEzRHRX?=
 =?utf-8?B?WFUyUGtHVmpVNTR0TlZiSGIzZGJ4Y2U0SENHQ2Nrc3ZtVzByU3Rva0dSUENR?=
 =?utf-8?B?Mk5GQTNCWlBoYW05WTUrQ0VIU2JhQ2NPdFlJanYwUm40WmppV2VxcHg0SkFV?=
 =?utf-8?B?SGo5bUt1MHlZSHdMYnU3UjFGVlpKUnVIM0ZmOTZxL1phQWZSSVF6OFNQZ1Ni?=
 =?utf-8?B?RnR6WmJjcVNsbkVaNkhubXQzdGIweGpJUnJyOVh0c1hKVzJGNCtvMFFISSts?=
 =?utf-8?B?bDBOaHd4T1FKZ1FoQ0p0TEZSVmJDU3NFRnJEMGVxZGw5WGlpNko2SU4vbVBV?=
 =?utf-8?B?SDc0UWhDNUgwZ3ZPTTdoY1NScUcvU2VYNjN1YkZMbk93N3VzRUJxK3V0NFVz?=
 =?utf-8?B?TTFOclFzSU9iak9yK0dLem40ZDJPWGF1bldPMk1Na0pDeTJHejhBNHR1V0Q2?=
 =?utf-8?B?cEVtTjRkNm01R05wbzNtWVhuUUFjeElqWWRwNDNxejBoaVJQc202Z01kVXVL?=
 =?utf-8?B?QVcySFZJNVh1bndzTjByUXBCM0JUcGlHV2tyZThJK3pCeFE0R244NUoxbXYy?=
 =?utf-8?B?UFlteHVBQXJSQjZDRUxDY0ZVNmxNWmNZMG5JaklnQ3pVdlArZ1JJZTYxRmh5?=
 =?utf-8?B?WnJIS0xTWDJlWU1aekdYOHB2bjFxU2hNZzE5azlBL0FYR210UVA2NzRNWGtW?=
 =?utf-8?B?YTRudEU0R3NwSHREd05jeE53azJuaFRiamw4cnFkWlZqVVdmNDFtUDZWditk?=
 =?utf-8?B?U1ptMnp6U2xZMnQzblVNYmhJZnRCa2UyYmxOeWNxZnJxOCtGSmVNeFBFUlZJ?=
 =?utf-8?Q?V/ZmfgoPg6IQpG8o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DOJ67yR0qQ9eygq8NeGjZdZgplSyY+HvxmTmN9ieLbBIHGh8wLqJ4tpQWNh+PDdsc2aeG+zbsA0VKEwiM0dgsm/4xOtpR75PnCVH4EmyKR1cmF/EpOfAnhrnGO7ETA67nlQVz/BJwx+mUBPMrskE4jmMNq1OfvghyQIDGvlxOUTta/2xpVee9L2rUmDRpN1zBpQhDOZhKYrGFVXH3Ig0tR+G43CXm8+M9oAVMZb8Dphkn05QE6WOtdrGWgyBRJ+sebkTNu1O9GsrrizrX0FjC7HhNDgy2B9watnPO4asqGtNMgRFooTd0eHg5pTfEaQrzA5GxtNsUGhGk22BRQaEGfB/ODXDMPcx6CYUrpSfni3NVmizQsRbt6z8mBnyqMIt00l60bJu8b7uVv2YM8axG96RY+SEFBRTbCqbD8DwqTDOorNSQfB67ri7zgh22esGucw0I10AOI7lO/BpPGt2ciTXB4OfyHgHlw8DYCeBKEQCWiQSeC0Yb/1MeDLljttO01zBbJHxNdLZtK6OYXDeLlSP6q5Hyk7oFh/8lTEQu2pO76xJsPNcxH4UoILzsgi2yZ7Ad/abGf7Ohwugp1WXyBdgeufhv7DtgcFbfpBWPxw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7156bbcc-537e-4e76-9d06-08de5cbfb0f4
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 09:45:51.1225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+kbeDffiGwcX2bQB55KgOKrbxOvRuofJxT5wmKjuXyyf03QWJEEBXb16xa2Dc87x4LIYLK4K8VLmYU0A6Cpm+kD6nb9pMxm/x2Q14+uzJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7578
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=719 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDA4MyBTYWx0ZWRfX5Vunfyx2NF7r
 bby+pI46rtiyn1pyMONqinm+pA8Ye2o5puV/VO8aFWubLy+TsnbEGuJS91+1gbzOjwx0maqB/cl
 sr06vRm6fEF2sVIv1Jm9iXbUR7FmYPhKr9AoVRidN8xJ7vErllC2jWFXBOwn2TUbhFh/o/IzSAc
 sb5XZUohebpyzgP8gJhqaA3bk7xwg4b1CDoGbPrFsvH49sZ5pQgHLg98EzQwvK+kUUJXJ0E/ZPG
 2lVNI2yZ/FouVGahMqoHc1NRs+dINUhbgQDp181Mx7rcyLL2d0l0r4FDQzqJNyYeVjzcSjfWGqs
 BlQxetPWkUx+rWPDBfoUWK8nB0RYBulRLx9J4N0eYYXmkdV5Pb7F3Rq+N9PY6DNS2kkV5q/meWc
 STbhr0VgO8VZ/6c9Nw+raut8WRYrNqREhQW84qu0dp0DxkSr5SXYNmPLDaeq3c+Y5qpeFAbV8q3
 n7+cHpoKG04S312vBs/OHFU/YhAIIEuftfY2UsMA=
X-Authority-Analysis: v=2.4 cv=C+XkCAP+ c=1 sm=1 tr=0 ts=697737d2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=dyeUQ3SXnc4yCxFXxaEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-GUID: Vf-3pz4lspjxVyLdWhS45BLC2gQ6pER0
X-Proofpoint-ORIG-GUID: Vf-3pz4lspjxVyLdWhS45BLC2gQ6pER0
X-Rspamd-Queue-Id: 6D860140008
X-Stat-Signature: 9inqj5hujxhpxipae8ptnfmgiozkznib
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769420766-771396
X-HE-Meta: U2FsdGVkX19ZEp+mnmR4mNSY9cq9+nL8IeQon6WBycJdGboy1uDXaGcplBV1FohYWHHIOEEGMius7gAxxvTom7pQm9Jv4bcFg+COpowVmZ2PUbk4NPTTXnqdapoXeAsm+EE+BJQECGx4K08Mrwm3DDmYMNmLDCQfPtWrBPJvU9angobG+fd42qqE2U2mGRpWYsJ2c6GKhU+vsekr331XbCeIUZl/K4IsYT3MpjpwkosHVLbqVmEmOcr7JfzrlbqReZz44vtdb4zVP0ksN7NdxaT99yT0h/9uJd+Pzl+HgcGDEGrhWMLY9Qlt+beHtclAqJ/z3wHqTlPKESGJrkGzz4bpSHC4tENeLPN/tno85D3w5csbCz5mZ5E+0z6xI8eQInEoyyNbJI4t5Jr6rvcUAQOy7aGPK+StnnGlK/YLG2bywlJ5UUz7Lm6Ut1eRRo3kb5E4KoTiDxXEIZlmSyw7d8+TotheXrXJSMfxIpAbuCbbh9LXuZmOpIG4RIPmOkPFO7bnnBBVCJ9apluAchgCBoWqf/howqSzgYiwh2Zv9QYJHqsnHhr7yxyR/MQDgEm7rqkEYiFxE08aWKCW6R6B02BHF2Q+5MYgpxWtlhLIIpHtMvqyoFkC/v/D0p4LMfXDGQ5wOpDfVN6UIieQKOsMJmwWV8f/SdbM3yVtD4SsMnIK6GaIxWX3lsi14yQruhQN9H5iZ3cQyVnFUMi90G3hjm+skoctZCYmsKOpecynICkM1lo2yWEhXAdHBayDM4E/d7NDU/kzH4vwj6W2x12QgRnLhRrJyHxZOZm7eJ6pdAx+UkICQtgOFLZOACx1C/6Y8TaAFcC6fHRMfUO394kMykrkLTyDFdily40zZcsvQvRo0H+0p5/BEb1pNXtvt+aSa0I/zG1K9KfwS9qZB+eJXM26GIO3hOmuw3ZANdkv0L4oRO4/HX90t2Cdio4mlCyObeTdhWzD+gPeXqJW/Re
 i5UlzNOy
 1Dgd70TG5McPhYN08Rhl0osEoY/h8AWcJ02pbNGxQ5pOabrFAtBI87B54er17M2Hp7md0RNCBzkfCxsyPLTI/lpko1jOLt+My7uUpq4AaPCiL+CGj0WFD9mAy6xV+8p4eTDkhUWIPS8I5UOeQT8e3/0pDzHf228yNyAg5+3SuK4HfyP4MhNgrWoiPdLRnh63K/e3NlmibqbDEE30RhTTNG9dPbfRRoplmmZz0OkV95OhEZTPLJDbL0k+D2WyeYkoK3fmVUz6Bw7xInqMr3ACqVdLrE4KIp8Sabe+Aa/dwsXy5E7jWE59iFNAMCInq8/uouVR9Ov7m8NqxX3XvgigSxNXVX5FUUCtpP0VfuhkgJIE7wRnaRiIKuxkHtmrvZN1m1Kyk+4s60Y6KXWWR7EQqQXfuAhHUxDKKEp6pxt8xtCA+V12DE0Lr/wWCcqbXK1/efgN7mn8mtCMF5McBhnGUdChFVUTmkN4WkdZTY2Sxi+T4u2n6NfdpxBmeNEFhui13Yu1AGrcMZUrvTwh/cbz62SIuaXbrv5fx2Uv+ACPVHuEv0i1N9RV65/lbavmwzAPrN+5fOL77luKRENUWG/jKIoQml7UGEAIXJrth+ZfKscwNdScvBVoXYk3gsxGgH5CAegT5dahNsU8FI7u9BcMEJe2KMcYpKyF+nyqHVMN8/DcOLdQ/dhst6r2a1bbraKOFc5R5VSsUTTxuhL/Hkra2gX/iVFReokdH4JmMYrNzw30iZqjKZlDOnMMKlKtP/q6YnH2KOqDsE5l4a7MZajuanaDpl9OMkiQ8DMqa8/5s1JSW7Diksq1j9C9C+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 09:47:38PM -0800, Suren Baghdasaryan wrote:
> On Fri, Jan 23, 2026 at 12:12 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > These functions are very confusing indeed. 'Entering' a lock could be
> > interpreted as acquiring it, but this is not what these functions are
> > interacting with.
> >
> > Equally they don't indicate at all what kind of lock we are 'entering' or
> > 'exiting'. Finally they are misleading as we invoke these functions when we
> > already hold a write lock to detach a VMA.
> >
> > These functions are explicitly simply 'entering' and 'exiting' a state in
> > which we hold the EXCLUSIVE lock in order that we can either mark the VMA
> > as being write-locked, or mark the VMA detached.
> >
> > Rename the functions accordingly, and also update
> > __vma_end_exclude_readers() to return detached state with a __must_check
> > directive, as it is simply clumsy to pass an output pointer here to
> > detached state and inconsistent vs. __vma_start_exclude_readers().
> >
> > Finally, remove the unnecessary 'inline' directives.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

