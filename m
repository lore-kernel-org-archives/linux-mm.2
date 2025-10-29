Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DD5CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C888E00A8; Wed, 29 Oct 2025 12:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCE28E0045; Wed, 29 Oct 2025 12:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E2B8E00A8; Wed, 29 Oct 2025 12:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0131F8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:06:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A47C514089E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:06:53 +0000 (UTC)
X-FDA: 84051630306.19.D0488F0
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf20.hostedemail.com (Postfix) with ESMTP id 580901C0013
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:06:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=PoTHz7Da;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=739746ee82=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=739746ee82=clm@meta.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761754010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEJgbpoLwjeryNYDwuCRyLWcGF/WQIlbs2qVOXSSYCc=;
	b=Aai63c3tvwHpakxEH9r+qg7mBNe7p/EnmQ/Tzm/PGI+Lyb4QFDHD1sHl1z11P7MWOZQjkX
	eyDniDrSaTWP1+mYDIHg8w9SecJV9ui4PKSk13+fBa3hr20jKTCMasPh/CK2Iam2Hnhx+r
	1rBz9b6ZGfs61zZE4cPwZwkmemohdsw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=PoTHz7Da;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=739746ee82=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=739746ee82=clm@meta.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761754010; a=rsa-sha256;
	cv=pass;
	b=jgX4XciHj3AXAtK/HzKnUsFaQvDVSvRnC5Kgsal4EUo0AAUyCSczdGi1+GxdTHq1IkQBQr
	7atsKnfhVQjWAbvUeqjlHzPKhxDDjNY5VOcACPCWU2D4UP03Nn2xeD4IMliXMQwyHfqoTC
	g1mIx8nAAwRngY9y2fGcfZmn8uv9GTg=
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59T9geiL2010276;
	Wed, 29 Oct 2025 09:06:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=pEJgbpoLwjeryNYDwuCRyLWcGF/WQIlbs2qVOXSSYCc=; b=PoTHz7DalUcn
	KNebVGqyFrlGWMUM2viCO2jBeh9gwwK9AdQchwy6e1EnVM1XCpnshceeEZNLjupL
	Ti3LA8WvGC90mc6+tQA4KbV6pSKzhuwGMd9PytmS9VQDKZK8t004Wz0Zd9EJRXpZ
	swjr3ciZRw1mUp0042zosb8FwU4yA79xjtNgV82/l54Gv/Zl22s0LyDM111q6qr4
	SAzAVtskjYnNgs1JQWlt8UtXbVUrlViN9VhHvR9plyxQsLP8+liok02/Jvj+6JMA
	Sx5Kv+RYyJKaYSNFekm6q3eu1rUnNGHu+HcaQtoGHtbTUxFi5B1i8x0mAUz+fnEK
	9T3OKyvVGQ==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012034.outbound.protection.outlook.com [52.101.43.34])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a3ghkaqrq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 09:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RzBcW6dDYU/AtRdAt4vF/P2rL4z7IZRJLlBAh7GpUCCcawhddLlYdHRkrV3WktB98t7f0A/tLCS04OcH/2/mw5n0+Mlbqo6PqbErJ4o6o3fg4qLdqt603WfON0TjDV4U12pp+qy4henhkemkr8A4VSWm+RdlcAfxMLBvIPLhELhQ2qSg0b9TXW1us5ANcIu8ThYS8QjjuJ43Y8if1fpO9VHm8VlJoJdE+3kc6+2uoH/qLkPRlfjRHeAJru/BswziO96ErvOHZQ8q8E1Rgpuc+GtSeO0UBUkdaN+iZWL7Y+Q0TrH+d0WyI3b2FFypdIS0KMKvThjiumcZysrkCnlkBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pEJgbpoLwjeryNYDwuCRyLWcGF/WQIlbs2qVOXSSYCc=;
 b=vZ2LKBLlRzHPgZrQcn8M9OD00bOKzrTALnAVA9mP1X8Q1sfkpoMOaPhJAPGCR3r0eRFHu7eeGU9C8c4LnlHHrawIXTiJUxxJg5f8Sg3fJ2dI3ussKpb4VG766FxujnlnnVNWViIh3Jiq5rJIk89p7Hhz4A+A1Y8Kubj9+uprVljiM0YApvd2Vq8KGPN/8L5XwodufsRmrUIt8sT1NNkZ7bRkarWANj5AYu/hpX5HxDG/rY2PTWuG7qyzwCs650utgnfHU8x1SB71aZWo99awNtoME/N6QRxVLvNKJbc3LvDgs8Mje3xRX8bmtTaZTYnnDnwDea5frrMNH8ax770fOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from LV3PR15MB6455.namprd15.prod.outlook.com (2603:10b6:408:1ad::10)
 by IA3PR15MB6581.namprd15.prod.outlook.com (2603:10b6:208:526::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 16:06:39 +0000
Received: from LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::8102:bfca:2805:316e]) by LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::8102:bfca:2805:316e%5]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 16:06:39 +0000
Message-ID: <09f7013d-b096-4828-a2f8-629c0a054176@meta.com>
Date: Wed, 29 Oct 2025 12:06:29 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 02/19] slab: handle pfmemalloc slabs properly with
 sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20251024142137.739555-1-clm@meta.com>
 <51cfb267-f4f4-42b2-b0ea-d29d62bb1151@suse.cz>
Content-Language: en-US
From: Chris Mason <clm@meta.com>
In-Reply-To: <51cfb267-f4f4-42b2-b0ea-d29d62bb1151@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0138.namprd04.prod.outlook.com
 (2603:10b6:408:ed::23) To LV3PR15MB6455.namprd15.prod.outlook.com
 (2603:10b6:408:1ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR15MB6455:EE_|IA3PR15MB6581:EE_
X-MS-Office365-Filtering-Correlation-Id: f4c28d8f-1b46-4e32-2355-08de17052465
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmpIbWYzSHBDcDFzTVBmVzYwL2JMOVNBcmVkS295V1dPQmlDUm1jMThSQjh5?=
 =?utf-8?B?OGVxVXNrVkN0RHp2VitUWXZWMm8zTWdhL25HUnRabFpFRHAxQlFkbys1VDhh?=
 =?utf-8?B?VjZ6TjVNb01VcFo0dFdHbWRhUFBxMFRsamJvQWxaRkpPVCthZWRGc21RNkI5?=
 =?utf-8?B?T0RCQUYvWHNBY3l1RGlYNWt3b1ZJWVRHSVlVUm1sei9ETlJ6cHZnd3o2dlo3?=
 =?utf-8?B?RFlNZHV3Z0FVcmJZa3BZOGw1Vmk2TnE1NjZvcXdzNW9UL0ZYNjR2cHRRb3g2?=
 =?utf-8?B?ZUhwSCt0c2tqQU9JaHF3RjV3T1JFczVtRnRtV1AxTXMvWktiV1FGc0ZTdzZw?=
 =?utf-8?B?VCtad3NVUldvTm1FdU5DbGs5NnFlMmNIUTVGUXY1SlJJOU43bnFMaFl6dFFv?=
 =?utf-8?B?UW16WGhBZUs1cGJOVTVvZUFBUUkzbnUreEpZczNkT1NPWmdzdDNSOU5vM2U0?=
 =?utf-8?B?M09WdWMvdzR3eWNGZC9ZZThMU2NvR3VoVVNhcFdWaDJneXNTelNpUjZhTkkz?=
 =?utf-8?B?RFB1cGxDcUxER3lxSDRvZFVZK2E4TEF1SUhrNE1wVlRnUllyZlBXZGtoaTN1?=
 =?utf-8?B?YytXWkphM0xnYnlzNnY2dWNuWldKRmdRK2ZpMVFIMVAyUFF1ZEZBa29NNktI?=
 =?utf-8?B?bW95MlJGWnpEM095UThmY2paalBrU1BPTHluSDB2UUNVVjF6SkJ1a1BRSUZq?=
 =?utf-8?B?UVVtRVhQUWF1QmRHczNNdVJjV0xKQnErd1E2enZGUGNMN1ZUc1JsbDdRdUdu?=
 =?utf-8?B?cjhUM3NmK3V1YjliUXVDd1RaMWlXM1JhV3B6eHRJM0E0S0JCUlZyL0k3ZUJx?=
 =?utf-8?B?aHNCL3FSU2ZEN1NCdGloMzV1S3MvdjFKbDlDTXhXVkUzR21JYmhlMlk0YkdJ?=
 =?utf-8?B?b3krTWdEM1pDaHBMaVZuRkZKeVJoeWRtaTgvNlVZcHNSQ2hIMVZ4MmtrYXB5?=
 =?utf-8?B?NU5OS3hHRXA1bGgvc0tHRlZCbFBTdzRKS3JnM3ZFazBZNlNVQUVwOXp3U0hI?=
 =?utf-8?B?NzlINmgwV0VZNXJrSnBWNm5WU3YxanBwbG1iRFZYY2lHazFoUzB5c3hsbGlq?=
 =?utf-8?B?OXFkOG82RnZ1RGhTU1FRR3padlMrMUh0WkYzR3BNOFZwT0RmQVNwUWtmOUlP?=
 =?utf-8?B?Z1dRbFdzTm45dC9JbHY0dm1OWlNvbHdMakxYaWV3N1JKWDRvenNLYk1KNFgx?=
 =?utf-8?B?RHNCa3FCUzVocndaUnVFTnNOVGVLNzVWcnZ0eHc2aVEwbmdSWXhnbkcyRDI2?=
 =?utf-8?B?WGR6OCtHZWV0eUdlYXZrOU9WQ2NsQWpJN2Fvbk56MmpLMEJsWFVDZWpVU2Zu?=
 =?utf-8?B?OVBEbkZLN2dWaXNrdHZTS1V6SlEzeThPakhvV29jdUVyaWhpU1J1MG5mSnly?=
 =?utf-8?B?QVJVa0ROdW80bnhLZTA0a3paYTN5UEpuVjdzN0FiWEx0WGVZdW5NQ3VVbzAv?=
 =?utf-8?B?Y0VJMDdiZUxhK0lOaHU0dXJzWUYyV3VmaU82ZXU4aHc2VWJydUZpYXdlQjFi?=
 =?utf-8?B?TnQzcHd2YWdZTnZMVVlTVFZqWTBvUTFIeWJ5TXJUTk93MkhaOVBlaUNCYkF3?=
 =?utf-8?B?R096b1dXT3czMDUwTlJlZkJOTG1BNEhtYkNqUjdEVDlwanpOMDJYZTZwTExY?=
 =?utf-8?B?TklpQ25jL0x6aTN0ZnBVNjJqZ1k3S3FyYjFHQUtqT2xPZUJ6eXg1MktURVdU?=
 =?utf-8?B?SEdSRVpZNS9LcFVGRnl6aXNQQ3F2S2tpcU1oV1FiUEYySGpFVmVSMmZkZlp5?=
 =?utf-8?B?SWZiaTQvbkJnNVhiaU1OTnNTSGlpVWJCczJnOTBJTG03Q1ZSdnQ0MjFJay9k?=
 =?utf-8?B?MzZmOGR3V3Qva29vRXE0UUR4Z2xPck9YMzdzcUtEZXlNTEozODh3SVNHMStY?=
 =?utf-8?B?LzIyVHZxUTdOMjZFcFhYV1NuSVREY1E3Q0NIT2oza2x3WnZiRzAyaUkrbnRz?=
 =?utf-8?Q?zG3RZfPbR2lTDAgbi3NTmMvUoCS/cIyH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR15MB6455.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzVIWHNZVTFnWHI2NWhrbUtQYU5qY1RldnpZc1FEaUhDcjNZdnZROUpJYTFV?=
 =?utf-8?B?SUt6TWxBQjFHOVJvV09yTkJUT1NTbFppNkwwTFJpZDFQRFd1alZVQTduTm9l?=
 =?utf-8?B?YlhzL0MrU0ZiQjV2UDRyZkowS2RXY25LcUZNM2g1Qi82NDA3VjZibUJ6V2hh?=
 =?utf-8?B?a252SCtiayt2V2FKUXpDS3RVTGtQUy9WMEVkdkh2SUxJWnQ1djdZL2IwcFpH?=
 =?utf-8?B?SzQraXBpNUpxYlluUkhRZ3Q0MFNlQWl3ZGxRODloR0lNdWRjRmdhNWxidWlk?=
 =?utf-8?B?c1lkNGtUWUhQRTRlTE1OWk50SWVqWEE0M2huOGUwZC9QTEVNMFJPS0NaMjhP?=
 =?utf-8?B?eDcvVUJ1dGxOTlc1c1l3ZVlKS0hVUk1vYmdQd0phWnZCc3lINTd4ODFtYWh3?=
 =?utf-8?B?V29qVTA3ZlV1OWF5Yk9nS0VWY1AwakZJZ3l4OWxHazEzWEF2ZkNmZHFYNS9v?=
 =?utf-8?B?WEo1cUdLVWw5Vm1zVjVhS3NNQm5jYnpTbG53d3ZiNWlFbWlBYXg1a0VBb2dD?=
 =?utf-8?B?L2Q2MTBJZE5ZOU92NnlCYUFPa2Z5N3hrSE9wZDA4bHNZU1lWTU9nODdZYWhU?=
 =?utf-8?B?eDJKUDUvV3VFVHJVTGJZVW81ZzduOXFpUFZ5eUpDcDlIZURhRUcyRE5WRHNS?=
 =?utf-8?B?c2pBR0NWS0hiT0sxWld5WXJOelArNFNSZ3Q2eVcrS3lOSSsvR203d0RmTnpP?=
 =?utf-8?B?RURZeE0rd3E0SG1qOEZlVzJycnVaa2NpbmtxbmRydFNxY2xRTGtWanpUVldX?=
 =?utf-8?B?UHRRWnNldjFtRXM5QUlreXVId2owZm0wY0RCR2NtQnZxM0ZzSWlyRzRiOGhN?=
 =?utf-8?B?UWw0Z3Fhb01TZFI2eWRjSWcvNTJRK1J2UkVUcDMwOG9yVVJYcG9WT3owTHEz?=
 =?utf-8?B?N1V0aTdIMDBMNXduSHlONzV1bmczN2Q5WWNiOERaQk9RSzJodDJKaDlmSE9v?=
 =?utf-8?B?Zm1WaVFNQUdhOUFqZjdybCtEUFdUOHpON2F4Nld2YXkza1NpUForaXRhR2wz?=
 =?utf-8?B?bjVlSFBjMTFVVlBoendjc0ZnQjVENGVjR080NW5TSkxKUUxpOUhrRTdKMHYz?=
 =?utf-8?B?Yi9RdC9nVGRLUjgxVW9wUGIzc05vNWNzUFBkdkhNMmZqaDE3Z2U3VmF6dnY3?=
 =?utf-8?B?bjRmeVZLRklockJXZFJrMDZzQ0x4MEMrUVpzZnA3UjhNRXUyZW1yZTZqZitJ?=
 =?utf-8?B?b2pjUTJWS2czRXIzR3hJZ01iZ0Z6a3RWQjJQOTlSKytPUnhxYUxuNFZVdGE0?=
 =?utf-8?B?MXBDWHhFYVlOYkRieXAyN1djbldjSHJvMnFUMlBQM1JEYlVzWG00L2Z4clQ1?=
 =?utf-8?B?cEJUaDVGb3BTRk1NZWp4bW1uR1FrUm80UUlTWUM2OUhXYVNjZ2M3T1ZvU2ha?=
 =?utf-8?B?bTFWZlA0YXVLNGF0bGNDSEl3REhqRlN6eHlJRExhOVd4TlJvU3c4STMvQjJs?=
 =?utf-8?B?YmdjcktCNFB1TnM0MDFBeENtdTJYeEZLMTV4Rm04NXZZNGxYSEZBZDU1YWZh?=
 =?utf-8?B?ZTAvMGw1NjJ5MGwzTUl5b1NuR25scllVdCs5NTdKRGFod0VJZW9KK2NSNE9h?=
 =?utf-8?B?cS9nb1c0d3BwMk1ZdGxMV2lXVEh0cTZLaFh6T2pKQTZUZ0VJTWtGUDdWRVdN?=
 =?utf-8?B?dHdsdFZTYUlKU2ZFUzd6ckUxWE9Pakd0UTVCazJUa281bElzeXJ1ZDJLK1ZW?=
 =?utf-8?B?TVFBa3N0c3BRM3VEZjhCdXVFSGNZck1QY2s5cE9XMzIyOEc0TXBwamlRUElz?=
 =?utf-8?B?TUhlVUJzRTNPaVo2R3Zxem0xREtqblUvaG9ZaDdKMXRuemdUajlzRXRTTTNz?=
 =?utf-8?B?ZWFmTkpwdkhCUjJPdmxnaW9VRU1WMmVlZzFzb0RVdFBBMkllS3JzbzFrdGdR?=
 =?utf-8?B?YzU1TGRvQlU1M2lkckFicEJZTHlNcmVFNUFUNVdWMGVkS0l5aE54ZVpNc21x?=
 =?utf-8?B?U29jWlU1S2hzT1N4WmNuVGFwU2FtSlZmZzV4RXlUVXN5RXRYUDVZdXRsUkUz?=
 =?utf-8?B?NzltMERnUWxJdmc5N3k5T0hMWHM3TFp4YUZEYTVwZzNGRmFzY0o3T2ZMMEpE?=
 =?utf-8?B?d3M5L1ZuMmkrd0JwYnhMVnBqL2czd1dFc3F5MWhReEExd3RieEhDeXNWUGUy?=
 =?utf-8?Q?WDK0=3D?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c28d8f-1b46-4e32-2355-08de17052465
X-MS-Exchange-CrossTenant-AuthSource: LV3PR15MB6455.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 16:06:38.8855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9JUd9xYg2t76Sg4tAFand1YgkshhcJlg/6K+7pFdsR6Ju/4d10nGpbtaiAWzSBy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR15MB6581
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDEyNiBTYWx0ZWRfX5ZxpCrSXLjUk
 3v6vR3HgPiG2CUBPCPD03Z25v2DVGvl+LQvyvBzFblOXOln/9ukz46GdvMWQQRvi/159FzRAql4
 GuIUVxyUhH/wy+JwAjNqHyd/Rb8bPSoEblfzRENpZX/YvpNhjMDrQC2P5rHsHCiEDipDooVdo2d
 365Uz0A0jWt4kaD792L529PQwHRjZRR44BFL5NHDOw28KG7cyp5+sj8PC/xWvb7G2csFUsV/BI+
 4iNzCEZ/C/bI3GRuLewPCYdmyE78+yhkjO8AoAJYo63P2q6vwRq5kOkbR+gQkhtHm++xMLJ7nYY
 2t32aD+XFdglA65EWWjkiHmTKFf9Sw/G3S2k9jlz9ctQ2XJTS75bVOkqhscoTvj41nIZw60pUfo
 xUeDop3j/WDWyyXQigu7DVwBz5+Pmg==
X-Authority-Analysis: v=2.4 cv=CaUFJbrl c=1 sm=1 tr=0 ts=69023b94 cx=c_pps
 a=e7UpQLGcWimQYEoqUdNrWw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=zvOSfKsmGlIUmWq8E-oA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: JW0Ww1s4YXaKu6JnEh-jZp0ioF1AAnoe
X-Proofpoint-ORIG-GUID: JW0Ww1s4YXaKu6JnEh-jZp0ioF1AAnoe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_06,2025-10-29_03,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Queue-Id: 580901C0013
X-Rspamd-Server: rspam03
X-Stat-Signature: q41u8o5o1h73o7tjuf85yhjqdtzmw133
X-HE-Tag: 1761754010-892519
X-HE-Meta: U2FsdGVkX1+Rv7dVsNGegkCICjy/IZsFxrityDzgLLPq9E2fJnJ9rgZe6KJW3M0bZm2d0PnmmXDEzukJovWtappQh1YnlM+QEbsZ9QYYTCVbP9YvkUs1sqJA5kfqFzAkkrBvXf64QNlwNy60z67XhGmwSNm28MfVJqt4kAKTUXtxfwo/lwgfJQKU45sQZsw1ROBMVR83/g0lNq7kDmsbpIlHv/IKs7Z3eZQoLl5OgjbwJk02vjdFofZLwG6dShK6lFUkwZ2qpjmr/ND2mCUIAiGMysTqjh/2pFCiW3gmd3QYN4/aLSf67OuuZfaoXl0VgNkBn3VB+5/Yfy0PnvIVtJAgCJaxBF0HCPM3e7mupiYM0RCHJac7M6uYaVoxdyrtKTu1BfQIvc45XH4orR/zr/JwzgMI4eLDLPtX1wI2FJvftI+RlFsKgjwexTFUXgYqWiNpymsxqSsxhYSHWXciwG7H0isdWowSh356HL9VCdcbVmle54eOJbtbtapwL+34gCCkSOcAO9BSXZrsOQ49qSDWTY3KL+JfL5ENuHyhXvWTdekgdqinx6uojkKpShSQl+puA36Iew2yrqYdJ6CES/QHvWQPwORulbgGGrAfucO/ZvQfzfTpgI2HmnFxOqRrYG9utPGGs8VLYdFIDXZCTw7lbNwcce/LeMBoxPwS9Qe0s2+FAaeTwUtrPuRU0bKaNz5Ydb7TSKgwyHep9Jad1b4gJ7JkZJBMJQRwlmescM0/L8ntWDEwQsJbt3NXB0HzEOp5RJbT4pfUmQtD2/sktYMtmTMilCd8rUrDMchWRJqmSXb+ZVOM0HAqS3X1vxB1RmqtCk6bONH0/dOPy+OzCynlMIDQxuFCj7kDXn5OTyMyVfAkupe+rIadEO3Vhfdv2ZftFh3wOORJUjUJ8M6i6/MP4Cu7n85vD2zJ7gbTBn31W3aeTsz7QpFtkZkwuK3w7SuOMy2/K/ObF5ru+ic
 4jZ5/lMS
 VXYAAxHfCAJOVHTNOIOdepUMuULMnY/cjvz3U5wzvNcjT2pefYsA1i411zaRHnfyx/CcX0o9pfQ5DsbeASzY+/focpIvHTEJOGtZGYknN8vvj8zRfsyWfw/NgseEMSeR7JyWVhYzcobhwma4zKQk3BQzQPtEOLQviaG/J3h6dleACnWvRR1ESVe1YU+9f7UmjUMmDcsczpubcOLCHhIaaIcuYdM4/ROPjnjxOkcpnezQvj6Wwp/Bn/YEeL7vQbxutCozCWQh5wPlwviMWdyFo9JjIuy/Izd9XV8zxEisE/FvWi08F77Bkt1ST9jNlPnSd0ZbSjoi8Ztv7ajz9Dlb0AYHs7DSptdbyw91mD4RhLkTKys0eC2Bqd/DF7N2OqFCq4GXrsjxsAHOSr3lzfkwM+y5t24pM90taBpcevuLRmirZVO15IguB3mnKk65dthb1Gd7tJkW8J8SfcMBke9begICjH8vOLHses13Jkc8qiY7iWudGH+FSftB0oR6qQTmUvDSVLHjcUOCMZePsyzINP4to/PvnNKpv1qu9ro6E0LYSXXVARPcfbXoSww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/29/25 11:00 AM, Vlastimil Babka wrote:
> On 10/24/25 16:21, Chris Mason wrote:
>> On Thu, 23 Oct 2025 15:52:24 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
>>> @@ -5497,7 +5528,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
>>>
>>>  	if (likely(sheaf->capacity >= size)) {
>>>  		if (likely(sheaf->capacity == s->sheaf_capacity))
>>> -			return refill_sheaf(s, sheaf, gfp);
>>> +			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
>>>
>>>  		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
>>>  					     &sheaf->objects[sheaf->size])) {
>>                                              ^^^
>>
>> In kmem_cache_refill_sheaf(), does the oversize sheaf path (when
>> sheaf->capacity != s->sheaf_capacity) need __GFP_NOMEMALLOC too?
>>
>> The commit message says "When refilling sheaves, use __GFP_NOMEMALLOC
>> to override any pfmemalloc context", and the normal capacity path now
>> calls __prefill_sheaf_pfmemalloc() which adds __GFP_NOMEMALLOC.
>>
>> But this oversize path still calls __kmem_cache_alloc_bulk() with the
>> raw gfp flags. If the calling context is pfmemalloc-enabled (e.g.,
>> during swap or network operations), could pfmemalloc objects be
>> allocated into the sheaf? Those objects would then be returned via
> 
> Yes.
> 
>> kmem_cache_alloc_from_sheaf() to potentially non-pfmemalloc callers.
> 
> The assumption is the caller will use the prefilled sheaf for its purposes
> and not pass it to other callers. The reason for caring about pfmemalloc and
> setting sheaf->pfmemalloc is only to recognize them when the prefilled sheaf
> is returned - so that it's flushed+freed and not attached as pcs->spare -
> that would then be available to other non-pfmemalloc callers.
> 
> But we always flush oversize sheaves when those are returned, so it's not
> necessary to also track pfmemalloc for them. I'll add a comment about it.

Oh I see, this makes sense.  Thanks!

-chris


