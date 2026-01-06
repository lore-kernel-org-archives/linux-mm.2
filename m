Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50179C47BF5
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B384C6B008A; Tue,  6 Jan 2026 09:17:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8AB6B0093; Tue,  6 Jan 2026 09:17:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CCA6B0095; Tue,  6 Jan 2026 09:17:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 854EB6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:17:33 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 010F8C0310
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:17:32 +0000 (UTC)
X-FDA: 84301741986.11.AB25EB4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 79C4C180005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:17:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UyZ+U8xu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=axwXaf6+;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767709049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dBAH0ejneHIR8nCEHk/BDipCauohnMZUORFAtO8hwY=;
	b=FSYvf5hl3FseCxuo92Er5wwNSE3seR1fjerxCIJiIrdzOuY1qECuWFJJflbLg9ZnXl/rJo
	rrHiClsuZukflWpdfs6Dt+bO9wgHDWUC909zfSFEkjxJs6dOestibb5N9/IqvdBvPodkwo
	en8SQ0mF9giEZTRwxkbOaAjrFCRFtkA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UyZ+U8xu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=axwXaf6+;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767709049; a=rsa-sha256;
	cv=pass;
	b=JlIwmpJEKLk90yVpaapzmRCFVoJqCdNrmzepF6YnlASwG/6W+Y1bJqh/t8GiQlzq9q7wNh
	BAVF/sYXKMcaki5uMdcGz1WOkrcyF9lkxu5JyMgj8B9o9nc6NrOF9+5GViJPcHV5yznHCb
	pzFcT2Ill25oUoronRzNp9aG4jHZGss=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606CoJN63899056;
	Tue, 6 Jan 2026 14:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/dBAH0ejneHIR8nCEHk/BDipCauohnMZUORFAtO8hwY=; b=
	UyZ+U8xupzqPypM+Of7d970n8OsfG9fa2Htn31rndTOKItdpI/O3IdMhr60YaLZT
	fr01DsofRON/PpxAGzfL0p7s2lkmJBEmMoWTucCW7fy6Xjg+6V4qWXASClHOuQaZ
	pe8elrYrhJy8LgoxVlY+5w2386IzqrgeLBwkunmChVH+7flg0tBg/qqOBqSmie6M
	TmF4svBhwrbv2zv3jQskraMjiWcsdhxfsCnS1GYsT3Jzuex4OoE2xsBtd/TnGn8n
	W0i4otXwKtizb8ZuVbYyQ8/Ex2RcE9hWcOViHLIb9vUKyyh2pkRUQKy6vyiwW+xK
	QN/vRToWR9wizvzaQKHuCA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh2rf83k4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:17:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606CqHGj020475;
	Tue, 6 Jan 2026 14:17:22 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjnb2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:17:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zkucpq+JPzEV7SxWZOGj+ZMvUcvxjh8Y2s26w8HfpAJT7PmL4C7gpPhwMBVe3LlkA2pyFgH0wnWRPXisLQjNRoKZTW62467TSWAo4jdnJhJnR59EOiu9FA9gLaerhBqz7LDzUH9zh/tEReV5E52+y53Cr43MBD+48puD88Luo84udTtb3Jf1IHk/Ug4XUDBuPaADZGBUJlByZ4qxFBa5vWlN38+IFhKTO9KePQnsgfR3Tlg67VttLDcTINAH/ENR26J83EZBb9AK7hgZluDVdi72wRpFkgo8w0+Qe608zi8TVi3PzNA6kCKiXTUAr3W6u/Z84d7JcqMeT7rDvf7/CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dBAH0ejneHIR8nCEHk/BDipCauohnMZUORFAtO8hwY=;
 b=TtiCuOZGJD3b0F+DgqBaPMpyAGKJC5s202yQ90mN6AqKaii3Ur8D8FyPVqCgW42ULyi48R8zBOlqwzz2ski7V1xlasWyTKrzAddb8q/1VqKyCNZy/QjYaGkejeC0nWWo/n4psbMASB83dlFNVoiHFqGheJHElX7V8sHDsDQLZhsWVlcMrBj5+lySFRa7+ci4lhEqM/32fmhzfRbWoLGN4zoqlQHRx4juYk7fYF9Q6cxYl/PjIxwqc+XubpsmWpVRXN5mES3A6/ty5X/bRddhqCP+BsxPMqDZs/pye9HwjX/b9Ok83jUKsgbbmNluczzJKu7v/JCzk7X6K7VeXfKv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dBAH0ejneHIR8nCEHk/BDipCauohnMZUORFAtO8hwY=;
 b=axwXaf6+6kz6fhMbD0Fdmj7yqv3lLxNXf/fAeuYkrR4KnhGfUcMrc7JhWuYrmgI9COmXbbyF0eogezG58ebzZfC7D5QpXLi9s+Oyt7GD6L5dxlgT1sl0bh8Yhobfc45PWmu5hOVQudW5Bgs65NcFu3hBV6+ZFZqJsclEAmPmemk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8520.namprd10.prod.outlook.com (2603:10b6:208:55d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Tue, 6 Jan
 2026 14:17:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 14:17:17 +0000
Date: Tue, 6 Jan 2026 14:17:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] mm/rmap: allocate anon_vma_chain objects unlocked
 when possible
Message-ID: <03723727-7fdf-4f06-8117-bbe2d6c2b7f7@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <4ce4ec09b92664091e8935982d83dde3a4c7f898.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpHWUj6npkpMsgHmLHMk4NHRzaDyDG2oQk1SuQ53swcMSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHWUj6npkpMsgHmLHMk4NHRzaDyDG2oQk1SuQ53swcMSA@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0487.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: 93803d81-fcd2-4931-9b6d-08de4d2e4c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjJTb1hBbVFXeis0RG9DS3hsTEhRSThXNEtzeVUraDIyb3lQbjVRYXdrZnNJ?=
 =?utf-8?B?QUJGQnBkWjBMQ0NjRmo3ajhsMXBtai9vVUhYTnRSMzdLcnRhT3o0UmcwaWRj?=
 =?utf-8?B?cFErVTcvckk1ZTBHK2xrZFFqWGluNlhqbHR6cE9oZG1hYjlOQkVWdldoNm40?=
 =?utf-8?B?aVBrWnJkNHJmUjRyVU5NMHRUMFF5bDZHVXJTNVR3VWt1TzdDeUFSSHJBOXJU?=
 =?utf-8?B?clZ4UDFHejBncUMxQzlSZ01weWdPQTVsUVZsRktaYXEwVU9HVVdsV2h2UGZQ?=
 =?utf-8?B?ZVNlL3RXeVdpVE0weTJhY25iUVN0ZXBhMUpYbDc3QjBGdG9wamhidnlvZGN2?=
 =?utf-8?B?dzJWVTZNOEVFb0RPczQzUXJDRlhoNWd3Rk5xSW11VVBQY3hhM2FreGRhN2M0?=
 =?utf-8?B?WHNab1VKQ0I3TXpXcGtFd3I2S1prL3M0eGVZYS8yMW1PSURZbzZHaXdZbjNM?=
 =?utf-8?B?ejltK1NlN2JETTIvNm9IQWVrQkVlbWxRK21tTUM4bGRqNTVRTUlUeFViOWJV?=
 =?utf-8?B?enNtZThBR2w5Y2lmQjlpS1laNzkxaXF4R3lJUEtBNys3UXp4dkpvWkRjZjY3?=
 =?utf-8?B?dDRlYkFzMEFySEFIM003YlRidHpjcGdMM05WUVFzUGNKSmJDUTVObkx3YUYx?=
 =?utf-8?B?SmVDQUIvOEhQT3VxTHpJalQ4eWp3S2laWHo1WmtsQ0ZMZGNlV0JjTkFTZEVx?=
 =?utf-8?B?WHVJK0pCNE1rRngrcS9NeGVnRkk5QVUwNll6MGRNTDlwM2FIU1NWNzl1MmF2?=
 =?utf-8?B?NitBSWhKT1drUjBaK3M2TmZMa2lmS1ZmKzBxakIxWVllNjFaN200eEJXUXBD?=
 =?utf-8?B?NlZGanNvZ256T3lWZzlIV1ozOGczN1hkMmpoa1gzOElIMU1sOVhEM3lubzQ4?=
 =?utf-8?B?TXlYNWFIUXB2QXM2QVdUZ0Urdml5OXJONVVwMzBvVnRIWUp6bVZxWlpkUW1w?=
 =?utf-8?B?dzNVNEkrd2hnOGUwSGxub0NWYmEyclEyL3BMMEFQdTFrc2hSdS9GTHh5aUVt?=
 =?utf-8?B?OWpKZWtMckZBRk9XOFpOWWpLMlc1emE1cnFaTlJvSi9QOHJLMjdPY1UvU2xk?=
 =?utf-8?B?ekpKU3FobmhJK0MwQVcwVGFDOVA3MUZQQWgvVloyTUlHdGVxS1JUdjJWTjJU?=
 =?utf-8?B?aGdDT1BuOU9zVnNGNkMxYW9MVkdiVWhRQ0xiVVc5ZnJsQ2NGb3lFOWtGRlNo?=
 =?utf-8?B?Y3FVVmVxTGhEY2d4MEpNN1NUTU9MYWQ1Uys4RGh5cGpQR0tjTC9xOUtwWFZ1?=
 =?utf-8?B?SmlScWxuZVBJUU9xSDBkT0Q3ZkFab3djL0tWWmZJbFdwdHdCSEJGc2t4UXpn?=
 =?utf-8?B?bXRXRk1PNmFCM3pLQjNVMUJRK2xJTGVZbE04a3RFdCt6OXRiMGNkZ2N6dnlU?=
 =?utf-8?B?VEdHeWxIeUQ4d1dQYnNjMko0R2tSQWtpTW9uNnZnN0JXbldzYXU3OGpqanZS?=
 =?utf-8?B?N0dtaWV4QzBlSW50aVVkeU9pc2d1SHo5TUU2bUxMMXprMmJCRTgwZDhML0tj?=
 =?utf-8?B?czNsZ3BnN2x5Y0loTy9rYTZjeklmTU5hZHBsa2pLc1NobzhtckgrVGc1NUl1?=
 =?utf-8?B?cnRGa3RRMVRJZlZqamtjTUg3S3pSMVF2VTBtcVhnVHNtSlNTNkxxZmxqTGVK?=
 =?utf-8?B?cHEzZUc3UXBucnVtMnIyUVJDQmlUaStmcFgvczdtanhDdG5Oa3NOUTV2SEVQ?=
 =?utf-8?B?bEhHeGpMNEVCV0libzRud08renVGdzBxSXMzNnl6aWU5aENWUEh5UjZlN2pK?=
 =?utf-8?B?WVlKTjZFMEN1ZGVWVUt5VlZlcHNDSWkwZnIrMzVLU3RLQkxXWWNtT01mdGFo?=
 =?utf-8?B?U3lLK1pJaXNycGlSNVVNN0dCL3dvR0pyUEJBTGg3Ry9BWlM5VXYwNStlUVBx?=
 =?utf-8?B?VVovRkpFMnNBcU1hRGpCYWdiR2xoS0c1UDVFRDVjc245YytCNk5Xejc4RE1Q?=
 =?utf-8?Q?OZia9ObXJMp8IwUesJBqqC61oVbwo6bA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmdZaTRGeXI4Uk5NSENtbXZiYjNEQnpaTG9qQWFRT1ZDdi9GSUZjQ3VOWlQr?=
 =?utf-8?B?RlFMeDdhYkFXVGg5eDkxbjYxR3RXdXVDSnVHZUp2T0xHQm1aWXRMdGJwNi9n?=
 =?utf-8?B?TUZuZ0FHWEx4UVJkcktDaGVkdjZGYWw0SUhLS09YSi84eFZDNDF3bXl0UjlV?=
 =?utf-8?B?VkxVbG83eUI3cUZQM1BMc2U3QVVyMVpubCtmRXdvOCtYaWNlWEVnRm1nSmtj?=
 =?utf-8?B?L1RFNWN4a1FoSm1KMnJ0ZzYxNlV6T2dCREwzN2VmQ3cyQUF1bTFyUVJSYWpV?=
 =?utf-8?B?RnBEbkdqWTdnRFlPeWdSeUg2REFkTUlSRHIwUkVYWGdpYUhQOFVpQTZXandN?=
 =?utf-8?B?dlVGZUJZeTVyZjd0OERWb1ltbkVwK0VmVWdJdW5VRDBxWGlBa1NSNnZIQjFt?=
 =?utf-8?B?RlZZRmFCK0tMaGxLbE03NVlzbFpTUFlkbUxQbEx0TDVYcGdLMzlBb1lNR3dI?=
 =?utf-8?B?RUFQOGEyK0hYOGM3VDJsNHpLSzd2NFlKdDQ5UlFuM1RGT1ZwaVBwS2RkWjI2?=
 =?utf-8?B?bWRKdStsSGFubDJXWWRCcEZnaDhzY1F1U1AxQXc5emE3UEJCNmtLKy94bDFz?=
 =?utf-8?B?OGhPb2REWlNoOGRORmFwaytVNHRGMGlUV2pDRTUvekZ6TlhPV24xNTNMQ3d4?=
 =?utf-8?B?WjlmZHMxbjZYdnMrem84bS81eHFiMFozMERSWGRzaTdnMGJDM0FodWNtVU9K?=
 =?utf-8?B?L2JIRWtoeUZmM3JTQWR1T0ZKWVd4U0RJRitEYU1XZ3BRdVFXcDgrL3Z0aXY0?=
 =?utf-8?B?Y054SWx3eXJOZW9UR21YajZOUjUvdHhmNURBNXpHdjFvU1c4YzJtVm9YdUE1?=
 =?utf-8?B?REhJejhRdXJ2YlNQYkliSDhFQzliYWlEcXBsbjlHeUNSVEo2WDkrZVFzMGdZ?=
 =?utf-8?B?OFI4SVFMQWpxUzlKQmhlOXVpWVlLMUZIVk5laTM1VmE1d1VRckV1bmlsY2Zv?=
 =?utf-8?B?MjJGM3MzNGd5ZkwvU3hJLytIdnpCcWE3WXM0YkNPWkZEOUhRWXBYeDgrTXVq?=
 =?utf-8?B?azNrbmdiVDd2RG4vSndLUkhtaVdUWVY5L3NINmlBM2ZZbU03OGNhN3J4U2lK?=
 =?utf-8?B?RVM1Yk9HTksxTmRIWUVDY2ZMNFUyU2oxRXBGQ1RzTS9BSGtZcmJJdE1GeVFW?=
 =?utf-8?B?dUp2cEgyUkJuWURIaTI4WTk1M3BWVUpySGlSZStCTG1ISnFmVk02MUxFdkp4?=
 =?utf-8?B?cHpwSFJiV1l0cUQ5U0pET2lCR2dYRnR4bHpDRkZ4NTJ2RVhCTnFmVVpXc0dD?=
 =?utf-8?B?b0UrOTQ0azF1Z2ZoUWN6ejRFR3RTNFNWQ2lqVVU2bkw4blFjeWhlQTNQZEJG?=
 =?utf-8?B?QlZGY0JsZ3RkdWhxTkpDNFZ3bGI4N0svbGdpUVg4STlxdFI4ZXgvWHF1LzVG?=
 =?utf-8?B?bFNCdWdNaFNjUG51dU1CTUlwLzgrdEloNlRaNFhDS29FZFdxeHI3UDQzbTdM?=
 =?utf-8?B?WTR1eXR3Y3ZnLzBxOVR6Y2VONXVSSDVOQVNvMURXT1J3Q3VyWlN1WXZPWlpk?=
 =?utf-8?B?cEl4dWJiNkRucEtLdmhtejZsL3hNcjNwYkJZalMzYkxWbkN2cjdLRHJDMWpk?=
 =?utf-8?B?RTlxcElNSmk0L3MzN1pxb213SUxaQUhlaWQ1enFjdWdVd0NmZFhJRFB4Q2xR?=
 =?utf-8?B?VXRmTEp5SytSMkxmRGE5OGpPUkw0MTFGdXVFOEVHMnVyUUhHb2RBQkJjcUox?=
 =?utf-8?B?MjRxWFdDaGNmSU9hbUh4UDliOHRUT25WQ1cybjBiTEpPeUY3TFk3eW9sbm5I?=
 =?utf-8?B?OUVSbVZIOWtHZUxrVVZDdVl5aEZ4Qi9xNldvdUc5RUxsUVVnOXhIVXE1N0VR?=
 =?utf-8?B?RHFCSGpUYi82T1VzTHVZbk0xMXN2bUs1Y1h2ZDgvdFM1d0kyRzJXdFlNN0pX?=
 =?utf-8?B?dUN6ck1IZFFGVVlpczNlUXVZVUpJZlpUcWxzZDd2cHZLMGY3OHpydUY0M0xp?=
 =?utf-8?B?d1l2Z3Q3WWVRWHQ2eTBWaVBPbEllOFkvNUsyWkNWc05QUkZOVXB2M2ptVVdz?=
 =?utf-8?B?ZWV0MWpzZ284SXJRMnJRaWl5YkR3dGx6L0pSNWcyS3Q5MFNMYzdmMGhXZE5t?=
 =?utf-8?B?cTRaNnA0ZTZOOWE1cVlyd1VqVDZLd3I5T0FhOWx3MEZ3cWFaR0xJcHcrQlIx?=
 =?utf-8?B?dng2Ky84c2czZG5rRnc2TkRmUWhTQzJrTkYxYkN3TE8vTkJLWVE5YnRGVk4x?=
 =?utf-8?B?Ynd3eFBrSENqNy9XWkw5YU1sWkx6RFBFMjF1dURmR2F4R3htZHNkamp1QWRi?=
 =?utf-8?B?dVlnVll2Ris2V2FudEdjUXRGME53ZEQ2S0RBTUFwS1BTZk5BUkRKL0huZlhv?=
 =?utf-8?B?Vko1bnRiTkQ4RlJLMnNVMzNBWmtnUWZZRHV3Q2wrUW9ZcGVsVlExVngyN090?=
 =?utf-8?Q?S+LCBTZKU1vP7Xy8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VnyWG6muMrsOb3/3eF/j0D0HXxAvYCu8yVkCj0MLiBJWO3StNfgU7NEK7FwxD99D1qbwZF043iLXd3ReeancrStYIh9VRpu9pusXIYWO9CU+t1rHK8ZvjDDee46oqN0vfcHViejKJGcu1Ocd6phW3wW0nQgkaEQNTktFO2sGun347Ck/+UHzU0MhA7Blk6KIh9sKN7mmp6aj3o4MHLrXly7OWNKy+CXJNJQuTWcZHQ1vejO0C/ld3nzZxdQSpLgbg4kg+WUBVTDW3bKVfCBl1MO/kMyd/6GytCSdy2+TDoOjlXSyinmKexcyUJ+E11SQuzuhyJt+Rg40xBmAtjIlpp5Mi3REGaHl+9vFnsmp4P/7qySE1fMnzHmgUl5D6G4vIngigFbjdxcoboRZDa4YpBzB1akSpToC4gl69a8jVBfE2j/VlARA903mxuioYN0MgturncnCLFf8nGIXbMiX/ZkiXcw/SctsCr82mxDTwUSvHjdpQvIB15o1ORF9mToTPPho3DxVClSxVRTthNpIQ4ZYnekbCZOrCY89XnBknyaPIrvpZiEsQm7Uv0S8ZiWFrEneQWgwQ9KyQ3+hAitirRnDyIEilKZUjVbspDUC+tc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93803d81-fcd2-4931-9b6d-08de4d2e4c0e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 14:17:17.5450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCGibTe4e+YUUn1GMPy+2Twj4R+QWmKbSZdflTpqyc8/tSorFfNjJlIcYGQahIeSczzNwij1mxt9I0siJkmn6aKcNrV8gJABW8cwKVzEZdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8520
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060124
X-Proofpoint-GUID: UE5pP5LMFjbvMLsIauwSmcuOT4H33fO4
X-Proofpoint-ORIG-GUID: UE5pP5LMFjbvMLsIauwSmcuOT4H33fO4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyNCBTYWx0ZWRfX9YbrC+cMXT9l
 yysOFSC4ZOifsehSUkhCXHHkeVpbOjcF0wbfG9h57U+PSUO2FTDAQTY19pDv+CGBiBwSI25CJ4m
 2XYk6zNrE+ogPGiigYl5QeNVWJmUdcPWDUURSnU8dX4D2S5W5wYh4TvOV5zAJ4DleKKgGKajvwD
 YJisxdQsSTqcIX/EdLWWcydVYUPhOD2LIeTZ4Yy/wnG9gC6RezFZTijTagcoTARE7kFu03Q338A
 kZmlSstTu92QmLYN3OqBycSchIrOvHiagBGUTs4VRtoOFAUgzi3BYa/ADn1XyPFRjXTwSE/dpLJ
 2zBo32wvMEMrim7tB7h6ttgjUw9aJWZbZar/XjY77c5u/vRrgnM7GKxBucAA7FOWwh1dNKNHd1A
 Y4pHFhu6yfLB0arZrdgcrCkXU+I51dKER/RxQ+DVAhXXpuIxUvQ8uLQprqz0yso16fxGCGo8MJx
 fadQKMkGCv8e9SQQY9Db10Gvt8+nrcwYnEKSBM5w=
X-Authority-Analysis: v=2.4 cv=OKMqHCaB c=1 sm=1 tr=0 ts=695d1973 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=IbUq4paBoLyxRfEMWzsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12109
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79C4C180005
X-Stat-Signature: h8877xub17x434epzz5kwfcbyfeqzi7q
X-HE-Tag: 1767709049-183549
X-HE-Meta: U2FsdGVkX1/5D0HyI999lZrgi33e/qFJx9tmbeoDQAi7o0ikWRBMlaO8fdsuNPzFR9vrsGWqDUHlmLOkMTJHlsfVaRRtZynnUE3PGAP0ZlvPgLPHifKyhMUI/soOwqLDrwKJyDnE2PB7XudFQ/xUCCXdAOqg+fHJ2a4tulwZwMFP/26z507/C1dJYO3C/StgnSSSztKjhe2QuAP2TAlFcNQSeJzEpZ5z0q7jVEICkesQ8OLdlECizH4JouZQLEtEdnnSqd7P/XsNTZQpQXy/difgeVEE58s9PRAoK4mUhZTCLlC5rKf6pd9VXxYPU3jvWPK6TZbqWLwhTJDXJKZc4utZCuS7ngnoWeFFbtsvEF+e38mjA/hJmB5hDmOR7PANDoJMxhvr1p2cyvLhLRnofZzAd8VvXbuKcx1BbUs7ZW2pqgByiygV0eqWe4QNkjiM2u3jQDr/isEMvM64+E3qiLbZmh4OasiTpUGgJH5dCBWWihbI7qTJMyr7y9lsnjyo6Umk0GceZ4wIbBfiOTMcgmQfK9na97XxqKmyPlbAb2SVhQbGtSsUr4vX1D7VGqD2JRzrn6brKgQZ6PZ5CUdjlqQz6ZNaulpp2mRNcU2mVz8sz9vr9hPDhbllPUV9kQkO0gpGzY9BKbkLdqaqWnMkAnJv+IimaJugYTqSnspyxDlQXXUV+Cqz491HnA7kbH8+OVlSi8V5tMbOtA2UY3JDewO4wn52C0viCvA2hdFMRiwvHXv2uQNmOweDBRRc811e6Xfj0fteJbfTX2EMi6HutpOtn5RJQDZDhQHfu0Mh1iapUCd+cRehp5p2tIO0XiT9nKnIXrfyHiq5CYdyrQQi1imbMCuD35sxrpnG6pGApI4WM0XiVerGpt5QjnQD6wQbtCbuppQ5RODpf8+O7FVs0/o67iyfH+PxYYmYPCFX1s8UCBmvDZSf7DuF0Zg8eEuxVVOmRkt8BrMlXGwpr0j
 LYSHvQaN
 Yq0B4tVhV63tAROizoOqo1jm53G4LlJ8uCEGn17shG1fus23OjO5iiMboRLREUE9qDorGO5NZUNnmgoviFeO9I057mUrPhGmsjxr7Apyx/vwi/zu4rxBluZgv43NMQHFtdk7S9Szn94kUqh2NnLu2rtav/Zx4xolm1LwywSmFgT6a+aLuSoUEupGzY3ZNk2X4Gpz7brslFL8C7kIKA+vngrz9SjPEUHPA2gpI9XIQ2HKuMJccXVWSApXTt+Zi01lqwuhu26x/+DR2gxOYC10p6f/00u0rNgSa4gpKy6J3mihmRCR8OzwdpN637rMSWo9IHjiqfpLAhXQAnhD2F0vYqpq4NkG7ZQHoQvIsNmEmevSvDhLdt20i9jcXvN2WNl2deptnsyCjAF4d0/gsLYNA+RvpoVaR538dxZXII0pP1YIgGBKgEncVruW1IRVN6OuyLIystn0u9I5g3IpVQb5rNrCyTZcwLskeceubmbCf9flC2YlrVWZ5vDfTZS2JVgQWTIFlg51rpAZQQcqaUdB0GLuYAzWQDtMONwDbbQL/jHOPKmAQyxC1wLNTqyKh4nvrkGBqVNdK0+beTEv2A8xM4dV0lPBYV9quZgS98YCI+SEPxqv9LtGO5g8H2VWt9pZ/6H3IVWa1pupd+h03j7JLxn0ZgA+JE9Vkb0JIlfggjTQ1i/uHRuZYYY5xHJmS2b2FosCFGM/a7oOYUP2ykkMIOPInw42j02zBaOqxMAO629B+0/6hQmhc1oG8nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 01:35:41PM -0800, Suren Baghdasaryan wrote:
> On Wed, Dec 17, 2025 at 4:27 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > There is no reason to allocate the anon_vma_chain under the anon_vma write
> > lock when cloning - we can in fact assign these to the destination VMA
> > safely as we hold the exclusive mmap lock and therefore preclude anybody
> > else accessing these fields.
> >
> > We only need take the anon_vma write lock when we link rbtree edges from
> > the anon_vma to the newly established AVCs.
> >
> > This also allows us to eliminate the weird GFP_NOWAIT, GFP_KERNEL dance
> > introduced in commit dd34739c03f2 ("mm: avoid anon_vma_chain allocation
> > under anon_vma lock"), further simplifying this logic.
> >
> > This should reduce lock anon_vma contention, and clarifies exactly where
> > the anon_vma lock is required.
> >
> > We cannot adjust __anon_vma_prepare() in the same way as this is only
> > protected by VMA read lock, so we have to perform the allocation here under
> > the anon_vma write lock and page_table_lock (to protect against racing
> > threads), and we wish to retain the lock ordering.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> One nit but otherwise nice cleanup.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

One nice thing with the separate cleanup_partial_anon_vmas()'s function
introduced as part of this review (thanks for the good spot!) is we can now
simplify this _even further_ since we don't even insert anything into the
interval tree at the point of allocation, and so freeing is just a case of
freeing up AVC's.

>
> > ---
> >  mm/rmap.c | 49 +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 29 insertions(+), 20 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 60134a566073..de9de6d71c23 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -146,14 +146,13 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
> >         kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
> >  }
> >
> > -static void anon_vma_chain_link(struct vm_area_struct *vma,
> > -                               struct anon_vma_chain *avc,
> > -                               struct anon_vma *anon_vma)
> > +static void anon_vma_chain_assign(struct vm_area_struct *vma,
> > +                                 struct anon_vma_chain *avc,
> > +                                 struct anon_vma *anon_vma)
> >  {
> >         avc->vma = vma;
> >         avc->anon_vma = anon_vma;
> >         list_add(&avc->same_vma, &vma->anon_vma_chain);
> > -       anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> >  }
> >
> >  /**
> > @@ -210,7 +209,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> >         spin_lock(&mm->page_table_lock);
> >         if (likely(!vma->anon_vma)) {
> >                 vma->anon_vma = anon_vma;
> > -               anon_vma_chain_link(vma, avc, anon_vma);
> > +               anon_vma_chain_assign(vma, avc, anon_vma);
> > +               anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> >                 anon_vma->num_active_vmas++;
> >                 allocated = NULL;
> >                 avc = NULL;
> > @@ -287,20 +287,28 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >
> >         check_anon_vma_clone(dst, src);
> >
> > +       /*
> > +        * Allocate AVCs. We don't need an anon_vma lock for this as we
> > +        * are not updating the anon_vma rbtree nor are we changing
> > +        * anon_vma statistics.
> > +        *
> > +        * We hold the mmap write lock so there's no possibliity of
>
> To be more specific, we are holding src's mmap write lock. I think
> clarifying that will avoid any confusion.

Well, it's the same mm for both right? :) and actually the observations
would be made around dst no? As that's where the unlinked AVC's are being
established.

I think more clear is 'We hold the exclusive mmap write lock' just to
highlight that it excludes anybody else from accessing these fields in the
VMA.

>
> > +        * the unlinked AVC's being observed yet.
> > +        */
> > +       list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
> > +               avc = anon_vma_chain_alloc(GFP_KERNEL);
> > +               if (!avc)
> > +                       goto enomem_failure;
> > +
> > +               anon_vma_chain_assign(dst, avc, pavc->anon_vma);
> > +       }
> > +
> > +       /* Now link the anon_vma's back to the newly inserted AVCs. */
> >         anon_vma_lock_write(src->anon_vma);
> > -       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> > -               struct anon_vma *anon_vma;
> > -
> > -               avc = anon_vma_chain_alloc(GFP_NOWAIT);
> > -               if (unlikely(!avc)) {
> > -                       anon_vma_unlock_write(src->anon_vma);
> > -                       avc = anon_vma_chain_alloc(GFP_KERNEL);
> > -                       if (!avc)
> > -                               goto enomem_failure;
> > -                       anon_vma_lock_write(src->anon_vma);
> > -               }
> > -               anon_vma = pavc->anon_vma;
> > -               anon_vma_chain_link(dst, avc, anon_vma);
> > +       list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
> > +               struct anon_vma *anon_vma = avc->anon_vma;
> > +
> > +               anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> >
> >                 /*
> >                  * Reuse existing anon_vma if it has no vma and only one
> > @@ -316,7 +324,6 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >         }
> >         if (dst->anon_vma)
> >                 dst->anon_vma->num_active_vmas++;
> > -
> >         anon_vma_unlock_write(src->anon_vma);
> >         return 0;
> >
> > @@ -385,8 +392,10 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
> >         get_anon_vma(anon_vma->root);
> >         /* Mark this anon_vma as the one where our new (COWed) pages go. */
> >         vma->anon_vma = anon_vma;
> > +       anon_vma_chain_assign(vma, avc, anon_vma);
> > +       /* Now let rmap see it. */
> >         anon_vma_lock_write(anon_vma);
> > -       anon_vma_chain_link(vma, avc, anon_vma);
> > +       anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> >         anon_vma->parent->num_children++;
> >         anon_vma_unlock_write(anon_vma);
> >
> > --
> > 2.52.0
> >

