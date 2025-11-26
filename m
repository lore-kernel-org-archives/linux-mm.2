Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3701D1118F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030BE6B002A; Wed, 26 Nov 2025 13:12:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008196B00A2; Wed, 26 Nov 2025 13:12:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12326B00A3; Wed, 26 Nov 2025 13:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCD2A6B002A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:12:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 680BC5ABA9
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:12:10 +0000 (UTC)
X-FDA: 84153552420.09.62ABAE7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id E7C584000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:12:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iKmPumtd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DHgLU3DB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764180727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QsHEoYfuEbTiZ3nJFzumCPdThjHmBLHVDEz4j5WzTZc=;
	b=D7/8d4DR0XFMTpjtyRph0LQlMcE1QMAHrYRbsCAi/WpHTFycr0p0gmcyjdwhVNGGn9baT1
	PbZdpWfqbByVJc9aU4sl2kQBvG1mVmww33z362ihv042/u6UTA1BYCxdKJXH8oUM/zM/By
	1vCFdk5oG7S2zdFqKnupOB+Gk576Td8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764180727; a=rsa-sha256;
	cv=pass;
	b=s9P5qGXkWR3VXnRZsvepxnyvzaT5i1BbY9iNGc3Xy7fPINDk0RO6HnJlK7+3Xk/mUtds2i
	fB0W8rS8DK4Z04Or+7rv8I8vpyuQsVcTBQk7ARG/+G7w2qMO1U0rftBD72zpovEr6kp7Aa
	8dcBmGPZjtc+9es3XFQAOSN9YWPUc0U=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iKmPumtd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DHgLU3DB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQGHa5N2727555;
	Wed, 26 Nov 2025 18:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QsHEoYfuEbTiZ3nJFzumCPdThjHmBLHVDEz4j5WzTZc=; b=
	iKmPumtd+cvg9CVxosvMWlCjAaWZeDWR9zZVs6z1OAyOADyFTK7g/Z+Dtzqci4sT
	BvAtiMlzGfYaP8AbCgYvlyTPMsEn75hWkmmLb4H0FoG63MX+TycI4g0qsqNzm1XU
	63Ob5M3Byina2WwEBQKrCi9IUy3Uvzm5zlH327hw4RQAmA3ofb4q5M6CzBW6skDL
	jZrH0+qcBTD6nIYRV9yG2xD1PL9czaifdz5UTA8hhoXasmnMRCN70jgAEqSHloVB
	+OqKmfMGBFfT2D6pf075dflnjNS2yn1bVxj/+WZngYv8UZUxYfKYVfeJ7/fDxRXT
	91nIwIyuCy8WQOuSh9B2bA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7ycn30b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 18:11:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQGUpEG018939;
	Wed, 26 Nov 2025 18:11:59 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012064.outbound.protection.outlook.com [52.101.43.64])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbaf70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 18:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5PC8CKBET1/xwEllC477vAY/8hZsHPRaXNezRVrEX7xZFHZpDB9FVz19bt823YXelLqKpL6dA5da8nDsVz/9Hply2vNTTdDgXjjLxVgMvFK4GHhXosEKyn4mIwya2JC4gGfcHHkb+G1YsUFOg4Km+6hsWXkrFg1K6iZAArv73srDunyegxwzkLmeOv0JFUbbqUVxOJwbYgXdQxuEDbEBTKTzQW9Omm5SGxw+T/flVEtvvVt0WmkG7m3hlLvCCbvFFyI/FQkYMRxofJA9eiBYDekmp4AgBCzUlXMClhlck/gAgorDuSrEQnPBxLSAM8NjE+/027CvYVHtIJnC9ZR1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsHEoYfuEbTiZ3nJFzumCPdThjHmBLHVDEz4j5WzTZc=;
 b=H8s7TsuIhK0m8UNHZP2UICoNJ3QA1wmbHv3p2KmcHg22NgxHU80FeCbPy+IJupjFDfKHNvqiQXzZBla2qjWuDvjASle3pqxYZsRmtJy7VRNXPLxCI1areTXXqoZvzUgUBwoTT2Ws6m6te1SrLHXe9kX+wFT7/ev3IFqsbJnUOIua+dz3i8XMRssamkrpRUXLIiO2c6+WJ5oB7V182ZCQK6NsglEXkSw7cT7dNtGIdaX5bRwYxj3eC7sjXCE613nIpdCD7CaGkQHqvvRvj+4ka5+Xr2um7lFE1k4Aw5QOZhCxYfuvWBxcOeoKBkHelynBTNvAWNxRm4d5uZqosi4HgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsHEoYfuEbTiZ3nJFzumCPdThjHmBLHVDEz4j5WzTZc=;
 b=DHgLU3DBbRoiYSM4k81usbRlYYFzx1d62e79w2V6AqnBb91KzC9xv1c679t1NLLvNzq8b5ZGPVl+Zpe4Lwqp92VqXhGCb2sAmrqhG2Kd/aYsm9PSixMC1lZgGQIp70M1YhhhyPit+I4FmYM4p4ThnVGpDTZ5ALDI7wTXgEJB2XI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5947.namprd10.prod.outlook.com (2603:10b6:208:3d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 18:11:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 18:11:54 +0000
Date: Wed, 26 Nov 2025 18:11:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
Message-ID: <6ee4d9fe-7a65-4686-ad04-b80494b82122@lucifer.local>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
 <aScXSEY7v7_fcEZF@casper.infradead.org>
 <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
 <058f5858-f508-40f8-adfe-e5de78621d64@suse.cz>
 <a03aa1c8-b54a-4ac6-82f1-40a06dcd7150@lucifer.local>
 <CAJuCfpFMt6P2cjgb7xfWVz5fhgK67=TQod8HZfJknLYSvZ5EgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFMt6P2cjgb7xfWVz5fhgK67=TQod8HZfJknLYSvZ5EgA@mail.gmail.com>
X-ClientProxiedBy: LO6P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: 98dd10a5-4310-431e-d94e-08de2d1747dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjhaOGdiQmZESG5HT21ESVloc1J2cFdRWmlIQWRNdml5OEFsRGt3Mk40c0x6?=
 =?utf-8?B?UnRmNmk1REJmKzg4RWlRWHpVQ0dKVXZLTTNJL2E3eE5EMEUxRnRKRXdEVmZY?=
 =?utf-8?B?RUFQakt6VTJIaWM2REkyWUF6RmU2blM2bzI3R1VkVnBxbGhjT09LMWtqKzhu?=
 =?utf-8?B?KzBQdlFZdmVXQ3I4S2N4V3FJWlZ4S0tLQnBpWXFLSWxpamRudGpFWWZ3QTlC?=
 =?utf-8?B?TlNhbVpSb3RIY3RwT3lXdGRsbmM5OVp3OVJuNm5DQ1YrU1lSd0gxby9wTGVn?=
 =?utf-8?B?c2RBRzcrRnh6L2JvQ09jWTk3Y3N1RmZkTysrRW9vL1Z6Kzg2bzVWTnV3eFJU?=
 =?utf-8?B?U25VbDFKZWRRNUtDSkxlWVNHWHVzZEx6K25oWkRHeG9HOWljVXpMb3ZSTHVS?=
 =?utf-8?B?ZzlvT0FMMy9LVGxJSWRiQ25jVzVzVnVKNGNqM2pMN0JqYWpWQzVnb216eEVv?=
 =?utf-8?B?VTNXOHZCcGhBT1VpZ3F4YllHK2JyT3Vvc1BaRDJqZXROSHZ2b3BlNnl2MXVn?=
 =?utf-8?B?TnByNG1vblExRzdkdHJBM01XY3FBVDl3bEgwOEk2c2ZXWHhLVFpSMWw2eTlL?=
 =?utf-8?B?U0hFdjN4NnphaG81L1J1bEhRZXJ4YU1MMlY5SU40Z29nV3MwdVNLM0VQcHY2?=
 =?utf-8?B?YmlKTTBZSzd3WTlzMFVQRUxBbm1TaFRMeGJwd3FEOUxlTkdhZWl3WnlQY2Rh?=
 =?utf-8?B?L212WGJtTFhTdlBPaDluT0hLS3NhbGxQVFU4Y2x5ZFFpTElDcGJYZjVveFp4?=
 =?utf-8?B?Z2ZjRC83by9xREMrY3BmYnVnRDhqTHgvRjNmTUxvQ3lSYjFiMkVRK2xRaDhh?=
 =?utf-8?B?K1FXeG5JUFlNNW9OTVh5RHE4MWZGWWNibDVqSFhETjd1ekloL1pmOWNjL2kr?=
 =?utf-8?B?dktaL3BabHFEZVdsMk5QU1JPdldvakxJZHYvZllMaUdlSGtlSHk0WktWS2dP?=
 =?utf-8?B?WDJtem5LSndOMWw4czZRSEVDNTlzM2pDQ0NyYXIrYWdreHA2eGVqWC9VaTBr?=
 =?utf-8?B?NEtQQm5XMnd0Z1RxYTA2YTdTeHZtUFBMTm9kcXlpWjJuVlZYRmZEc2pNQ1Ns?=
 =?utf-8?B?dmdYcVBFSkpXVTRVVTVsYWp3Q2h0ZEJoVCtDVTFqVWFzWnp6c0JOS215c0Nm?=
 =?utf-8?B?YzMzY3JUL3NNZ1NuK3hjNzVra0VHcXBKQUlBT0wzVzVpaVZ6eEhUc21ObkJs?=
 =?utf-8?B?eStKTWFzVmxKWW5PUlRER25LZHBMUDUwQ3pjZmo4UHpEdDd3ZDRqQ2xjNTkx?=
 =?utf-8?B?QmxVK1JDeTBTSTZtVGwrSlpBeHE0Wjd0V0ZKWUJtbDNkc1h3Qk1CQkxzamg5?=
 =?utf-8?B?b0dCbFA1SENhbkMzdnFhcWhZV0xVYWdQRC9lUHBjY3h6R2RmR1pHd2Z3SXZU?=
 =?utf-8?B?ODNXbDRMaHp5Zm5oMDZYdnVtOUd2cWl2NlgxN1I0L0FNOC9EbUt3cDB2dHdm?=
 =?utf-8?B?NlRiQ1hreTJyRjZFRVNyRzhsd3dwb1doOUthVHhsTEMvc0l4ZU9sbDZYczhO?=
 =?utf-8?B?eXJaWFdWM0t3ZHBYaVUvUGVLOXNlLytmRG9zTFdjeWNySFF0L1BteVZoMGQ3?=
 =?utf-8?B?T1N4WmNCVS95bXpDb3RaWndKSVdQbFBuMUF4WEd1ZGZNNVo3Q01LeGY4K3dj?=
 =?utf-8?B?ZVVOR3luUGRUUjBRNnVwai80eC9kc1kwUFBEOWhHVHBNcmJlL1FHZmJJUDR2?=
 =?utf-8?B?UkFwellSNjd6UzErdHRwbHRMZWd0eFJGVzR4SlRVOWV4b09WMmZNUlJYbXBC?=
 =?utf-8?B?b3VKVHRYcXlwYUxvU1Z6ejk2NmV2R3JwZDMzYVgyWWZuSVMyay9aNzljb1hL?=
 =?utf-8?B?ZnFTNkV3ejVoV002T0wzUmVZMTJIczRpODBteXQ2SkowYWJFOGV5TTE4TlYx?=
 =?utf-8?B?WExVREl3YjEybngrWUNvYkI1V2pPUjd1YmdnU092WWdrcUFGU3VNTWFhSmh4?=
 =?utf-8?Q?R3wWzo04yOwsl7sTzWqJXxk45JMk43n9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZG1lRThHY01wUnlFTDA1S1VFUTVyRHlRTWdTbGdiRVRoQW1oME01TnNiRlJT?=
 =?utf-8?B?ZmF6djdKenFyWGt6ZTRnemJ4WXVzWVBWL2lOdmt5WS9MU0hBR1Z5VTRFTDY5?=
 =?utf-8?B?ZHhOdkpaZktXd2JjSkc2RDBsUC9qR3AzVXNpWHFoNUI5cTEycVJjZVNwV3Fi?=
 =?utf-8?B?Umk4cmljRHk0QzE3QVpodnV0T3V2R2NUNURLYWhYbFltL0V5R1JCb3hQeERr?=
 =?utf-8?B?aU00QzZWakkyQlVzNDZrdEs2aUorU1haYXp3L2xoblFqcHJKZXAwQXRGOTRE?=
 =?utf-8?B?bGd1VGd0bUdpcmsrOVhFeHh4d21nNEVsN1NBaEMwT3NyZS8xVmlXenBBM29P?=
 =?utf-8?B?OEVnOURPNUprS2F0Tkk0Uldlc0svWjNza0xWamhmVEhpZDN4bDIyVUpReER5?=
 =?utf-8?B?cDVjY1QvaTU1N1I4Qm05S1Q5ekhZb0g5ZlF1T0hNNmtuTDZPNU93VmUyUUxX?=
 =?utf-8?B?UDRjbGZXQmhGbjZlMUtKaVMzN3hrekhRU3NXMXpsa1MzZnlJbUZ3Nk8xZWtJ?=
 =?utf-8?B?MTFqWFVsM0Rhd0M3cmw3QkhrbXA2V0tSTWhFV3g4MktSTVJFTDJsVUpWWXJT?=
 =?utf-8?B?bXk3b25XaWJhalZZREQrMUR3NUt2TmdsalZiVk5rNG5ucnJ4ZUMveVF2cGV2?=
 =?utf-8?B?Yk5YdWtCS0hoOTAyY0ViM3V4QS80a0V1ZkQ4dTN5c2E5UmMyOW5WdGhhNzZT?=
 =?utf-8?B?NitKMWhYVGFUeWZNMTNoSTNUWDFwaW5XVFZwQnhIbS8yMGU0dnc5cEUwMDlY?=
 =?utf-8?B?T05QaFZ3TlpMNjFrbGZEVUVKL2c4ci9iUmhPamVOTGc0Vm1VWitBNUlrcmZZ?=
 =?utf-8?B?M3lZSW1Cb1Myei9PTGpBT0lzMVBCNlB0WGtUSkc3ZlV6ZXVJbFNtdmliaTFR?=
 =?utf-8?B?V0N0amZzVjByMEFBUmRUaDRsalpQNEUydFNSaCtkWVNCMUp0WTByckUwNHIw?=
 =?utf-8?B?UTY1a2Z4RGhQTXQySHFtcDRmNzd3N2Z1TmJtRkQvQTZwVzlDYnUvcWhwM2xs?=
 =?utf-8?B?dFJhSTRLTXVJZkVCSytJUTNrc0dpRmZpdDYrbGQrQkdLdUM4dEhqWlk5b3pi?=
 =?utf-8?B?S1pRTjN5WGxMbVVvWjFrSG9DQXl1dVNHTWZLcmpYOXNsR3p0S2kzZFZNWnFu?=
 =?utf-8?B?cERONkk1dnU2UDNxRU5wZktmOTFEVXpERGYrMjREWlhhVHFmNGU0SWVmcTYr?=
 =?utf-8?B?QmJ4eFV3dDNtUkhhdmx0cGlTTjBKTWU4ZE1UZEFzT1VuNy9BbnBuR2lHaGhz?=
 =?utf-8?B?OHRjSEg1VTY3TXZrbHRCU0xSeXJ0YmpoUXo4aWFSMDB0NVoxdHpzMTNab0ti?=
 =?utf-8?B?ZG1FcC8zeXlIS25VNjM1Q2YyRGMrNWxzUjJaL0locENBRURramFwNFZ5NElk?=
 =?utf-8?B?RFhQMGpZVGNtekorbVdtMHp1M1hLN3NCUlNBaEo1MnZmUi9sTXIweGJ0M2pn?=
 =?utf-8?B?Z2owcHR6bjdWM1hGWU9YdmYrRjdLWncwYkgwanVCWDFRT1lZTnRBSmhRMnM1?=
 =?utf-8?B?aWRvSjlQN2Z5NTk5K1pGN2srSEF0QXdtSllUTC8yZTlXd05GOWtSSTZDRThK?=
 =?utf-8?B?OXBjbW1FUklRV2ZzcmVuSUVhT1VwbEcvM243b2p4YlF0WGhQTHl1OVNnS1NN?=
 =?utf-8?B?S3Q4STg3eFNzdFoxZ0x5VllwNUhOSFFET0QzRExaWFJFa3Z5NGtsM1Q3MVJK?=
 =?utf-8?B?aDBpc0FsRGJBRTZkWEVWei9kMnd1OFY2SC9GWTBlNFU1RjR1TkliN2VvbWFn?=
 =?utf-8?B?allDdTJMQm1WNVAxZUhiZGNNRVVRMWpWdHk3TnRXS0RHeGRsaFFpYUZnSU9U?=
 =?utf-8?B?clpuWVk0UDVYVjFkSG43OUxtUlVuUWdRZVU5eU9ORU83YmRvdHVQZVB4MEdS?=
 =?utf-8?B?Rkg2L0h3Ynp6ODU1Qmp5TUlvMitoVmxTQVM0d2pDM2d4NDVzVGtJa0dHUGlD?=
 =?utf-8?B?Z2J1R3p4REUzblBNY2VkZ0dNRWVnQm1nYlRXR3M1dDFxblZCSmRiZkcwcWxI?=
 =?utf-8?B?ZlQydXp6UXAxRVpkSHpBSXNOVGhOWlNqYTNBK0Y2SmhNSU5IVnBoeURnZnMy?=
 =?utf-8?B?bmk2OVRzM3MwcWFmNGhzVU11T3FxRWJZL21BeG9iOVlDNU43Y2xUcFk0RFB0?=
 =?utf-8?B?ZHB1cWk0M0tVOExBSEJFeGJ6d3lwWlU5VHlUcklKcStIRU1IMkI2ZGp5L3k1?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	krDHaA7BJRzX1uNyvcFOc7MFCND+uQN3gw3H3J5slVtj0DA3u+LcC07fWzOTLUMSbyZiGas5k/HgIZgEsbztfiErY/f0E/2XIz/Sgf2Ym4Qw9KFiZ+m5of0ey2R3ob6Df/zOxX44LpCSbQnyHyx2fif/CPFHdYy9IOPgtOBPJSTFh8LXQKT7VelFhEKapk1nySypqQpYvAJSR2cbnJObnbOTfZnLasrgPo1U+UxpvJBYpyqDokZFJLkQ1vEw5vJZxStp3Nnstwb6Wkfg3qyTdumQZaB+eCM9P7zJ553zyBaNeYSINYg4Ul8sx3MlMdRsPRNF8a+nvh/1SjMPTt8HmNextENF8vk4xJvj8uFe+0/fUkEIE7ay3NjJyXBIzqDuAGqiHB1XvTZpK4YwcW0hzsazeDjZrHEUuoqTOKtIeM2TLDUMVtNkLlhbEucXXbUBcz37C8Z4noZJDKSvQ+HDDu3ZbRv8B4Zer+grloS9C8gttTKHdHvWC1CcDlZbzBadiJzXw3KHcjqYIm51Kvsu+86LMnewl//RAu45AsSHwIjeetvYe/mT8itbOiShOoPMtZH0z8lbIKWQY5SlpTDzdfwdUfZQ1LpdCVtJl4izv3c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98dd10a5-4310-431e-d94e-08de2d1747dc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 18:11:54.7033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmLI239xINX+cqmbrd1KSC0F07sfCzNomRzbhOoG12Ni9GuPCanGhqBGhnsOpslhCqavZotaifY3EhhQ39gJCHu3MJMILeTudQmCU+nB5kQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5947
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=849 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511260148
X-Proofpoint-GUID: 9qrp3HqdfzVVWPEOw0xDij2Ibyk_Xlup
X-Proofpoint-ORIG-GUID: 9qrp3HqdfzVVWPEOw0xDij2Ibyk_Xlup
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=692742ef cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7MaKTZUXmBkZ5rK-2vYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDE0OCBTYWx0ZWRfX4yUf1hF4+BVj
 L79p1/GwWrqXGhC3WnDeO56OMW7XN8pgZKUpi9lAg0xtfguAXrZjpGdPVfmp1NNX1UxrOqsCxLI
 JaqEBDl88CZTj47N0rIaJLP7GieLZBsGx+pOejmcfyUk2mM1nc7ybqC1mqK2KrwuwaJ1Q+lY7YA
 FS9B3uBkU/zSX2932AQlj0uOUwh2NFx0W4C1y/a2hakVRW/Icp6T+zRlk1KBHCZl92vi6j2o5eT
 LjIwKBWZ8bGvSzWeXrA/JnjW9fJpx0D2WuD8Plok1W0VNgOEewMeKeJFWt41YP6FNo4csqV5CHQ
 eOSHk6W2fUvTbfFIUE9CztbHho23gkUWx6DVJyUPiyI1/634SjdJnNQATG9GpOibrFy6h9swcoi
 K3gw2mg8NF3N+XYBtZKU7BWTfx+nkg==
X-Rspamd-Queue-Id: E7C584000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: i899yay9o7oxspto1a14bk3motpss6rf
X-HE-Tag: 1764180726-724896
X-HE-Meta: U2FsdGVkX198NoECZqSGah4MysUlpiRA0BJj/pKZanpX2ZpJShBGH8LVjEuWM+70e1FOcy75Aix3KTMlMKXKj8aH2Gz0cKKund0QbnuOALlbHB8qScJJQhuZkfYr90uSQ4udOXUL9iBGiNlwWoAbAFscDjisRKbrHI0VKElHX6J0xYzBRhUXtdc3a0Fod5CxF2LM8ViRjA+TRuTtOLRPmiNUXI19ED4+KEYsq5WX2sVD6i4u9wDBhZ1GSr0JPy9+1vBRLAsQDxHA80RK5FGvQpHGFPY+HY7bsUXyWV3b5zxYebVrdWR5w2ekiuRgd+Dahz89Pl0oolmQZlghj8izNc+2G/agewkMUpoxnowjlvTRRbFoAYxxpCfp+08w9AFdjl1VB0ksizIEJXQZ4bXrOW/PumYJBKl9F8+EWKP9ZjHLYVoU4MURnKaGOpYDInS2LXhVQiBMQgWU1PxD4IHa7/FYvQcCKwTSSh5/rR9GJqu4bPKeQ9bzVpg/H2HF7V7wAxo87r6y9qwJs/OiPq0sAxkf7cHNZvzUs7GwqSUom+ldz15fDqOEMUtcmy9gSc3wfehRBikmS9yd0bdQAJovbnsK4W4xs5UlQIvKLPXoeC5Djm1uZ6bpfUvZtDTJti67dJzg003YXcM3Cuso8melgiz3H08z/4v4pt7w1ZEN+0ffyGmzHeFB3DVegU6IVyGNEHI5yfuMkth4jkmyY3+W6bnDEJp0X4nfdqe3Pc/6xMiVJJKgB0psMp2Am1NlvfU45UMNChrLPuDDzdvkFB34UmTU5XuT43+jmU/OCaoMPftAnQabrQ9USi2e/kA4nCA5KR2E02+Ih3RBtHKhvFpWW4wPk/TsvTYic9ex9HVMhsvubDYlD6oI+t9+47IBXb4/Bjbcj78YjueHUodPmDgi/wRhDWd0jLFRSQVeuP8QyMxWKDuu7cVAUfg10tAwcjxrpRmX0ggWjr3xYnM/6kG
 0JLibdY2
 O/m000NE6WoP0AvYolJUAKVc7IV42UAwyvzigcN1lWrvdeVlztdvkCt9xWbOfs/ZVSU2Nv75SqBakgDQ/c6goPrPWs7jaN4seMu3gBEel+QFSu0pAK1B+L0nbzsD2+LTZIO7PsaNhCiQmTtClSUD3NqaWiaiV2BmkCFlgAXyLr1tNhv0RKBukHPHO79J4EzyR1xHluaHOIfx6GsahUzpu477YL9YeXjFNkTyisnF8FcRjDNiMxy5YksHhF7r99P1+zZnbFqZWM0xGByawEwCMb3QoCnBpqUC52IQk66e21bFxrFLtnaG+xT6NIOEebSyv5DiKT0+pH1KsSajEUpIhfe8B1jlKGk1oF8+PM/0paQWe/MAq9c7oFD3kJYI4hc7qyL8p+XvcHXdQzODAts3ryfqW0TL7nbMpC1lJ8vsnUiMNipMhG4Qg7sns7KKlXjT77YjAYzxJ9or2A2OoVSDb3wMCdM8BHdhXtCPwupCf0G2VonlDAgvZW0LoWhisqYPKNCf5Pr5upq0qm7fvOIFZVRY5k2tujL14B+I4dqOYjLBg/iLZQePLsf6V5Ok4zKtxrSgTS2VvKZq9DnrKm1bRMrz2okj/IwKsg1TUhzRs6/y1TauTpN8VyrU3Gmuf0krSDlcV62nnjI3Gh5RcRIaCNLUNjLGiuy8FoMDbur47DuGQ0X3ikt9lwzSNT2fmxc6CwkFblS6kQ9GBZUP3JzT+6CoxGngTYcf8Fz4vhYphXs8520ufcNVLfj2i1pW/jq5AwG5X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 10:06:28AM -0800, Suren Baghdasaryan wrote:
> On Wed, Nov 26, 2025 at 8:18 AM Lorenzo Stoakes
> >
> > The TASK_UNINTERRUPTIBLE saves us, but it's all still a bit ugh.
>
> I went through different scenaros and I think the race Lorenzo
> described would look something like this:
>
> READER             WRITER
> //recnt=1 (attached, no readers, not write-locked)
> vma_start_read()
> //vma->vm_lock_seq != mm->mm_lock_seq
>                            vma_start_write()
>                              __vma_enter_locked(TASK_INTERRUPTIBLE)
>                                refcount_add_not_zero(VMA_LOCK_OFFSET)
> //refcnt=1+VMA_LOCK_OFFSET
>                              WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
> //vma->vm_lock_seq == mm->mm_lock_seq
>                              __vma_exit_locked()
>                                  refcount_sub_and_test(VMA_LOCK_OFFSET)
> //refcnt=1
>   __refcount_inc_not_zero_limited_acquire()
> //refcnt = 2
>                            vma_mark_detached()
>                              if (!refcount_dec_and_test())
> //refcnt=1
>                                __vma_enter_locked(TASK_UNINTERRUPTIBLE)
>                                  if (refcount_add_not_zero(VMA_LOCK_OFFSET))
> //refcnt=1+VMA_LOCK_OFFSET
>                                    rcuwait_wait_event(TASK_UNINTERRUPTIBLE)
>   if (vma->vm_lock_seq == mm->mm_lock_seq)
>     vma_refcount_put(vma);
>       __refcount_dec_and_test()
> //refcnt=VMA_LOCK_OFFSET
>       rcuwait_wake_up()
>                            __vma_exit_locked()
>                              refcount_sub_and_test(VMA_LOCK_OFFSET)
> //refcnt=0 (detached)
>
> This seems to be fine with vma_mark_detached() using
> TASK_UNINTERRUPTIBLE. If we decide to change vma_mark_detached() to
> use TASK_INTERRUPTIBLE I think we need to handle the possible error
> from __vma_enter_locked() inside vma_mark_detached() and allow for the
> fact that refcnt can drop to 0 after the wait.

Thanks for going deeper into this :)

Vlasta also pointed out the TASK_UNINTERRUPTIBLE saves us, but definitely
something to think about in the future...

Cheers, Lorenzo

