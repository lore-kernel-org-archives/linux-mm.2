Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27584E9B260
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2886B0089; Tue, 24 Feb 2026 08:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589D66B008A; Tue, 24 Feb 2026 08:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437DE6B008C; Tue, 24 Feb 2026 08:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30CC66B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:24:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0292160142
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:24:03 +0000 (UTC)
X-FDA: 84479418366.24.CAE1432
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023099.outbound.protection.outlook.com [40.107.162.99])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90738C000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:23:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=TmiykoYs;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.99 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771939441; a=rsa-sha256;
	cv=pass;
	b=AI7vB79T3mP4L8DbM9oXOPGuWq6MmZfcsIuEOTn9f3LwChH/o8r+H50wCna2adSE0ZH7IX
	9X3jbuT6oxgm63KJPkWgF2sv19dCSdOTZe6dZOnAYUB9yYngFQVt3Cf1QxADoAV1pcIJCZ
	d0jjA/LvC0191w76F8EhJC9eBo+5Dp8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=TmiykoYs;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.99 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771939441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAhnpusAyPEbLzfo/BfVLb5p1RUFtQjwwJvZ7LUWprE=;
	b=1tAUfUOju6CthtTyhNrHrkXnU3EnEedIwAepsaTpE0Pk3CW06zJLhqvBOjNTB+Z1Losg5K
	z07l6yoYf+Mel8PoAQZD5aOl8XUoMvrzO//kjTpmF1jzQWZlxyJaDRLnESmHiKBt+b2ifw
	ImwGC3ThNXMFBAWdmJS4E/rsB8ryzVk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IuMRjecfCAIA4TEjDEAacTpKcXcFGTGfKXsmfAYIOpebBQajRYPbAcVba/ywb1TR2Rm3F/+5Tlreecop2kWFEK5wkBJZjCNEROWcsxVsz9N9dEBbVfCjZ//6gGn1Clc9/PI9PElNpMzirf7hAFJC5pEY+GB4jZXlfKTbGowiI5giI0Yh4HM1n5Jxomd38Q2WTvB+U/MH6PX4By/NFmFSFpCl1W5R3gMFfa4bzTGezOCnhDpZb3yRcmN/UT/NO/bfcJ17y/7WnhL6CJMPH1Fs1muD2BtQCsGUMLtS3mUz+/cfu+fKcTpalLDHtJBr7RBBxfL3+c7DSA8/vz9v7FbS4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAhnpusAyPEbLzfo/BfVLb5p1RUFtQjwwJvZ7LUWprE=;
 b=HDUspcrn6pZwfBcNtfNH/qqbnTcR9Tgc6L8OYjwOpZKWG6BACyT9Iqs/zT5PtD11JfsFxgS+/HHhPYJA1LBmOx3JvTEK6PJzVEAP3PwdiSiRbd0lkZkWvX6iLwlnLp2qgnx1G9ozvQMw+o9j4CL4ZrBvV353DG7GpWEmCns00SKV6zpZoipliyl5NMYvh22NGzvwNbEiw4pAfdk/2p6NjUWnFq9jvmnnrvDSUsnOMUGM0/It9P15sVJoa9An9/JPa1mA0c63ZTBSafXWlyGqqYExEccNf3Zgnkc6E6GgC/uxx3Q7xpHSzzhEgUoToGEM7VEEM9ee0hTCrlSuYxOJWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAhnpusAyPEbLzfo/BfVLb5p1RUFtQjwwJvZ7LUWprE=;
 b=TmiykoYsxL64Wq52mDyLGMveJnWyJt+O+xviAFOK06yW308YYiW1J2csBUKeW1Na4XC6WcwLMCGjsN6o1kTa0wjUPkD1iMoDGuL44THPuc9/Sv8pMzksZtvrekbo63qQ/nCsQpMHOw7hwiDQfRg5XRbGRzwPmU58F2Dboi6X1VZ+AT9UQUwbES9NXUf+WRgIjIj6zNR7qMVVc4yiZsxFZD8JrNimPmKXp0mHUxzffIyvdtMeBCuf39U8aH6jl0YgpeSxrd0WeBpSgQACbfIm2SupnAQ/nnRW8HI3G/u1YUZ+2W1rQzIlxpl84VQvbbrOAlDaNCmEDAtqTP/PzZ5+8w==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS8PR08MB6086.eurprd08.prod.outlook.com (2603:10a6:20b:29d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 13:23:56 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 13:23:55 +0000
Message-ID: <3f095a91-f052-4f38-a8e4-2e6dbc9a0c6a@virtuozzo.com>
Date: Tue, 24 Feb 2026 14:23:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] pid_namespace: allow opening pid_for_children
 before init was created
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Jan Kara <jack@suse.cz>,
 Aleksa Sarai <cyphar@cyphar.com>, Andrei Vagin <avagin@google.com>,
 Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn <alexander@mihalicyn.com>,
 Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 Mateusz Guzik <mjguzik@gmail.com>
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
 <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
 <aZ2U6TwK7rQtkTvT@redhat.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <aZ2U6TwK7rQtkTvT@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::17) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|AS8PR08MB6086:EE_
X-MS-Office365-Filtering-Correlation-Id: 1400d628-33b5-4c7b-7cd7-08de73a7f5f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3cwSGJpdXd3bUlPakIreTdycDljN1loSmp5bTdoRHlyMDU0Nm4xRlMvTW9s?=
 =?utf-8?B?bnE3SXlqSXpqVnQ0L1EvUFVnT3l5ZkRYbk1IazZGYk5xQTIwd2Z3Q0VVWFRv?=
 =?utf-8?B?SFh1cXpQbXU4bnZjSHRLK21rZzNha2g1dU8yM1pMbFB5b09wUTZ3OHhIYUVW?=
 =?utf-8?B?VG1GdWY5VjVGbGM1TUxhZlNrUml3N0V6RVdhVjRadUNhRklEb2Vya3JBZFNY?=
 =?utf-8?B?UVFqblIvdnNabE1JeGlTUjVqWGlTeXFmb1piOFFOdnoyaitrYmh3UTNXTlVo?=
 =?utf-8?B?Mk93eFp3M2xTTE9iOGVaY0lKRnBnZUU2OUdwM2FTV3dScUtyM21GQkFsYmR6?=
 =?utf-8?B?TWRPNXppK2RlTkNkaG1CWXZiMVA5Rlp3M2xHUVVIUU1RRzNYVWFGeEVKdVgy?=
 =?utf-8?B?bGpYZGtFWVFsZ2tBZGpkSzkra2lFYmpwT3JkTW5PODlzVkh1ZUdrcVI2cU9X?=
 =?utf-8?B?ZWpONHNpRkUxZUR0UXpZZnJ3QlpZc2hqa3kwNlJTZXNLOWNzWjFEVUFmYUlt?=
 =?utf-8?B?MkcyTmtjNTN3VUNJQ1NzS2FxVHhSVlNzcU5Gb3lsbys4UEYzYXF1OVJaMlVx?=
 =?utf-8?B?U1p0TGhnUlh1N1lnbXczQ0VxaEhXQ1NqZzQ2Q2d5b0hLY2RHejdlRlhvOEI4?=
 =?utf-8?B?c0F5WDhCNG9Ld015YW1GbkpGK2QxbnlXK1NqSWthODlrVHdVcnFnM1ZETVho?=
 =?utf-8?B?ZEZzRlpUbHd0R053VGx2V3RYY3pxbmVTRHNKOERJSFlPU08xTEtmOCthYTk2?=
 =?utf-8?B?SHZyd2MvQnJ3dGlYZG9Zd0k5MUZYcVdaSFZ4Yks5aE84UENpeWJteUVLbnNH?=
 =?utf-8?B?MnBSWGdPWUQwcEQvYnRNWVBYRXBndVJNUTZhUE42WUV0MlgwaFIrQzdoOTl3?=
 =?utf-8?B?ZFVPd0dXUVhMOUtGVW1ldG1hMzk2YXk0VElLZEJaTFNmUHMwNVF0SVhicWhW?=
 =?utf-8?B?eEZYc3pSUG1vWUl1Q3JKZ2d4SllRVlpMYVBad3pUMmZjcDZTQk5tclI2Nzcr?=
 =?utf-8?B?cjZXWmllMDVUL0taRnkrRm9uQnBEUUx0WjkzSVovUk5yeWxTOWZ6TmVlM1JY?=
 =?utf-8?B?NkZScnFqcmtBQ0JMd1Bud3U5TWtyTXIrUTVienpMQlp0NTFZbjJnYUFMeUt0?=
 =?utf-8?B?OHF2ZHFBZXhzVUZJYWtJYmZodzN3UGFBcUZzejA1dE00M2twQmIxdjc4Zy9D?=
 =?utf-8?B?R0FxREhyZHF1MTBGZHloc21za3NwQVJIY1dPNXM3YXRGMUdrQStEblhETmJ4?=
 =?utf-8?B?WkJhQ3JsV25PcHdFTVJ5NEI5NGhiUnZNazg1eTdRZHE2YWoxTVVoTlhoVUMz?=
 =?utf-8?B?a08rMHY2aFhndjR3U0NKR2FKZXVXR3JNRlNSVmk2bjdBaWpXcFlnRFJyWlFM?=
 =?utf-8?B?U1pISGN5N0ZreHZyVXBjQVdJbklSZHBvR2U2aThOU1RyaU5VVlJzRC8zaVBr?=
 =?utf-8?B?WmhyS2x3d3dJR3VneE5QRE1qZCsvM0RrQ2VSaTM0QUYvaVdYc245ZS9GenZU?=
 =?utf-8?B?a1NRODlrbkpEZittUVJPaGRXdDc4TVZEbTVXa2NRSmY5cFpkTFZYdndxMzk1?=
 =?utf-8?B?QXVZU0p6UDVrS0w2Q29Ba2RDVHNrY2NtWFFhbUF5dzhVaUNCV1hiSlF0eVBx?=
 =?utf-8?B?aWJNVTBLaHJlaERzQjhua3VSenE3ZDd4Zk1Xbi9zYzh6emFjQWkvK2FidjRX?=
 =?utf-8?B?cUY4aGZQTi9PQ0l6NlVxOUVQelI3WHZhN2tIRjVHOWE3YXFLVGVTSmRtaTBX?=
 =?utf-8?B?YWFtckN2RmdXNXhsWTRKUkNpUGVtZTg0bHNRY2hSTll6bGQ2cjRkbk1WWDF3?=
 =?utf-8?B?TTZtTlV4ajQ1WDlEYWxEQjhvNXQvTWp2KzlVbjN5OVNkaXM2ait2dTRpTEV3?=
 =?utf-8?B?NjVWK25Rc3RDUHJRQm5Relc0eHlQTFJXR29iMmNCd3pIOXloMEN6NnFLRm9u?=
 =?utf-8?B?RlJsMnFNeWFEQm9hMUxRTzl2NDI1bXhNb3ZiMi9jWTFTMHREdGsyU0lEbW9u?=
 =?utf-8?B?WUFjb3RFenlNSlRvSmowbXRuUk5ORHVKSnl1TS9PUUVORldzMlRRdVh1dzFl?=
 =?utf-8?B?QnNMRFJDRjdpc0tIOEdaeWxFYTlweUdtTFpEb2JxMDFDQlZFQklkR3B2RzBZ?=
 =?utf-8?Q?BdUA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDU5OUdSL3lOei9UczVobXJRY2hidGRjYks2RG1zVGlPeFpZb3RZZmxOTy9W?=
 =?utf-8?B?alhZMjRpMzJvRzdIdXNmNTFTbm5iUTRnMllRTHNVMENjRU1tYU1WLzdMZFZT?=
 =?utf-8?B?azh5NU12VUFsbGVGdEFtZW1xK2FxM0M3YVlXbmszZEoyWC9kNVZ3RlJoaURB?=
 =?utf-8?B?eDFqdDc3ci9hWkppcHZNVHgwTkNyUEdSRnc5NnNTSXRsMlhlZzBlWUdKU2Yv?=
 =?utf-8?B?QTdFa2swblNZVzgwTXFKeHdYWCtZRThZUHVBUkhLUWxEcThZcEtQZDJySCtP?=
 =?utf-8?B?a1BXbVp3NlFROWk5bWJ0WEF6WnNpTGNzTUJqb0tZV0FDTHZ3eDF2S3ExRU5k?=
 =?utf-8?B?aDRSdFFkazNZakJXQXBIVFVHVGdHZ2NTWStjdDdqSEZSYWVxWnZ0Y0hoVWNW?=
 =?utf-8?B?Sm9PbmdrSUlieVRqTXBlZ1ZqL05rMFJ3WngxdjNIb2U4NDl2YS9MVnNkT21M?=
 =?utf-8?B?ZUZmcWQ5emVkRzlOa3RPVlFiK21Sb2xLRkI5cFU3WGF6ekRWNElrSFZuY2NB?=
 =?utf-8?B?VWpQS1hvOWZkS1cvSnNIdGE3Q29xR0dHQ25aVmIrQmZKTnhSditsUGRjUkNv?=
 =?utf-8?B?U0M2OFZlVW9JUXY5dm5pMllJVDAyazdGY1dtenhmYkE2ZGhiTzYwOCtNS1ZB?=
 =?utf-8?B?dkhlY21ZbGgvM3ZNVW5keTVWQ3RoTWtvV2hCUTdvd0piN25qTTZXWFlDTmI1?=
 =?utf-8?B?cGdseTlMWFp4SWZVUmdWZHlkQnUrSmFDa2lYdEx6T29SSE9ueHpHL20rNFVN?=
 =?utf-8?B?cFpxYVZIWk9WYytZS2d0MXNrNlBqeVIwVEhubE1naUlDVnhXeUZ1TFdHdHF5?=
 =?utf-8?B?aitaYnk0M3FUeGQ2ZHBZU0xrS210aERCbXcrdWh4YnZrQ2ZUTHFIa3RoN09q?=
 =?utf-8?B?eTZpaFcxWi9RS2Zud1dqWC9lempZWUxCZ1BKS0VlWEJ1Tk5mWTNtN2xBVFpW?=
 =?utf-8?B?WjNGLzErKzdTbVR6TzZWbHpqdGZVTGhHS2dqbkx6VmF0dkhpelpxVERBYjdx?=
 =?utf-8?B?YS9SRW12d2F1WDBVaktUWTJkQkFWdi9YajluZFRuKzVjcW9BQ1c2bWFGR1cv?=
 =?utf-8?B?TzZvdGhuOWE1TFB4SFh0NllQVi9HZ0lZR0wzR3oxQXhRd0Nkem5UVlhyMzBj?=
 =?utf-8?B?NllpSjJlYVpOQlJ6dUZ0elBUSGpST3F2KzlhUlRXYUVMTkxNTXhUZGxmREI2?=
 =?utf-8?B?MEc1aHNPajlRNk9vKzFBQ2VtUlVkekZndDBzcjArUVRRaEJrQklSUHloQzNN?=
 =?utf-8?B?bWdTTmI4ck5pVEtZbGtWRXBzRjZmd3BuYmdGeW9hbFozU1NUUEpQT1ozQmFq?=
 =?utf-8?B?T09rZW80anFhaWsxUjZRRGMzU2RzYjZPank1bWNOTkovWTdST0xLOHVuOXlR?=
 =?utf-8?B?U1h0QXNDTWNyZzlpZzRkM0hEVDExMS9hUDVVaEUwUTM4ajdPODVlM2J1YStR?=
 =?utf-8?B?cnZKSGE5bWFJRTVER3UyQlJjM3lkUEV5TjlqUHVtbTkrdW9HQjk4WUdBZXh0?=
 =?utf-8?B?WVB5V2pVTXdKaGlIS1MrVjVuelJnUmxJYVdSZW1SQVJwRk1ncjQ2Z1lldEFo?=
 =?utf-8?B?Wm8wb2VndFZSUVFpaERZWUhteG5KMmVzVXU1SzZFWUR6a2IrMG0vUTFSZXVG?=
 =?utf-8?B?TUtIYmdZTGdJMGJXSys1cGhUUEk2MTlVaDBjZUpIZzIzN2V5S2RIRXlkdXhL?=
 =?utf-8?B?Y0Z3OWNDdmlGay8wcjZSaURnNm96L3dsampWOWhLQ2tMWjdMSjZiYUFra0ll?=
 =?utf-8?B?YUE1YlFLMnBwb3J2T1pGOVFISm1aQmhhMzVuVzE3SkJDV0lIdGloT2orTEx3?=
 =?utf-8?B?MDRDdjYwbnl4d29GSWpLWExMTnRpWVhzTC9WWVd0azNCb2Myem01cUVkTnpW?=
 =?utf-8?B?Z00xRWFVM3ZvQitDM0VYVEJmN3VJYnpjK3J0VG9HbDBMRmhmMHdGcHBiUmdV?=
 =?utf-8?B?ZkFuaHRUajRKdGNhSnlMSTRLYVlBck5hNVFjaDl4L2lNQmIrY1dNbUJQZXlH?=
 =?utf-8?B?OFpJRTYvSVBxbTVWMWQvUTZIdVVzTW03SDYxeUNLcGdGZFJZaXVIdzZKVmk0?=
 =?utf-8?B?MzR5bDlyOG9lSW5yMTZpaU5kOWsvaFF4bnhEeCtKSW9sSGFQeUxhK3IzWmJS?=
 =?utf-8?B?ZExDQldaQmFMSGpiZmpzK2VxdlFOc2ZZZ3FvdXhsam9qSnFUbHA0MlVjK0tw?=
 =?utf-8?B?VkVDY29TbzFSMUY5VDEwUVV2WU92aGh1TTFBejRlb2hnZFVzdXQySUtDTmVZ?=
 =?utf-8?B?amo1VkxielVKeWhVbnpSSys1V1EvK1cwdzhSWC9qWEhZVy9xZVdLRWcxcFJx?=
 =?utf-8?B?ZUZhTVZyQU5ETElYc3laQVc3a2dEQVY3OFAyMHJxbHErMHV4NWlhdGpWLytX?=
 =?utf-8?Q?xdGych8cIWTdycevFfxOkNfoIYZrAYvwzqKXn1iihFUre?=
X-MS-Exchange-AntiSpam-MessageData-1: UYxeM0P06tYbmmxkmhep4wE/LcS9TF6sgKA=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1400d628-33b5-4c7b-7cd7-08de73a7f5f4
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 13:23:55.7744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SltkP3F4bNCHdw0RmISHwujVZPGv5FFnwNpt/7cvBTrfiMrezP3XliSMQ/gfjcf1lM2HfDZ+dRTNuhl+JvvFZfWp9mQxfHm8HeLWnx+prbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6086
X-Rspamd-Queue-Id: 90738C000C
X-Stat-Signature: hkeptu5imo97s91rcs6yqj6tc68fordy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771939439-693966
X-HE-Meta: U2FsdGVkX19wH0opxFKyPyl1EwI+Z/TtMKep+HBqYwHInX2Jp/aJg7zd3uew3JLQqq9dUJffTliEfeiVD0Yk5x1xOcMnzMmmCRX0/Pr8yqCWENSHuAdF2nUeiekySKGTPJzmyHEcrsmtLGm4l2VVSIezB/69AvfgN5ytETpNOSkVgdZVYNIf1IrYb+4RZcA6z5Ao75n0Wv1goFjttX/GXjZZ4hjfKJAOILAY5bpnLaIhSosXRnVQwbil2QCjek5uO488yQOQmbAadcqOKhhVEdu2QA1VrzdkF/+doyDlU80GbpRNBUU2vaheAh1oYbcKy5hZAqd4eA5WcKZWP9bblFU/nHZJaaQK/Q/vr4T9ENb7ukoy4g8SGtVjARiSGJ3BRvwAa9MUBiCpZ3laYpIBtbu9HjGwlJOwNViBk9zHmE1C0TBD3kj43R8yccRtsG7lnSBEnUdfvRxsq79n370Qz2zWemKwmzyQxcDTnloi7SHhvVT+fI9PlKlqZ/duU01rQWl2hTA0grwFfSj/rMxfCwSYmMwwHYU7KdMYWR75Pk7FqIaR4G312hUDeofHjiWrsFTY3iDwtC9STrDNX2E+tLFj4NhsTC2A39H/i824KiPnbvtA2pvoIGiTu/D5ZLIS9DTm82O6BaLNcCTsnGMaTJ7V1POULxQPb+mWawNSDUXxDyMlPceai7srowTeVKtKKxG8Ukba8JR0n84GwBkciRuuAMFzx3esWmsV8KZF0XP28vrzsH+JZPAkMSKWVJNDM0TBQxfFhgX/sAImefDzc0vcT4z84fkjcp0JABrlhmTDDmdlY5ev4Ph2vb+B8ooizvdGkR4l7vVCWZjN/1O3J7AW3y+GN9mfMnll0BRXk8GW1/EuMFvaJmGkhnxudq6JRfZ7Qj/InsYFofZbPix3gFbElAx6feBQl1fwEBHbrk0Xr6dgz0t5G3ek0ghCeV6znHbGdofEBnaVu5CI38+
 RSaM/3GA
 y/mwh7M3nx1dPQF+jyyFJE1sumu+P3amt7F5e1u/gRtEjaEKp73v91Carxj7Tnz4bxyc+8edt4KfKH3uYfDMzvD88S5kIOWS99Qa3eStkiWTvveJ1bi0qObXG7C+mtGIsTzSLPT4StPzeTjz9DwY4hBGtlSuQIGcOGJT24ecy8RMK5XsSnP4wgOxqv5/SOwPt/LauRijJaIhgxidZLrisGvsnzpjnm7wUkkUnMNIisMhuVPXmTpLtHVbtrmjNTOrgCSSVCliYHk/1VpWU8f4LZLksmGsymt8muITM8YN6SSxd11KxFYt3gh1hl6rpNdgiSa8bmS3nGPLxap+fc7Fhstp7Sc27h7LwYc7Cw5LbVvKSkQKFEfcNbJPv6ZOBMok4ht6VjW3sZB/XO5y3kn5+LvOLZVCcMUVs5u9U6hTEBGwErlSYXDXunp5FL1BeIhbuQutcl5fh9JRgV2/4QWvp9AB044k5RgcYjxwC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/24/26 13:09, Oleg Nesterov wrote:
> On 02/23, Pavel Tikhomirov wrote:
>>
>> To avoid possible problems related to cpu/compiler optimizations around
>> ->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
>> everywhere we write it and use READ_ONCE everywhere we read it without
>> explicit lock.
> 
> Yes, this is what I meant... but I can never recall if READ_ONCE() alone
> is enough to make KCSAN happy...

AFAICS this should be fine for memory safety of accesses to ->child_reaper.
I would love if someone more experienced in this area would confirm.

> 
> I won't insist, but I think it would be better to do this in a separate
> change for documenation purposes and for discussion.

Ok, will do. It will be a bit ugly as I will first add READ_ONCE to the
pidns_for_children_get() and then remove the hunk with it in the next patch.

> 
>> @@ -247,8 +247,9 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>>  			 * alreay in use. Return EEXIST in that case.
>>  			 */
>>  			if (nr == -ENOSPC)
>> -
>>  				nr = -EEXIST;
>> +		} else if (!READ_ONCE(tmp->child_reaper) && idr_get_cursor(&tmp->idr) != 0) {
>> +			nr = -EINVAL;
>>  		} else {
> 
> Oh, this doesn't look clear/clean... This even looks racy even if it is not.
> Can you move this check into the "else" branch which does another get_cursor
> and unify this check with the RESERVED_PIDS check?
> 
> Either way, I don't like the fact we check ->child_reaper != NULL twice.

Notice that we don't really read it twice, it is only twice in code but any real
execution either passes the first check or the second one, not both at the same
time as they are in tid set/unset branches correspondingly.

> Perhaps something like the preparational patch below makes sense ? Not
> sure this is actually better...

This looks more universal at least, as instead of two checks we have one in one
place. My only concern of putting the check where I put it was to avoid extra
idr_alloc_cyclic() + idr_remove(), if we already know we don't need it. But it's
only in last pid_namespace we can have ->child_reaper unset so we do alloc/remove
for all other namespaces anyway in error case, should not be a big deal.

I will add the preparation patches: for below patch and related to _ONCE.

> 
> Oleg.
> 
> --- x/kernel/pid.c
> +++ x/kernel/pid.c
> @@ -215,12 +215,6 @@ struct pid *alloc_pid(struct pid_namespa
>  			retval = -EINVAL;
>  			if (tid < 1 || tid >= pid_max[ns->level - i])
>  				goto out_abort;
> -			/*
> -			 * Also fail if a PID != 1 is requested and
> -			 * no PID 1 exists.
> -			 */
> -			if (tid != 1 && !tmp->child_reaper)
> -				goto out_abort;
>  			retval = -EPERM;
>  			if (!checkpoint_restore_ns_capable(tmp->user_ns))
>  				goto out_abort;
> @@ -299,6 +293,11 @@ struct pid *alloc_pid(struct pid_namespa
>  		tmp = tmp->parent;
>  		i--;
>  		retried_preload = false;
> +
> +		if (!READ_ONCE(tmp->child_reaper) && nr != 1) {
> +			retval = -EINVAL;
> +			goto out_free;
> +		}
>  	}
>  
>  	/*
> 

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.


