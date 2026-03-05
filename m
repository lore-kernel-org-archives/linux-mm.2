Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C666EFCE5F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 04:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392606B0088; Wed,  4 Mar 2026 23:24:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336786B0089; Wed,  4 Mar 2026 23:24:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7DF6B008A; Wed,  4 Mar 2026 23:24:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F60A6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 23:24:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 971BD1A07F1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:24:45 +0000 (UTC)
X-FDA: 84510718530.07.5B45245
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020112.outbound.protection.outlook.com [52.101.189.112])
	by imf01.hostedemail.com (Postfix) with ESMTP id BFFE140005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:24:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=Z4f92oRi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.112 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772684682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+seJ95qpZWk8QmPRVUtwi0kFjb940k/5ybpYryRA6M=;
	b=T/YkI1PGlziwcgpm7vN/7HLAT8LcJKs5ozfpGSATt3GL0urxgF3vCQpXYhJXKR/tCuWgn0
	lwrz4JAJ7MVxO4QeHk857pclL/50psOwtxToYKtcoWEvrFVRdA05GstNMMpprZMnN24Wnv
	+AQIV7aH0lgVAYuJYpsZY12t5IC35GA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772684682; a=rsa-sha256;
	cv=pass;
	b=IkY25W1kpddvZkDccEH0nwNl1cv7fqRA/pvv1B7vTA3TQJME5LOEwm8edy96+EJ176My/8
	QqF/BzdzWo+yVzClrORJoF64Ijq9bgUQd1YWTSuF8eeQ2jEVIRXthvT3ZcEEnxvFijLbD2
	KuDy/EVQHiAQkRbTzucz4kzMMnBFAvI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=Z4f92oRi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.112 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lzd611SQ+/6/QjxZxiJrMxkQLhmnLMegdcNVvK6y+xMMHdP2GnGENGgHgLMNZCuNz8oImvHAZvxtMtDzB/ne3+AUlIkWt9GieTmvhveQe+lArmese/o65va5sSCvdHgIl15ZpZ72cu6UXrYUixmGnYQW/PJpzyGjgaSOy5AFZrVPoGxX0IU1ItZkCK2rYZeVDdf3kQYJUXkFYKNn5KBPU3rnL1F9wUOTUd2RAvrie0KNiS1ESJnn9npL/sOHEfWMjs+ls8rTzW2QhTWGILQRJh4xsbSt9vt04sq0S0rad8SbUk8jmcXW+cnRZzfXMQXeZ/XZY4fYRFWvX/+tUumlmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+seJ95qpZWk8QmPRVUtwi0kFjb940k/5ybpYryRA6M=;
 b=ynh4t6eJUsAIOwfwGedWM6bySIoo7I4ejvxj4/wlpmIDbTVmPxwOVZrWdUO4VrJM44f7UXok+LyAY+AIjKHooN667yGzZjucf0Tv2niVQnrx6YURVzdqcS6DN+JpFyWxy7aMP9RaGovusrlYPfeQM8ycZqidCmcWT86mDtd5gdhK2itkYJ3TbpZ6CPVl+k/lvfz8xm2DngSLYBqTmVeDnAM6K5yCfJYZifkOvKXnPcSOGHgA+7frdt5Hn6cdLEuDcNoMVOyoCtmnt2MRs2OZ2fvKdoF3WR4ngLlcZ4QSbwsFjdiODSHWxF/Ro5/y2a1iO/TgFFxOzOjj3LYVPeYN/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+seJ95qpZWk8QmPRVUtwi0kFjb940k/5ybpYryRA6M=;
 b=Z4f92oRibpXGIub2i8oDDrkHnnqCO/M+bvy8dQEi5c33zXZASeSkUHrZ4qd/RtUtOC8KvC1Kd65jR92Nc/aOnPQc1QKwQmeS7IlXJ6keTHP8VlVVDsd1W2IAQzMJDIQyhVPsWlVg9ayjPrkG4h7v5BbXAXSAuJ6e2/jptlbD96Wq/A5sKZU2Liq/mOrXrcn+zLgIn4QjgxHJOpDKV1PQcDHk4jHCAj7W5YRKKfnkmnLdbH0K4VDdh3L0S7ol8qBkkQ9lkTK8jAFpeRaPeN8gRYEWBUghuXCj511UMJmhTGz1QahWJjaeoFYf1MXBk3Prz36CMEsmk8p0TnJf27bZrA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT1PPF7BABA26B5.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b08::554) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Thu, 5 Mar
 2026 04:24:39 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9678.016; Thu, 5 Mar 2026
 04:24:39 +0000
Message-ID: <dfbc98bd-8f80-4f7b-8209-cd5cd82bd3f0@efficios.com>
Date: Wed, 4 Mar 2026 23:24:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Ways to mitigate limitations of percpu memory
 allocator
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org,
 Mateusz Guzik <mjguzik@gmail.com>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Hao Li <hao.li@linux.dev>,
 Jan Kara <jack@suse.cz>
References: <aaE8rkGzxlB6wCTt@hyeyoo> <87ikbb1o25.fsf@mailhost.krisman.be>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <87ikbb1o25.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::14) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT1PPF7BABA26B5:EE_
X-MS-Office365-Filtering-Correlation-Id: bd6ae61f-7c7d-45f6-b3d7-08de7a6f1dbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	nRv0/OIMMWTjG9qKaqZwYffRom8BJTvu29Rhk8KuunrhPB9Doyf4sQsDkEcRIuQ0G3TD0X06TScGGdTWwV1Qc7+HiBIweA0x9aU77313NVmxBRY46rCUDx+fa579BJl/nxoxIYE1UAX1r4mukr6cYm6nYhHJVc+sXlWLTMwdtkvvEK93NPqrU6gHP0EIGLUVFKHs9XGwnitxJQsqpD6j2uuFWffjfoxq6532vxtpXJLh3kYYyxn0U7+D16RUuvvGVEi4I1Ir1Jkm9h9aCAAGpPvgJwDJOcItuSTFCLtlFLIGLY2De2k7BN5ApojKabgPSFcF4KiyoBv90gjF2rEEGGXTrgxlr+ad/OroSWO3kE1pA/ohY6RVwjvTKHEzTnMcQSDIAZuK3cbD05eTK9jCqSWfyjmNnwaLx0797xgqs0Xk726RQOJRRtl3GD2tyxnIp6+zCpqz9LZvEEC5qoY3QkaqvrWBUtLcKmBPJErqsm5JT7N8cWO+FXulhXfvshh+P2FZBtBUHGXSx285zibsxWmg+8Odf6yQCSbO/p4IdKZ4dz3XzkaqV/OgvOoA6VmbTZKlmshWH8kdcpi430XMMZBhZ41gwdvT6v4hI20TUjGt6QPFzQUu0L62q+TYA0rtBlOItoNbMmJNR5r8y2m6lMK8f5+ylrPq7pyVpWw8pJk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjdmSkZsUGcyRjR2a1RJSUV3Vk1DTHhGclU2N3d4Z3B5eGtlZVI0M0ZiMm05?=
 =?utf-8?B?TmJtN05aL1hHdFhGZUU2M0dFcFlJbmR4YUs5Q01OKzRHNXlSdVdTY3hkNXk2?=
 =?utf-8?B?VUFscGlCVkxUYVM2c1hoOUZSa2hVR0VDcTlWV3loY2ozVmhiZXlTMzJEUm43?=
 =?utf-8?B?YlptMG5OdldtRThXdWhUUTh1eDNUWGp1ZUpiNTlWYm93K29LeWxlRTVPWmZi?=
 =?utf-8?B?cEdQcnZWR3Z6NjV2ZEVHUVZVWVlDMXp6MjloRE9tT2NqaDk0MXZoaU5PNXMx?=
 =?utf-8?B?dkFkVVV4ZHllZVJNMDMxUWIwWWNYMFdjeGNyS0VQclArazZXVHhnTGlOMVpE?=
 =?utf-8?B?anVKa2RzNXA1U3NneFo3TTZIYU1Qa0ZoVHpOSXJScWxIV3A5eURoaDFjTkxX?=
 =?utf-8?B?ZTVBRm4ybTA2d0krSE14aWNOQ2VLNFpuZ3RGOFUreTl3TWtTc20zR3M1TVQ5?=
 =?utf-8?B?VzUybENSQ01WYnV6WUw3SHo3TmNyQUZIUmx3VnlqMXNxSlc1Qm5hOE01TDZR?=
 =?utf-8?B?SE1kUGdwU0MxYWRBY29OVzVBVjhHVVY4MUNKUTZwdFFaekh4ZFBvRElySG1F?=
 =?utf-8?B?NzY4c0EwWEtoc1dkYUUvbzBGcnRyangxTjRrV3ZwL04xOHhZNkFDZnpKSVBI?=
 =?utf-8?B?VGdmREg3bjBiOXc0VGI5UzdNUGE0bmpIZGZHT0pRTWxweWRvOFdyOEFGSEUr?=
 =?utf-8?B?T3J2R0QzcWhXTTJ3NnVMNmJ5ZXJuR01kQTNnbktWUU4rbEZHTGJjMDlZQ2s3?=
 =?utf-8?B?eFEyT2VRQTFEQy9EMElkSzRuV25tZ1hRcjl3aW0wVkYvWHQwaGVQdGZnZy9Z?=
 =?utf-8?B?cGorV1o1ZGorUitSNVFJU21HZk5aVVpRekxwaWRERXBjUHp5SlFBYktpZ0hC?=
 =?utf-8?B?VUZ3ZkZkWGNPVldCZENqNUl2RTBCTmRJUTQzNWJta2lGdXMrTUUrRzVVUmdr?=
 =?utf-8?B?MGdVRUYrK1JBUE9NMml5ZEJLZERiK1IzckxoVW1yeHBXRjJ1aHloVFVGckdQ?=
 =?utf-8?B?ZHhnYVo4dXN5eDJ4a0lnU3JoTE5qamVYSFlLRTIyZDRKV0xMUG0zWERKcHZi?=
 =?utf-8?B?NGNjeGpadHBLNUJ1YlBIeFJ1MjArTEtpS090M2RDUlQvR2RtQTVVUzdEeEpF?=
 =?utf-8?B?Vll6MjI3OFVWN1lOS3JYdFJqOThmYkxNY2lVOEZzMW9saDRHSW84TkNDT2lD?=
 =?utf-8?B?ZHM5eW0yazBwWGtmOFg3UUsyQ0cwbk5nZURCWUhObU9TWC9yV09xeXpEME40?=
 =?utf-8?B?TERMc2FFOGVTWjFTWjFKUG5VMmFVZXU0R25qbXQ4WTNEeGdPTWxOV2hrdTNG?=
 =?utf-8?B?a2ZYOWRBMFZFRmNvbVA5Y2JrRmMySE1EOE9MZ01MZ3JUY2kvdVZwQUs5Wk9p?=
 =?utf-8?B?RHVMSWViejZMRVUrZ2EvZW51clhyVG1Mc28rTU5LN1k3WHZEWjh2bHNmenFI?=
 =?utf-8?B?TEFVaWQxUXUzL2FPdTZtM2N3NlNhK2Jxa2NtTWxDdE1STm0zWkZCUGpxYTlz?=
 =?utf-8?B?bUdFeVdrUkNsZEk4cU5oT3ZvUGJSYUhTM0pxVzM3OE9aa0R0ZEFjaWpYdVVh?=
 =?utf-8?B?V0tWRjRYQk5XaWRhSW9zNHFWZFFNRUNVWHpYK0JOTVRVdjd6ZnMzNVlCMS9G?=
 =?utf-8?B?MkQrOGk0a2xxVHp1c2pWcjJYaTNtY1p5S29NQWFpdm1BeUlRbnJvMkZkQzdC?=
 =?utf-8?B?bEFuaHEwNEpsMXJVaHlQd1N5UnFkTEl2S2J0V0llTUU0aWxERXllWEtjaWpm?=
 =?utf-8?B?NlZkNXVBQTFxRTJSL0NVVXQwU3REWjdDc1IxQnkvTEN5TlJEREdmTE9xcDJ0?=
 =?utf-8?B?Nm84VHJnMTZGYTBSU1VFMVdPU3NxYmpjaVVVQXF1bFVuQnhFMmdNUlh3bFFF?=
 =?utf-8?B?alg3dTM4ejlCbmVhWUJFUGlrY0xSZi9iamFZVjdaQzN2VXJMVERIeUVlSmtp?=
 =?utf-8?B?TFBkbmlKV1EzWUdHSHdhckthc3BRYVpMZXNHSUF2czNhR1BDMjMyUXF1VC9O?=
 =?utf-8?B?eVJhY0hhS1ZYcS9pUi9UVnFFZ3J0RkNGQlJndURjM3EvNjEwY0U4TkxWbWxQ?=
 =?utf-8?B?MGpGTmhRL1I0MzVzR2RyYm5VbnlvU21sQ0dPZmd0T0NKd2NCSmFuNVBoL05j?=
 =?utf-8?B?KzJsYzE5WlBVblgxbEVnV3hQZmVHeEZnaXYxMTJUUHhKY0JFa0lBVmpLMG5y?=
 =?utf-8?B?RitXR3YxdUxsNEFCVlhXYm9FQUN5Q1ZscGRmS3pPamJoTG5YWFBUWisrbkVE?=
 =?utf-8?B?MkduOGVLZ2RWZ3pxN2ZRRTFHU3k2NVZHRFNPOXZxVlRzbXc5SHZGQWVXRGRW?=
 =?utf-8?B?RS9YVVZuUkpHeERSMTQ0Y2s3NkpXVks4eCtYWGtYUlJvUVM5dUVVd0N4akhu?=
 =?utf-8?Q?xJ9cKYfl/6WgI7Go=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6ae61f-7c7d-45f6-b3d7-08de7a6f1dbe
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 04:24:39.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9GjKfggv+OGZdV1EJFq67d3O3INt0Mo8c8C7BEmXB8H7Oc+NiasH/E1/qJjRWMdXV8TcZH29uOXFl+CKyK4pAA5meI7lr1MLDI0KXsl2hQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PPF7BABA26B5
X-Rspam-User: 
X-Stat-Signature: h46na351hkc8ruioe8gn5prcyhzbkhkq
X-Rspamd-Queue-Id: BFFE140005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772684682-490434
X-HE-Meta: U2FsdGVkX1/LNKYB3KIJm39+VLr/VqYSYPpxpq2Krsn2URGDNbiPEWsK8gMMeOH02X+6u4GbmPsqLxNkmW4gi0wNu75xt8o24hTOXbkcEv8SeUvddF+KXXt+Qnhav9OjkifFpeTeQwFMimVutDsLOvxYi/aBUO8sBS1BTAP3YTZEte/I1wusb7XOI8ej79pSAQdJfy0TWilIm43fBefWcYhl3HKTtfCYnVX/FcJjas5X6rEne29TTZ+q0BN8Oa5SvSPyDDO3zx0clWb7Nwb7GI8Gi7vq/XFpHlZmXw6FMQi4xG5vBgqWmwsfncI2SR3hch7OKRZH2mhHUP4VwcgWmAczS/OV/4El1jqrFRp8ywnWXjZ89GkiHHayA9TLNxyuUEY9fhVRAzEtYst8Cld4gETm4lmSBaxtacpl6Uhrqui+2hbilysMquE30jdR0rISCtq+4/gGfqyjsHCXY7dIdKHLYvpwIKOaZAYibG3H6JSbmkUiHuWfdctyiHJZhG99EPz1L7fYLMrrqxjzZLB9n16vVSFIOSz9VrY9LfYxLeIbc+y51MGxW8TMbv/8byr/uFSYv/+Obeu1tLtC2C3Rg/euWGwCIYXbt3uk1VGZ+AiNhVxO5/lORAY1Gp/5RawM2LnOVUUEnR610msJ6V86ntWgQnqjG68cpKDfntBtCeAj9CpwALWPD1s4rB1o4xFdRPNr2ZGhLIcAo7OjfrUzNOYDVe/VFSsxlpZUJXXzr2L95DfJoWCzbURHSt9Sug2O+6VSaOpdRVfFiORG36EEaOTP6Ldcl2xKv5a4IelW/YiMCicSfXpHUYzDDtOuzxSHZzDJnbfjkDEXkY/cGtPVVCWLC1HvclLyS7JL3Aiu1kkiHi1TOLkVdXwdNcZfIiIpzCadg0MZIvIQT1bfaWIJg+tXYTmkBjYwmhEweIMO8dW2mSCCSroLHIz7w3H+MLoCKf5mwHAv6FfPwvuW3Zf
 XUQRatfr
 guojUrPLTLaT/eywJO0qWPKIagBUYAml12bOyU4Z1DizkCMgvGGHTd+dmW3ePiDw4ywI9NO3b9m/cOAXX4VwKqEvELnB+pVFYnhGcKp3ADWfHCMKGJWbvGe9MjJVrIR2gYDJHJfJG8+RWJIu8VcXaGSOoI1A3To7DJCnLhXPG1tQS4xu64ZMsdgp5WgOaErz+wCDQtkczQqNI7jfloc5hHuXm/XDwdsu0+rxM2t7chWQEP0YYAHe/RIq2Rs83FtO59XjErtV+3C44sCqn4WV9hhVxx7X62jxLju6veDzPvLLPX0iaHURGGEfoMzZn72u2MCbzzvgy8F2EaKR7bOh4DvyjoDemEajzK7BeNDcGVqIX2oKTdJzQRLKGydRK6pYyOOToEGtvDjg4gakrCh8n0OrcEsrEpsVAhlZx2zk2nF6AOLFjHgdGamKJEEzVTPGE8zS7+atmDoAxs/pkA3jJXxAGyb+HSElM/pUYoY1fPg9Zxf8DRRlliXBWT5TzHUvf/20SLFJK8TRvMTzCCoibLm+S4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-04 12:50, Gabriel Krisman Bertazi wrote:
> Harry Yoo <harry.yoo@oracle.com> writes:
> 
>> Hi folks, I'd like to discuss ways to mitigate limitations of
>> percpu memory allocator.
>>
>> While the percpu memory allocator has served its role well,
>> it has a few problems: 1) its global lock contention, and
>> 2) lack of features to avoid high initialization cost of percpu
>> memory.
> 
> I won't be going to LSF this year.  But Jan was the proponent of my
> dual-mode pcpu initialization work and he'll be around. I'm not sure
> this requires a full session either, as it might not grasp broader
> interest.  Are Mathieu and Mateusz attending?
> 

No sorry, I was not planning to attend in person this year.
Is it possible to attend remotely ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

