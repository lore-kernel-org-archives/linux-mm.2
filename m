Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED835CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E168E0007; Thu, 11 Sep 2025 12:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546488E0001; Thu, 11 Sep 2025 12:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40CFA8E0007; Thu, 11 Sep 2025 12:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9078E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:59:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F39AD1A051C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:59:53 +0000 (UTC)
X-FDA: 83877581466.09.40A82D1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8347140006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:59:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DA8EMScn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dCxGpbyE;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757609990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDQUeP2WxCJHRD9cxKZ3ZKIbTG54o9EQzEAOuUlQKOA=;
	b=YMTWyCMjTUXvJ662aWr1mGMFbNtQR1PekpBIQFa9faMdM+qwyLyORb3wEkDfiYFRTmvajO
	h7kIm/9fQs4JFcXYFwomRb/rvxuWQpTVDy/PqfPhGKbzErIvAZ8nudcqK+3Ph1bo/klQRQ
	vxpUXZmEwIAwK6sLVLsKWbc1ah+lXK8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757609990; a=rsa-sha256;
	cv=pass;
	b=CEd50STc71jIJN+P+yDEjdF5cJXDs5nNeRUxyDNjsiqCLjp6UyLdgLdGrGXdKuYWr/k6aI
	EXad62u6Hf3zdq3brgjWGb8gwjR5HU5RJXP6v2wBw0srRkkqgs6p7+0zlRZwyTSB75900B
	iyCtz69DkgJaQbUhIe1xBT6LQ8XJ4v0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DA8EMScn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dCxGpbyE;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BFttEE029240;
	Thu, 11 Sep 2025 16:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EDQUeP2WxCJHRD9cxKZ3ZKIbTG54o9EQzEAOuUlQKOA=; b=
	DA8EMScn5r0YXPO1Hkt/bsN0BBOYx3jG4g4+YoC4sfG59LDVyZoOnmDvdrFmCXfr
	8SvmhQ3vNig8KOvbdFWbyc1r4aV5hI6U6Izw+tudBUQuekZIHwzXKfoaKUvuSF1W
	WcyYcYb75/AxDhWQWvYfvZni7XSOZdGYAv7pMIFS36FGjEZamhroHgi9pKLxJmU4
	SvOfgEJpd+hI0FJzEaXGwNJ83m9JDj5/eWVTXVU2ZfOBoDbOwj/ffc5dfNyr0++Q
	WSH6Av88gaxpcsD6cwsIDSp22J4unXmGCs39X126CS7fqi9VOUjUKCeivYQEYumv
	3AwUFPZtJOSuOdNLIrDAKQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2xpth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 16:59:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BG4A4u032903;
	Thu, 11 Sep 2025 16:59:38 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010040.outbound.protection.outlook.com [52.101.46.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bddpabh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 16:59:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LEWGdnn6nO6a+hL8cEtYTzQOBdCpDrYphEdu4xDKNtsFgO2qGq/Wi9GYUjzHh6ZW46XVPxLabPfwUSzqNWg0WctXkKI5JFzjUKUQon/r7/FWEgrB//d42eWZe/bI5gRlO22nTmBn8dyz2eVlng4xXpebgIuQerUC3ghK82FT0KKFT097AlYBdQ73CmFJ1w6bwTroZSFJipq8kfclS84lnTuRGsjWv/z0qqWFg7kN3+xAT3vnQdUZY2FD7xD7eEZ5rlyAl7LARPP9vC7IcSCRLkN8C2XYXnnvX1dGm6T5+EHY3zdgwClToNBT2cFuVq1FVmzPHmclh8zNHUO0w+Ai1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDQUeP2WxCJHRD9cxKZ3ZKIbTG54o9EQzEAOuUlQKOA=;
 b=IK98id+JYwkRuVvB4wryTCQqxfqWKyIpGbKWIcRW908jiRoiXIfkEuWvSGxRHob8xSGg1DrYj62ykd9co34oaZ+l4jV+yCzm9kWRWYsSgHQ6DkwQjJzxTJoh9daoCl2xloFZoyXF7ge80PPrFBZr2spz1pPJe712Q6mA4egf2/h/LEKmDA6uSn8G99bZ+NX/5bQAFOlUnH8UkeW3EncLg5zDVLhFdGO3BXwDrFEihoM9aTOjdCjDznpfyFqlCR2Im3u7hCS9ZCHSxJe2VUyD+lKcOjJlve4qRKGeDdJMQjUFtRxOQQNhqBPqcMbcG79DGqJlIq2Q3tz8Ji8pisMV1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDQUeP2WxCJHRD9cxKZ3ZKIbTG54o9EQzEAOuUlQKOA=;
 b=dCxGpbyEmqTXeZefDRW+1gc2jyXSoH6cwbZ5J+JnD7gT/3p+Jw9vAelgjYcMLnhabAAc+u4lYmva3kTeuNClVgkOoFBP8JSC7M6hSiLlQO08qcEj2KwcisVjhQV2mvZBXPqTl3DZPO5y4Njs/+wtKRNaN2eBBgf4W3yIVd/G73g=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8516.namprd10.prod.outlook.com (2603:10b6:208:57d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:59:32 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:59:32 +0000
Date: Thu, 11 Sep 2025 12:59:28 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 8/9] mm/vma: Use unmap_desc in vms_clear_ptes() and
 exit_mmap()
Message-ID: <2slsnkd6abablb2zxvzti5w6e2sdacz2z7uzwvumodg4ccuykh@ul45isfoax3f>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-9-Liam.Howlett@oracle.com>
 <CAJuCfpFGo4JXQQGECFdCgNNVaQc5MDLghdmnVXEK8Zfag7KHiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpFGo4JXQQGECFdCgNNVaQc5MDLghdmnVXEK8Zfag7KHiw@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0437.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8516:EE_
X-MS-Office365-Filtering-Correlation-Id: e4daf940-b103-419e-86ef-08ddf15493ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3JQSDB6Sjh5R0wvbEN6dXNkQXF6aTNMWXJObURTbDVoUExhUGpzWTFPU3BR?=
 =?utf-8?B?Qi82V0d2OGlFSTNybmk0QWo0aUZjeGp4Uy9mN2NQNVVnRDJwMVZlQ054UDZs?=
 =?utf-8?B?RTZKdGxobkNkNmEvTStzaGZmcVlEQjZKQW5hOTlpL3hEN2RoTXRRWC90Nzhi?=
 =?utf-8?B?dXZKNDZkaENUb2FnbElENVFadEdramZDRFhCQy9GaHVDWEJIQkpHSW16VUt3?=
 =?utf-8?B?NWR4cFJZUlZiS2lkdVJHYWtRYTloOElOVEtCSy8yRGNUcFM3RE9ZUUlORmda?=
 =?utf-8?B?S01NaG45YmR4YlFLUmE1RFdEbUlScHZUeFVYaHQ4SnNXV3J2dGpGZEVvNUkr?=
 =?utf-8?B?bWRMdU9NMmNjamYwSkEwMlhhd3d6dHlmc2pXK3hXbDd6WkhpMUJPVnJsVGFl?=
 =?utf-8?B?M3hJOVRReFRoLzk3THE1Z0YxMm05SkNJa0lMVnlLcURlR3IwSDlIdFE4ZnJ4?=
 =?utf-8?B?ekdQOEVibkV3dUZYODJDeG5WWVVJSEhGdndDcGF3aFRQSCtuSUc0OElSZllW?=
 =?utf-8?B?R0VJY2Q1K0orWjR4SjBmaXl2OStDVFlvU0JjdUJteTBPdHFQRTlrb2lmczFw?=
 =?utf-8?B?aHBkQmxpc1ZQckY1T0JOOHRYMWZWeWZVdUdzNG9kbE54akVTcWFHN1FFL2F4?=
 =?utf-8?B?LzVOMlhKU21HSElTUE1XU2xpdnBHY0IxeDd4eENkZzIzMldJKzhxbnhNZUlH?=
 =?utf-8?B?djVZRWJiSlFWZEs4dFhFdjkvZWVVUmd0S1VmYzE1MFBiQ0xFNDE5ZjdWR2dk?=
 =?utf-8?B?LzJGL1dQNzZ2YmZRcnFsYW94aWtWWjJ5dHcxTCtPZHphZ2YrM0J4SlM3OGlY?=
 =?utf-8?B?dEMvcmJoUDZVZFZ1UnNtY3lTS0NvQjZ6blJpaW9Ga1d4SGJjRkZ0OEo0QzAy?=
 =?utf-8?B?N1hocERzeWZRZUdxMXRtWEgzRlJRVnVWT2tBbkIwZ09PcDhzNUZ0bHd5a1h0?=
 =?utf-8?B?N3JCakp6UEwzUWtpYjF6QmFvTy9KZGNyYStXR1lmOUNIdHRpUEUxNnZLbWZR?=
 =?utf-8?B?ck1xSFVPWUE2b0M5MmIrcFErbGZzc3FDamc0anJXWlFDUnY3WkxaeVBTNlBs?=
 =?utf-8?B?VytYeUxCWmUxTHVZeUJnd3ZkcUVvRDdzam5yMWRYVHFpUHYwV1VUeDJRWTAx?=
 =?utf-8?B?eEZWSm91bGE3eldxUVJ1cjZEUnpPUFpOZ1BMdEI3VzUvTnpyK01Yck5QbnpB?=
 =?utf-8?B?L05kZHNzT0puUUxhaXRFYzBUTFdSRWJ1dTc5eXBJVHp0ZmVnTmZIWTRYR2Ni?=
 =?utf-8?B?RXlKMWwvNWcwYXdMZHRXRUlLcXl4d05DSnVTdWdaMEYzZE5iREtpdzlyTVda?=
 =?utf-8?B?M2dPSiszRWRROXhXRFBOUXBiSnRZN09rRFF1UldOZ1laQkVBZHVOZDZEY3ZT?=
 =?utf-8?B?OHlKaHRzckV2MCswb2Y3YW5maUZrSEwwMUVtaVJqRnNid2RISXZ5dWJvZHRx?=
 =?utf-8?B?Mm1DR2phdkhUVzN3c01rL1doeTEzRnNjNnc4am9KTFNzSmt2WTBqMXdxRmdk?=
 =?utf-8?B?N05YT2xXekYxbXE3NUZ6MXF6aTBjOTVOdU5UVDE5S3JTOXI4dlhFR0UzdGh2?=
 =?utf-8?B?TzlQRHIyeStjZVZ4MEhxRloxaDhzclV6c3lJYU8vRlpoZWdxbHdoUHl4bFJO?=
 =?utf-8?B?NHhXeHpUQWpkRXNPWHF1ZzM1MFZScTAzTE80d1hTdllQd3dWenlsVHBxZ1Nh?=
 =?utf-8?B?eUZsMll1MkYwZ3lFUkt2STBGRHIxd1J1Rmx0QWxRUFQvRWxib1cySzUrQk55?=
 =?utf-8?B?bUZzRkwyZ01nZit2bjNGMEFOcXAvbWwxRzArbjk0VWdwQzZHc1ZWNWQzYVJo?=
 =?utf-8?B?NGJBN3VDV0J5NVMrb2szZmMrWHpCbm9DYnN2czkyeGpLMUdVTVphQ3RGUUsy?=
 =?utf-8?B?WmtuWlBnSkJlVzhGVVgyU1BSdjhXa2NybTZDQ3FGOElsTE5OSG02d0hYN3B3?=
 =?utf-8?Q?rNRhTbEMGOI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MC9FNFlrUlFjU05XM3FrUlNQOEt5TGYrV0xCbUlwUWlzeUJUWjRPSk16Rkxz?=
 =?utf-8?B?NUNVS0d5M0FBQkdDb042bm80MW9MN1J2NlhhZzQzQkpDdkhXL0xJYjU3UytB?=
 =?utf-8?B?QW8zOTh2a096cUxFR2NhYmw5NkYvS05wV2FyZ1ducGFZcHU0RHRaaEprakhR?=
 =?utf-8?B?REJ1S2cvUXE3ZkhnUFBqWWwxNTM0SnpjUGlxZUFDVktYcGpsTk0wSWJnWURm?=
 =?utf-8?B?eWNHM21zQ29aQS9WemJlQTF6UHRodnhtaGp6cXFnOUszanFPdXBCekd6Qzh1?=
 =?utf-8?B?cGwzamhKWllzQnRlUmd2b0poQzFpaVpUSDRFRmw0RVBLZTVPbEhNN3VrUkMx?=
 =?utf-8?B?dzZ2TkVXa0lQV0w5aWRVaG82ZEJWbmtSaWVBTC9xVzYxcUlCQkk1RUZya0Zi?=
 =?utf-8?B?WWJxdWFLd3VKbHRwekpOOXBWYkI5cHpQY3g3OTJycFFabVN2TVV2VVZISTgr?=
 =?utf-8?B?RzI1OTdOeHBWeloxQXhOcTY4WVc5TXk1ZURBUUszUDJkTU1FL0J5ZGxNUUgz?=
 =?utf-8?B?M2RTT2lwTmV6dzA3OGZKWlhtTjRYc3MrNGR2VHFmb0pMaWordHdhb09kektC?=
 =?utf-8?B?UGJtV2wzRTNCVkZSQ2hDMlBMWmlqWEpxODFCUlhwNmF5OG9GSjZxd21VUm96?=
 =?utf-8?B?V2hKVTliYlIxUmJkbFgwM1ZIQ2dSSktKSy96WVd1UFAxakpoc2dqMS80RXNH?=
 =?utf-8?B?WXZDYUh3TXRURk9lMFJ4VVpmZk5iOGtNa0xtVFFZNkFybnU0czdkMEI4MEZL?=
 =?utf-8?B?blN6YTkyM1pvY1JHbDZLR3E0aEFDeHBmL1p3OGx6K3UxbWNSS1hSMkFwRVg0?=
 =?utf-8?B?VlU5L040U25mc2xGR0l2N2FSeVFXWFZjc09uZmRBbnc0VUpDTDFFNGxWL05z?=
 =?utf-8?B?UzFhZmkvMHliRGZqdjI1a0Ixd2ZITU5GY1NOY0QzZkVvVkhwY1pCZGw5TzNv?=
 =?utf-8?B?RU5paWJZYWdnNjlBQlc3eXp2NStHN0tYcDB3TFhIdCtZNEpGTFhDaTVqcFIr?=
 =?utf-8?B?NEZNVFJKcklZWXgrZ2RqbkpnSzlIeGllZWZtVEovTGE0OWJocTF4V1VlNmlo?=
 =?utf-8?B?TklCQ2NyQmxPTTl0WHI3RUQ5cVRUYTltODkyTGVLUjFGYzBCUXBLbitJcklU?=
 =?utf-8?B?RDBhdnRwNFFiUEFuV294NXgyWkFld2NPelB1Ylc3NjVuQXQyRnh4ekNqa3pv?=
 =?utf-8?B?MHNwdjdlaHdsSkNyNUNnby9VSTk0bjhnVE5vNEJkb0Z2MTd6NWN6em96bDgy?=
 =?utf-8?B?NXVUS3B3TUhFYnI0ekVpMEVtYVFDcUI3WkxaWGhYbnV3MExoSndqZ3lKSElm?=
 =?utf-8?B?S3NOWC9tQmtuOUtma053K0YyY2dWd0hEN2lKVFYzYmlwaG5QVHYwRDJsT3RG?=
 =?utf-8?B?WGN1R21WQURxajgxWSt2SlJDZ3VqbmZCaEZnV0lyN1g4S1p6ckhWYVo1bTEz?=
 =?utf-8?B?a1RhR3R1ekhzaHJuUjZDNEJxbHEzTGwxN2FSUWJnVUcweGI4am1WSlpNZ1V6?=
 =?utf-8?B?VUlOWWFROHlOdXM5cXVlT3llK1VheEdvRnp4RHRPd1Y5UmdGWDRJOWc0MkZE?=
 =?utf-8?B?dUdrMXhRUlVrcnhyays3akF4emRLQzRYQk9tSnRqRjEwSkNFRXpkcUZ2YU5r?=
 =?utf-8?B?cDd4VWFSY3VScHU5cWoyVWhlL04wSFdvMUg1TnB0ekZHZVlRS1VBd1ZxSjIr?=
 =?utf-8?B?VjlQaDZ0NTA0bEhuRHk1dUQ3OHVjY05LTktaZ2JuSU51RzdDUWtCWk54aHM0?=
 =?utf-8?B?RE91VjJRamV0R2kzQ2dKNGxTdllCVnEwWkhUbS84TGNKUllIcHlnNEE5Y2R0?=
 =?utf-8?B?LzloVVRZUVV6OFRkRzZQMDBTb1NmNEV4dFZHNU1WVXAwd1FRbGx5Y3Q5b3hR?=
 =?utf-8?B?YXo2b1lVZDByb0tSdDJqVkVKQlVCaU9sZkdxNlY3YzQ0YjVRV20zb0RLNU1Y?=
 =?utf-8?B?dWRXOGNva05kMHBrQnBibjJwdCtzeHRLTEwray9UV2lMd3NTdExqLzMxOVY0?=
 =?utf-8?B?akdzRGdCY2ZMUjViUVhjQVlrTHp2eVM4YTJod3NSdk1hSUFhemw1RitidDk4?=
 =?utf-8?B?UXI2TWlzdWQwZFo2L3BxeWN5cUtUOE8yWWh3bmV1Z1pzVDMrcEhQVmp1MDdF?=
 =?utf-8?B?R2JFRmRodUNzTkszN1ZtdEtCY1FKV2pFZGhnQzcvSFdmMzVCWUZITFBEdmRN?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9IjpzV9zcbWmHdUMFfjj44ZXXAbQaCbht+nfcLoG1njvN9uJ9eoMSJDastIbNO7xbesbKfPkSkMtTEWPKcgGhR/YZBWXshtUpphfKgcaKxvWJ7T2mygtMOghra8dW3a7jzwo2HronBewxo2gPwINP8aeoee0Bh3SEWEe18E/IFtzkRjvehFHcVkBXG2xvQMCBxbnc/S2tGb/cLd4G4eZUKzm7f041xnTgexQECjXVbobIJxy97m+qRtlFwawpF4HpqO71wzO6+9EZEOOb4LWy7ucHKHroHTc237lgRtNPDfnApQzM+L7qy2uaDdG79lnYvmeljFaerTxFgLyvJ0LZC6iprfeQZWNrX1T1zaUNNNtiTKRZ45agrqLC4xdw5VMxVDK/jGBG1ETcjZdRjkwQ3bX+T4cjfyES4hPTnBLGRhq+yTXmJmQkuVTbZUHaIWZhqMAZ7T6X+bgj7QooxwjxWWf8dm3zwQLoHpW/SyxmAwDogCz94d18a/B+UQP/TG8RMMgULYiBXbvEXCAdd6YvZ4sMcTWTwbSMJr1+A4tL4krwLA5z0e4fNGwYKRGy541tkLciSQUKZqRfwBfBpi09Xvx5/R8ulBbwCfsnpMahbM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4daf940-b103-419e-86ef-08ddf15493ff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:59:32.0709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hP1WE3wjaKDlJvq2kxTamKtVVTvKo/FUoFo5COn9lwEOApOxoPnEFhL4jYBV7d5iRPgAZqGUuwxU7ahdaQBuGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_02,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110151
X-Proofpoint-GUID: fGTKbeTV1BenvnQ-cVgs9QaX7WEKSOMO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfX6+Rv2NL1lwnT
 MUef0SoOUuXEUPn9JLlCLc1JCV3iRS2WDykhshcmqb95hb8y3p56KFXyVTlNgBTHK72bjaS8mfS
 3AVyWwVfcKRPSNNBtLvPZNw4X6fWqQMqjHxmcB8MMkRD8zwCjbyP88fGU99M+CDKiNcELfa1hY2
 zCjCF/81/3Jp2XniIZ1eJ37eJKXScQC+z+oJuOWL27T+O0mcTl70oENYuBaRxU9xjqDeX8tfpaH
 w03xflgLBs1gTCkGU66TsCHaMAw81YjXgzfLiq73XTXrsM0Y+ATtgO+w3nEILcNHaBJ7oKVRm5l
 PU75NcTLc8YYNVjkbEwA3GFj3a1G0w6KeoFlpBMkSSHVejY/fD6N3/3EQ7EzxfxY+mEq3o7MK1E
 P+wLWN+m
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c2fffb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=sN3UFmd7gbddgl24Zo8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: fGTKbeTV1BenvnQ-cVgs9QaX7WEKSOMO
X-Rspamd-Queue-Id: 8347140006
X-Stat-Signature: x5aewcmwyaa1iz6kioucw8d3z3sqekkr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757609990-225903
X-HE-Meta: U2FsdGVkX18LhgXwMk03YTtRsqjKxOTuyVmSqT8Sg8finSY8HU8j0lmeBC8r8bEOYBZRJizXxXdv4G43tQIwex0V7gCcaMNJiysnNRvbF/wAqnoF2VHrZfzMhiGhdqOW1RFph3pSH2SXPwVdrMobecWuA24ykQnCYlycngEOo/4D+nLuz2RUfcksurK3ozq73ZpRiupTCkBS1Je3sb+iuflkzhxrSs2K+/yGrcE57u4AnBYEzQM4GXgV1p90kQd5f3pl2egI335tTxTpxtPfnGAzZrL7hM+Hq+lKCGFbmHEq/fRBhyVuBRfWx+vorPgItrOOt753la9vY2WNIDEJXMh5JjxWewxz1glAiyCuKF3516wmJ+PS2T6Czpwo58GCb2T/fJIEOn7gheVdNjcQkS3cTky44cNGJMwRsuI3xTwfo9FdgG97AlWIoy78scexTgbnN6R55/h44u4Ej2RkuIRLgEmka8NCM3D7LoU6w1JnfFxH1wub0vlLNl1/2JnMzfJyKAUYFqTVtFy3FaxtwjJl5AekYfThAdMelRqSw9TVoNZU7Gwg4x7CezC4Kp477wHyDJwlrBs6KfzKDT/m8BnmjZcsrVLZyEMgb51Pg9VSEQ5lFVAAj+bZUbNNSElyHU9f6j1FYJ43t4it4BWIoXhXiKknXp1/P8mZjqWv+HdZupzNGAhFkBVHkApaKGx6W4Vu51T+lSGVA4eExmChPDbVi2Bzh5He19+Era+4QB/NNomW4nc+1eIFf6m5fYeZzTuW4Z8WuzyulAIESQ0ZQg2dMAc1p9sW2ta6X3iOB7X1vz/mRsAWE0afttF64Gp9jKnyDy2jrB44re5I1Dlx+26DAB35Ez623uEcShPqjsUgWoq8lc0xxYZT5i1O7X2Nfi/rV5Gq7/CrtoLx2mkbwyDSZfx7Rrv1396J6gcmm6UN36PiT1/ZiFJTdHJOtFgjzRhBL/yhe8mePe6KYtw
 bg51Prn2
 e1j1TpT8X7k1Ndqj/3SDiYanyl+pzBiVRcJaIt3dePbI8WTQLoNGHTZceC17zeKCIdxFFK4tp2VQimzjNM8ukczq8dTwkjtmIvZlB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250909 18:16]:
> On Tue, Sep 9, 2025 at 12:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > vms_clear_ptes() is slightly different than other callers to
> > unmap_region() and so had the unmapping open-coded.  Using the new
> > structure it is now possible to special-case the struct setup instead o=
f
> > having the open-coded function.
> >
> > exit_mmap() also calls unmap_vmas() with many arguemnts.  Using the
> > unmap_all_init() function to set the unmap descriptor for all vmas make=
s
> > this a bit easier to read.
> >
> > Update to the vma test code is necessary to ensure testing continues to
> > function.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >  include/linux/mm.h               |  3 ---
> >  mm/internal.h                    |  3 +++
> >  mm/memory.c                      | 24 ++++++++------------
> >  mm/mmap.c                        |  5 +++-
> >  mm/vma.c                         | 39 ++++++++++++++++++--------------
> >  mm/vma.h                         | 14 ++++++++++++
> >  tools/testing/vma/vma_internal.h | 14 ++++--------
> >  7 files changed, 56 insertions(+), 46 deletions(-)

...

> >         struct vm_area_struct *vma;
> >         unsigned long nr_accounted =3D 0;
> >         VMA_ITERATOR(vmi, mm, 0);
> > +       struct unmap_desc unmap;
> >
> >         /* mm's last user has gone, and its about to be pulled down */
> >         mmu_notifier_release(mm);
> >
> > +       unmap.mm_wr_locked =3D false;
>=20
> This will be reset by unmap_all_init() anyway, right?

Yes, I will drop that.  Thanks, I missed this when I rewrote to use a
different function.

>=20
> >         mmap_read_lock(mm);
> >         arch_exit_mmap(mm);
> >
> > @@ -1295,11 +1297,12 @@ void exit_mmap(struct mm_struct *mm)
> >                 goto destroy;
> >         }
> >
> > +       unmap_all_init(&unmap, &vmi, vma);
>=20
> Can we use a macro, something like DEFINE_UNMAP_ALL_REGIONS() instead
> of unmap_all_init()?

No, because the vma is unknown and we set up some of the unmap_desc from
the values in vma.

>=20
> >         flush_cache_mm(mm);
> >         tlb_gather_mmu_fullmm(&tlb, mm);
> >         /* update_hiwater_rss(mm) here? but nobody should be looking */
> >         /* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped=
 */
> > -       unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false)=
;
> > +       unmap_vmas(&tlb, &unmap);
> >         mmap_read_unlock(mm);

...

Thanks,
Liam

