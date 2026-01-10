Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123DDD277D9
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 13:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318686B0088; Sat, 10 Jan 2026 08:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CA06B0089; Sat, 10 Jan 2026 08:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129A46B008A; Sat, 10 Jan 2026 08:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F29236B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 08:21:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7685513950F
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 13:21:10 +0000 (UTC)
X-FDA: 84316115100.12.276A6ED
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1872F4000F
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 13:21:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=K4rsntVp;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of "prvs=94707e0023=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94707e0023=clm@meta.com"
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768051267; a=rsa-sha256;
	cv=pass;
	b=qQG7UyoTaW3lN9rjhc1IewXbengZ9Y+oXCKCjdcGZ+Q7VWUOe9ihhs6trYKxVdyla0WR0U
	9Krukt8Qinj1sQLLBREbwEazziaf6EO1tt8q6WGKpvVo9HTdE+AHi8IS2rHsO5Cq5F4Tgl
	Pi25KO4pVUYeag0cyza2NPP3LqB8HVQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=K4rsntVp;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of "prvs=94707e0023=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94707e0023=clm@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768051267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8e1kCE6/mqj9bpn9gFAYjmhLo7kFY6txpTOvyk3cKQ=;
	b=Qr8mdunnYxz7K78qBkiAHlOn74HH+JMwns61gzVIy43UpQgO8Hq8iG8Mhi2oNU5PJPAfAe
	RJ5gaU6AVN8h80jHh9XQXKuCL/iF0l2nmugNNHywewjxanoozXn7HARtg+FQr1o+dHtkjW
	2ktdo6r6JwAPLSaDUAa5cW5pXUcoqVQ=
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60AAnpGb2152493;
	Sat, 10 Jan 2026 05:20:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=z8e1kCE6/mqj9bpn9gFAYjmhLo7kFY6txpTOvyk3cKQ=; b=K4rsntVpTVPL
	BHGfnn/TPIKXAi76YQRPiX3b9JcX5Xwg6+N/dkcnUaVVNVgxDMakuHtEs86hEu0J
	bFpI7zBgqkuc8/LAAYEsb9VwpKu0/9AVmnezK9cz+dhZxaG4pf+2JcrkVMk4Vv1p
	gCxmLcpqnS2afkUj7ISzacGAyiuN2LY1FLJe5ktjZEt8TdIWp1wB/ebreWPNWbxh
	L+9RFcAUyznYMrj+b+r3UqeXmvR2XRZ93eyYUEuP2AsV6Rg53/3oduiEYYTUGwcf
	/6N632f5mREwW7sLj5rzeHVjwsJZd1EztSXGHNdXnWKSraa+Zzd9s+I597UzdK9b
	6BB6318Mzw==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010000.outbound.protection.outlook.com [52.101.56.0])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bknb0rg6b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 10 Jan 2026 05:20:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yoSyJrmFKtRUT8a2/svSCx6pPEkNMMFG2dqiBaDAybKw9v0sgo8iUvAw6y5yPxJ8vRWNDGApmptzyhyEVC+OI5wJhWvQeGJJgLpO63H+ipDFGVf+gPQ4wIshexA9BmeHr53eS7nmj7P4OA+RfbMlwEaUi6xJVS6Vaq/A7C8SB7Mcqx4Y9Ab973qP91tTTg5PwWsPZpUFBv4GFEs9mQ7BmzESVbPKwgKyjy823AD9xMZ11ONIPcFFPyuUhaWdFXmxJJXakvLFtlt0eotOkFgZUjU58KT7OJz5qmfaOHcAi5Dd2U3zbd/T1J9v2Zsg+E0Xmr2hqh9nAng7NpVz8eskJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8e1kCE6/mqj9bpn9gFAYjmhLo7kFY6txpTOvyk3cKQ=;
 b=xoz8Y2SRZYh7q1LtUId1WWJwyMaBBe3QMJudSVmDhriH1eD6wFXkcRpiI4XlVVBBpSl9/F9w0dtuljX4gP8QpKN0IZSVu5Pzlw9ap8Y3TATUkttKNmrmM9CMLeWg/x4Ahbo1hdvrx1m5DqP3ZtM+37jr4MPW9LRqa/vjw2W5PjyvedmLYZXzb27BlnHbvzThAGnCbLBRlhsi38IGbSXJQsqjj3bS1F4JQ/CkrJymkIqe2rx/eyUndDGh5sTtNZtW3BwSVJj1AGmobPGax/LMYUpULRXcSpnuOWeLZtIzYS+ZVCjw6HVdkSQ3QqwVl5vwBXDKJN90Jf0cn9/NBwAWeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH7PR15MB6463.namprd15.prod.outlook.com (2603:10b6:510:304::9)
 by SA1PR15MB6397.namprd15.prod.outlook.com (2603:10b6:806:3a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Sat, 10 Jan
 2026 13:20:55 +0000
Received: from PH7PR15MB6463.namprd15.prod.outlook.com
 ([fe80::46c0:7653:5dde:4b66]) by PH7PR15MB6463.namprd15.prod.outlook.com
 ([fe80::46c0:7653:5dde:4b66%7]) with mapi id 15.20.9499.005; Sat, 10 Jan 2026
 13:20:55 +0000
Message-ID: <9a00f5c2-7c9b-44c3-a2ac-357f46f25095@meta.com>
Date: Sat, 10 Jan 2026 08:20:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from
 allocation paths
To: Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>, Harry Yoo <harry.yoo@oracle.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com,
        Petr Tesarik <ptesarik@suse.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20251024142927.780367-1-clm@meta.com>
 <28e6827e-f689-45d9-b2b5-804a8aafad2e@suse.cz>
From: Chris Mason <clm@meta.com>
Content-Language: en-US
In-Reply-To: <28e6827e-f689-45d9-b2b5-804a8aafad2e@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN1PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:408:e0::14) To PH7PR15MB6463.namprd15.prod.outlook.com
 (2603:10b6:510:304::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR15MB6463:EE_|SA1PR15MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: bd000a1f-dab8-4d0b-376d-08de504b15c1
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEtxZzJxMTJ5UFVEREtybGV6Ump6NVo2UHZxTGhIaWovd1h3bFZ4SHJwNWln?=
 =?utf-8?B?MVV4QzRMQlFBeG5hd2FMVXZiVk1mcEZNNWVhcnNXTmNRZHJmRmdmczJPa3FZ?=
 =?utf-8?B?Ym9KRXBCcTlUZWlHZER1L2RBcnFNSHdjdzY0SzNzNWZzU09nazYwVXRhSHNR?=
 =?utf-8?B?QVhscUxtbFdDdHVCRFAxVlQzdWFsZGJzaG80K1MxeTBVd1o5NHVSbkxiZVRY?=
 =?utf-8?B?WUFKeXZJMkxYQW16R2ZpVHN5UXVOTEFBRVlFVWNETlhlVzBNL3ZrUWRVeEtr?=
 =?utf-8?B?TVRCbHRqMzBWREFFdTcybXpjOUtiZlFCVzkzZnQybjh0N3BjbkowRHlaYTB2?=
 =?utf-8?B?REFHa09ZcjRDZW1GZWx1NXp4UWZ0ZXdvMHVFTWRqclkrZlpFM2U5UHVHTkxF?=
 =?utf-8?B?TWxpUmVpblM2TEpFNlU3ZXdtNDFpTkxIcVhIR0dXV3NiYlRLUGZUQytXSFVn?=
 =?utf-8?B?RXh1Q1luNjVXaWlhR3BlL3hoM09xakNVSkdxNlBtRVBReUk2UnlRRXVvNlpv?=
 =?utf-8?B?SlV2b3FLZG1vY013Z3ovMi9KRlI3Z0N1dWFwOVRORUVrTHBCaDg2TmRhRER4?=
 =?utf-8?B?TW5qY2w0cGF0RG0rdWxvdTIxLzdINnFjUElwUTEzWmZVOGt1clFpSDNLOENi?=
 =?utf-8?B?Y0M1K2VmaitVRW90b211S0ZGOGdKV29Sd1RyUkxycHg2cm9NQTZ3WmJNbE4y?=
 =?utf-8?B?RDU0T2dFczN0ZjA3dGNISkJONnhxd25NNnJyMXNrRXNvWFQ3VTZSRXFUb21V?=
 =?utf-8?B?TnJGM3Z0N1E2VEdiVm4xMFdING03cE1YT1IvRktOamRYeWhoaE5US0tCcE95?=
 =?utf-8?B?T2dMR2NJWXdpai9pOGJZZkxJMmJWcjFxajlsZzl1MkZETFFWNU1CVStOcURR?=
 =?utf-8?B?cFYyRlRJc2VxR0RJemNPSVdPTGtFRTA0M29HcCs4YUp4Y240R0pmeGg2MTNY?=
 =?utf-8?B?TnNia3BmbWppd21nc1dpN2FvOG9zU1ZCbEYyeDhNaXk5VkdIZ0ZOMVAzYUxq?=
 =?utf-8?B?TDZBbU9FZGZlWmVVODNvcXFKa1duUlljRWVVbFZXNENmZUxDN1JFRlEyN1pu?=
 =?utf-8?B?MG1mUVZNUjVsemxlZDB3amErSy9qYVBSR0luTmh6akU4YTNkV2hNNUpRNCtP?=
 =?utf-8?B?Rk9ZS1M0OFd5MHh2TUk1WXhrdFpwYkttaTZMQUlPYi9LQmRxVE0xdnRNOXhn?=
 =?utf-8?B?Wjd6cDhvN3ZUdFpGeWpOV21xaHlTa2pnKys1QkVyMmFtaG56YUFvMlE5ejRS?=
 =?utf-8?B?NndwTmtpbkhwT1VpYXczalJHYkVZejNnTklYZkpvMndWVmxyamljM21mOUg2?=
 =?utf-8?B?eWNoZ1pHa2c3WjBRVisvQnEzVElYbThSbmJ6bm1lTmR1WDNLQmEzQThFMWRy?=
 =?utf-8?B?R3F1enpEaEs0ZTNFWEppSmJVVmlNRVIvaHNWZGRQbUE2VGpibld2MG9ER3Yw?=
 =?utf-8?B?bzFLSlV0RlU3TlBkTU9zaTg5MzUxOFNIQ2FURDdGWDRaQUhrbmVIUjFiV1Ur?=
 =?utf-8?B?S29XR1I0TUJXQW5aMFgxREhqNXhpZTBlK1FucWlXeWlYT2RtclltbVdVQkZl?=
 =?utf-8?B?SzRNSnlIYWFHQ3ovYlVCeDBWL0E5SkxVL015Rnd2RS92K2xBWVIvRHpraU1V?=
 =?utf-8?B?RGVZYnFjMzI3QkNtLzcveEl0cHR1cWpIUEpGZDhLTHdWSEVuS05QT28yVTlG?=
 =?utf-8?B?U0VNamZpNFVBL3FYRkZodDRmZUFXbE5YVllRUWRTUUJweXJxYjFEeXNGS1A5?=
 =?utf-8?B?b0g1Smh5NG9ieVdNV3paeEhUMk5rRUFpODVCZmpiTktubUo4MC91ZUZxS25i?=
 =?utf-8?B?UUpmZzBGOXFmVUhwNUYwdlU0QWxOSzlYZDBaL1VJYVI2VjcyMWVwZTZJWElL?=
 =?utf-8?B?V3lwZFNCZkUxSENIQTdjdmhNTmhEcFBOVFdQNkprUG84bDhoWWhNdkdUQWtW?=
 =?utf-8?Q?3dMvhgkqKH4mDQKxGxU+gNQrmMBzwVQI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR15MB6463.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R01FMjBpK2MvbTNkQXlXdXd1eG5LV2p6LzQ2dG5sTEhITWZKV2kxUW9ObUFL?=
 =?utf-8?B?bFhnNW9IdmY2OE5ubEVkelJ4RGFKTDJnMDR4N2hBRHFIRHF1amRrZXVyOHhJ?=
 =?utf-8?B?RkZPeHIwSTVLdkgyeFY0d1pUSDlQYmZuekRvUCtqVFVSVTl6UlBIQ3VCbUZC?=
 =?utf-8?B?VW5RcTB5MzR3b1AxWnNJMkI2THVOc2VvN0ZMdHhiSXRlWDEvRlYyUnFuWE1T?=
 =?utf-8?B?QXFQYkthTWpJRFozRlA0ZFhDYnVRdmt5RFdyZ2tiekNJalFxVGFYVjV3ZzZh?=
 =?utf-8?B?WFJ5RDc0N2pjaThEUzNYWC9uOUN2SzB5ZDNJd3RvbDNIYVdRRDBUN1BVY2xX?=
 =?utf-8?B?ZkMzQWVPWlNtSmVweU1BQVdYSFp4alBtVVZlWmRQTmpqMWNZRzJTYVVkUEZs?=
 =?utf-8?B?NEJkOHZTVXp4SU9Gd0pwb1B3WlF4RkdoNlcwSXFhZGx1ODJXK05zZ1VQd083?=
 =?utf-8?B?ZEs5Tk9NL2pxWjJFQzYvR3NTektIUldRZE9LZVFtTnRMWC9YTjJRUE4wc0hq?=
 =?utf-8?B?b1RLRE5Fcy9mUWFEcjJOdTJTcUFMbGxCNFhTdFhBVFdZYzROa3lGVzhtRmNh?=
 =?utf-8?B?VnpzM3J6WlJEYTdSK0ZxSUxpMHIyR2FtVWhZZkxqcmNBek5tdHBrcjh4dHdr?=
 =?utf-8?B?Rk93TWlseTB1RHpEWkFCYkliRnYzVHdTR2t6RitUWWFQVjRtNWg3eXVhc0tR?=
 =?utf-8?B?c1htQk9hNjhVeUpwSVhnTFJZZW1JaWJiT2ROZUcwM2s4YWVJOVZOd3phbUp4?=
 =?utf-8?B?bTZzZWU5S0xYTmxmN3Z0SktFQ1Q2aXpJNEl4ZnhqOTRsK3ZxR0NsRno0R25n?=
 =?utf-8?B?V2QxdGUveERBbFhPdHFlVDkvSzF6WHNPMlQ2dkxaRnMyOC95YjIzWTJmNjNW?=
 =?utf-8?B?NGlaU2hzWmE5dUd6eXliWmhUa25UbUhmMUl6T1I2SmV5QWdhK09RMERuTHhS?=
 =?utf-8?B?UGQ1ak9aS2tiMzVsekowWjB2czBsUXQrN3ZUdjRsTGlRdjkwV1A5R0ZVa0h0?=
 =?utf-8?B?eE5peTl6VHVDMEN3aDlFdU5IaDI2VEM3dDhSeVAyQ29IbzQ3K2NUUExyT1lx?=
 =?utf-8?B?ZmlMVHo4SjVVeU9XVDJwcU5SQnRwNW5OVElXWm5YUHRldENoeTRxeUQ1TWJZ?=
 =?utf-8?B?SUNZT2ZmTHJFUEN0a2V6Nk1LM0JHQzRzZURDcTRaTFE2WjZvOHRudGFSL0JN?=
 =?utf-8?B?U1U2bTEzeGRCaHh0VGpXZFIxMmowY1dvL3VlcFhEVzRxdlU1Q0pZODE4TTBN?=
 =?utf-8?B?N2VjeDB3TEhtdjd5UGM2QW9Pd2M2akswRTI3c0tMcG9IcDFFbTJhNmcxZ3Zj?=
 =?utf-8?B?U2RQYWJPUUh5VTh1UFdwZThXOTQ4UlF4RHNTdHFEdWpGcHhaUlBST01idjhh?=
 =?utf-8?B?akxzRTVsakV5YVJmNEVWRE5FOG1ES0JEMDUrejdlRGxrUkQxdjRmZVpYWk5k?=
 =?utf-8?B?ZmNybmZXenhFK2tCUXZPSnNEdXdDekdwbXZFR0pyRDc4R2EzcmpweGdYd1hV?=
 =?utf-8?B?WjFDYjBjc2hTWkk5c1FWTS8xZ2NOeHBkSFVYUnZ2WTVGM0tFVTFXd2FEcGNi?=
 =?utf-8?B?VHM3UkVxQTBDVFRqaG14bTFYZXQwdy9heTVrVEVLL2pkS3ViaHBNQzFUallk?=
 =?utf-8?B?aGlXcFlGaEg5dlM0SXdLU1JLRVJjd2owSDdBOFl5eERZV2VLMVU0akpxd0Rq?=
 =?utf-8?B?d2dYZWVxeUJjc2hXM0U1VythVUg5ZmRQYzVJTlJxb2YvNkcxdDY1SW5UbFNI?=
 =?utf-8?B?a2M0eG1hQ2xnV3FVQ2N0QWZYY3YxaWdMNVFoWS90T01QTjd3OHRyQzVIVC9n?=
 =?utf-8?B?UWNQejNKU3dZMXpmTUk4VFFCaTRkSWttTlFybmlyU29mVlJEQmxQQVJDQ1Vz?=
 =?utf-8?B?UkxSbzhqTERwUks1TloyOWpWcHNRNFBOaXkzQjZXUW0xeE5aUC9odXdDcytv?=
 =?utf-8?B?dk9QZjRoNC9CdktKaU1VTktlS3hQM1lQUGRWUGtIQnJTNVJJdlMvQm9PMGhj?=
 =?utf-8?B?dVFmN0g3bmhHbjFJbmh2a3E3WXA5aS8vS24xR1Y0Z29HVEtqWC9qcEp3aXpU?=
 =?utf-8?B?K1dSem9QMDZUN1hLSFRVWlVNS24vQnI0cmlHOWoxMnZmSDN5SExnRDFnbEl2?=
 =?utf-8?B?TXpvTU05aEZqOWRoNDJXelMrTVY3M2IvWEdpUGVlVVRib0UzSVptOEpSajgy?=
 =?utf-8?B?L3d0OExzcm9obVVyYzFXNlNwQXJFZWpNSnBHdEhaOVdXUUdWKzNvUjNxWnFC?=
 =?utf-8?B?cVlsb1pIczFhTWlhTHdiaXY0aGhna0t3QW9kUzhhZDl2NHFnM09sUEpiZzdk?=
 =?utf-8?Q?4EhDbEoRDTEUzairhp?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd000a1f-dab8-4d0b-376d-08de504b15c1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR15MB6463.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2026 13:20:55.3316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0BLxQHLd96Z2xYuHu43CjGHrEGk8KXe1S38Mg0dKKkYJw/tD4pFHIvDv71gaqgsD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB6397
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEwMDExNSBTYWx0ZWRfX3DLlQR0zpr2C
 WkTmJjsDMr1si/LhvBL1Hc0RUYQ/m+Wa6WXt+ZPrjTKOFTuhhFImbA1DeKGYMyaa7GWMgFD5vei
 IDi9OnKmHCLKiWL9mtWODOJzcjEt8TpqwrcndE/ipOdz4P8LzErMdCqmuEC90MNObSlYbJjEiQb
 Qa0d11N2S1Xa1peUdQHbgi0Lbd5on9LFLODk3YIjeraxmv7XrwQKPiUhB51mfvEtpeq8V0czqgv
 4EMYHjczm3e+m/ButnxhfWhzPy7HxNP+GYDVidn0WLj87+m1RXrNBRr/fghK7j1mS+15w35SKBZ
 JOlR1Z0qYtmbYNaWeX6d/uTeKX0rDj7TOp9LaL9lb4vDuyKSdKgMYHI6jJlTh38gtP3XBOigltd
 dgYyUgOYd08mx7NHlrtUFI8KTU9wiw2NZFIxB8LCNi95Eu30DyvzQm7otpPRwVB5pH7aVZdqEg7
 L3a+V7KB7Da3bVg8Yfg==
X-Proofpoint-GUID: AQuIC213qOHcAVfrUIIso3-_pBqcCyas
X-Authority-Analysis: v=2.4 cv=f4VFxeyM c=1 sm=1 tr=0 ts=6962523a cx=c_pps
 a=EtrKi/+kAVY73poqiPL3VQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=vv0Oz4QAI_S6nznekUsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: AQuIC213qOHcAVfrUIIso3-_pBqcCyas
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-10_04,2026-01-09_02,2025-10-01_01
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1872F4000F
X-Stat-Signature: usz76m1umuqh4keherf5ui9rbnyjzqmf
X-Rspam-User: 
X-HE-Tag: 1768051266-497259
X-HE-Meta: U2FsdGVkX1/mkifv4FuPNi6LwgJbSIb6noo1U0VVm9UlNbwECO8Iphd+QboaF6PMACBCTAEHaZ8PKeddLU1kAnUyZp2WbZolgQ5HIEo4aTChrqxtXe9JUYTvKD/77wy3/RkFiAB4ei7zQAvxv8m9GfARrs9HaoxPG/wSl4zmtlYfsyn2P7ccZNtvwHOYSjhQBlSkG1UrwupYJGIcyksbqwrOJXsxYcMHmAQ1kfpuuvizPxVT2eww1xcF5psj5ZYvo68Sb+FMdiALvmrp0fr+ZqcwuoRKOJ8SGF3TGFiL54Ik7QMYt2X3UCueRiPL9d0CSIBCOO3qTJLpi7+saLcS4bC1ofUtYwqg7e1jnC6Br59iCQCuRuM7cEFDCC5rVqNyl0G70X1wzy3h+tRcIHVOvOtoYOaZ0tbFpw0kdI7/9+l83s5RUslDbs/L8bAu2evIYVv3oSXDt/mKKZBf6Gi0WMo/n8eFbjM4ktAjdJAwmZoFK6P1edCUqcMPTk090Bb9K6HQK3TPDzxVJfqYWK6ft6eVtoyO2Cz0VenCLiOO/2FBXqxr8JShZjqCkLeG7BxKDRt5QkqFG0umNnTP9NVwHEs5Pg48MheTCCXSqBQ313MbqcDFAuQSZZUQZnstSd/yOQ7hMmH4IaCA31tCVeo+uO2m7o3mOMMIjh0kwL+f9HlMGRFQF4Qtw6t9DvVLmrTVIg6K+aCEqEoo+YHQ5OqBbsjr6ZRSN6a/M6+j6W7SbsVR0pBlV1a0V/hu2gmCAw+D7btYP+2W58gWoVxPVBqpl1l1lMzWKgiI7vqNN5q8spQaqC7SV5jJwFIYWYmlgyzrN7mh/DiYEXnkeQtSCZsS3kQe1rDovPTIbsNaA0e1EzOdGYiA960Ru0dSZlNgMgYqVZrRgk2t5xbgjJ+K9oxEM0MyNEhFwxEIctmWhS0LQEQPwwd/XdJ4UUiFSUB05X5tRMIBY/S6FtbMIULvpl2
 dyrQjoLd
 4o8Nn6ZUt7c4CYISBbDo630ZN4G8HS40pSn+IlibDXyrCgQz5y1coPq0Dko6USFg7Pu062ZUxwwVkSquel7MRUNX9k1+zVdxKe2MFWtsS72ewp8gfp8bwaWabUkR3ZtBC9w8SAnhKtp9Jb+T+e0fGdc724I8cdncP+mQfelduWQaJ64VlwFR0+Mc5m/39ZxMBpy1I3RqdO9Tubq2H9qUA48URDd7yQh3zlSp7ak5Ggfh00NQcbZgymu8jDAmW/zVmH6gmkBeK3QapP7PkPQvoqxlj7g8D9i5xgkfLRoFcKMW3RA5JNB7Z+qu7yhzl4E+L6vNl28M6l4p9D42URMXw4J7Ubi3jIKrTIXZAy44Q4+h5yHKLAci0TXFxrI7iyrJ3Yubt4/BJev2dTqF1K7OUHAi00pX4kn/HkA/E3E35lewCW0/AOdkQXRJFCSedACVZ7rPhfIyMf5jAwLvnToUovT6jLuON+BZ9Tw6wxzAMe7xLofhkAG63odoNrKJdat4gCaGdmWibdMZBSIsLJ2eHFxclDSfbQB4jxE24vqNVTVz3hmpDEsdPZ0H7AQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 3:16 AM, Vlastimil Babka wrote:
> On 10/24/25 16:29, Chris Mason wrote:
>> On Thu, 23 Oct 2025 15:52:32 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

[ ... ]

> By the way, there was another bug in this patch, causing a severe memory
> leak, which the AI unfortunately didn't flag. Petr reported it during
> performance testing and it took me more than a day to find it. Oh well :)
> 
> Wonder if things got better since then perhaps, and your or Roman's tools
> would find it today? :)

Yes and no.  It didn't find the leak until I changed the prompt to say:
"there is a leak, find it".  I'll see if I can improve things...

> diff --git a/mm/slub.c b/mm/slub.c
> --- a/mm/slub.c
> +++ b/mm/slub.c

[ ... ]

> @@ -3592,54 +3549,53 @@ static void *get_partial_node(struct kmem_cache *s,
>  	else if (!spin_trylock_irqsave(&n->list_lock, flags))
>  		return NULL;
>  	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
> +
> +		struct freelist_counters old, new;
> +
>  		if (!pfmemalloc_match(slab, pc->flags))
>  			continue;
>
>  		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> -			void *object = alloc_single_from_partial(s, n, slab,
> +			object = alloc_single_from_partial(s, n, slab,
>  							pc->orig_size);
> -			if (object) {
> -				partial = slab;
> -				pc->object = object;
> +			if (object)
>  				break;
> -			}
>  			continue;
>  		}
>
> +		/*
> +		 * get a single object from the slab. This might race against
> +		 * __slab_free(), which however has to take the list_lock if
> +		 * it's about to make the slab fully free.
> +		 */
> +		do {
> +			old.freelist = slab->freelist;
> +			old.counters = slab->counters;
> +
> +			new.freelist = get_freepointer(s, old.freelist);
> +			new.counters = old.counters;
> +			new.inuse++;
> +
> +		} while (!__slab_update_freelist(s, slab, &old, &new, "get_partial_node"));
> +
> +		object = old.freelist;
> +		if (!new.freelist)
> +			remove_partial(n, slab);

Is there a missing break statement here? The debug path above breaks out
of the loop after successfully allocating an object, but this non-debug
path continues iterating through the partial list. Each iteration overwrites
the object variable, so previously allocated objects would be leaked.

The commit message says "Now we only want to return a single object" which
matches the debug path behavior, but the non-debug path appears to allocate
from every matching slab in the list.

> 	}
>  	spin_unlock_irqrestore(&n->list_lock, flags);
> -	return partial;
> +	return object;
>  }


