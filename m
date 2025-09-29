Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3737CAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 17:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31E798E0014; Mon, 29 Sep 2025 13:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF2F8E0002; Mon, 29 Sep 2025 13:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170688E0014; Mon, 29 Sep 2025 13:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 012088E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:34:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BF0511A1EF
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:34:56 +0000 (UTC)
X-FDA: 83942988192.10.D89DC0F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id EFD8A16000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:34:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YWjXr5oo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ie6yOWIg;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759167293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1gGex9q94xawiimMwU85eBrkVcAwwlGAbaPc0GxK2o=;
	b=rfhiWKLnkrFcSLaZO9TMzdf0mb8PEFyZqSYcO1bTwAbBk3H62vcdVekC8QmoWJIPTkvYk0
	CVYyom0S2EzeKo/kq+nZTHvRavlxN5LlKavluZZZIo9NEZS9J8B060y6xlRleyqzgBR+wg
	LsiCZ1rex1OXJBxIgIOJPTR+STSWAbE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759167293; a=rsa-sha256;
	cv=pass;
	b=n8qFGQb/fhEeAeQNjVxk68ndhi/LyYwVdyt8rONp0qu6GukMUVdxXYCd5YUHGu5Wnb0JZe
	em9/RoIMU6JKh0Bh1akmUEoq/G5JkHuz9C3Wk59Yqjw7lS2ho+wJRMBjueuOWmE7QKj4Xf
	f+zaNxcawGwxTrReY+WXH1lHbhsHdik=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YWjXr5oo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ie6yOWIg;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58THNRUi008053;
	Mon, 29 Sep 2025 17:29:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D1gGex9q94xawiimMwU85eBrkVcAwwlGAbaPc0GxK2o=; b=
	YWjXr5ooNjhTk6sPbFLOLQnPDhJ9fN23TDUJDphTnEDLExMQ/7JXAcq2AJNQMTOJ
	ektmyqoFrMxsIELXdOmTyfOHWZC8WXY7HGvWMPAsLJgMztky9CLYo3ixBhR8ih3h
	3szy0hSdBY1NHhz2KBc7LEJrDSc4Bto/tC+NVuXe9uevUz/MQ8U16WF6RJbEDHQa
	YusBSn7XIdmvNNuSb/rzQ1rWwIBYMIeZHUs46wPmilFj3p48RaXfIAl+L4neZQzO
	uyDYOTQJRWBmyNuNYYXECZcB2t+iD6QFweaQQW9koj3+wXe4FBnAAxofIKcUjGUv
	ZOd1zzfqrmLfXUHH80SR+Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49fwyj02bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 17:29:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TGDhsh036457;
	Mon, 29 Sep 2025 17:29:39 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c70gyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 17:29:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wgtDJXJmVwd9tC/aKh8lpDjZbujY2n+/oH7/f9+528K6KSusPdzldiR5a69NCWGaj6MyGWj1c8rIUltCmVu/FovhZuWerXYd6ZeBVAfVfGVtGHgsLDcLXrkhkznPsOtzcfaF6daw056h8LzH4pzUxnqgb7bg+f05/I8urMKraSXvDsxMxIzjZlHhjahLWJ41rrGthluQEcmV0b3VHm+Mmq7Fu6VmQ1g2aVlv6C6hIQ+D5x9pligP3rrZANAolABLKPjAKgSldtbFd9++eqDATJfQs4Fg+C4VFYgcklBVKjFn6lKwWWJ/HB0meQmXeRfTtCWPUg4wxRZjDCdO9qZLAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1gGex9q94xawiimMwU85eBrkVcAwwlGAbaPc0GxK2o=;
 b=U5DsmqSz6YRpsqLzLfr+KBvOe6nlPQASLlOecNfdL4yfDGmONiyXMSJj/JeXxl465bGhYy7OO7oWoV93lGLHXqQbZHtROV48UTUIO/crJpkwdytuTKQbUhXIo84ygqAaYnGAfDulgi+gI75nEnzJxqebVVucTL0dLIvbsWH88jhvjF7S+Gv1EGLnb4q+d3ArfxdBcTKWMXE/r1O+COaSiZIjRFsf92KAqWOg7j1DWsFNIaW7eeOELLMg6urWlUmL2yjisGH74j0Fd3BTZGEf7Fh0RbBGKbRhNKOzqd4KkyjCuWNssKrTogBc9Dh/JMk1OUGdxk/pKYClL4X43pWyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1gGex9q94xawiimMwU85eBrkVcAwwlGAbaPc0GxK2o=;
 b=ie6yOWIg0TbEenOCMMpqEWpqVS3mRkmnwkx6/KKpLOCPjjhVaN/nfkir32RgxTPTVQU24tK9IToKaQepPDsnV7Od6U8ylw3Y5LT1egAZTR33XH+zphgKCyX2t6n1XxIsTqOJDM/bw19b2ow8z7/Blk/rI9L5a/H5pAi8JsDmmhU=
Received: from IA0PR10MB7369.namprd10.prod.outlook.com (2603:10b6:208:40e::14)
 by CO6PR10MB5585.namprd10.prod.outlook.com (2603:10b6:303:144::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Mon, 29 Sep
 2025 17:29:35 +0000
Received: from IA0PR10MB7369.namprd10.prod.outlook.com
 ([fe80::c047:e76c:2405:bac2]) by IA0PR10MB7369.namprd10.prod.outlook.com
 ([fe80::c047:e76c:2405:bac2%4]) with mapi id 15.20.9160.014; Mon, 29 Sep 2025
 17:29:35 +0000
Message-ID: <594350a0-f35d-472b-9261-96ce2715d402@oracle.com>
Date: Mon, 29 Sep 2025 10:29:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
        Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>,
        Luis Chamberlain
 <mcgrof@kernel.org>,
        syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
 <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0276.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::11) To IA0PR10MB7369.namprd10.prod.outlook.com
 (2603:10b6:208:40e::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7369:EE_|CO6PR10MB5585:EE_
X-MS-Office365-Filtering-Correlation-Id: b6d84eae-b477-401c-6a8e-08ddff7dc242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVJCL3Z2TDFKQ0pIYnorZFVydWZQWkoxMC8vdk1idkNVL2ExZHpub29YR0d0?=
 =?utf-8?B?a1BzMFV2YVlXbFhHaFdyNFRvc2Z5Z1pkSy9JU2Q0b253bWdWVnl2cG42M3Fy?=
 =?utf-8?B?T3JOTVZrL3pIalVKaitBcXYzczQvNkpndjFlR2xmVGZUYmkvK0hTeVF5dXly?=
 =?utf-8?B?ejZGQXVVRCs4ci9MdUhtVVlKUFlncVUxZlMzeTVZakdxa2hUOXp5TElCTURD?=
 =?utf-8?B?VllIenlMMWhVbyt3MUZReHM5YUYxUzBCdDMxOW91Y215T2VVcmMyaS9SREEz?=
 =?utf-8?B?akE3REdhZVR3UjB3Y1FPU0puaFdrUmN3QkxHL0xRejF6M0VuM3RjaTlOWEly?=
 =?utf-8?B?VDRTM3ZyeUZnakNWZUZTQ1BGZ1UvM2JTWlRWL3d6UGZFUC9jSXcyRHc2YjFi?=
 =?utf-8?B?SVB4NS9HWmdsY0JrTFZtK3Z4R2tEdlVKQ1krS05JdVNBNGl2UHQ3bFZDQ09l?=
 =?utf-8?B?Mm9Ub2xCcnFnWjN3V2g2M0taRTlmYTBqamZ3aUNMc2VvZTlScGRUbDRncmNp?=
 =?utf-8?B?VktKd21hZnBxd1pWeFowckpxL00xUFVvQ3lvcTVSb2MwcFN0U3lld0ZtNGo0?=
 =?utf-8?B?WHkrZGhSUjZEODN0Z2c4RlR1UTNCV1psdVBpVEdSYzZhYk16ZzEzc3kra0tC?=
 =?utf-8?B?ZmZDU29RWlgzNUFQeVpkNVlPUkduZ0xxV2tRK2lTcTVSWHFYdW96dVQ1eGZ3?=
 =?utf-8?B?WTU4dFFiVTg1NjNndE5jS1pGWTc4ekFYaThpNGNTMDdvL2JnS243a1NNWUZL?=
 =?utf-8?B?bTI2a3VCeUsyUTlmemdKZ05NNnFpQ1RpQ2RMeEpsQTVhaFFSQTJxTlQ5Titt?=
 =?utf-8?B?KzlYczlyVkxkdU1DbEZxQnRUR2paKzk5SmVnT24yVTNucGI1YUluWk85K21q?=
 =?utf-8?B?TjFyZ3BLSmppVDRLTDgyM09aZWNoWEVOOTArQnBwRWI1aE8zLy96QzVyOUZo?=
 =?utf-8?B?WTlzK0FHcWJOOWg3Y1ZUYy84dkJqUUlNb2hvVEVyS3dFK0tlcDBLMGRwSk1J?=
 =?utf-8?B?cjVoeWR6V0UyUFoySStQdkllVEFrdmloRlRnS2xMbmtvUlYyTUVBZ1BXTi8x?=
 =?utf-8?B?VGZzVWFlbmhRTXYycDdTNllzVkhXVmFoenB0dFE1NzVqZFRkTWdiS2tnemZY?=
 =?utf-8?B?K1A1d3FZM3lYUFZ0NlZPRDFXZWhQQWtBdDQ5RmJORFlmQndnQ1JnKzQxT0Nw?=
 =?utf-8?B?R3U0SmptNXBjaEJSdTVQWHVtLzVtUklZNThHWE5yVFNkYTNaZG8zYVcwRlI4?=
 =?utf-8?B?WENJR3YvQU1mN21reVcxYzF6TFhtcDZDdlpLekRPSVpCS2FFSmZJQ0R6dVZG?=
 =?utf-8?B?WFFXZ3ZQT1l6amZxQ2V0eUxMb2tSeTNwK3lqVU5GdVpsaHUyd3NkVzJnUG1l?=
 =?utf-8?B?azNTdXVWYngza1pmQXJPb1RONTBnUTN4SHdOSGkzaUlDenV2MWdjc0NZbUdj?=
 =?utf-8?B?QU1BT0NXMFNLeVFTaXhCN1Iyc0xtOTQ0cWtBRUZNamZDcU9ZdXY3NnFJZDVm?=
 =?utf-8?B?SlRCekhQWlBLMEFMN3VoOUhURExaNW1PanJlcTlkc3ZnUk42bU9kQXlGTFJi?=
 =?utf-8?B?a1Q5RVRkeHdiSzZENERrNG5YUnBna1llV01rSmZGcGc1MzFyVGxJcEpLaE9v?=
 =?utf-8?B?djRxZXlFa0tJRHF5Z0EyOWhDZGdFRFdTaFNCM3psb0lTL1hiRWJIOEJnb0Z6?=
 =?utf-8?B?MFk2cUw2azMwZlA5dkRUR0lkN2lrRmwzN3hxTm9QZU9wVW1pWWdMNVE3NFlC?=
 =?utf-8?B?ODhhRncwaGZJbmd6ZHhrZWRkUnNrSUMxM1pnRTBZZnNLT0U0dmJZWWJ5WEVR?=
 =?utf-8?B?cG9uUlA0U1hNWHJSRGRManhQUjZGaEtWUVlUUjB3NnJibGQ2Wm9ZajFyb0xK?=
 =?utf-8?B?ZVZ6TXNRdHpDMDcrMTZTdkxldHNEN2YrYjN5M1p1UE93VVBCdHNmajR4VDNZ?=
 =?utf-8?Q?K9oFi17oLZJu3d1+Ft2ny2voH+lNYY0/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7369.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTFMWG9vKzdzU3FSaS9qTDYrc3dpUllBeDZQazYwSExhOXJ0Q3hmOGxpUUlY?=
 =?utf-8?B?d2IyYWVwazJCQXIwdUFIV1QxeFpQcWREWHpRSUFZQW5Ic002SjF6L1lZc2Yv?=
 =?utf-8?B?VGt6Qml3NmduWjVEejdCR2xEelBhdFVhcUp6T04vZngyNis1ckJ6LzNwSHdq?=
 =?utf-8?B?ZUtudmJYc3ZEY3UzMmgwVFE4Sm5YMGw0ZlZEcFVHRHNJbkFxdDQrK3JkRE03?=
 =?utf-8?B?cXRxOEZxa1VYMFJLSVNDbnpuT0ViQ09rc3h4NFIzTHVHRVI3YmcrdzJCUENY?=
 =?utf-8?B?QnNjRG1XWk9KdCtuUmJTSTBqSjVWUUVoeHUxN0xIUUpXWjNtR2M4UDd0aHoy?=
 =?utf-8?B?NHFUL1h3dkJpclhvQ09heDB6Tjh3eHgwTnNub3lEQWRaZ1QzTkI2Y0ZyUndT?=
 =?utf-8?B?Z0RJbG1mMDkxRXQ1cW1paFZoNmRPaHpHblAvMlJqWjg4UC9rUWJ6bVNRNVhh?=
 =?utf-8?B?aEQvYUlST2xNWnV0UnVUTTI3MVA0Skpvb0hKMkVUd1VWUG5JZ2M5VnlDejBl?=
 =?utf-8?B?NlZXNEVwUXNOd3V3cDlUakQwR1dLSGhJeFprZ1ZhdFoyUTBmUnpmQXBpN01J?=
 =?utf-8?B?NmVQOTRlRHFwU3R1UU9xRFVtWTNlaWMyWVl4WHk3NnNIdjZUVEREQjlpb1Aw?=
 =?utf-8?B?THBMMWp0R2xvVGR5YVRhS2I0Z0FvUklZWENaUVBBdEZ3TTZ2c2NWVG1uU0g0?=
 =?utf-8?B?TVJCUkVVZ3AydEF6NmkvSFIzYmUzRFN2R1FKaGtPZkhpemc3SnBQZzMyeHFT?=
 =?utf-8?B?eVZmdlV2bmsrSkp5OS85L0RXTndpZkpQMDh2Y2RIck83bXlXT21yNCs3V1Vw?=
 =?utf-8?B?dGhxZGVCVWtYUjVKVjd5aTZDalc5SnZXc0o1Wnk3VkxQYWVOeFd6ZTFiMkRK?=
 =?utf-8?B?N1dkMXRac3BsbDZDTE8wNjdkNktkSkhWdFM2NEVvRkdabCtlanRnWkpRWHds?=
 =?utf-8?B?M0NudVNrNjJLRmpVcysyOTJ5ZzFDZFQ3djlyN0ljeU9HRW53Z25OSjMzTlhr?=
 =?utf-8?B?Y0NDcFdRWitnY3ZIeWlRdktpdC80aUJEeGJXWTJnYk9JdDRFQTdkdlE0MktP?=
 =?utf-8?B?SGxhOXdlR1Z0NXRiUng5SFBUc252aml0dkdjanlIdWdHOUZzaFVQZW5pa09m?=
 =?utf-8?B?endxNHo3MUgvNUwyeGQ3QzNtYkllSWpvdUVpSzlJc04vWFlPMHRIc282OVZp?=
 =?utf-8?B?ZXowWDYvaW5IRUI1SkNMelpBY1RUa2lld0thU0hKOVhaSUFsdnhzUWZSUG01?=
 =?utf-8?B?N2Rwb3V6bkNqNGRMNndTeXFTSUpPanlFb1BkMzc1MDNrU2w2bzJiS1dybitR?=
 =?utf-8?B?U3dyTFpJTVpYSDlzemV3bmxBM3o2VFRBRmtMMTRoQTRiRnpISy9laFNJdmtM?=
 =?utf-8?B?a1lYVjFKVmMxdzlEMWV2R3BXckNIeE8ySHBiNkw0NG5ISU1SV2RXcTdXMGFM?=
 =?utf-8?B?TG4zV3RxTEtEUjZXd0JacC8xZ2FSbnRXWTJHbEo0Nk5aZzU4TGRlejcrQnNN?=
 =?utf-8?B?QjBVanNnNWZjNm9zN1lDSVZCVEJMcnlhMDJVQmZKMHd5NER4d2RMcmkwRE1o?=
 =?utf-8?B?bnpwMU9QbnlZR1RPR3hacXgyR0lVR2lKRVlZOUl5OWJVR0ZTdEN1KzZZaDNy?=
 =?utf-8?B?d3FWRnRrNU5qRkpWOUZ4bU9nTTVBODVUR1BVV2lMKzd4NHdIdGw5ekQ2eVRm?=
 =?utf-8?B?aXFjY0poRlNnejVhZGpKL1V2SFlPWW8vSmQxK0w4Nm5mZlZGaGFGWGVnb2Jk?=
 =?utf-8?B?TE52dUV5MElRNU85c3JTTmxHNXRiQ1N0UC9vTUo4Uk5GblRyZU1RUHNLeENI?=
 =?utf-8?B?UDIzUkJ5WmxuM09zZDljTVRTWlZHR0hvOERNakRsakdlQ2RMbW9yY1hCNEtS?=
 =?utf-8?B?VnFjZ3ZCbzRtcW5DNStpVGlNRUdmdGVWK2VaRWZnYm52VlFESGJZNXRWYVZD?=
 =?utf-8?B?RXVRejErLzR5ekUzNlphSnEzdXJyalNZcEZBdENKSHE5VWFDNlR4TEpibUlI?=
 =?utf-8?B?N0FFUXZDWWZrUVVMaVlNS3ZlWnlMU3U2bkZiQzdJc2JYeGRkb25ERE5VZVJX?=
 =?utf-8?B?TVU2YTAyVy9GZTBoa2F5SGFjdm1QUFBIMHZBdXlZUWlUVGpuNXVCNXA1Rm1k?=
 =?utf-8?Q?e8GNg22ibI1RFCH60zGjsbBjw?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XNBhl5qaaWedZZRHlWaSvxESQWWfZSI+9yyi9YLMPWsfY50/CcneLw+t4rzN+JKt5LuVG2ZKcnx6yb5qMXqnIEZKKoylnLI77K7usrNuK1wuEFOYhRvU03SUtiNwTTB8JVrrmCdaf2bW4sae5goB8hwzqq3jO5Vky/Jo+Y8d1xG5WoLECFV6smAq/99cm9fTH4FxJPNGxY5vjrrjXOVjVEC9fFg9ocukosWeFcQqSjspaeJhDz5wV+BnWRpDBlSCcY3SY5Ne4M9Elytvh3X15HsjLxxPXuL08Luo/TURGkaltRDkE9OzK4z9Ip5+39dCh35vwCZcMypDaG583GFJ2oD1ZfLPiBnMlM4hS3MA/BgNiVLACMkLrl0t35VsWnMMZOUoT1qyT0cxnVvNXCqZvdvHEM/KETUdGKINfqrfJ1Y2AyBB68nDrFYe+TMO135F3ph3ZFDzr3w+JTXLB2siHKtDwkhRhjwS+VN+WdOQ+v1i2Zh6k5Pt2rXcfDWorZe12+hLbJL2mUktJq9fG6fS6mxvg83F/Nfk8O+nhbEnMTrHJI5PommW/u+e7u4+2jJ0fSpAJHzLEjAvpZEGTM1HUcxGGoNS3PKwBWbra5KzmEo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d84eae-b477-401c-6a8e-08ddff7dc242
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7369.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 17:29:35.4103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trkTc+bDaUCRs4//X8nt7YMc7gd0hLFsBwu/ZVcrNH2wrBdu2w9ON/dYwuBaPD1kWaKY5lrAK3WzNFRdF9asOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5585
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_06,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509290162
X-Proofpoint-GUID: 33-dsQka4_cOsbAAkYdG_uS8UbZ0QBM2
X-Proofpoint-ORIG-GUID: 33-dsQka4_cOsbAAkYdG_uS8UbZ0QBM2
X-Authority-Analysis: v=2.4 cv=LewxKzfi c=1 sm=1 tr=0 ts=68dac204 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=FWFCUNoPiAk7VytedekA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE1NSBTYWx0ZWRfX5iR9IOdHoI/X
 eS9DItT8KKUaOMyPpvSWaO3kSAnGokojnIOf9c6W0XG6oFHYW+MmUt6jILI4JvP5UrC30GcEOZM
 ZyjuzS93D5PpxXi3a6eF+dJXeEOabON2DG51tFKoP/US2trWFDuu59HFp6ceP1ncBrBwOMH1GpS
 1WDFyDbjFQ5eKoJSqzW8Ax6pagQhMAcgRAJeqy9JDKwA/LlI0YI00fj/OWiVqbmxw0tkWpOfbAC
 OdGsnSLlDEIzJwucgRcjZLOCLL/hIKbVmGK/zA1bkWGK8aA+Ws46W2A67LLAUF+scHuGmH/wN3/
 YcJvSFlqr7TjtZgld8ljgDL5t5xrb1pOtvzAL7PD2Xg3CtW7rcTYsjum53NsH1WYZOuC6x7oRsc
 LvTrpqDMgJ7mpzGC98Y8Qq8mYl9/1A==
X-Stat-Signature: 5fb9ra3jnrxx99ibbqp4tcg9x6ynf9wf
X-Rspam-User: 
X-Rspamd-Queue-Id: EFD8A16000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1759167292-184734
X-HE-Meta: U2FsdGVkX1+m4xzfaK23BS51abr+90dt9InFv6hMG9bm/wWvcyHXzd7GiWSP5zfYYVWij3/zktj4LjVIs3XLB/eoJZ3/mQW/hbWUtqXzlxZmy+xgoTgzRHD9rXrBa11+n8nVayIOok+oY+CJcjbUX70AUTZLSj7kRokRiFpONipZ0Nlk3Plb0YWzT2+NKewEsbhNvpKuEglW/DeXteJ4gcnHiShXv5yH9GZkv0oGvO0XV9P/XRr8SSd504LprwMiBr+tkXESLuWtyQiag9ILAIeFBYI64MXIAgUmgwYWp1nZehw2W9jMFpblh2dTtSRGuGOcQVGQtwubAFZLJJ9JlM9FWGvqphoKoobMyKKFg6VBjEMZXDmlVtoUt9iu+9eybF6dPFSZYtUxH3b92tgO8dkELb6IvtPytjvrtjpr+XIeH/4YqjTAYTG89XVdU8eIUjiSOV0ZqMsfUqVkKJ6P95ep6mkJjxrSGph6o7u/eCpXKYM88zuNCmsqAwieo/9z4wForVKiS3yP97C/skK/z6zYqOnBeyvKx43zUKCnCl30fQes+jZHrQl+p59MrgFqD0dbKszylvspgefPCbrLAM+CxM+cCJFNbogrU5QS7547E1wSPByCg+EQfs5u4LF+V0zKXGCeF5Xjoeu5CneyFO2X/gWu188Tkod4JeH6mtyp7pbEIUPb86cjDhAOKQxuknLzHJM76rRQz0/pIASJDiErygIgKAuMGnGSPny5HSZ39RBXzAOexSKoVd9zrPoxs1LPBQLnqjJPQQ/OsWm7eA5e6RIXYn5NWDaoHRNDs3XuUpoHOYQvrFgO81mGDWY5y5pk+uEZ+ICxtGcm98ro4VgnxWRPwPWT2OuKsIfO8zsT/bCKX/6iHS8WLzlktC18ab7Y/DnaU6762bgghVyMVbm6mGnmT4B6XqcVFEr6gOzquaU2y1/qbM+gpMSJdwb4ynr5TLo1w8bgJadQG8K
 evFQsO3E
 f9vek7Cj9ojC55UZv0RmY/AgyiaWg48UGgmVtfZ50Uorgkcw2HIXk9hfqpcYkthlBN+Cb/eKXZnONEqPMeJ7uOB0Hs4CJKDPsHYXokUr7eUZc17ZSXEOiqlkcfx6031ETyhqEzwZhk2cpY3w205uKUjIQP8GgkNLrIMZOoueqjg6KHAn/jpdOCfRFJHQZdPnX25suGWwBE1aUlVbeQnrhaESYClxMskHp4NOmVFWK5e7J22ncqC9iKLkU485EjgH1lKGdAN6xLRz7QFK2rvhxhyWEl0TJoS6iz9eygVGmAHZXfl9Y5wkhjvh1RSDbpXrY+9MTD5Q6fh1fkvsJ4I9SZML65Hwdgx6tMf6DSjM1+iVAuSPn00jiMIpt4qZJgKMh/ocytqiJJP6eW+T9hZ/VRj9+AhcS6ckWWBJ8ItOXh7KIexiDM3CALyyw7m6Rqvwzyrp2XhnQTH426aUoMZrx/PXTmO12ranyg7nX89/Q+rbJm6eln8p5AV1xAqxJ1qoDHm4ZqrftrJKmMJc2K4/aI4FrpXtatoXFQXrOqPX7VwuHUQpsy0WH85x0+uQ5ZCiXT4wt0x6QdHvFisagudKYO8T+AEQjxxs8eM1A0Fb4YH6d/usTESPRI20IW+RryqT/1Wc8z86+BUPZVtsxoFeIP1RViH0BPh3fQb6g1uJ0v+/mB2Cf3dskxyYJYtYPiQYpZhCzGdDo6hSpysUGhD+E4UC3sWcP1cFAdk2LDrKf38/GU7z6A1nuoXnli7cg7HQpnkk4YtW/Oqi3P58uySfQH910ypIrO1lovLCPmQZPgbceVVpWrCyoOitL5PGf9qcu2MVZGn/IOk5TmkhQFBZh/3jMDjpOBqc8+nAz1omISxVZj3n+L/2z09f748wxQPsGd7H1sC6QxcQYw3Em6HujJVSPQze30s6RJwX5gDsmToT4TodK8rvjBmV4BjDeA6dhnts4mygUIzPoLjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/29/2025 4:08 AM, Pankaj Raghav (Samsung) wrote:
>>
>> I want to change all the split functions in huge_mm.h and provide
>> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_folio().
>>
>> Something like below:
>>
>> 1. no split function will change the given order;
>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
>> is smaller than mapping_min_folio_order().
>>
>> In this way, for an LBS folio that cannot be split to order 0, split
>> functions will return -EINVAL to tell caller that the folio cannot
>> be split. The caller is supposed to handle the split failure.
> 
> IIUC, we will remove warn on once but just return -EINVAL in __folio_split()
> function if new_order < min_order like this:
> ...
> 		min_order = mapping_min_folio_order(folio->mapping);
> 		if (new_order < min_order) {
> -			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
> -				     min_order);
> 			ret = -EINVAL;
> 			goto out;
> 		}
> ...

Then the user process will get a SIGBUS indicting the entire huge page 
at higher order -
                 folio_set_has_hwpoisoned(folio);
                 if (try_to_split_thp_page(p, false) < 0) {
                         res = -EHWPOISON;
                         kill_procs_now(p, pfn, flags, folio);
                         put_page(p);
                         action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
                         goto unlock_mutex;
                 }
                 VM_BUG_ON_PAGE(!page_count(p), p);
                 folio = page_folio(p);

the huge page is not usable any way, kind of similar to the hugetlb page 
situation: since the page cannot be splitted, the entire page is marked 
unusable.

How about keep the current huge page split code as is, but change the 
M-F code to recognize that in a successful splitting case, the poisoned 
page might just be in a lower folio order, and thus, deliver the SIGBUS ?

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a24806bb8e82..342c81edcdd9 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2291,7 +2291,9 @@ int memory_failure(unsigned long pfn, int flags)
                  * page is a valid handlable page.
                  */
                 folio_set_has_hwpoisoned(folio);
-               if (try_to_split_thp_page(p, false) < 0) {
+               ret = try_to_split_thp_page(p, false);
+               folio = page_folio(p);
+               if (ret < 0 || folio_test_large(folio)) {
                         res = -EHWPOISON;
                         kill_procs_now(p, pfn, flags, folio);
                         put_page(p);
@@ -2299,7 +2301,6 @@ int memory_failure(unsigned long pfn, int flags)
                         goto unlock_mutex;
                 }
                 VM_BUG_ON_PAGE(!page_count(p), p);
-               folio = page_folio(p);
         }

thanks,
-jane







