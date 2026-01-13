Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E168BD30CC1
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 21:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131FC6B0005; Tue, 13 Jan 2026 16:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDF16B0088; Tue, 13 Jan 2026 16:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F039D6B0089; Tue, 13 Jan 2026 16:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0DF36B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:06:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 827A3C13F5
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:06:10 +0000 (UTC)
X-FDA: 84328173300.03.19DDD1C
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010024.outbound.protection.outlook.com [52.101.85.24])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38097100005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:06:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IyoMDftx;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768338367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMBdE6YMBNHMFHHpUOoGWrqZCe80m0OGsrxFAnXSXhc=;
	b=kN8ZvpEnhYqZE5y3iGWeFKHy6jLXPNP2FzZDwDdmsc6GHeAaBTZvyxp3s61gY1gL2M+uX5
	Mh+5pmUQOoLYbfRzU4jaiPvKiSMNqfv4erICz3sn6TnP+ydUid6WTnKRrgh0am2/MutSlw
	miohosrVbyA4h55Y3Ye8P/R5WidI1Fw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IyoMDftx;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768338367; a=rsa-sha256;
	cv=pass;
	b=IzgeyNo/ykkHcbaTJVIELG/rTD3lrd58wmuqtXv9aWweHWpQBqRfUO/qaCaY90lVy9F8u9
	xrQ8M5MTQ80GhpUhtThWRQb3iEJovMFFBwjS/NJk+9paH6ulgxzFJ6UXwwJeLrw2oS9pDw
	r3KwLCZNF/ZjlTFrUIQfpO8VNgvp/x8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQ+7y8AWTfnm9uk31MMP6CSvhXeFP4ijXLhzpJSrLqlmexj4w9OUaPbHebxMiJtbTzVXaEkAuUun6aI3OEXHsEGqakOBXQeXCQmogxZNBKqFqoR7k2pYaUKpqN7h96AOBm/E3Tk+PpHdLFZbAAQihaWHk7sy2vVdOs58T0kwHFtnyfTOJWmfSEmhTW4t9AcOpsX/DDW6sTZIEzl6EiXTr6J311vOXBQee4dqyGC68QdcRyer3XjpnT/N6suj+1E7HDMpJYUNyyq3x4ycCMGCfznFeVz4wZJKWN1SRWgxV2giVSV5v0Xb6AYywYaBQk4EjnDit+r++puVGYcqiof2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMBdE6YMBNHMFHHpUOoGWrqZCe80m0OGsrxFAnXSXhc=;
 b=yolS2lwKZb7J1jraK9uIPBCgRkaB8OjCeiM/6I/6ZzB0xhri/0+4FTBT4T/I/JFZTIXI3hE8W3bAEBSHLp5mI/85NoZw0E9veG6GTXjZSHi9fcs2rxBmvr8MIc9YdBpUf/lvsUJX7Gut9ZQgegw7n+A+njAdPQxVg4qSHMzzfdl47QDIeDZirGJpdANn9KkyXyg6gdSZmof202p+A1+Z4O2LOgjr4/0ZVakh5oXW9d7NEFrHmgvCIEk3SxQ9phbxqqa78msCXOG0dLHyS8PbH5u+ic4hY/1gXfdIHbj7GI4HML3eGwtJCyKgC5efC3pPOFkhW+j1WzWrb2k2Kc9b4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMBdE6YMBNHMFHHpUOoGWrqZCe80m0OGsrxFAnXSXhc=;
 b=IyoMDftxm8rRDUdUF1CZwvvIqycwpZ5gjMRxYLPBgzP+aZNxLVOdtiANJmsOpIJS9xPS7Iy453bQz14CZHsJoRUi8//XZ7GeVszyEpHW1swh1ovHu0rJugtmmEME8IwZg7RSHHdUcCSEbZD+Mu9dBT6zMjEq1ipWvK3dJfHaHbWsAKCluIryHe1bddta/IHpPTQhhlkCoTxCWoXjP/OvmhWJPj5B6PixmEK8v86bNtFx37F/dj10Fdqn5lN0vHDewOf7LxNhnIR6UzD7ASvCDsasiawEZGgV6YawIupnN/drLEb1ak0IX7YViXd8uCjCLHetKB1Fchi9gDQ5OJ8Y/Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7314.namprd12.prod.outlook.com (2603:10b6:930:52::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Tue, 13 Jan 2026 21:06:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 21:06:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Boudewijn van der Heide <boudewijn@delta-utec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH] mm/page_alloc: Fix freeing of failed-split poisoned
 compound pages
Date: Tue, 13 Jan 2026 16:05:59 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <54CB622C-0BB0-4772-A939-162D63433A00@nvidia.com>
In-Reply-To: <20260113205441.506897-1-boudewijn@delta-utec.com>
References: <20260113205441.506897-1-boudewijn@delta-utec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0225.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7314:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b34a1b8-20b4-4946-7c50-08de52e78f81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzAvZjk5RDVyYWJWejZtdDJiTTNjaHBOS2ROaHk4c2RSaElCM0d1U1NNMGYz?=
 =?utf-8?B?T0UvVXZQWVAwTENTb2ZwRHBtaWRZVkkzZVlZSnkvdTE3czhIR2k4YVFOd0Zu?=
 =?utf-8?B?aXg3NDJSZlk2R0VnQ0FOSVFCT2hwSGIxRUdTUFZYUDFZS3NSdUNyTGp6UkZz?=
 =?utf-8?B?akxDbWErU2JTRDA5UklFODIweS9tNTlSUGozU2RwM1U4VHhMVGlkTnFvUDJa?=
 =?utf-8?B?Mm5GWW9VNUR2Ylo0aCtnNXRKa0orTGdBRkVncTVDNXZlSWg1dTVHUkNYbENk?=
 =?utf-8?B?NjFxc0tzUGg5TTNRS3pnWEZNWkFiWGZNUk9CSmFoOXJHRWkvREpqR01BQ1FL?=
 =?utf-8?B?Y0pvcjJkaEMrT3BScDN1V1FTSWJvSEtkNVczamtlOWFWbUMzSXQ4dUpDN0o1?=
 =?utf-8?B?QUEzeDJML1pZelQvbGgwM3VicDh2Y0FkclcreVoyd2FrVzJJVXRzaU9RZWxa?=
 =?utf-8?B?TTYva2hVS1hLdDJobDNmaVhTQmNhamVLSkh0R0NtdzZCU0g1ODBQUy9vZGNL?=
 =?utf-8?B?R05UZHhZWUErZ1ZYWWl0UGNWb2dCczFkNjFLcUp4V0hTWkc3SXA5bFM4aWor?=
 =?utf-8?B?NXhPejFHYXl5bnk0bXFJcnZVNDFNL21VRkVrbWxPd1IvaENvV1ZUVHJta0E2?=
 =?utf-8?B?TGV4aFBZMlY0ak5iUzZadmxJdys1VVNmaHBkMW05L3J0bFlUN250ZnZYV1RD?=
 =?utf-8?B?M1k2LzVkbTF2T0pTcDlPYS9KRmZkUjEwV0NWczJJZExrTUFGeUlNbGl6WFlP?=
 =?utf-8?B?UE5nMkVJTGVDYTZOTFFiTnNNTHJ2SFlxaFZxQlZLSUlMbFdTSkxOYzBUcnRv?=
 =?utf-8?B?SjdlNnd5RkxHN1JaZ2IvbVU2bk42NEFZakJRZGltSFdQZVVtcVV3dWFvVDMw?=
 =?utf-8?B?a3ZuYllDaC9Sa2ZVVkpYamVtV3N2YlNRdG0xVlZwRmlxZHZ4bTYrbDVyd0U3?=
 =?utf-8?B?YmtmSTBLZ2ZBNUpWTlVFR1h2ZzdrK2Yvazdod2Q4NmZad3M3b3RUdUhKSEJv?=
 =?utf-8?B?N2V5QjhQWHYrbWZYRHNCYzdpUHY1V01ETmxGQzdyYTNUcUdjU29LNWZmcXJo?=
 =?utf-8?B?b2FCaXUxUzJFVFcyQ0FBUmZwV3I3WlpXUmJmSTVySUlNckhjT2xZZGZFV2ZJ?=
 =?utf-8?B?RmVCRURwSkFNVVdyRFdNYVB0QnhrTHVQaTRsdEFaMXBkUU93a29OVE1GRlZU?=
 =?utf-8?B?ck15SkJjKzJCcVgzU2FYdksrcGV3RkRDVW9WMjQwSmJVUCtDUjN0VzgrNU8w?=
 =?utf-8?B?dXMzUTY3KzRSbDBJai9BdWlIVkVFSkdvQTBZZjFLVHZ2UWZYZ2J2eDVsOHZ0?=
 =?utf-8?B?VDhMTG9adVFXeFpTWFlJd0xtUU5zQWJwR2YwMVR2VXpaSDhZZ0FBM0d0Nmd5?=
 =?utf-8?B?MjEwa0czOEVCUVZLUnJuRlNkSEcyUU1CVWl5cUVQajRiWTlUZDQ1V0ZIZnRW?=
 =?utf-8?B?U21KaFRleXVrcW5MdFpFTDNRaVU4cjlYM0RSbC9iOFA5dVZyYTBJZTNFYkZl?=
 =?utf-8?B?cER3NTA3MEROelo5VkQ3WDZZU0pueUdUZkNQY0pGSm05SThUMUlKRzlUZ1Uy?=
 =?utf-8?B?dVYra3YzakVyRXFNSkNtSVhXc3Z2eWIweWthSzdWT1prbkRyM2JQTzVtTjQv?=
 =?utf-8?B?bS9GeGMzRUFpMkdzamo5MXNCQjExcTdrQkRVTDdWaGc4YnNXSnhnckFVNDBF?=
 =?utf-8?B?bWZ6c3dvRXBvamxIOGJXZGJucWdDcTc0M3I1VUhqemt4S2tIbDFYV2Z1aEo2?=
 =?utf-8?B?QVltUVU3a1FKcUNzZlJFTWozdWlpd2R2cG84VGcvWmtFU2V1TjUydDdTeGQx?=
 =?utf-8?B?TVFnNTY4d3E0L05jQnc2dFZmWjQrb0VWeU5PQ0luSy8xdHd4RkpnM1FmS0ZI?=
 =?utf-8?B?VkYzckNESk00M0JYS0tLaEpIOFhkVGRvamhVbHJqYVBseEw0dW5kaUo4WHdF?=
 =?utf-8?Q?zNByJK3w5xExGbfz4A6JrhjZVPHrgQ6n?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vk5VUWZXb3crdjU0NXpETzNJa0w1dkM3bkNKcmI3Yk5JZmpBaG5pcHZvbkd3?=
 =?utf-8?B?MndkeVBiZnI5Sk8rMUtvK2VHd3lHR1h5ZWs2NCtOMzQ4aVRKK1ZDTmQzazNk?=
 =?utf-8?B?eFl1UnhSVDRPWDVJNkdLNEFyazZiL0ZxYUI0ekhERTA0Mml0cXl3WUtXV0dO?=
 =?utf-8?B?UHcyM3phMlRXaTZvVzF2bzFOM1pYNllabktPUjBlcDNsRUp4eVVYcFFCa3lP?=
 =?utf-8?B?dzYwdlUxaGpacDBDdGFRbG1RSXAyb0VWQUY0ZXJxSDdpcXR0cjB3MmhUa2xM?=
 =?utf-8?B?Yjl6RGkzNkp0WTA4M3hvUlRjWUFwd1pzdHo4SlRpNG5Ubm5zdDFCUkJkUnZy?=
 =?utf-8?B?aEVHZXRaT0I4VDBRekF2QnVZU3VFRHdMalBTQlZZQWxJemdYVzlmNEQ2SHlp?=
 =?utf-8?B?RDYrSTNxZHpjUnRqeHRjUW1ScFZFU0xUNHlla1RvMXVaNi9IQk1CQXl0WHQ4?=
 =?utf-8?B?UnBIRVZMbk5NV0l0OGwyQXBiM1laa2wwRGpvUHcza3F4enFuMjFnNHZTRDFW?=
 =?utf-8?B?WGNVYVd2enQxTWZqK0JPYzYvQTQxWjJIL2ZCTmZhZEkwNU83UjZhOWV0SHYx?=
 =?utf-8?B?VExWMy8yc1BJR0QrY1RZNlNRRVNKNmtqNmFQbU1BWmMzSE9kcEhtVURjQjJ1?=
 =?utf-8?B?eVUzeEdNMGE0d0NnZGtXVHNROFBXcTRFRmlaY1dSNTV1czRiOVh0Skp5SmUz?=
 =?utf-8?B?ZWZqQnNtNmR0bi9VYU9yWStHall4KzU2NlA2T01UNFU5bVRwRFA2R2R1R3NV?=
 =?utf-8?B?OHlrTGh2a25SZ29IVEpjamJpeVVzWGp6S0s4T0lzMnRoVlZrNGdjd08xRG9W?=
 =?utf-8?B?enpqVmFIa3dWaDNQU2ZER1pKRTJsNE5YUU1rUWVucUVOQklJcG5UNjY1VU9E?=
 =?utf-8?B?dDJmVVRaWDlZRlYxM1N2Vjk3L093TmY3ZS9JZ1I5SG4xWWkrb0ZQYnU2OGpt?=
 =?utf-8?B?blMxbGZmcE5UZXJRQmNkQ2NZNDJzUjlSelB6aGFCbTA3bzE1Rm1oaHlVSys5?=
 =?utf-8?B?ZDJQdDFhYUtDVnFUaURxQVZrSGU1MXlJaXBDVVMvenFobEl0blpWZUFPci9B?=
 =?utf-8?B?bDRzS0JDTXNzUUxqTEk4eHUvTHhoWWxtUnIrMnlyVVliSERLY2JsbUFPS05r?=
 =?utf-8?B?MFZ6Tk0vckpOcWl6OURMelEzaThudzBDbzN0ajV2MkIwUHRCc21Qb0lSbXl6?=
 =?utf-8?B?NEFjMFRQekdvRS9vbzBEMzBKb0RZZXBXQlJYNHpOYit6bFFCKzhDN2doRENW?=
 =?utf-8?B?b0REZWEzbjdrcHh6SUE3QjFQa3V2bUhVYjkzb1RvWlFTYzVnQ0RVYnU4c2di?=
 =?utf-8?B?NllQNmhMRjM0dDh4MkVIR1hZUGI3QThYTStNVHU5SEx2UWtuTk9ZckNwckNR?=
 =?utf-8?B?Y0ZwOVdHcWRaSTBaQTNhUXd6M3gzRFg2UFNuTjV3VEVtQkEzbnpxRHRGQzcz?=
 =?utf-8?B?Q2NtQS9DckE4WGJNS2loYWEyWVpBUVBVeUQrTlR5b25tcW9DUHA2MlBsVUZR?=
 =?utf-8?B?bDZZcGJBcTltcHVuMUxCRHNoTWhyQmxzNmlwSUlBQVVLcVFrUVVpcUdFODBy?=
 =?utf-8?B?U3BaWkFTSUdLNlFRRzZJSStDN2swdFI3TzVzOU4vUWVvZ3R6djYwcVROSnVY?=
 =?utf-8?B?UjBrbmplQ2lZREFMaHlkcXB1SlR5VEdSdVlvZlRLRzBxbGFPSDJQK1prcVlJ?=
 =?utf-8?B?U1A5NnVJOXowN3pVYmgvZlU0ZHpEWDNBL0UxNDFsRTcwamFtMmZIcHIxRCtw?=
 =?utf-8?B?ZXJ1WS8xbkxxNDBQOGxxeGVaU1lqMHhoNDFKMjYydzZlcUx1b0tTbUNWak1K?=
 =?utf-8?B?V0NwQnVab251LzAwa2tVRis1amFnOE5QODN6RHk3UUFBVCtPbUVnQjZPdWE1?=
 =?utf-8?B?UWJ2VE1uUEkvcWV4WWlQdkVjWUlsd2JFN2RDZjNFVXE1VUt2MTlUTWVZS0ZS?=
 =?utf-8?B?cnFyVVczY2dFT1lFZkxJeVlYM2FKdHg0Q0lPQmF5Wmt2S2I0UVpXVHpMdjRW?=
 =?utf-8?B?NVpEWkgxajlJcS9yTHVKQ2s5ZTlHdzVSZU9Ea2pZOEtsdzFsZVdOcE5NVjlQ?=
 =?utf-8?B?RjRQeGtNazc5Y3hIVHhpTytWell4RmJhNVJyaHdGUUZ6OU1BWGhQaWRISDUv?=
 =?utf-8?B?R2hnaS9SS3U1OUJ2aVA0cDFUNmFoOGlvSkM0VUo1M2g5cDRUMXV5U2xWOE9R?=
 =?utf-8?B?Mk52amxLVGs0L2FIRDVHVlZzbGs1SlhWdmRZMUM3S2RmNFVCOWR4TGZFT2Rn?=
 =?utf-8?B?aTJmU3J3Vmg2WFNldXAzM3lBS3R1RnQwTjRKV2JhK3JLVUpQWDZNeUtVdm5x?=
 =?utf-8?B?T3dMMmtWVUxWdW55QjFUR3R5Nnhjc0tIdFFhRFRZZnNrRUpxbVhNQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b34a1b8-20b4-4946-7c50-08de52e78f81
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 21:06:03.2732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Atvj3zAeJNB0Khi7jiszraBS445CLtU232S4UJQEHbugBLTooc2oOS1PEEok3LuK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7314
X-Rspamd-Queue-Id: 38097100005
X-Stat-Signature: ijbayy1e38ksn9koatu3s7kqk6at719e
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768338367-253458
X-HE-Meta: U2FsdGVkX1/aRt0fWRjGOgEIxv6w4ic8YZrxBUl3sueFvM3MVwjTyx6Q7tXr2zwKyQFQlhopLyXXG0j/RIPqTCSaz+VCanPs96NO+M9ZubfX2/Dcs00xG5tUyvnEWudIchaEZ0U6SrS+qKeZ9NMUZerOfoXVItJ2iYrB+Yw164NqYAAgkrQSSZ0VXgYvBP4vDsOWKZR8WAaOfXCSPABOE7qIh/ktMMl5+4ng7pPP7eGuPMBS9w43AtrNJPRSzUjbut+4vr9w7+vXvRLrlcKF9CS+DOcebxJwk6ZpWOtIohowQvHuyrooOvUm8JioyaU1+0tPbFwY+cbThgJRrFtulzoviZB0DWKC7YuFHr9r8nJg5DIlsTn1xd7YW6emMYpu+oLcxwuOl7on4yiZ56L8LIlTUMqk+P0/VOLODJoPnQzjz3Gbt7p8Tr+FRhmpZxHQXngvqj838BZ2rFoqnJxg0o65AXJ8to85g0Y+zDVOMqxNhMIPsGkOG09HraR/zgkjjl3KnHw3qKmMVnEdkLbIOjyHqpxggydR1B3YPnHZ00xDw7CyP7TeR/QkNS33TcIGAadBtwleFROFWry5642IBx1Tghc8rZrlZ2DmC30BKvTLNIiUDAcH3o7U9kmiG7W8blHoQOibpdv7RxvCC/kwKsesknbyX/lTBi3dTO5ISiwvPLWpGF4mkq9542QcYyDyjX8Q9EAiSmmP6q4fHsrhY/r1ovkNKXUJDL8+bkltPo544rEoihS+4mAUX4MaA6jPErYzu9vSmZh2gIjysgXkyxJ6ILdmdShlePlA/im/ynTKqJ+wt4HxEmvAU1uTHPbNnN7dMGvF6ToVSYTONRGlFJhaX7cGrcicwNYxuHfiPUFUJqzeGMG/EprI79CKS6KTBKiQvR52w4NX+TC/7W5z10A26Gv/U8oQrd49kNxBKSNpzelbxh+iozlBSkdATkqxqekf28BzVQ0OethYYdk
 ZeTXJ8Yh
 NnCkelXMm7aNCf/TDKpGTluGvrWLLVxyNWCPvU5LR6czI9Rm1edLIqWCkDq/qsecfN75HMynXw4KBBja/gp43pNvIqjIgXJs+yA+IuMmBuAlQlK1kZrrE2iAMBC5tdcK9Mj8I8GXfEl+S+HHPFXh7GgLrgSJOhr4cziDoYHCy0cpBBV0k2uDus1cI/+KEAlXcPlTlgAOxdyC+QGD/eih+CHctKBasi1C+X/WLoT+shIH6mYsNxtgyq23/3FEMQYxrB14j+BlaotxK8lzQ/2y1h9rzGt46LAJyMWM4J4gk7OBQ8eUPc4LUTQDChnENyPJUyEVhltT4SgTCHdqo8xZYQIolcLnZhChTz0sdIXaO2do4Uyv5QPHF499tGswdLQQouzQpZAHrk1bLGLOJB5ye0RusoQplNLcuZSnEChzjyBEWIClSL546xtORKmrDmJoMPT6j/58pQQZZnRbR6DMbaRzByX/CRUvuwOLkoAuK7cwKb7D6lXgabkRd4PUQ/SJp9hHZQgjGzL2Rr3q08BJUZjjupZWPLJF0ufrWrZh4Ru1q6EI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Miaohe (memory failure maintainer)

On 13 Jan 2026, at 15:54, Boudewijn van der Heide wrote:

> free_pages_prepare() only handles poisoned order-0 pages.
> In memory_failure() (hard offline), pages
> are poisoned before attempting to split huge pages. If the split fails,
> the page remains a compound (order > 0) but is already poisoned. However,
> Soft-offline pages are always poisoned as order-0 after migration, so
> they are unaffected.
>
> The '!order' check causes these poisoned compound pages to skip
> poison handling, leaving them in the buddy allocator.
>
> Worst case, a poisoned compound page could be reallocated,
> potentially leading to crashes, silent data corruption,
> or unwanted memory containment actions before the poison bit is detected.
>
> This patch removes the '&& !order' restriction. Cleanup functions in the
> poison-handling block correctly handle non-zero order pages, making
> this change safe.

This is not a fix. IIUC, for >0 order free pages, memory failure uses
take_page_off_buddy() in a different code path.

Miaohe (cc=E2=80=99d) should be able to elaborate more on it.

>
> Fixes: 79f5f8fab482 ("mm,hwpoison: rework soft offline for in-use pages")
> Signed-off-by: Boudewijn van der Heide <boudewijn@delta-utec.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c380f063e8b7..64d15e56706c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1344,7 +1344,7 @@ __always_inline bool free_pages_prepare(struct page=
 *page,
>  		count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
>  	}
>
> -	if (unlikely(PageHWPoison(page)) && !order) {
> +	if (unlikely(PageHWPoison(page))) {
>  		/* Do not let hwpoison pages hit pcplists/buddy */
>  		reset_page_owner(page, order);
>  		page_table_check_free(page, order);
> --=20
> 2.47.3


Best Regards,
Yan, Zi

