Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEF8C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AAE86B0095; Mon,  4 Aug 2025 05:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C0E6B0096; Mon,  4 Aug 2025 05:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E654C6B009A; Mon,  4 Aug 2025 05:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2B9C6B0095
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:22:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 880551367EB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:22:17 +0000 (UTC)
X-FDA: 83738533914.15.1B2557F
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9CBCDC0007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:22:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Np1idC6j;
	spf=pass (imf28.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.212.73 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754299334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHdeoYBdXFgfCR1PCftPtzyyfd43widQX4L1cYvLxcg=;
	b=YK7l3dS1PksDqxqsrnK76QNP94GuZAxby7HoOKNhJMGW2ViEPXdjJhear7v9ACI2F615U9
	hETdgouOPEQ/g4VWHZNKqQkYDoATYG/wl8Lj88+WOPWE9m3KVgOZniF9IHRKVc88tZjP6X
	8wrZILGDZlGq3jC3LWAyvgEvGl/XAnk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754299334; a=rsa-sha256;
	cv=pass;
	b=5CeXu1hEDDVCRIJtkSukb/xQuGnSQ+P88Z0OupKPZErmKz+O0BTZ5nwnMRWqPglJ30uy+z
	JhBTWkpP9UqRQXbqq3yajHUIgYU7ALh70xw1SaiZpN2bOOPq/jx0Yqna49D7ROW+xVrSse
	2WqrxVuuxdF1Sn40QOLSu/N18b+0Mxw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Np1idC6j;
	spf=pass (imf28.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.212.73 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NOGptYdAXIeLPU64yRwmYJXMzUL4MT3zcs9hYuZesxXB33N4m/VBBea5rNlfDrPpwWw49GDGJ8Lo6Ldo68TI/VZsVj2sv/AJJ2fuVuQTAdp86BYtbWaXZ2dzqTmn0DNNroMcZgr37fBOuZh+a9aNN/ZB59pohr32jbp3XhfgCWi88zIfDG06noT+MKoB5eDie5HTJRSEEC1MuHMyILcmX+hRF/bXMOQVt7jeyqtp6oHC7/s3RYTiU/iwOJhtycw6O/BwycydtrEKjKdLolU4jXRCw0keZankV34rO3O18yxpflWDHhcWjpolyfic9M03YceGgcRklJbgdWVDJNeGoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHdeoYBdXFgfCR1PCftPtzyyfd43widQX4L1cYvLxcg=;
 b=eGWOSLCVF9p9ogG4zVnXT13mMPsRq9JJXgEvhCQhXKrpYQf452wR3bkXS6OHWuaZHXgOy3kdcbjxN3//t//76a99nhjBI/L8HNl0+YE09xzChj3nSxEDcqPIxQmLuhIODCVo+R1LnU+YHa8MZxhTR0bCg82Dv57mcGrX3Xqvebn7jRuGMBfKOokz4dfSnEMfKUBnLK7qSa/cjkQWCPwlF4taG2i/Bp7StS+vjNWBWmJNQnorQahM9ZF1XqW+jzkWJZlZ0m5By1pToINL0La8OluUbUodFL58EIMqXZuI+0yMwhaTG9YGKg1Kt2b0SgNiCcUc63i7OXkNyuMcS8roIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHdeoYBdXFgfCR1PCftPtzyyfd43widQX4L1cYvLxcg=;
 b=Np1idC6jYm5xls2akKV74P9vTaO7c9joajKtH+TM/yQQb97jc9idUSIQVnpS2+murXbv1IANj/3Ccup9cYue7gKDnt9stMjpgDzMsG2yI915pJaqjpYmnKdwRHxqCE0NJVsf/0ysvQxtxxAuvO+IEGkAK5L42uV8/e3Gc+Iddr8=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ5PPF5D591B24D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::994) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Mon, 4 Aug
 2025 09:22:09 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 09:22:09 +0000
Message-ID: <903cbf42-2fde-4e38-89e4-2d7287b845bf@amd.com>
Date: Mon, 4 Aug 2025 11:22:05 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/18] ttm/pool: enable memcg tracking and shrinker. (v2)
To: David Airlie <airlied@redhat.com>
Cc: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
 Dave Chinner <david@fromorbit.com>, Kairui Song <kasong@tencent.com>
References: <20250714052243.1149732-1-airlied@gmail.com>
 <20250714052243.1149732-14-airlied@gmail.com>
 <77949b3a-201d-4e7d-a51f-e77274e4a4be@amd.com>
 <CAMwc25qP-42wMX4UYhZWiYfvf_1dBVNL9TU9i_Wq7uZPqjQL5Q@mail.gmail.com>
 <CAMwc25pyqhcq-8ubGZT5UX5AYroewBYP6oFN-JmjzEkHgFLTrg@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CAMwc25pyqhcq-8ubGZT5UX5AYroewBYP6oFN-JmjzEkHgFLTrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0007.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::17)
 To PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ5PPF5D591B24D:EE_
X-MS-Office365-Filtering-Correlation-Id: a3464d66-e17a-4b69-6539-08ddd338633f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anJjU3paYitvR3ZuL2JMbzJTbWM0ZmJPLyttVVRwcFVLc3VJNTdqRTNPdS9P?=
 =?utf-8?B?S3E4RHZ6N1hHa21VVitjdTc0NndnVWJCb3RuZjVtRm9vM1pnNm5MaDQvc01K?=
 =?utf-8?B?c01haGRuRndHakg0eVlKcEs4US93clRlNzNSc1VWc1A5MjUvbUE1Nk1GTkRZ?=
 =?utf-8?B?Z2FES2JJQSs4Q1ppVlRkTE94bjdBKzJKS0VLdi9NaExCSERyOU1NUEpvUkd2?=
 =?utf-8?B?eXBjdi8rWFUzR3R6K0VyQUlZZ0g2bUsrbTVhbWp4N0tNWmJTd0JmQXhrUC9F?=
 =?utf-8?B?WEdaVXpjeExEdVpGM004UzVyL0tWQk1Ra01hYk8vL2IyaEhmbmkxcGw3aXJx?=
 =?utf-8?B?QWxkQWNtK0t4U3BWQzRvUGNPdWUweU9zb1VXNUo1d0VheXFvK2NzUXV0d0g5?=
 =?utf-8?B?bVprU201VkpscllEa3N4bWJiTzJVbVhVRzdxdlI0R0JpYXFWRTlKR252RVov?=
 =?utf-8?B?dnlPa3BiNThYWXViU1NkVTV6K1UyL21WUUtORGNObjdjSk8wVWkvcytqZGE5?=
 =?utf-8?B?QXpweEdKOU9LQXJ0dEtBcFpjc3pFSUJRTWQwL203WTFSS2d3RVJoQ2JKKzk2?=
 =?utf-8?B?b3VaWFNYTU9PUzV0cmoza1hmYllOMjJSZXgzdWJTbDJPcWtGU2RuVUpOa3ZE?=
 =?utf-8?B?WGMxb29VQ2lSalRNR0VVOEs0TXZYOTRxYTBteUFuTk9pRUpZQmZWK1VJVlhw?=
 =?utf-8?B?Wk1yb2tYZlFJTkd6WVJnbkpKdm5NY1FwdEF6Sk5SMzNkVGVLbXIyY2FQSDZW?=
 =?utf-8?B?OVR4MEhGUUN5ZFlHMUNXc2dBZWpDYVpLSmxQcVpmcDRjRmltbzRTUXpWbmdF?=
 =?utf-8?B?M2ozVHB5Ym1kR2pTWE16SDA1WDMrWGlzc1R6N0hkN0hsSmhSTDhzMXZ6Mno2?=
 =?utf-8?B?dTh2ajVleTc1NnJRNzFnS2JUNk16bU14cVh4c09HTzMzRityczQzYnczdGk0?=
 =?utf-8?B?WG9KT1ZMbmYyUHNtY29Ya0dZZkUzMWVaRmNFcXNZVDFGOXVnQ3N0YTRweXVm?=
 =?utf-8?B?RnM0bXczUUdzd1ZNYWFYWExHNEN3dGcxZGlOZkwwZWpIWFltRGFrRU1KV056?=
 =?utf-8?B?dzhkMWlBd3BDYmtwci9KT1B4UGh4Z1JKSS9wUUo3RU1xekJ1cHNZUWovZlVT?=
 =?utf-8?B?QmsxQjlHdmZ0Qytwc1o4UTh5aFRiS2hNZE4xYjZpQjhMYVM3b0FaSFAwMlhR?=
 =?utf-8?B?a2xFS3U3d1FORTVYU1NXVTZKK2YvWEZvRSsyTzNrOERuZ1lsUGVDSUEra295?=
 =?utf-8?B?d0c0U0VXTk5ZcU1ab0VZRzhDSTlUVGwvU3hDOXRpSUxOVTFsdkszak1wQmZN?=
 =?utf-8?B?MnVteVRvaEd0QUdQbnFQRXpoaUZuUVE2QWxQY3Uzd1VmZVY1czk4eldhd0Vi?=
 =?utf-8?B?MHZNMlNsWVV3MEtYaERBbXdwWUhVREFjZW9qVFhNYmRPajEwYnJNOGFNbmsz?=
 =?utf-8?B?aGhaWFlHY1pzSHpaRVdYSUMyM3FQeC9xSmd3M1RBTlprUklpNEJKWkkwaGNs?=
 =?utf-8?B?TXJSS2h0eE9tR28rSmdQSmxKVTlHWER1Q2ErSWlmVUM1UldpbXdjclUzSTV5?=
 =?utf-8?B?aWxRbUVIeE8zSkxac1VWcS9lLy9uNFg4VUhkMFEzZGErY092UDNaOVpGYUFC?=
 =?utf-8?B?TFg1R0FiU1hSVG5qazFvd25BRytVRXYzOWRrSnZWdmpSQWdCbEk0NzEzcFVm?=
 =?utf-8?B?eEpRM29LdjN0RFUrWTZFbytTQ1g5cXpNZXVLaUswVkZORS83Vm1DNExpSFl4?=
 =?utf-8?B?ckUzUFRYNmZlUVVVQmFPdzQyS3J6WDE3NGI5YmZUSHpBSnpjMnhtQmlRSUxY?=
 =?utf-8?B?dkFjZjZCeldzS29qWllQU3dFbFlkemFOVG0xWkZaMGJNNEFkT2QvdWs3SVov?=
 =?utf-8?B?bDRuZUpNOFlxL2FtYTB5QUNscjNhMnVLSXh1THpVRDNCSVdwMVNKSVZoNmVM?=
 =?utf-8?Q?A3nfLcqE5NM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWhMdThqa2pIN1RqeTlhRmN4MGdDMUZ0SWcxQU5JUmtJbUxmMEtnRGFITit2?=
 =?utf-8?B?OUtOUjQ0cE43d1dtcWJySFFRZVhGdVJwSllmckNVbk90M2U3WHVXN2xNZStT?=
 =?utf-8?B?bDh5SkJXVWlJZDhmbXMvbzFsSXd0Z0NaWFdpMVljVW5hT3J4SWVSWUdxWVNa?=
 =?utf-8?B?UkRTam1ycEhwVnB4QS9OOElBWEsySW1DSCtYekhoWXoxbzV0K3hHUXVERkVO?=
 =?utf-8?B?UzZIN3hQWXBQd1orSXM4L1dxeWNMbkx5eHhmbTJyd3hGL3JqRUpzTnhLRmVJ?=
 =?utf-8?B?d0R1WFBVWFo1MGdpZ2hQUmJpeUVJbDcvcXJlMUk1NSszZmFVNzlubXFLM0l0?=
 =?utf-8?B?eFJ5a2taK3ZLb010WU9CeE52SVJ1eTdHcVdJTXRtZElvWVhrYmNMeG14bVRW?=
 =?utf-8?B?YTZadDNDYk5qNVdxekhDQnBVVERlM3hieEdPdnpqS2FETlkxTm80NDg0Ui9m?=
 =?utf-8?B?OWtZRk1lU0tmd0VaSHd6RzhQUkFPMU5GSE45UGg4bkVqY2RYbzQwZ0duZXRq?=
 =?utf-8?B?elY3YTVwaW9VSTdtaFcyeDhvU3BBWmVnNXBrd01TSlp5MWxmczBSejU2dDNK?=
 =?utf-8?B?Vks1dC9KdStBKzV6L3hLMnRXT2tRZHNmekJiQVZUS2w1WjBKVXNueXV3TCtS?=
 =?utf-8?B?WWpPcVRpeEZlZTEvdk5MWVR3Tmx2SW5jMUladHdzNk8vbmRGV3dmMGdYbnMx?=
 =?utf-8?B?QkU5QTlLaDBGU3pwdWcveGFKbTdwaXIvMU51MjM4Vmt0My91Mm9CQis4ZlFN?=
 =?utf-8?B?M0Z5cVBGQXhkWGVaWEx2bkoyRitNWVg2eHQ3Q055MEhibTVqQ08xcEdKYVds?=
 =?utf-8?B?UTlRelR0Z3V6Umo2MXA0NE1DRkRSZEtmMmFYMXFoNlNuK0xQQ2dIdUgwWmhI?=
 =?utf-8?B?aVFBcGVERHE3SENVcGZnK2VPWnNZQkpZaHYwTEkwTDZZdCtFQXIwYlhVY2Yy?=
 =?utf-8?B?dFhSWFpYRzlUMGR0QUVRNmNGNDJtUlI1bExOWUZ2MnpqdnpaNENKWUhwTWRi?=
 =?utf-8?B?cFM1amhuTmFoR2Q0WTM0VWV5NjRLRmg2S2pYVjhJd04yT1VaU09jTVRWV2hz?=
 =?utf-8?B?dXRnSHoxYVo1em5MTG9uWEh2UGplWFV1STg0YTBkdC9aUHdBOE55UjROa21I?=
 =?utf-8?B?NGpXdGQ5NlkzaVo3NkJBb3NyN1B6L1R2WTV4ZzJFSjV2QlpWMFhOdEMvUXV4?=
 =?utf-8?B?em5VNkJXU1Z3NG05MnN1aGlhOVVqaytSZGt6WVY5NlZhMC9iMVIrZTBIQSts?=
 =?utf-8?B?Z1kvRUZxQithOW14QUNmc0VOSFg3NzFla1VFaDhQeGhJa1FYRFVWR0hkVG1U?=
 =?utf-8?B?bWJzeVZ1L3didlRsTXF0dzZ1SlJtOUVJbDgxdmEreHNxWmJ1T0t0eHo2R2lm?=
 =?utf-8?B?NWpGOUxsSDN3elBkdEw3U3JERUlVRUl2MVR2SExZYlZDU1owZEVVcEtMM0pp?=
 =?utf-8?B?dkRmc3p1c0o1aTduVGg0b3ZvYVYxZklqK21TR2gyVnQ4OTRVQk5kQ2NmNGY1?=
 =?utf-8?B?VGJzZFl5eERTNmVnK1NsN1Rtbi9UTkNaNDBsMWFqT3Y2WStGSFBtaFIzeDJP?=
 =?utf-8?B?eEp5dFJyS3kxTW0rSDFUNUl5cWdLTzYvaVk1VkRQRkpZYlVMN25hYkNOK1E2?=
 =?utf-8?B?b2Zhd0dMUjZ0bmpkMEhlejdiQU01bEY3amxjYitveVFEQlRUT3g5dkg4WERv?=
 =?utf-8?B?WGNDR2pObVJicFpRbVJwYmhEZCtqYW5JbzgyUE55QW1Xc3BaMXZyR3d2Z0Ir?=
 =?utf-8?B?bHdnVjFoR2dZVituUFRZeDFsaGJFRC8rb3hiSFp5T0hsT0I0SFU5Wnh2bHlE?=
 =?utf-8?B?RitoVG8zVGRHVS9LeFZ1cThwOExNVUpUMlc2L0Vqbm9FcG9oMjhSNnYrOWE0?=
 =?utf-8?B?Wm9YVE9kUHAycS85YkZqT2RDY3ZkUVVQTGpzVDd5OGZRUUlIbzBjUUUrMTY0?=
 =?utf-8?B?M21hNDRxZ3p3ZUtIK1JTRmgxQXdiQXU3ZVYrajBsMzBNZ2lBeUc1b1BUSHNt?=
 =?utf-8?B?NWtJMkY3aHB2MTVuaG9YRDZXQThTTG4vVmVlaDUyMG8rMmVGSVppVlg4SGFC?=
 =?utf-8?B?MjZMbXRHRWpaYXFWT3VFcVExVU5uNXlOTjIxL1Z0enJOR1lkbEZxOWVNWGRW?=
 =?utf-8?Q?1w/A=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3464d66-e17a-4b69-6539-08ddd338633f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 09:22:09.5754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vha23ms+yYNkom59kruvg3YlcFePAWZNYixEGl0Cbjc9gKhwpARQClDLW4HGak2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5D591B24D
X-Rspamd-Queue-Id: 9CBCDC0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: soipb8nqc4hmnh3q8xqmn83fhugbz1yj
X-HE-Tag: 1754299334-86571
X-HE-Meta: U2FsdGVkX18AO2A9vcYuiiDzJeBY7mQzTMetQ9HqpcjZemKVOW4NTqyptw23Nv/gPcFhl34wAnqqTdzAo/x5YD46oUB6p5PVF8KHusiooiKmrXeX/7AJwFoKwFxyk/CcKn9maXUapCTlgEofW2wLTaQfupXYnm1xmXO3ajkNU3vlwk7WxyvC5cYhG40bDBo+bL4sYKPcQhAcCuPTj8o9VVxNqRaV2biSnTBxxaad0QyGuy5QVlKztzkn+4ZeL1RKA7NesO4s0N3Ersy4dif6+oXrNuzHrJyEplz8SSQPWd4BuVwDIbWobx0e9tyL4kCBIhhwX6AptN98xqPLV+fDd+X19qwPONsETC3ykv4Gm4vbBlDMslr8tkBmkPA7uzf2lYaS8bcTBW/lNAV8N7VGdC/D86Iw49ZT9ADd4A3on6+uwbWEULfLFzJ2W2xuQ9IjqmILwOzqSUZzIxptV/prjB24uV7LEgHhQPGC8J2iXrrAaykEURYVTAd1Kcat7wbh61vMaWs0kbA5bkRqxtVHCAIf1BNhKR/hGskRDkmuPW/lg+0nJskcTGLhuEjfk27GzgrQxRq/mRWG8y/zVD8htuQ/M6r+6SlXs+/CsLKOQz4OO4lrCVsiaPYc7fvqSZgJfdRBEA6NMhKwxMOkE2cgDc8ShSaSW8MzO7qGNGf/KsTejcHvlE94zF6N1sMPt/f9op+SwGTtCnTHB61xYJLigjIqOo5QIz05aKY6P+RLF5WIsUJeydMUsplSMLJ+fdxPLfAtBhONgquMaiELl2XF0Rtksa4EPOkScMu2swDQK+C0XaIUrIAyIE5Ki4ReqzLCFgkByKYOfpvrxzE4fBOhIpobuPaL3k9QSBUT9KlArLdD2I00DpfWuYB1IeDF/KDoBs7GT5OGl3eQVT8pSBoy7ixdaDaORyJfOwzY9CZJ20o1Hdd0+/5+9ldYseWrxiKGzcIeSWOmQJ9FqIJGllB
 S0KVdT4s
 3F7miESOevG2l/eBd8Vh3T/AQ0MTwBoCNHd/9hbYs9n3NLcI7t3ctInMrx8yjEI4kwN1K1OtUOQseAYTkeAT37flq58/8E4AFzPj3LJwgkCPAgZEtevF8gFuf+HUPSKEMXetSZdXAMiYPot9DhxF6NEEHJLAN0NROlIYPyOdJrQY/vdSEcCxJ+kcxnZy4+79rOtB4xOmrQxBzjrKSx9j2C8PiEbLiRt1oEVJH9WUwLXg86NQH1RR1ldT8GsXS9IjcAi91DiUOjTbVOXLKE1Q2UDSWIbkVj6Pq/V5ACrjsWyhVVIEvpHzr5dZVGi6jkaX/Irr5RmhB6HTE+EZ+5wJfUz/66Mthrz/2dZBftx3ozrr/8C/pNmaM2+jg+CsNREC/3A3NSE+WiQhmId7k0KwXGzvuqUP9NXR/+2jAvS25H6V2Nid/K5hy2OePkqHBKKSQB2JUjCb5JpB5gGBKEETSvcy3Cy0Ek4vpK4kTYgzNzWB0rxLd2fz+nM8bCDCF7qZiEQyaANV1VX+MhIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the delayed response, just back from vacation.

On 22.07.25 01:16, David Airlie wrote:
>>>> @@ -162,7 +164,10 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
>>>>               p = alloc_pages_node(pool->nid, gfp_flags, order);
>>>>               if (p) {
>>>>                       p->private = order;
>>>> -                     mod_node_page_state(NODE_DATA(page_to_nid(p)), NR_GPU_ACTIVE, (1 << order));
>>>> +                     if (!mem_cgroup_charge_gpu_page(objcg, p, order, gfp_flags, false)) {
>>>
>>> Thinking more about it that is way to late. At this point we can't fail the allocation any more.
>>>
>>
>> I've tested it at least works, but there is a bit of a problem with
>> it, because if we fail a 10 order allocation, it tries to fallback
>> down the order hierarchy, when there is no point since it can't
>> account the maximum size.
>>
>>> Otherwise we either completely break suspend or don't account system allocations to the correctly any more after resume.
>>
>> When you say suspend here, do you mean for VRAM allocations, normal
>> system RAM allocations which are accounted here shouldn't have any
>> effect on suspend/resume since they stay where they are. Currently it
>> also doesn't try account for evictions at all.

Good point, I was not considering moves during suspend as evictions. But from the code flow that should indeed work for now.

What I meant is that after resume BOs are usually not moved back into VRAM immediately. Filling VRAM is rate limited to allow quick response of desktop applications after resume.

So at least temporary we hopelessly overcommit system memory after resume. But that problem potentially goes into the same bucked as general eviction.

> I've just traced the global swapin/out paths as well and those seem
> fine for memcg at this point, since they are called only after
> populate/unpopulate. Now I haven't addressed the new xe swap paths,
> because I don't have a test path, since amdgpu doesn't support those,
> I was thinking I'd leave it on the list for when amdgpu goes to that
> path, or I can spend some time on xe.

I would really prefer that before we commit this that we have patches for both amdgpu and XE which at least demonstrate the functionality.

We are essentially defining uAPI here and when that goes wrong we can't change it any more as soon as people start depending on it.

> 
> Dave.
> 
>>>
>>> What we need is to reserve the memory on BO allocation and commit it when the TT backend is populated.
>>
>> I'm not sure what reserve vs commit is here, mem cgroup is really just
>> reserve until you can reserve no more, it's just a single
>> charge/uncharge stage. If we try and charge and we are over the limit,
>> bad things will happen, either fail allocation or reclaim for the
>> cgroup.

Yeah, exactly that is what I think is highly problematic.

When the allocation of a buffer for an application fails in the display server you basically open up the possibility for a deny of service.

E.g. imaging that an application allocates a 4GiB BO while it's cgroup says it can only allocate 2GiB, that will work because the backing store is only allocated delayed. Now send that BO to the display server and the command submission in the display server will fail with an -ENOMEM because we exceed the cgroup of the application.

As far as I can see we also need to limit how much an application can overcommit by creating BOs without backing store.

Alternatively disallow creating BOs without backing store, but that is an uAPI change and will break at least some use cases.

Regards,
Christian.

>>
>> Regards,
>> Dave.
> 


