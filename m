Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4760AFCC9A8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 02:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF0C6B0088; Mon,  9 Mar 2026 22:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0D16B0089; Mon,  9 Mar 2026 22:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8986B008A; Mon,  9 Mar 2026 22:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 565396B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 22:04:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A82D1A03FD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:04:47 +0000 (UTC)
X-FDA: 84528509814.27.516980C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id A32CB40007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:04:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rcV4xtBA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GQmgzqkH;
	spf=pass (imf04.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773108283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwIfshUOJJLAQ5ssFiX+zkIHPXQQ+O6L5uUvlA0yfGw=;
	b=dKKMOnVyd/qwKOFezbREsxIxMK7rFY/OXpTP/+u0jcmNRqlg21SpY13ve0P5A3mo+aSeyy
	az89bKE4kFv7VOT3m9xKq6N6BSUU7YbcGdyOHtEvxgiRiIMrMbgIEw7FkZ7WajnDAUkjAf
	ky3/dlUOqRzY9MLTBM0vrO8U5nDGjCk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rcV4xtBA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GQmgzqkH;
	spf=pass (imf04.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773108283; a=rsa-sha256;
	cv=pass;
	b=RyOeyMDJFUde48qSd8uvhNVzhVfW0yto4A1358XHDv+Me7SFF/4RIXkwehzHv9UWsN4A6v
	r3jf+5i2r0WeEZ7yNiYzwjNK4sjqpZmnAy1kRxt7/2SGCv5YBpdUwJSpkU8QcxZUVmKJk+
	KW9lpL4zkIVbCA+leWf2OAAruPtc6/o=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629IMjHP1627724;
	Tue, 10 Mar 2026 02:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wwIfshUOJJLAQ5ssFiX+zkIHPXQQ+O6L5uUvlA0yfGw=; b=
	rcV4xtBA0/FnBTIkYDS8TEskjaI0VgmPo5/NwAOFwQNpB5tg6s1640g4YrFnF1JW
	SDCfEE0GC25Mfy/4olAOc4xAb0/X8h+gRf7Jlk1r0cm+2aO4Oses/h2A9d7cYqAg
	KUC538V2EM9y4K6BDRWVYRmM1r+OiYpkg+Dd0xNdUBkfFsPZ+Dfs83Ns2IzRAWSX
	6A+do8da/5APw+6T3ORFqOxGcCSdvhAdD6DjujRckT7YGeR3hq0MLPfsxmQAegTp
	N4vkjBNxkwqMzkY/coyrqWu/LryQRxHYq2liEw4e0LdqPJRStFLL72EzjFFjeoY0
	w5/OFrvOoIWPGoRvbr5XNQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmps21x2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 02:04:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 629NMcOl012887;
	Tue, 10 Mar 2026 02:04:35 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010018.outbound.protection.outlook.com [52.101.61.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafe0s65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 02:04:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tuar9/x6Ia6GTAOTxYFdqFaqdH8zII4O0rBjZ1YFC98Nw0jg11CrAMK/HTbkcaHNVumRaZVD2vKjeGZA8Ap9PXkmkZ2lgYA4vKV6hkEehqyEUwAKuzDZR5YVx5W9lMXjFZr+A9jp/gGZ/m9e90nla4t28QMTjr15X6uaT0RNbJqsQGGSEqNKwssxKfAZo14cOoNgptVSS+lk49EVB7t63ZtPej2ahhn3yBiHxiJJRVmGKztlkRtHXGe+cYamVLWWiQxx2PjHK1rRoKD5m+lMqrNxxQfMAvZyfCpNAg9R0LUwJZO/vEn25t7DJZt7AmSqZ7DCHcT6hE7NpUsvpLJDWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwIfshUOJJLAQ5ssFiX+zkIHPXQQ+O6L5uUvlA0yfGw=;
 b=QpBHmDxFhycG5OMyl2urIZYohFGojxOQwpr9YO5due//FIhYhaZzYGn7w5e9nIBK3KpsyAtVNdBzRjChJz2AnrlU7cV2KvRgqBLmMhY8XFUQqtqUhym2rd4UirUoPa57aqUcceSe8gdqU/FxqP0ydB9VgriieN6MIl7PLITeJaWT5V0Jy1lDIV94sfmGF9sIzNWMn5vdtrA1r01/6pSIsS9Q27DDJGfRQtnSpptp6aMV3i+6LnA+pSFi3kgkLucEHyplEh7uA9FCJ6LR7lna9r8B9F+y0G0/S1bD2Fdele2AbVjnN86zlpBXO11XXX3G6ma7T4laqfr3oiyiipXn/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwIfshUOJJLAQ5ssFiX+zkIHPXQQ+O6L5uUvlA0yfGw=;
 b=GQmgzqkHRHJzDSKZxhq1sab7FSHU4zBh7wIV5p6ENqYjWFaF0ZyWVPaG27LdbS3/s1GtUwM76VOiCC8wURwgOTUDSD2TRcWS9TtdJfli3og/X7LF6oMfD76XuKcUVP/C1tJF1X3nzu/M/4Df03wpkg+5oN33pDcLovp1jlwupXw=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.22; Tue, 10 Mar
 2026 02:04:32 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9678.017; Tue, 10 Mar 2026
 02:04:32 +0000
Message-ID: <7c4a45c3-298a-4a72-b551-ec687898b4f3@oracle.com>
Date: Mon, 9 Mar 2026 19:04:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prevent droppable mappings from being locked
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com
References: <20260306204550.8405-1-anthony.yznaga@oracle.com>
 <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:930:10::26) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|CH0PR10MB4907:EE_
X-MS-Office365-Filtering-Correlation-Id: 837badf8-9b6d-4180-a0ba-08de7e495edc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	07ZuETtN5nJKud07p3gbUu6Z0Cam0Xkr/KSM+0FkDlbovcnanDQl7MCt6u+M5EX3IzM+PgYCV3cOwUxPPnWupk6YKEuTuNFDsEIRU7jY+6LIrlBVLN5mnLQlsQQwFH5S6+777yQl8RU2PyfUy5BoSviFrwVxT9qbSS0loGJVafr4GAmaHQRowaOQz4rtHApkWYP3PJVilyQSdZzMMQGVmf20h8BxbdEHXp1PVtjskZG0IMIx/8xIHfw40Nz9NRRd7dzoiHkSzOH1B5E89dklV/4V7Qy85sTHIq84CZiSJXwgfIRToZMDRFFrzJ6pRlQBQXKKReozNm86QgkwIvqz/lsfODL1uZa1h/jgzvfWQaqrHAK1V5mYWhUPdSJQgfsX7+vszRophW1ejWivaBwqFPVGvWWhr77B5wXQF78bgD96I0fuihuPZi5llvam+G4O6vJqti4J4rdr6MBwgpulb9yBjQDt6qjheh108riLX79d9qwB+AQXmp/PDjMuWuIIkOy5HkpNihbv6VqmEFhIzpXybyWUucWax286gRaPZ4TnYiQKcyE6sWIlFpwAkitap8p3+DOpihC1bUvy7OUpAXOVSAYrIPL2bPz+kTinInwzmv05snq5DfxcuagriUP24FWTLNbxH3CnhGtbHs014ZH4bhghBtz+yI3XpBv6BFZyqHLywOeM72fSHmaDlwoHV1SRWWwWl0IYPKkZRERZ1Ta54jfFbpbcEFq9uFfM6no=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1JHa3crYllEa1duT2g1NStYTjRDeTIvSUhoeXc4cGNKZ2ExbkpBVFg0YzNy?=
 =?utf-8?B?OWx2UERWb2RscUNtWG5CQitPSXJXYTE1QXlra2FkZGNXSHFBR1VoMnllZFlW?=
 =?utf-8?B?WHVDdUw5YXhwRXByemQ4dlBIQk5pb2FZOHlZUElKR3NxZmIweDQ5amkvQ0lp?=
 =?utf-8?B?MnV2NzBreUlvQlcwYlNML0kxZzlGbWRVZG9HaFE3TjFaMjJYT3JQOEwzSmpP?=
 =?utf-8?B?L1VoYjg3eWRNb3RpUTZwM2NVYmNVT2RIbFNTQ3NDaU1QR2c4UDU1M1J0R3R2?=
 =?utf-8?B?bWk4Z2h2Sks2eUlxcm5YdHQxajdFQzVFOWtETHBaOUp2c3ZPck42NWk5SDBG?=
 =?utf-8?B?d3EwbGp0ZzJxck1PN05zUCtyZVQvSVJ4RGFaK3VLc05UR2hCOW5ucWpBVWRT?=
 =?utf-8?B?bE1oSks1dHYvdy9GemhZN1BQWC82dDd4RkRSVlRTTTJlRFpFNG9udjFvSVpF?=
 =?utf-8?B?WHpYU3IwOTh4c2dhWEJtcXJtS2x1K1pQSW92ODI1b0NjUXk3TzhRUlRWakpU?=
 =?utf-8?B?cDY4ak9QR3pHdkZIWDE1RVJOSjFxSWhHSTIyc1JjdEx4RUtEMVdBVDJhZHpT?=
 =?utf-8?B?VVFIVkdEaDhpME1CVjVnU0ZLMWdRc202NUFXblhkL1lrRmRJZjA2SS9Gb2Y1?=
 =?utf-8?B?UEF0OUVkRVpmZzNoNmpTWmU1Vy9GTCs5L3dNSGRSeTl0NjFBeEtqMkpmRldj?=
 =?utf-8?B?bWp4cFlUWnZrYzBVVE1TYzNhbnpvT1M1bm1pZjU5aEJHaWh3cytrQjlPcmZx?=
 =?utf-8?B?WDJOY3F1M0tIMml1VWFIZTRlNW41T3JyUHFQc1lickFlQ1h5d3FGOW56VEl2?=
 =?utf-8?B?V3JaOXFRTTNwMmEySm16QjZOZW43T2RNencyak5RYTVKTFRlRGRvU1hld3VZ?=
 =?utf-8?B?aDNpdXpqMHo4UGt0NHF0Sm5mQmhDbS9UZ0JnWVpkZ3Vtb2hEZjllQkhYaVBk?=
 =?utf-8?B?djJTVllUcHFUbnUvcUgxVlNSMlZSNHdTUStsSXFyRlVZWUxvSlBRY1E4Vno5?=
 =?utf-8?B?T2VMWk9HUWxmTHVLdlBIaWdmQndYdXgvbThzcTVMRWxMNFFIcmVaUkpnQVJ6?=
 =?utf-8?B?TWhJczNjMkpEVzIzNThrL21Ib2Z6V3B3QjNUMUNMOENBQlJwL2RGbFlMLzZ2?=
 =?utf-8?B?eGNzYjFYaU4xbkprbVZKSFhVUk5TVm53c01Db2JwMFZIeHcwckxxVTlWLzht?=
 =?utf-8?B?WWdSL0IzbktWNTZnL0tBNUFzU0RjYUdQRnVMUFJnUnArTGh1bGtyYTVsYXAv?=
 =?utf-8?B?Q0lNenNmZlVCM08yMTBYSkd5dTBNTjZZcjcwVk1MT2UyQ0pOM09PbzZLQjlX?=
 =?utf-8?B?TFY0TXVpV09sRE5TRjh1TWlXZ2RiOXpTZ0t2VmY0d3pRdjcrMEJJd2tMREpV?=
 =?utf-8?B?VGh0TkNmZGNocmQ3bW5MeWcxaG9NSlltQ1pWMlQxbmg0elFtNTZrRGNxYUlt?=
 =?utf-8?B?Rk43U2R2dW5PRnFjckE4L1AvREhDT1BYTlRiZWFOS2I2b3NGWGFWNXF6Qks0?=
 =?utf-8?B?ek84SEVPdG5UeEx5OUR6bDI2Z0pwbTd0M0VTSlFrVWhiS0JVUTZTQ29Vb1Vh?=
 =?utf-8?B?alRmQ2htRi9pemllR3NnUkpuLzdjOVRHZ0NaTGNTY2JRVHFaZmg5ek45Q0J6?=
 =?utf-8?B?WEl1cmRMbndsY1ErQU14WFlwQmZtL1pxTCtVb0MyNlJ1UGhkRmhtWnhkUFdX?=
 =?utf-8?B?cnRzKzJJQ1YwU2tKNTFLTHdvMlFFTE9nQzlDWGZ4QlVoR1VwRmlVMzJkQUc5?=
 =?utf-8?B?MHFDd1A5ZFhDVVlQbUQ3S05LMFl5dXdkc3B6WUVsU2orZnJJQzR0VEpLdmdl?=
 =?utf-8?B?aFlwZnd4RUFuSXdtM2ZIRTNBcGJXRStwdTE4YjY4QkdieTJDZ2dWaW5MOTg3?=
 =?utf-8?B?TWgxQ2J1RHYyQ1ZiTkZ5enpKN2RwOUVqc2xXRzRnSlBUYmpxdWllZXBZK2g4?=
 =?utf-8?B?T3grNjlScE5ReXB1WnJ1RFhpWFpBbWVJRUpHQkdHc2VObDk3OCtTMDFKSzM2?=
 =?utf-8?B?TExabEw3OXJyKzZQVkYxVkIwUmR3WlZjY25EdnRIMitlSFdYMXVlSUpFTmdp?=
 =?utf-8?B?MEVlSGZpKzA2TWFuL3dhRG9XMjYvUjRSNmRsOTdteDlxOU1HMVRVclJmd0Fi?=
 =?utf-8?B?eXMzSTJXTEFrVWxDUWd3MXpZZGVzT1JZV1Q3WFM2cktGZWZvRUI5bUswRWVn?=
 =?utf-8?B?cVo1SlJqdWpyQ1BvT1VTVnoxamdTL2FIS0JobllFdE1iczd5WUhBWkpxNXE3?=
 =?utf-8?B?eVowZjA4SkIzZ3dBZDJMVlkrSDZNYjJzeHdTK1hvK2RySVoreWxtU1VZTnN1?=
 =?utf-8?B?b04xbGxwV0E5bWFCRXRTOXhORlA3MDJ3THZYVVpkSzdxK2hEdk9wOUJkZG0r?=
 =?utf-8?Q?Zn776XfnzkRBN3qU=3D?=
X-Exchange-RoutingPolicyChecked:
	qug+HMFqAt7079Bckjt2S8Cs8d5VtMNAZk1wrY2V5iOxhnFZzDFDJ7Z61L7NjkO/s/GyNddCYkbQEPzPRRAdMP7kWi9fzTR9P6gW3fIOhI3i6UnisJ4yRtIyaaTnG0zRXXSo3dPah7iFoS7NNshfOypD/rizuCYwxgs0yiq1iK5U5e4smQkPu1DVZozRJQNH/E/1FXfQRNGjuyTBGLdzAportf3jEgAO9MK2gcNBkXZWQBukpTN4RaneZSqluTPU6jnBhmW6jq87ffeCqzan8b1cm0UlXudn9QSoBmkflNy0mCR108xbOUMjIQq0ziD6JC12ao4LcPTi11GXQ6OCag==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4a6gyInEu/RFxcr/gpNOAuec20/fqdX0fPSaCUfZ+q9N+PMq+UrixZ3tg0qr4JUpCZWLepNH2QnhtB3LauI7E1OZoFdcsB1yrU3FLe4VonSm4U0UgkYehxESnee3yObTFnlvyUTRVZUsYnVO5JTX4wGAC2xcPfhlYvtH5I95tWqzpUCfynDZ0LzY2e/t445bKB4HxAMENn/OohnClaUBKI60BRXbmGQ8g6qz/YXojRdfC2DfA4WOU/Hc5H5r73jHZelyZM/Rqa5Hv2K7J8T3r9sfV3fZvuE5jF7sC3ylLhH4c2JRgxi/e04qBU83njT30jblqrq247dWGU8M1rnkVMzUsVkDOuWeQUsFlMs1rWoHMYfNYd/z0cWHT01Tmkgie8/rOrhDZXX0wvvD4/pgM2UYsrbIXwCegr04UAxE/DzfNTsGR85MYHQ+D3DjDkUfZaECx4BhfVorllmNvhlJrx/guy2R0MOxAM89T1LS7acJkE2cebyuEGZI+13iCdBy+oxflWo4uEsT6hQdwei3aZAdRayPi8yr5aISSzszt2DGHgK3/vAb1lHXIFnmMKaka3Yd1X858mVrpWNrKLDjIkrHCdsz3NJdT7ibJ7fBjq4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 837badf8-9b6d-4180-a0ba-08de7e495edc
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 02:04:32.4550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IsfVt7KxyV62FP725yInR8p/ggMfyW3IbvAaNySsyg7w13jEudFOR4M6lWHspd5amjk0/JWpF7q+a9SocfExU4W484u+/ThMleYv5UWhDkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100014
X-Authority-Analysis: v=2.4 cv=IJQPywvG c=1 sm=1 tr=0 ts=69af7c35 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8
 a=Nhchd_dL6qP2J0vsR8YA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13819
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDAxNCBTYWx0ZWRfX8QPIFjdRd34B
 3S5RRLQ8MIzp0MOX6G56TosgcXgm71nqgztYF3yV1YPYKzYzZgar0zsM7yaso8+L5HWAxzwkZK2
 a+2FxfhtYLaXaqI0DHtw1Pa+8eb55FIX1nKWlh8EyaOOTNcz/u4DHwcdUhVVzHH1bvDqbUEP2H1
 HeTv9ZyCkdhJVDY3SxJsqi6eNC+UA/1mGpIhLa3mLHoymCFcqAfwRvJ+TJ/r6xpCgfP5OU5DXyD
 ZJTKFbiNRzbxJWFyyvbJEUcpncogpt2KGZd/b7MpxyzSRcPJEls4K6qKcJhBiiftoSnkZ1uRKrx
 Xt0QV2/STrNc8ZUOqOAWAd0Z/xZUStgM99uTHh+FqDHOlOtEkxGIZEO49Le74mEnnlU/rEyo+el
 u5x+UelRZ8XXkUJQ+7uutbPEKQcg6o3qMvKO9yN1zAi4VL3hihTjSJoUEwPLjWUyZTljC+PPhEU
 8pEC4ktJe+xI/ZHfU3R5jVBBTacK2g4v1nh4/NV4=
X-Proofpoint-GUID: LQYpGTfegp_ZdDgR6A3ZlpSdXAY05Y_V
X-Proofpoint-ORIG-GUID: LQYpGTfegp_ZdDgR6A3ZlpSdXAY05Y_V
X-Rspamd-Queue-Id: A32CB40007
X-Rspamd-Server: rspam07
X-Stat-Signature: 3zwsb5nbdguadw4wnbizkrw6ydra9daj
X-Rspam-User: 
X-HE-Tag: 1773108283-678300
X-HE-Meta: U2FsdGVkX18rEe/ti8uIGOL5TemIFmz1y7OeJ3Lpll6U3Z8U69oA5jy8UgR0j1BmHJIHGmezTHyQqsoDr+ilWkhBB+WnJ5ga1dunujiR/ULq29MmJ8bC+3H7/Lw15YLaxIFdnwaq3ZyHH/wy5Sen5UHCuHB42j8GK8U+e1EmWoUOGftQJf67U+gQRvO9tKAHJBWV84BbPOG7pP8SMxlECJ0Vn3T25IW+DNY4K+sQ6i1eQpCoL8NGbZTk/2bITMWBOBIUm6jWklX2YeX6SmfGOsq97x3wtlr8Ts5YIDsKvXf6/WQka0S1RPcuwU2D9/NxAOa/DByDXPdHH4if9cBlNG3Ydm3iTB9HgpwZnoKX2Kdt426GBgePfqG8HXA/aQ4hWrn6WJaoUpUpO3EeD+MeuTqnKOBzyHWrVfSDjpVCGpNmvAqTfHguoijFF0KN0TybZ3S11Y/nZk8Ra9Hp2kFXA0Iw1ow9ERWVLSJMHTKzohpBPuoUTELoJ2VH0xEzb9QOntuisuaqAU+9wZEAsd+6G/WTxzWnxeNbIuFFXAANKZ5o/X5UzStA/G3pqtDz/VY9gEhswZBgOHAGEejoyQzYbUid+ELVqPgfXPrY57ilmjUZsRDxFU+x3EKC+LjSxiyujr9r0LMpxQH2+Ss7N44AtqEJnfWseOF1PEEzyMjRCT6E4uASnZ41/3ETa1W1YO0IBKYXU1v99H+hGMp3Ei1CEqns2jPloncThJJrZmGmxC+iwgKW7ofrgqNIdF9KfWedO/TB9a0GOV+53qJpTUm6FY77y/6JFM7mRf/JOrRHY3Z5ZOqpgo4zsgaFmGXPkxafmd3oElI0hP9caI9IhjO9yxgkspEWeLm9fmkkXJp/0qtWXCdDnYQ3LeWNBX4RnTGNTRJq/GPX5pqoeoJXCWQChd4vL3JkzYye6aq/rnYuwRv7pYq9m/2/Ng5jVFJgMAhMEKKz2/5qAzFM4UiSpMi
 DtS2cdD6
 zPVas7ZErcPb0TAER+GYr3qszIxTUQjcghczaxuddHPY27RL9+7588o8gMnlF7q4JDe1xQ4fkq24QsZIMaSNTRHvzBBeCYbZ4BMAleqWUnkr1BX85WOOdVYww4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/9/26 7:15 AM, David Hildenbrand (Arm) wrote:
> On 3/6/26 21:45, Anthony Yznaga wrote:
>> Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
>> to the check in mlock_fixup(). However, they will be locked indirectly
>> if they are created after mlockall(MCL_FUTURE).
>>
>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>> ---
>>   include/linux/mm.h | 3 +++
>>   mm/mlock.c         | 4 ++--
>>   mm/vma.c           | 2 +-
>>   3 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 5be3d8a8f806..bb830574d112 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -574,6 +574,9 @@ enum {
>>   /* This mask represents all the VMA flag bits used by mlock */
>>   #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>>   
>> +/* This mask prevents VMAs from being mlock'd */
>> +#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
> Instead of adding that, could we cleanup further by doing something like the following?
>
> The usage of "vma->vm_mm" must be double checked,

This sent me down an interesting rabbit hole since gate_vma->vm_mm is 
initialized to NULL. I can't see how the gate VMA could ever be passed 
to mlock_fixup() or __mmap_complete() if it's not part of the VMA tree 
of an mm and is not mapped through mmap. There are a couple of other 
places in the kernel that assume the gate VMA may be encountered when 
iterating VMAs, too. Am I missing something? Happy to clean these up if 
it makes sense.

Anthony

>   and we'll have to take care of making
> the tools/testing/vma test happy.
>
> Not even compile tested, so will require some more work.
>
>
> diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
> index 593f5d4e108b..755281fab23d 100644
> --- a/include/linux/hugetlb_inline.h
> +++ b/include/linux/hugetlb_inline.h
> @@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
>   
>   #endif
>   
> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
> +static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
>   {
>   	return is_vm_hugetlb_flags(vma->vm_flags);
>   }
> diff --git a/mm/internal.h b/mm/internal.h
> index 6e1162e13289..b70ebbdafe00 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1242,6 +1242,15 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>   	}
>   	return fpin;
>   }
> +
> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
> +{
> +	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
> +		return false;
> +	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
> +		return false;
> +	return vma != get_gate_vma(vma->vm_mm);
> +}
>   #else /* !CONFIG_MMU */
>   static inline void unmap_mapping_folio(struct folio *folio) { }
>   static inline void mlock_new_folio(struct folio *folio) { }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 1a92d16f3684..e16b2ea234f7 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -472,9 +472,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>   	int ret = 0;
>   	vm_flags_t oldflags = vma->vm_flags;
>   
> -	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
> -	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +	if (newflags == oldflags || !vma_supports_mlock(vma))
>   		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>   		goto out;
>   
> diff --git a/mm/vma.c b/mm/vma.c
> index e95fd5a5fe5c..b7055c264b5d 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
>   
>   	vm_stat_account(mm, vma->vm_flags, map->pglen);
>   	if (vm_flags & VM_LOCKED) {
> -		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
> -					is_vm_hugetlb_page(vma) ||
> -					vma == get_gate_vma(mm))
> +		if (!vma_supports_mlock(vma))
>   			vm_flags_clear(vma, VM_LOCKED_MASK);
>   		else
>   			mm->locked_vm += map->pglen;

