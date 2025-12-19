Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC27D7878C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD44E6B0088; Fri, 19 Dec 2025 10:43:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82416B0089; Fri, 19 Dec 2025 10:43:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C8A6B008A; Fri, 19 Dec 2025 10:43:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C36F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:43:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 331651A02BD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:43:05 +0000 (UTC)
X-FDA: 84236639130.13.B8AA9CC
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 155D9A000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:43:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o2juLkbh;
	spf=pass (imf15.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.107.200.56 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766158982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snkrFZRnneELA+DABA/hKjHw9SRMJLXUl8Wk7/tgb+E=;
	b=Keg331NDOpF6EcAB+sBNnI28UtnuIqthSiWeC1bGxxRpp8bN5i5tJ7xEiVt3lX6M+qrh1p
	iKNPTZ7Y2etbR/Iq5X8wOLswap6PTmkm85qp0y3ARw5DPGsqJ314X5rcgOTm0h7r7I+Kof
	M8KTAzA8gCNheoDsmPn0M+OEgCD3W8E=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o2juLkbh;
	spf=pass (imf15.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.107.200.56 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766158982; a=rsa-sha256;
	cv=pass;
	b=ZlkfRkRP2+En1Zvmg3kuWQ99quGCJkS6wKS0AV0RupMpQFsesLEmIu9vutlkjabnX4D9jU
	+rHCZkgojRLE4druW3l6sjXuIWLyCSNkhqphyoz6B854EWAT87LKnmOGGWMJrFtvWKkCXM
	RBpuR2fzfxJma47gv3mn/TNKK8MtSmc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RC8x6oS2r7BO3vynSbiQEZ5wEcZwxNDYpTDBEz+LddjFlKCuPVqV2wlh+lLTmN48iF6QG6P3sIO/xmaZL83pk3fBZbxV7hnClK+gt5iuKcagqlrFvmLTi4juc836lE5onB4KRT/eywRelVucTk5DsIjo/2O6n3CH0iYM6V0xdX0Gaj+hoTDCl2wvrmnq/3DR+LakFPbZANJdgfL9+IlS3/a3YylnNqm5SaMIOCc5JRQ1PJZE+5h6D+zU7m/vZnT7c6Bhkri8L2OloQa2CxxW8N2nvRNgXSyvY1y3cuNkiBn7CmNW5X31wIeai6+JIzx6aT92kfF6L5zdXam5P/8R/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snkrFZRnneELA+DABA/hKjHw9SRMJLXUl8Wk7/tgb+E=;
 b=IqAgheIuVbBQpCUnbHO1QY2kKyswipOhri4Pfjw6u2XBFqeaZaGdXBwBULoLFs1BmLb2DUe5rxzS6BYpLwuTWhqL8yqxNMv15C87NIwqQUMJ5o0BV37Y0uBGrGGHTWn9ZanIdMrgKp52RID+kk3PbFzF+rpvjqd4lhOYZGYk5wSABdVx7qkFoiF+Y8uRCkXBMtUjV13E2Ldd/VOO2pvDV/sVLit7RBhXpWGoUWL3a0sOq1wX4CQNyiRDtCPZVWaWu9pshBhYYPkoX9whuOsHfbf6Hby/kq6//bvo6WlPE33sQjEC9ueTXLAB5TJjYrCAOZo9SF3lIc1ubkJDwN57MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snkrFZRnneELA+DABA/hKjHw9SRMJLXUl8Wk7/tgb+E=;
 b=o2juLkbh6wZHZGW4mQLiRTBUJAAZJU7capRUjVG1BwaloAqw+o11ik13KVVz8PmrCrepBmEExL/i8f8cywbnjmsIPp4IDuLP/++ycsWFdkTC+p/8s9PVAEH/iGXQ85NcvNCRMC8RG97wqE0ahiVFosOdQwgNHJHwf/ODKI77LUgZi88i9YExlHycqQONB6IMTy0s02+WJI/FbeKqYXfp+Y96yeqxv8uQtZs/OhUz3SaUgoxNJds6d2Zp2UWPxGy1P4Fvl1vTQDu3ThfZgMkKLMYEMNr7piCfqJmR/RV65saZaCs4eIpPA/LcaVaIGtxoMw+lUuaRxNoC56Vr8oQCKw==
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by CH2PR12MB4247.namprd12.prod.outlook.com (2603:10b6:610:7c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:42:59 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%2]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 15:42:59 +0000
Message-ID: <6353feeb-c2ab-4ff6-9ea6-04ae5102641d@nvidia.com>
Date: Fri, 19 Dec 2025 10:42:56 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Boqun Feng <boqun.feng@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
 <aURihbmjsKi8m7MO@tardis-2.local>
 <42607ed5-f543-41bd-94da-aa0ee7ec71cd@efficios.com>
 <aUSbhiMgluudbVEG@tardis-2.local>
 <edbe45b3-0f85-48d2-8d4f-784781a8dee5@efficios.com>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <edbe45b3-0f85-48d2-8d4f-784781a8dee5@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR12CA0020.namprd12.prod.outlook.com
 (2603:10b6:208:a8::33) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|CH2PR12MB4247:EE_
X-MS-Office365-Filtering-Correlation-Id: 348410e9-85c6-4256-cf43-08de3f154934
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDFkcXMvdkhmSEZvKzBDcUg1OTRIWll0aUcycGQyTk9MVjcwNFl5a1ZKWVg4?=
 =?utf-8?B?RG5WbDhLOC92TUxVZWs0NnJXWUpxMStQWEhzendsdElEa08zYmxIT2hkQzg5?=
 =?utf-8?B?eXM1M0JXcGxJWG42b0ZDUk1yUmFRUkREclRpNXBZSUxzQ0lUeHZCTStoUGN0?=
 =?utf-8?B?YngvWndZRFBxc3l1OTgzZ3A1SVRhV090empSRDljN2c4T05RT21Ud3V1em0x?=
 =?utf-8?B?MThOc2NmTEpvRWZUdTEvb3NKbU90dStOOWE4SFc3S2xTN0dpRmdKRDRaMlFG?=
 =?utf-8?B?dnBOc2o3VFA0VmR1L2ZtaGRDMW1NYTRyTHFCY0RlWCtLeTNvTmtGUXNGWHhO?=
 =?utf-8?B?cUJVa3VaNllhYmFlZU1NbXNyWFNLbW1XUFhydjErVjdQMDJRdWtHRnJqU3FR?=
 =?utf-8?B?M25NakJFeVFQRGtLQVpTSFp4dHlYY095aUFxdFpJdzE3SnExcDN3MFo4Ymsy?=
 =?utf-8?B?MEhrQk9OcUp0OFJYWVNiZlNsNTFxckhRdkZwNmF4L2YwNWFldzBGc1YzVnJC?=
 =?utf-8?B?UGN2LzhadWZhQThaV3dvcVVzbVFTRjA2VmVPZkcrcWtrSmhQQnpvT1VvbTE4?=
 =?utf-8?B?dksvZFNQTXNUSjRmbURpdTZYeXlOT3htUHRTUGRqY2NKRXlmdGFtSC9BTnZm?=
 =?utf-8?B?TE51WDFyOTRnUXBTL25WK2RDWnQ5Ri9xZkJPVXZMS2FPb09VdThic3ZCTnA3?=
 =?utf-8?B?MmVxcVlBd1NxT0dTUmYvd010bnBialhaNXYwZ1NIRnBjZFNrTmZFMUVlaS9h?=
 =?utf-8?B?bTNBN0RIVVNXY0NzY3pMZml2WnRFUzFxdUI0d1hmZStHdDJPaVZBRHRud1Vx?=
 =?utf-8?B?Ykx2ay9kKzcvS1V5L2xYTFJGVThxSExMRnl4d1FlUUYzVEZDYWhyTzgraFVr?=
 =?utf-8?B?MjJtL2dNUFRhMXE4L1hjak9nUHVxMjBVTlZVakNCT1hYODJnZmlFUDNoSU90?=
 =?utf-8?B?a3piY1pqSTBmZVJQTGp5V2NlZWtJRXdjSmMwak9LODNVbEtzNm9QeGtJakRl?=
 =?utf-8?B?Uy9vSW9jQ1I1TDBDeHc4eTd5MU82LzRCWVIxYmFNM01USjhNZDJLTU9IRG9x?=
 =?utf-8?B?bWFNTnhtNVBhOElGbG9LQXZUdmFqeDVRaXA0Y3ZKeU5YSk10L3ovWmZva0hw?=
 =?utf-8?B?ZGJBQnA4V0RFa3hpYVJEZlIrenNHY0wrZ2x5djVxS0p5aE4yYlN2b3pMMTdN?=
 =?utf-8?B?TjB3R2Rsd0JkN2JubUZ3OXJqTVlFOGIydi8zUENLbUlTd1NBOEE0ZkIxbzY1?=
 =?utf-8?B?THhyZ0hpZnNjWkkvd1FheSs2b1BFMStWWkNOOGFtdk1qYzlKVmpUNmNsT3ZD?=
 =?utf-8?B?QitTWDdaWTZmTVlQSGZ3T0QrbFV6eWJEVE0xampDZHR2WWVqa2FUZ2d6dmxB?=
 =?utf-8?B?SW40R3poU3RVbTFibndEYS9mWVVUMVRsMllpL3IweHMrd2c0UEJxN0tnY0RZ?=
 =?utf-8?B?K1NaR2lXWTE2WGlxbEFmaCtELzJkKysvaFVQUE45TWVKU2ZuOWszLzFhS2Fk?=
 =?utf-8?B?UHYyQUwydUV0aWR1UHExVDkwV2U4TlYyRys1NUJtSVhiaEdRejZBb0VGckhD?=
 =?utf-8?B?SURlNnhycExzdStyVVdBTnNsaTZoSTRBd053SURZK0hXQWc1TTd0b0R4QTV4?=
 =?utf-8?B?NUQ3Y2NkTHhTWUgwTWc3QkFnRWQrb0IyMDh5SEU0MERvRU1kNHVDZzZoQjJx?=
 =?utf-8?B?WXpqcG1ta3hkQ1k5VjYrbDF1NmV0RHFUVEJFVTFCMzYybGFPSWVURk55Z2Rn?=
 =?utf-8?B?WkdpU3dGK01oc01jemswb0NJMTFxbTFSaDl6cmYwWlkrbngzSWJlYUh3bVB5?=
 =?utf-8?B?TWRzNFlER1BvTmFiU2lHb0IrR1ZhU25pdThxR0t4OTdPeHp2US9YVkthVXky?=
 =?utf-8?B?V0syTE52TVA1RjhtbWd3RUpQZ2NRNEtoZm9RdDBsU1p6MGU3QXpQY3hpSU8v?=
 =?utf-8?Q?Q9ULnHiQiP5gZClTlI47pJM1Fwkmejd1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekRva1UzQ3Vad2V2dTdmN3ZGYTc4UVI0L1NoV0ptNGJXclpuZDVyMWR4OUtM?=
 =?utf-8?B?UXU1Z2Zmd0VwUzNDaGwxbnp6cUFQem1EZTZBL2hVWUhVOTVaQUt0TEpTaEF0?=
 =?utf-8?B?a2Zxd3NjTU9pUWY2T1hOOWVsaGFWbWY1THFiSEFrbDRabVVOeFQ2ZXFxUWNt?=
 =?utf-8?B?czNkMjd5aW1PTUNwekZhMWZZSTNVN3hnYVArc2xvbEtGcWlZTVdBN0xBRmVL?=
 =?utf-8?B?OGVHZ1Nwc250bytKQXZvcWlkdlFCUWM5aUJqK3FSUExIWDRkSVQxZjhEc25U?=
 =?utf-8?B?bFo3QkJGSVlvQ1lYeCtvdmZaekRLbHgzNXRyeWp3ODgvZnJuUTdqc2QwUHZw?=
 =?utf-8?B?KzZQNGlKUnJsanBuU1h5UEtXTk9OeGdsY2dFZk4xWStTc3Q3Q3hVcmZpTTlQ?=
 =?utf-8?B?MnNxdlZaa0J1QlpTcWd1cUViaWFvQkdibXNka1hDNEMzUDE4aVFxSVY4M0Fm?=
 =?utf-8?B?QmxQc2RlNnpxZS81WC82Wkp0dEdqQVRTM2dlZFV5Tm12R1VuUUNPaVg3QUkw?=
 =?utf-8?B?a2R0ekxBcmQ5MENmWlBjdlhjVUFnM2dqZnZRdHlWN2ZRaGR3TG5Qc1BXM0tB?=
 =?utf-8?B?emJmckVxZU9KbzVCUVZGUTh4cUpPMFMwQnFqL09DcVIyWTlaRjdGODNwZkRQ?=
 =?utf-8?B?MEgraE01T1FUVGZVOVJpRkNUakEyWExvUDRvRDhHUWRLMDNleDRPa1YwekRm?=
 =?utf-8?B?NnhhaHYrU0lyL1JXR3EydUlyVGsrWHgxaXNBczcvNDFkMXVBcFBDZkJtVkNs?=
 =?utf-8?B?ZS9wblViSU1RSnJHZXV3eTJ5OTMxUDJ3UXluVEZ2a1k3bkJjVlZYdmphcHBB?=
 =?utf-8?B?bzd0T2RseSs0aGdkWXA4YkdEWlIvV3BOTTZ4Lzg1NW9taFRCUGxINzJES29R?=
 =?utf-8?B?eDJwd1YwT3VOcDRKMVFxTEE3QVRyZWRCZ1BvclZIaE14blFNRlVsVVJCdlZi?=
 =?utf-8?B?UjQ1VjhrRTdXdGx2T2l5MHFnYWp0Z0Z3MkZaZ0JXaU1wTjVTNExMREF4ci9w?=
 =?utf-8?B?MVorRDkwcHFJOXhUZVlwRGYvUlB5ak40alhLVzlJVFg5QzVvYU9DTjBack8z?=
 =?utf-8?B?b01IQzJXUjZWMmVEcEh5M1kzeDJabkQ2Ynk0V254Sm0wWlp2OGtqMWZGbGVL?=
 =?utf-8?B?amVzd3YvbVRlUm1ReXhVaXU0SHhPV3JnalcrSjdaSzNNTldrZjdYNkFtbzRJ?=
 =?utf-8?B?QnJ1OUlyczlBenlvUm5veHBZNjIzMmpDa2RpSkhuK0lGVDF1OGpOdThERUJ2?=
 =?utf-8?B?ZSs3UnArVUxGTTlsK0tRWFZCYmF0di9aU2FrUTlaRGFIaXdEWkZmeFpydzl0?=
 =?utf-8?B?K3hPSjBvQ2xmV05Ea3d2eVR5ZVpDV2FZRndzNnpLVndXRnhCNUxzZnY3aU5u?=
 =?utf-8?B?b3V6R3RUY0RZajE4RXRFRHFQSVlWb2JDSlZqUEJDOEQ3VlBHSndrRk8zRGdW?=
 =?utf-8?B?Y2pMTU4vQ1d3YkdxcEZoZ01QY1lsQU1VcWFhQVp3cVkrdks1SG1DL1draDhv?=
 =?utf-8?B?bkViMFd1Mlp5UnVRcDZtVHdxS3NCUlFkRWRpQ2p4WkFkUVdrWGdqZDVyaVRS?=
 =?utf-8?B?OWxaRjQ5QlhJWWt4TENsbElIVXM2SDJPZDhvNWkzVmJZcmwycHZtT3Z2bEk1?=
 =?utf-8?B?T3R2dHhLTy92dHhjOXBPZUNQNFh3SWsxZUdpUXlqZHA3RHpBTFd1dWhUV1lH?=
 =?utf-8?B?eWQ1RHlYNXlEem12Vjl5RStsV21ab0k4ZHlnZHBBRVFjd2JPd2NFS3FKT28r?=
 =?utf-8?B?Y3dRZVNudFpYUVNJYzRVdkREUW0xMHROd0RIS1B3YitrYWc3NFVubnFYOTdZ?=
 =?utf-8?B?U05CdTMveFgvYWswUGZqVGQ5bTVreDVSaFFGZ29qbklHamZDajJFZ01kZ2Rm?=
 =?utf-8?B?QXhkUmVHdVFIQ1NGM1lWS2p5RXJsY0JsQ01OQXhITnhlY29IN2JJN3JBMVV6?=
 =?utf-8?B?K3hvb094aEVEWEM2VDI1RGNPblVwSzVzMURacGprTk1BcFBpSmpCVStkdUxs?=
 =?utf-8?B?RllVcWRUN0VCcVF1Zi9IODVjUGNQUUt2LzdrejJxVlcrNm9UYXVGOENYSGZh?=
 =?utf-8?B?NzlyMHcxUTVUUElKNEpJRjlhcXo2cldIOFpuREgvUmR1UmgvQmw3bVJzb0NK?=
 =?utf-8?B?cHI2em9mbC9zdHRKdko4ckhlb1RvMlVoeTFaRkROdHZCK0o0bXo2dlF2OVZN?=
 =?utf-8?B?YjR1MkM4L2JnZUx0UDRqQWZGN2IxV2Q4Qy9ibzZCZU1xU0JEYlowZ05QSW4v?=
 =?utf-8?B?Zm1kUmVVVkZmVVV6VmQ3NGJuNStZOUFPUVNSQ1FZZmhUby83bXByWW4vNzRr?=
 =?utf-8?B?SjhvVHNZNzFQVmNEV28wTTBZQ1NzcGljWkk4Nm04em45Rm1jWFk2QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 348410e9-85c6-4256-cf43-08de3f154934
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:42:59.0121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJnXEXevdvE+Ow1Dzw3DjnOJ1MJWDLPSG7PIbeWO6W8eGlKacpN/SczjLOgiEWgmiFpvpl9nB6snzzhqcwFP0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4247
X-Rspamd-Server: rspam02
X-Stat-Signature: afdmfriwf5n4yhw53juissyzx1y4mjjd
X-Rspam-User: 
X-Rspamd-Queue-Id: 155D9A000C
X-HE-Tag: 1766158981-17827
X-HE-Meta: U2FsdGVkX1+t77jCcFp9Rq9944B7QHvxkQwcVH5vmIWBLX33yBAFEsxM2mesp2vFlkYuaBAZ2pph8Cn/BL9gwi9eCydaRK+eIf7zzUUNoyvOh5NaUg2JWEI5bnoqMuakrsZ8gl3FMKI8oi47hBk4qdRSAhYhdtFaMPn3V1ygm8VpO2EtdGUo+scjkZyU8uIm0vkG1gasMlGVJJ5A+E216AJjgw5S6XH2KJCiPaZw2MG8B5UT0LE9NzPTondofU6/CALMLBCO4StbddYARg0deIQiLvxZY8jk+pz7EdWETlTh9zl0TBWde048qFZ4Fu2yAjdZi7FjT2cmaNabDziCL3d1t5dDKdGCPYHJzLdetgw4nEmDRVMJ9p6PRMAmLBWlcBAiRt5m+I7RaAtdtc0oDVwpx/XWZOjkdMcCPWEyuGD8PnmeFkYcJNeSw2F467rYwTD8sznk9qeZM1rzYU1OEEfhw43iZuF6+io0Hgpmgq9FKh6dcjoF5Pi46iIYwIWFw0DxVquDooRkEM7BLoWscSJAQ2SCjaFjS9y80eD9vctO5s7U9acLeP5qxijEC96b/fTFODXwdmTd1yRraWtHUSX+k9bj97s7YT/BbsRMxiYcskWS9y+vsvwW6dWD3jiLbROE1h0beovk1uJevc8pnaF3PojSLG61hDOVW3zTS9NE846n3aQvWjIc/3+BtvBJps4vyIjjHSIbKr5HOvr99NR+nUTRxzWhMrnDUgeLPy6BVe3ln94uDBgWwOjJoT3LEXg47mIWrz/g9FNIlpVhuo9BphUUrVJn1Q7p1Z9t7RZHjhYKzU2lQo5Ltk452N7CzVlM7/b+msGhvz/B0ws1y2zf7KWdJ+Y8PAFB49M7QOxodbnVNzBE7yUIYSY90kjp8w1fcAppVTTWTZhV53s3iUeLhF6Lm9iAfLwYyCbwmH3Kl9p3NfOYPWeQ+uLeQ3DBUnyOuc9RQsB3qSRsWXB
 ghAyuUot
 Wd1i8fo/0xrvD42dMeZGEjreMm4f64pVnaTaUA1P9pZaJkJsVw/e1uly5Vf26Fr4wl0uJq1dtw35ctm3uhrlQQl2xbhqQX/gMuEoAYf0S2xD+/MnVVcT59gsdVJJAA6lV6wQ+mmgma6w1KpHdGPgYcuI8hRGIiM6nFxuqyqXfVake+r5TpfITnB7xLT3tVrUHn+HyYPHqIFfp0HAUzj1eXK5Aq5pd2uhTIyq2GXgKdySLJZ6cO6U5WcMXKtEktAm2UnWhdTMre65Rt/+MHWT05shnnzkLmqAsLarpYKAiXz0vjwHOYR/BuU5gMUlQIt23Am58Vb3ik3SvPPCXsFL1Uu8J7y+wVhlx2cF+V65yNIdAeNH84sq2VHRSFk0pjV0u1XeXeg+UqvZX4lvsTdbX4augqSugmVK/vBulaTHdi3YGqBCajnObfshtuRubodmcYbTo9UQiX3KpYf2ZY9COmAWffUpKIODlZO1nTJ6FmNL+Duaawz0710OLhWegTOqUZ6Hv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/19/2025 10:14 AM, Mathieu Desnoyers wrote:
> On 2025-12-18 19:25, Boqun Feng wrote:
> [...]
>>> And if we pre-populate the 8 slots for each cpu, and thus force
>>> fallback to overflow list:
>>>
>>> hazptr-smp-mb-8-fail    67.1 ns
>>>
>>
>> Thank you! So involving locking seems to hurt performance more than
>> per-CPU/per-task operations. This may suggest that enabling
>> PREEMPT_HAZPTR by default has an acceptable performance.
> 
> Indeed, I can fold it into the hazptr patch and remove the config
> option then.
> 
>>
>>> So breaking up the iteration into pieces is not just to handle
>>> busy-waiting, but also to make sure we don't increase the
>>> system latency by holding a raw spinlock (taken with rq lock
>>> held) for more than the little time needed to iterate to the next
>>> node.
>>>
>>
>> I agree that it helps reduce the latency, but I feel like with a scan
>> thread in the picture (and we don't need to busy-wait), we should use
>> a forward-progress-guaranteed way in the updater side scan, which means
>> we may need to explore other solutions for the latency (e.g.
>> fine-grained locking hashlist for the overflow list) than the generation
>> counter.
> 
> Guaranteeing forward progress of synchronize even with a steady stream
> of unrelated hazard pointers addition/removal to/from the overflow list
> is something we should aim for, with or without a scan thread.
> 
> As is, my current generation scheme does not guarantee this. But we can
> use liburcu RCU grace period "parity" concept as inspiration [1] and
> introduce a two-lists scheme, and have hazptr_synchronize flip the
> current "list_add" head while it iterates on the other list. There would
> be one generation counter for each of the two lists.
> 
> This would be protected by holding a global mutex across
> hazptr_synchronize. hazptr_synchronize would need to iterate
> on the two lists one after the other, carefully flipping the
> current "addition list" head between the two iterations.
> 
> So the worse case that can happen in terms of retry caused by
> generation counter increments is if list entries are deleted while
> the list is being traversed by hazptr_synchronize. Because there
> are no possible concurrent additions to that list, the worse case
> is that the list becomes empty, which bounds the number of retry
> to the number of list elements.
> 
> Thoughts ?

IMHO the overflow case is "special" and should not happen often, otherwise
things are "bad" anyway. I am not sure if this kind of complexity will be worth
it unless we know HP forward-progress is a real problem. Also, since HP acquire
will be short lived, are we that likely to not get past a temporary shortage of
slots?

Perhaps the forward-progress problem should be rephrased to the following?: If a
reader hit an overflow slot, it should probably be able to get a non-overflow
slot soon, even if hazard pointer slots are over-subscribed.

Thanks.


