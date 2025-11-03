Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC63CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C39B8E00A5; Mon,  3 Nov 2025 11:22:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89AB68E0057; Mon,  3 Nov 2025 11:22:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789F28E00A5; Mon,  3 Nov 2025 11:22:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6589D8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:22:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10C401601FF
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:22:00 +0000 (UTC)
X-FDA: 84069812400.19.43D2551
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023127.outbound.protection.outlook.com [40.107.201.127])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF3F0120004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:21:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=dQbW1bdK;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.127 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762186917; a=rsa-sha256;
	cv=pass;
	b=Na1ODn3J3/51uJXzfrBa22YTduJD970fYQwcvKX6Q5q4Q1OykFfrEd/esw0wUkV+MQ0gDx
	cHeHgZQQ9HnSlb3HtAMLZu+2X7dW5Ay9PO1gTPCs6XnOEKLPUiAW6+mJzBd1dDtCcRRW57
	w6v1O7jCIZiGQ8d7m63esXiAbzmYqCc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=dQbW1bdK;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.127 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762186917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cY/e64ZG2WxDNGgQCtCdcmjyXl2s9NoFesewiIUfoY=;
	b=yj4niwI1v/YwB+HLniZb9A0l608LBaqOsMf9Pm7uZvqA+sQE5K52D4SZQs0iASv+wx9t36
	nQFa1bLQn16Pee4wFn+IGjtp2o6hdtsGbn74V82dArE6/EqSeDSYJkvZN06T/UDkrAY9du
	BDpstMEZOqsV2uXftBp8pjV/xiZd7dU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X89LTjuxaYjZD8WRDbY64yOuv2kS6ctKCqlKSjPjybRfxf7DMgzAX0PPfEkhtVyyvZhKWxJSIdH9iFJPbq/TJHxMlNT/CHQNhM1Lb8h3ISCEaXjMluWdO9BpFP8RsPMlgrh+ERzsr0YLJ+iJvngjfwxpz+2sJ63BCvrWrecPS+fEOkzIywVXpkZC99s9TSG50ULdvrzAwbraU3oli8H5Vxtd4pbWHPDg7TNHpPy5HWCef/N4JDCGwchc1oAjibiAWwtqYcsvO1QaAxGiifpCxtvzuhGgW6E2sfxOUavUq3xZaqzby6q9YwNeA9VysLjUclu4Gbe5JsA9qM/LuEYtGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cY/e64ZG2WxDNGgQCtCdcmjyXl2s9NoFesewiIUfoY=;
 b=TC2CJ+O59diKHzrFU6fMAhxNtzoyQQdcS2DvMN+Y5wzz4MXO4yNN9gBff6iAXi3FYB2lshRwmEp4l6bWHF54C7D5FYx6rjYTHVYqNoceKSEB+W2dwimas3qxizNJBQ/V459DmQ1mhAaVc3WyLZBn1u3lXPB3qApizS3/yn08eqjM0bO9AmWN56Et/n03vJmt7X9s1w6w6qhLllxBWkuW8367T6zVtFnojFzRVTIUw17b2gRCFBXjNBGYmgTGw6izETnrQc2AbynqH24KgbZkO0Zdou0W8f6hirRYCLXhRPdce4bDagQz7bn1ybZ4iudf47Hqe5KM+DFGovIENDHo6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cY/e64ZG2WxDNGgQCtCdcmjyXl2s9NoFesewiIUfoY=;
 b=dQbW1bdK6EDv7zU2Bo0DX4S4CxV7MRJ6ouYkAaP3jyxzdsgj9LOMWBKeD72f975uWIhHTpleWcr2DUo+jp4IMt8myMwCkQmSnqoJdxsq6lW4hvXy1kXFSt4mSxk4KPXFs99tTSE/3jVfLugo5GIxdICAOkMqXN7pRfROhzQwvoQ=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 PH7PR01MB8197.prod.exchangelabs.com (2603:10b6:510:2b8::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.16; Mon, 3 Nov 2025 16:21:51 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 16:21:51 +0000
Message-ID: <8a973a85-7c0f-4e3f-a63d-7565117d4073@os.amperecomputing.com>
Date: Mon, 3 Nov 2025 08:21:47 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Guenter Roeck <linux@roeck-us.net>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nd@arm.com
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
 <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
 <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
 <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
 <85e50475-7d2c-49df-924e-90e0b915a4d3@os.amperecomputing.com>
 <cbabb814-3ca5-4213-9346-a7de28aac474@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <cbabb814-3ca5-4213-9346-a7de28aac474@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:a03:331::31) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|PH7PR01MB8197:EE_
X-MS-Office365-Filtering-Correlation-Id: 8958417b-f7e2-4788-2ff4-08de1af51857
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2pMM3Y4U0dCaFEwYlYzOTFscGEraDA3WWtNUjRod3NDNHNMaDc1MlRKUlp4?=
 =?utf-8?B?MC9NV255N3o0ZDZaREF6L2tnWUZsVjNhUDk1Z2hlZFU0VkN2UVZEVW1QWTkv?=
 =?utf-8?B?WGRGbVoxd1ZyaVIrSFUzV1NOaklKTEdSeXVId21qZGxydE5uV09wVDRraUZz?=
 =?utf-8?B?L0dVOGYwSTBGV3JEK3llWVRVYy8ybWhzbHZXcjFkc0lpRFVhME84bktrMUZx?=
 =?utf-8?B?YVMwVUVGeFVlb1hmTkZrVFlKc0ZKOFNVNXNXOVpabjUxMW05VWc2STYvQXdT?=
 =?utf-8?B?Y0x3YzJBV2txM2VoQnVLbDRSYnExNzR5alczTHFEaXFORUcrNG90emQ3WGsy?=
 =?utf-8?B?M2pHa3FJQUFGNC9ZVDZkaEdhMS9ITXhmZEtESjRNajI1azlmWHJ1Z1JHQTk3?=
 =?utf-8?B?ZEY4WTA1bzUvbStEWG14dmxVTVZPdGNWZ1MxYWhUWjdKMDVtZ0RnbVl4NldC?=
 =?utf-8?B?TGF0Z2dYNnQ4UXkyakp2RzVzeFpDTy84ajdYMWxLSE9PR2ltbWgzeU5JcFdQ?=
 =?utf-8?B?bGlHb2pmSjJwVjJBbUZ2N3pRMFpBVVp0T0lGZEgwSUFlbDZGQmFxMURKNkNP?=
 =?utf-8?B?SEIxeGFIZHRjdDlJaXpBYjUreUNnK3NYU2RUMjhjSk9UU0VRMzZLUjNtSHRi?=
 =?utf-8?B?T0I3cU9ET1RyUllXZXNjelBDbzhRSjlpNU5TQUZWZkk5S05KbXowU3NUeHdV?=
 =?utf-8?B?Z0RVbTdjYUFDSlZoRXRkTDk3dnR2RklkK3hTY3duSzBVSkUvZWpHdXp5Qklm?=
 =?utf-8?B?ckw3UWxFVlFmeUlyTnE0bmZqc0pQUkxNTUdtQ0hJQzRpMU5BSFE2SkNiSW1O?=
 =?utf-8?B?TEZtQS9nTE1qTytVU0VCMkUvV1gxVHl0SnEyVks4YjFXSXhSb0xnUTA3SnhC?=
 =?utf-8?B?K2N3c1kzTzBFeHN2b0xobmtHUWtOQnV6OEROZTI3b1lKdDlGRW1vQUE3NExq?=
 =?utf-8?B?RXhnR01xUmZ2RE5pbUVKVVZIeFdBT012NXFyY09UblRWeWhCTHgxWVZzbEhl?=
 =?utf-8?B?WmtQdkVHbkJBTUZCcG9wb1VCQUV3QWI5TzBHMlQrUVBRSEtmcjNlVkFxSXlz?=
 =?utf-8?B?bWNpWkVTZWNwc3ArSFE2MXoxQUFsc1ZocGhYZTJzWERyMW1KSndGVXJhcWlW?=
 =?utf-8?B?YWtuODYrcHpuOTAwWkY1eVBHOUE5bzkrOFBNdHlOWXV3bkpaRktEY3J6cU5q?=
 =?utf-8?B?d0dna21EVHM0YzZIWGt5TXJoNU1jNS84M2ZkNzhjN3JpOThFY2o2MHpNcGlZ?=
 =?utf-8?B?dkdKbHpJaVVHSG95RWsrL051Z2F2U3BKU1p3N3NXTXAyRVBITmg1NkRtUGpj?=
 =?utf-8?B?ZmFiQ241QXVRSEo5RitNK2hZbG5GZzJIMmUweU5LTlR1UG5SYnVrSlZ2T2JN?=
 =?utf-8?B?V2UyUkNkVmdvZDgrQmFWQ3o0QkdXSDZGTnFyOUNlTnpPQmk1a1gxcjh2Q0M1?=
 =?utf-8?B?RVFsRERLRExrVTU1U2hQVkJqekRSQnFrWmUyTnV1bmpIVDRqR280VFRZdUVy?=
 =?utf-8?B?RmdSeVNsTENrOVB6dHdtNWcxb2pxczRXOENkOTZIWjUwV0E5dXJDU2xqV3BM?=
 =?utf-8?B?TVRzOGJxU3ZlY2V0U05WaVJqaHN4Z0dWZ20rb0RrVmdtK3BHeXJDZitVa2di?=
 =?utf-8?B?TStYMCtRWEpoUXlWemwvcjAyOEFaV2pNYncxemJzMTNONTJRcUc3YlI4bjV0?=
 =?utf-8?B?MkdrT1hKTlBzUWhINi8xd2xoU3RTejZEKzRPcEtOcVoxamZVWDFFSlVhMzJw?=
 =?utf-8?B?Qm9hZ3E4OXVEOTRXQjB5TGltQnBXUm1DNWlYTHl2Q012bENKZGpCUWhxckpt?=
 =?utf-8?B?b3VCQ1NSVUJ2M1JwY0FvaVprUUY1anB2YzRKQXhVVzJnRkZMWGRlcU1CdEh5?=
 =?utf-8?B?L0JhR3BHMDdvcjdyTkNZMm5aWFdUbm1qQWZRQ2k4ejZ4aVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2cwTHBhckQ5MktPTUlLMkZkd2g0L2lxNHdKSnFVVlBESm8raFdtTmpYajE1?=
 =?utf-8?B?VWEzeVJyOVRQNGg1bHNTU1d4ZHR6cUZxd21zbC9mUSt6YjdKazJvcXVSc3o1?=
 =?utf-8?B?R2xDM29DMTR3UHEwZ3NRZm9xY1BUUitIUkxISmxNcklxeHB5dmx0NzdHNVBy?=
 =?utf-8?B?WVdrWDBVdFd5R1l1UkQyTUk4ZXlyeGJkSDZpQVczMXNoTWVXK3RESHZ4OENS?=
 =?utf-8?B?bHNra0N2blZsL2w1cVNQWkVzSjJzczhZaTRWOEo1T0ZuMEdnK1NwUmN2US90?=
 =?utf-8?B?UUdYdERpNmI3YXluc3JUdnAwZnBSSVd6SXVaQ2E5eENhNTgycG92U2dteFd4?=
 =?utf-8?B?RDJHUGNHaE4vSHBDNUZQWkswU3JkQWtoZ3hCc1o5NUZHNTJucFoySEQzMGVW?=
 =?utf-8?B?RTV0ZWt4MVVSekdiMk4rNytLUnd1ZUdaYVIybXBTYStoRGZGbW9PbEZlVmlz?=
 =?utf-8?B?VUppb2FBMGZMZHovaTBEUWdialFwNHNTZVVVSDFjb3J3dUkyRDFyalBqUWo1?=
 =?utf-8?B?Rm9kd1ZSMUgwdDFtKy9nWW16SmpvRm9XdE9IeWZMajJDbm5XRkluR0Fqbitx?=
 =?utf-8?B?SVBFM0hUZTBVbnZTdHYvM2FQWVI1Z09QUUE4Q0FrN1ZUTUhNemdTdkRMbHN2?=
 =?utf-8?B?K2dRUEFlSVFqVnpQMGpKVzJZdlgzcmZTd1htNUMyK2kvNXl0bG0zZ3J6aGJt?=
 =?utf-8?B?OW9HV1JjWEVRNHE0clhqR0xJV0ovWUlxR0E0eWtJUGZLMUFnbkF4TXJINTAz?=
 =?utf-8?B?bGNwbldEeXV4YWdZanRDMk5lZGtZZEdueXU0UkpiNVZsaklhbzF3cXB1a1k3?=
 =?utf-8?B?V3I2V1gwZ2ZnK1REUDJ5eStZdWlRZXQ0U3g5eHRLTEFPRHNDdGI3aE5iM0pM?=
 =?utf-8?B?YktDYkVJVXB5RDhkR1JGZDhDeFk5dm5vL2tlTjFKd25ZaFJxTTAzNGtFZ05K?=
 =?utf-8?B?V2ExeGRFY3BRM0hiQkpOM3JGa1NHOTR1WWFlNmw3Z2NFSEI2dEZhc1ZiclM3?=
 =?utf-8?B?dEYwZkpURXVPTk13M0s0cUh1bWZZUERjc0ZVNWQ2M2VleDhsR054Qm5Pem9Q?=
 =?utf-8?B?eGFEZ2lrS0dYeFpHNFNmb3lTa29iODVHcHEyRHJlaVpxcjNkbFlXMmtTWGEw?=
 =?utf-8?B?bGFTYXBWamRXVEViRkcwT3p5U3pvT3FQU21ObkJ6cUUrTUZRVXI0SVpjQ21w?=
 =?utf-8?B?T1RrSmFySFd2dHJqY2dsSjMzdzBmcGpOT2JJcjVDUjJvR0hmKy9wN3B1QnBo?=
 =?utf-8?B?SXpiY3Y4V1RiOWdabXpDTThwQlhnblhGSk5DUDQrNnJ3TVNIS0dTWTByRlI5?=
 =?utf-8?B?VjlxcGJ4OE5DSE83TWVoNFp2NHFQb1UrRC9hMlVuQ0luQjRwZ2dwdS9jV2hY?=
 =?utf-8?B?Um5LY1lvNEQzQlBVNmJUWi9jd0VzVXRkUFFXYTI2dWhpWDEraFVmSkNhQUt3?=
 =?utf-8?B?dnRYaTFhUkxrK2t6aHlnRUxVU2JoSGxqbm1UVGJURjRJMUxPeWx4Nkx1K0s0?=
 =?utf-8?B?OVJvRFA3MWUzMjhKQWMzTmNzM04rNm1MZDMzcExhc3pJbGIreHdWZjdLMm85?=
 =?utf-8?B?ZFRCbzZnMFVjTzdGWkJranRka0kwNDJLTGh1OFo3M1hzR0FYZWlVSjlqSHRD?=
 =?utf-8?B?b0xuZXlOTFJJcEVnUjBlQ2EveTJhWnFEMlFpS2M2em9vY2FUYjJKZVEyS25P?=
 =?utf-8?B?T1BXOHJEVy9QZVdFT1BYSytRM3AydkY3d1dtWURQQzFPWDUvNmtseTl1bE52?=
 =?utf-8?B?cGFWT0hYNGVicjhaRGZzYVVhODEwT2xCN1VGVFJaa1BTaUpvT1FjbmNRbmg3?=
 =?utf-8?B?YXdBeThmWTRRTmNzZU84MHBHdGFvUFZSOGVXRHlPTlovRUpDVmIzbmV2bTUy?=
 =?utf-8?B?WnhNclV2TVhtRitjKzYvTzFmcVVNUWRHaUpmTjBSWWt0cXUxb2xacDFNWE9R?=
 =?utf-8?B?REdCVmN0eVgwS2xUMTE5ZkdyRkwvUVdORkt6TzNwb2VhNUpndkF1RDBoc3Nr?=
 =?utf-8?B?QzN4L1pXbjJWMThtNHVxOTdBU0V5ZXdvZ3BFcGNtN3V1UlJxSlBUNFRsUkZO?=
 =?utf-8?B?ellIYmRUdzdmelJ4czhnSkZKUEJOcGlSZTcxa0o5ODJ3Vmc0UG5laFJnWXBB?=
 =?utf-8?B?SkdqTWRKZC8wa3lvbGlZbk9SS2dOcVh0RmdiYW9qTE1nSExaTnpmdkVEQW9D?=
 =?utf-8?Q?9Veoi+xvqLl8b2GwxGZ8imY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8958417b-f7e2-4788-2ff4-08de1af51857
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 16:21:51.3295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qAswakKuehpGunMTDqLzZT1f+/U6ez6/cJTp9vrmaMnkGzCFrOBjLOrPmy+uDqP01tfwQ892Ef5dE9SsM4QGuwguoRXu9y6vB/8E0m8B4sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB8197
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF3F0120004
X-Stat-Signature: iosq7yzrxstbwybqm1hka373acec3qt4
X-HE-Tag: 1762186916-885436
X-HE-Meta: U2FsdGVkX1/0wHFnW2zDdLuKPAPbSxdhCmYAlzWtEZu57BEmPtQ7yZBUjIVXkeqVo6plUh9mbKf+Yhk1WKwEW18X247ocHj/4Z0uR1HO8BeNwEPBcMCHX0cuanC4QAhQL0HmlM4KjxGXf7uyhvK1yKV3XlJXstR+EjNAxj8kqCNUf8qbOYbpxhM9pfy0m1c4jHQIatpI/NSQLuByR41VILv4ziy+u6uhm0MIL4eNfWaDB2hr0i1t62K0zQeuf2kqHmr2zLD/7alV3jr7/VuPPgtPEl6d0hewTjVweRqNje6IUAzwYJBxsvsU6IxccFhuzB3a5rgGZNMv6cN1cCZfoe5e5iCKRt7uNQ1GqsWuiJAB+U9aHVwk3LdVLeRpsy9k0PWUz4f6zixxsMlTIUJ87Yr1m73/XDQMfiJCIrVmrYRdKM9AfXdWZSIomDHpHGYkQtd44R1Six5hDtyYwkUJc9EcB6u5jluCpEFU6uNNdrkrWzouAktDzELsCQkxzBM2Z1PbXoyPoI15ljyWysba4Hhtv533MLfQNDob3DSLJyZjwJ4Qy95trGJGlFSGIbDKwzIaXWsCzTu5Y1AApEznzkuqVn3WHYIOyGTsAbcGAV+DsOb/ZRrjuXGzHA3BfilXHG/bDbfenPwRPp3sgDrg4LXHRZQZ5jlUoPx71fmOISoQjL4PcL1MliPRNfUaE6LTo8qQXlNlNjQ7O4DpPPVH4LCUcac5lW9HSDG2kPOBj0+CfG9ksapjSHfhWBaZ/iBd7K9yaGO3x3esaym9m1Y549NsIY9lf1OmlMmL8qBtEX0QXf/sT2MSYtqupaU9Ixaq5Spx9+Xgp5BbVUIcJWdedSXUj9nTGBeRkr9oCDyJhOS10+kuOtm7Vn7+bNL2WZscotzdh4PXIGPt9gyY+mGq2Gj82TQZ2YkLg0/X1p5GHapVkXUW9UCppHtPKJYpZt5SwiUYLVAJX6ArxWd7aUU
 uzvTVg98
 UzM34jCOgLiv6JpukvQRoIl7+Zi66pPV9I88kuYhjntkuTpvJpdWfblUfWq3aiztb9cy5sUgAnmiErQ1f6ghrBAIPW5B+LG8G8QRcQuIwG5/fWwFlomgaoJio+mQleElZZIHRiOgRh3x2gZE9mG+tfYOjH3wJ2XeFt9PryJA1yW0cf2p1ZBrN8YFYGJ/HmKIZ3n/SapZRRTgR/gCfjKyb7rdBFG+py6c+IScL9WB+aQksJt4mx2JsmqHtye6LuwsVIocMyI3MUF+LqZUXwhNCf9dX3LRNxB0xvfFfxD2869FLhIKebq0j314OgT6CJ3I0uDmk60NXQ3Rt6n5b0FKJ0UAOMtpagDDX9qxkDUV2E3kWriMbhLQYuvtNk2xr9PiZI4mo+Q8umj4mXAK2QIYzmqkdbCmcRHaRIdxmlI2JUxaqfOYQQ1/2JMmf2inf/Pee7h9T3LY0VnDXInZcaufG8u8mayTu1jVR8KMkFvgw0gh/6EOTtFuBT3/E81Can9prVOTT1HLWE6VfZaDy44thbqdU2Nf1wTWwe0pUVZ/FvXz4sSCCzu5Hg6uiRCobKSiAjnAz2HnQXXcqg3Vc0iBmviMQreVOp5VaLYUoZEvealqgyubrEEReamTo9hZ91ie83xzTEo+f0g4GqI4oTJ8L/qyIMTIK41K+zWefyGpo5Sy9cpFlQb0vYFEBTNnXW/jk3FihSpKN12avkeE0YPj32uP1qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/3/25 2:07 AM, Ryan Roberts wrote:
> On 03/11/2025 00:47, Yang Shi wrote:
>>
> [...]
>
>>> @@ -723,6 +733,16 @@ int split_kernel_leaf_mapping(unsigned long start,
>>> unsigned long end)
>>>        if (!system_supports_bbml2_noabort())
>>>            return 0;
>>>    +    /*
>>> +     * If the region is within a pte-mapped area, there is no need to try to
>>> +     * split. Additionally, CONFIG_DEBUG_ALLOC and CONFIG_KFENCE may change
>>> +     * permissions from softirq context so for those cases (which are always
>>> +     * pte-mapped), we must not go any further because taking the mutex
>>> +     * below may sleep.
>>> +     */
>>> +    if (force_pte_mapping() || is_kfence_address((void *)start))
>> IIUC this may break kfence late init? The kfence_late_init() allocates pages
>> from buddy allocator, then protects them (setting them to invalid). But the
>> protection requires split page table, this check will prevent kernel from
>> splitting page table because __kfence_pool is initialized before doing
>> protection. So there is kind of circular dependency.
> I hadn't considered late init. But I guess the requirement is that the kfence
> pool needs to be pte mapped whenever kfence is enabled.
>
> For early init; that requirement is clearly met since we pte map it in the arch
> code. For late init, as far as I can tell, the memory is initially block mapped,
> is allocarted from the buddy then every other page is protected via
> kfence_init_pool() from kfence_init_pool(). This will have the effect of
> splitting every page in the pool to pte mappings (as long as your suggested fix
> below is applied).
>
> It all feels a bit accidental though.

Yeah, it is not that explicit and obvious.

>
>> The below fix may work?
>>
>> if (force_pte_mapping() || (READ_ONCE(kfence_enabled) && is_kfence_address((void
>> *)start)))
>>
>> The kfence_enabled won't be set until protection is done. So if it is set, we
>> know kfence address must be mapped by PTE.
> I think it will work, but it feels a bit hacky, and kfence_enabled is currently
> static in core.c.
>
> I wonder if it would be preferable to explicitly do the pte mapping in
> arch_kfence_init_pool()? It looks like that's how x86 does it...

I agree, this looks better and strongly and explicitly convey the 
PTE-mapping for kfence pool requirement.

Thanks,
Yang

>
>> Thanks,
>> Yang
>>
>>
>>
>>
>>
>>> +        return 0;
>>> +
>>>        /*
>>>         * Ensure start and end are at least page-aligned since this is the
>>>         * finest granularity we can split to.
>>> @@ -1009,16 +1029,6 @@ static inline void arm64_kfence_map_pool(phys_addr_t
>>> kfence_pool, pgd_t *pgdp) {
>>>      #endif /* CONFIG_KFENCE */
>>>    -static inline bool force_pte_mapping(void)
>>> -{
>>> -    bool bbml2 = system_capabilities_finalized() ?
>>> -        system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
>>> -
>>> -    return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
>>> -               is_realm_world())) ||
>>> -        debug_pagealloc_enabled();
>>> -}
>>> -
>>>    static void __init map_mem(pgd_t *pgdp)
>>>    {
>>>        static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
>>> ---8<---
>>>
>>> Thanks,
>>> Ryan
>>>
>>>> Yang Shi, Do you have any additional thoughts?
>>>>
>>>> Thanks,
>>>> Ryan
>>>>
>>>>> Thanks,
>>>>> Guenter
>>>>>
>>>>> ---
>>>>> Example log:
>>>>>
>>>>> [    0.537499] BUG: sleeping function called from invalid context at kernel/
>>>>> locking/mutex.c:580
>>>>> [    0.537501] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1,
>>>>> name: swapper/0
>>>>> [    0.537502] preempt_count: 1, expected: 0
>>>>> [    0.537504] 2 locks held by swapper/0/1:
>>>>> [    0.537505]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at:
>>>>> sched_domains_mutex_lock+0x24/0x38
>>>>> [    0.537510]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at:
>>>>> rcu_lock_acquire+0x0/0x40
>>>>> [    0.537516] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-dbg-
>>>>> DEV #1 NONE
>>>>> [    0.537517] Call trace:
>>>>> [    0.537518]  show_stack+0x20/0x38 (C)
>>>>> [    0.537520]  __dump_stack+0x28/0x38
>>>>> [    0.537522]  dump_stack_lvl+0xac/0xf0
>>>>> [    0.537525]  dump_stack+0x18/0x3c
>>>>> [    0.537527]  __might_resched+0x248/0x2a0
>>>>> [    0.537529]  __might_sleep+0x40/0x90
>>>>> [    0.537531]  __mutex_lock_common+0x70/0x1818
>>>>> [    0.537533]  mutex_lock_nested+0x34/0x48
>>>>> [    0.537534]  split_kernel_leaf_mapping+0x74/0x1a0
>>>>> [    0.537536]  update_range_prot+0x40/0x150
>>>>> [    0.537537]  __change_memory_common+0x30/0x148
>>>>> [    0.537538]  __kernel_map_pages+0x70/0x88
>>>>> [    0.537540]  __free_frozen_pages+0x6e4/0x7b8
>>>>> [    0.537542]  free_frozen_pages+0x1c/0x30
>>>>> [    0.537544]  __free_slab+0xf0/0x168
>>>>> [    0.537547]  free_slab+0x2c/0xf8
>>>>> [    0.537549]  free_to_partial_list+0x4e0/0x620
>>>>> [    0.537551]  __slab_free+0x228/0x250
>>>>> [    0.537553]  kfree+0x3c4/0x4c0
>>>>> [    0.537555]  destroy_sched_domain+0xf8/0x140
>>>>> [    0.537557]  cpu_attach_domain+0x17c/0x610
>>>>> [    0.537558]  build_sched_domains+0x15a4/0x1718
>>>>> [    0.537560]  sched_init_domains+0xbc/0xf8
>>>>> [    0.537561]  sched_init_smp+0x30/0x98
>>>>> [    0.537562]  kernel_init_freeable+0x148/0x230
>>>>> [    0.537564]  kernel_init+0x28/0x148
>>>>> [    0.537566]  ret_from_fork+0x10/0x20
>>>>> [    0.537569] =============================
>>>>> [    0.537569] [ BUG: Invalid wait context ]
>>>>> [    0.537571] 6.18.0-dbg-DEV #1 Tainted: G        W
>>>>> [    0.537572] -----------------------------
>>>>> [    0.537572] swapper/0/1 is trying to lock:
>>>>> [    0.537573] ffffb60b011f3830 (pgtable_split_lock){+.+.}-{4:4}, at:
>>>>> split_kernel_leaf_mapping+0x74/0x1a0
>>>>> [    0.537576] other info that might help us debug this:
>>>>> [    0.537577] context-{5:5}
>>>>> [    0.537578] 2 locks held by swapper/0/1:
>>>>> [    0.537579]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at:
>>>>> sched_domains_mutex_lock+0x24/0x38
>>>>> [    0.537582]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at:
>>>>> rcu_lock_acquire+0x0/0x40
>>>>> [    0.537585] stack backtrace:
>>>>> [    0.537585] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G
>>>>> W           6.18.0-dbg-DEV #1 NONE
>>>>> [    0.537587] Tainted: [W]=WARN
>>>>> [    0.537588] Call trace:
>>>>> [    0.537589]  show_stack+0x20/0x38 (C)
>>>>> [    0.537591]  __dump_stack+0x28/0x38
>>>>> [    0.537593]  dump_stack_lvl+0xac/0xf0
>>>>> [    0.537596]  dump_stack+0x18/0x3c
>>>>> [    0.537598]  __lock_acquire+0x980/0x2a20
>>>>> [    0.537600]  lock_acquire+0x124/0x2b8
>>>>> [    0.537602]  __mutex_lock_common+0xd8/0x1818
>>>>> [    0.537604]  mutex_lock_nested+0x34/0x48
>>>>> [    0.537605]  split_kernel_leaf_mapping+0x74/0x1a0
>>>>> [    0.537607]  update_range_prot+0x40/0x150
>>>>> [    0.537608]  __change_memory_common+0x30/0x148
>>>>> [    0.537609]  __kernel_map_pages+0x70/0x88
>>>>> [    0.537610]  __free_frozen_pages+0x6e4/0x7b8
>>>>> [    0.537613]  free_frozen_pages+0x1c/0x30
>>>>> [    0.537615]  __free_slab+0xf0/0x168
>>>>> [    0.537617]  free_slab+0x2c/0xf8
>>>>> [    0.537619]  free_to_partial_list+0x4e0/0x620
>>>>> [    0.537621]  __slab_free+0x228/0x250
>>>>> [    0.537623]  kfree+0x3c4/0x4c0
>>>>> [    0.537625]  destroy_sched_domain+0xf8/0x140
>>>>> [    0.537627]  cpu_attach_domain+0x17c/0x610
>>>>> [    0.537628]  build_sched_domains+0x15a4/0x1718
>>>>> [    0.537630]  sched_init_domains+0xbc/0xf8
>>>>> [    0.537631]  sched_init_smp+0x30/0x98
>>>>> [    0.537632]  kernel_init_freeable+0x148/0x230
>>>>> [    0.537633]  kernel_init+0x28/0x148
>>>>> [    0.537635]  ret_from_fork+0x10/0x20
>>>>>
>>>>> ---
>>>>> bisect:
>>>>>
>>>>> # bad: [3a8660878839faadb4f1a6dd72c3179c1df56787] Linux 6.18-rc1
>>>>> # good: [e5f0a698b34ed76002dc5cff3804a61c80233a7a] Linux 6.17
>>>>> git bisect start 'v6.18-rc1' 'v6.17'
>>>>> # bad: [58809f614e0e3f4e12b489bddf680bfeb31c0a20] Merge tag 'drm-
>>>>> next-2025-10-01' of https://gitlab.freedesktop.org/drm/kernel
>>>>> git bisect bad 58809f614e0e3f4e12b489bddf680bfeb31c0a20
>>>>> # bad: [a8253f807760e9c80eada9e5354e1240ccf325f9] Merge tag 'soc-
>>>>> newsoc-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
>>>>> git bisect bad a8253f807760e9c80eada9e5354e1240ccf325f9
>>>>> # bad: [4b81e2eb9e4db8f6094c077d0c8b27c264901c1b] Merge tag 'timers-
>>>>> vdso-2025-09-29' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>>>> git bisect bad 4b81e2eb9e4db8f6094c077d0c8b27c264901c1b
>>>>> # bad: [f1004b2f19d7e9add9d707f64d9fcbc50f67921b] Merge tag 'm68k-for-v6.18-
>>>>> tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
>>>>> git bisect bad f1004b2f19d7e9add9d707f64d9fcbc50f67921b
>>>>> # good: [a9401710a5f5681abd2a6f21f9e76bc9f2e81891] Merge tag 'v6.18-rc-
>>>>> part1-smb3-common' of git://git.samba.org/ksmbd
>>>>> git bisect good a9401710a5f5681abd2a6f21f9e76bc9f2e81891
>>>>> # good: [fe68bb2861808ed5c48d399bd7e670ab76829d55] Merge tag 'microblaze-
>>>>> v6.18' of git://git.monstr.eu/linux-2.6-microblaze
>>>>> git bisect good fe68bb2861808ed5c48d399bd7e670ab76829d55
>>>>> # bad: [f2d64a22faeeecff385b4c91fab5fe036ab00162] Merge branch 'for-next/
>>>>> perf' into for-next/core
>>>>> git bisect bad f2d64a22faeeecff385b4c91fab5fe036ab00162
>>>>> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/
>>>>> misc' into for-next/core
>>>>> git bisect good 30f9386820cddbba59b48ae0670c3a1646dd440e
>>>>> # good: [43de0ac332b815cf56dbdce63687de9acfd35d49] drivers/perf: hisi: Relax
>>>>> the event ID check in the framework
>>>>> git bisect good 43de0ac332b815cf56dbdce63687de9acfd35d49
>>>>> # good: [5973a62efa34c80c9a4e5eac1fca6f6209b902af] arm64: map [_text,
>>>>> _stext) virtual address range non-executable+read-only
>>>>> git bisect good 5973a62efa34c80c9a4e5eac1fca6f6209b902af
>>>>> # good: [b3abb08d6f628a76c36bf7da9508e1a67bf186a0] drivers/perf: hisi:
>>>>> Refactor the event configuration of L3C PMU
>>>>> git bisect good b3abb08d6f628a76c36bf7da9508e1a67bf186a0
>>>>> # good: [6d2f913fda5683fbd4c3580262e10386c1263dfb] Documentation: hisi-pmu:
>>>>> Add introduction to HiSilicon V3 PMU
>>>>> git bisect good 6d2f913fda5683fbd4c3580262e10386c1263dfb
>>>>> # good: [2084660ad288c998b6f0c885e266deb364f65fba] perf/dwc_pcie: Fix use of
>>>>> uninitialized variable
>>>>> git bisect good 2084660ad288c998b6f0c885e266deb364f65fba
>>>>> # bad: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm'
>>>>> into for-next/core
>>>>> git bisect bad 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>>>> # first bad commit: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch
>>>>> 'for-next/mm' into for-next/core
>>>>>
>>>>> ---
>>>>> bisect into branch:
>>>>>
>>>>> - git checkout -b testing 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>>>> - git rebase 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>>>>>     [ fix minor conflict similar to the conflict resolution in 77dfca70baefc]
>>>>> - git diff 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>>>>     [ confirmed that there are no differences ]
>>>>> - confirm that the problem is still seen at the tip of the rebase
>>>>> - git bisect start HEAD 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>>>>> - run bisect
>>>>>
>>>>> Results:
>>>>>
>>>>> # bad: [47fc25df1ae3ae8412f1b812fb586c714d04a5e6] arm64: map [_text, _stext)
>>>>> virtual address range non-executable+read-only
>>>>> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/
>>>>> misc' into for-next/core
>>>>> git bisect start 'HEAD' '77dfca70baefcb988318a72fe69eb99f6dabbbb1~1'
>>>>> # good: [805491d19fc21271b5c27f4602f8f66b625c110f] arm64/Kconfig: Remove
>>>>> CONFIG_RODATA_FULL_DEFAULT_ENABLED
>>>>> git bisect good 805491d19fc21271b5c27f4602f8f66b625c110f
>>>>> # bad: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large
>>>>> block mapping when rodata=full
>>>>> git bisect bad 13c7d7426232cc4489df7cd2e1f646a22d3f6172
>>>>> # good: [a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8] arm64: Enable permission
>>>>> change on arm64 kernel block mappings
>>>>> git bisect good a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8
>>>>> # first bad commit: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm:
>>>>> support large block mapping when rodata=full


