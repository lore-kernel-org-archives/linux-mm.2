Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 143ECCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 17:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9E28E0013; Tue,  9 Sep 2025 13:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A4B8E000C; Tue,  9 Sep 2025 13:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B448E0013; Tue,  9 Sep 2025 13:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AAE88E000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:32:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECD72C0620
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:32:29 +0000 (UTC)
X-FDA: 83870406018.02.06B7ED2
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2121.outbound.protection.outlook.com [40.107.243.121])
	by imf02.hostedemail.com (Postfix) with ESMTP id 060D48000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:32:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=u3fhGHu7;
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.243.121 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757439147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIJM7Rsy+LHfCDH4V3QvO+BN+/b7lu9p+8TF+tCXBoM=;
	b=GfcmoBrL5MEiPijh1E3LqLVNtA7P7bqOghgL1unSxequXlKkWOPbsEyyuBGZdth2RXVii0
	9EKjOwuDVEeC03jyy4fkPhvrojcWNkLV20Ek+OHbDMxmb6/OHzZLZwPoxUetqPWAjgh7TD
	VKN/p3szttDzF0si+Ds0ucSmBVCkqMw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=u3fhGHu7;
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.243.121 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757439147; a=rsa-sha256;
	cv=pass;
	b=sWiVNWbBBTagACT5JAixmXnJYQJmX+N22ZWepIf49iKgdh6yDFRAd+2nal5OO51TICSTmC
	cIAmgakxZhKK0IsRnHe/KGkSRvTs9wzosvv3PIok5hVyt22IgTvCZY0gDmK6ETV2miNgRz
	5f2axCtWaSlIPWshpUMn1KCDtWOxv3s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pGCOpKDcnLDnV4QTjNlceKiFerYx6QRwOTP0l67tY46P4EtRBEpNetgtiUrQRth+vrFfM0g3ULV5Xx/DBdneww+xfOGqFGuXMFs+TTcbftlqUUJfa4HthjyBjwkaj+czk2XkbXr/5vVSvPF5TPts6uwSCcee+tpK4oV0OF0F9FFM1IwLMjgNDkZ/+QZx6HGTbpFWUA3l59cH1E9M0fPzntYa0/YHeCMdJ2Lhkh5rHj8YhcWXUmZw6nDm9GNcE5szoZ24SUqCz7LQK8HxLdvhOrhfAoPPNqOLgn63DBlmGok2TpHl2liNXVGArnSABMTt4IaT0OnlTp5oaf8Uypghzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIJM7Rsy+LHfCDH4V3QvO+BN+/b7lu9p+8TF+tCXBoM=;
 b=XiXYbTbJy8nu06aW6DbVOr4Qoeq7OrZX2E16mCcbon1TTzVNgTzZ+1inf4F2/jdK5u49am5/i54r9kEmXwkAOwujZD4FwVE3lmY59Jo9+B9XLi30HqIwjuQo2Nd0xYuCmdjcxMApJNaRU5YctoiboL1wHANz5WdwMuj2siszs/MkH8SLOhkz+WcngeGsTneIDihA00tWbAKukGqAu4k9hJSOfJ8tNgOns+aAIRUebVvn2JYCmLpER1jmleZPA2FW53Hfa4nOtJ1wA9WlzMp4YzWrRMpZpfMjJbqoYmBYcuZQZw77MKKvKVZ3VYNUasmP8MmByEQncUQS7mARuDQoNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIJM7Rsy+LHfCDH4V3QvO+BN+/b7lu9p+8TF+tCXBoM=;
 b=u3fhGHu70ME0VeIGFLw0HWlVjQyGic8LpPrGW6cEG7GDDANyvFOQIdkzV6K2pfQmZRBj1d+ozdpMq6165Rsj5TGfl9UO1n7oWCfWgxlO2PcQELztiDBPmEVMKM36h9MTZp84X7APn4qz5ZFrisKuSzjxuoInQABdBfTL5l96BQI=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA3PR01MB7988.prod.exchangelabs.com (2603:10b6:806:304::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 17:32:23 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9094.018; Tue, 9 Sep 2025
 17:32:23 +0000
Message-ID: <55a79826-48e3-41c0-8dbd-b6398e7e49a6@os.amperecomputing.com>
Date: Tue, 9 Sep 2025 10:32:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
 <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
 <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
 <fe52a1d8-5211-4962-afc8-c3f9caf64119@os.amperecomputing.com>
 <8c363997-7b8d-4b54-b9b0-1a1b6a0e58ed@arm.com>
 <4aa4eedc-550f-4538-a499-504dc925ffc2@os.amperecomputing.com>
 <1cfda234-1339-4d83-bd87-b219fbd72664@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <1cfda234-1339-4d83-bd87-b219fbd72664@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0052.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::29) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA3PR01MB7988:EE_
X-MS-Office365-Filtering-Correlation-Id: e0f3a267-964d-4bdb-a926-08ddefc6d601
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVlqa0kxVDdyN0JZOWxMb0dxaS9iTEZ4SFNxVjgwenE3UkZvMGMzSm50LzIz?=
 =?utf-8?B?VFJmU0pocDR2M3BSMG9jaVgyUVpZWmx2ZFZqOHhqY0l6Vm84QVBXMktrbGZz?=
 =?utf-8?B?NTRkbWpYSHdBNWZmc2lINi9TTmsxZEF0OUQrbnlVQ3pjRWtJenNvRzhFYWNC?=
 =?utf-8?B?eGxXdXFZNUl4TEFzQnExWUJFUEg2UVZRaWxvZ0F6aVVSRGhTSGpqSDdqQ0pa?=
 =?utf-8?B?eE9IbnJkMWpBaERSWS9Edjhlc2ZjS3FteUwwVVZiOE1xMnR4ZTBZMmNETkE3?=
 =?utf-8?B?R29BQlNTWnpGZGR6d2lkTHhYU0RSL1lxZEI3TTZNS2xYVVVxUFZUamYrVEhD?=
 =?utf-8?B?T3YramZ1ak9vUzBEbU9HbTlXeHRrV1VmMlk1MGhiWEJRNEQ5am5BVWlacTly?=
 =?utf-8?B?TzR4cXBsODFWaWZvRzNDWlFmcktCZG1tRm9BdXBHb2NtWlFMSVN1TURzTkZs?=
 =?utf-8?B?OG5VZVA1WkNJamwvTGlPMTBmSnM3TU04d2VRRHFrc05wQTgzVlVZN2tGUmZQ?=
 =?utf-8?B?M24vWC9LbGhkQ1NDcjA5OGNmRko1dFZuRE9DWkFNcTZXaGNZS2JQTTNmcDBy?=
 =?utf-8?B?UUJXTU5CQjhKVk9HYjRjYS9mYVJEU1E4T0ZzL0Q1UFJ2Um5HU2ZuaWFsQWhQ?=
 =?utf-8?B?NHVwamxxSnFvU1FmV0J3djZPY0VWQ285aC9sN1FFR25QakVPM2pZTWsvaGZQ?=
 =?utf-8?B?MnpjQXJlbzQySlVSanY5V3psUnBWcmppZTBxR20vRk9RaExkTEg3ejdOYVI0?=
 =?utf-8?B?MzVWRXVZalVic2k1ZzZ0RDhtWnE5K1k3Vm9Va0svVFptcVhFeFc3MzdtNEZs?=
 =?utf-8?B?eG9BQnNGTGdEcTVCU0l0MWQwWjlKVGZNdVdEeXlRU21rM0RQMlVEQXRtdWRQ?=
 =?utf-8?B?MHBlTW12QU5oSCtqbDFrSklOekRaTGZOZEhyVWoyNUNZUm44NDk0TDRpWVlG?=
 =?utf-8?B?MDZ3ZVQ2VUNFZkQ5Ykh1cDVPdE84ZUpma0M1cldTckJZUWJ6UlN3eVlMRitH?=
 =?utf-8?B?N1kxR1JMU1FFMHMxdjJHT255d1g1OXNhcjhJK0t5MFZQUUZ1TzZDVWgwTThk?=
 =?utf-8?B?MmM4THhjZHprMFlhbGMzTXU0YTRab3BrYUtkLzU2bm1Pb3Q2Y3o2RUsrbm5D?=
 =?utf-8?B?U2o1NEdXSkNrV3g2YWhTeWZ6K0s4Z2Q2d2ZOUHYxT01iMFBtSXgwaVhHOElN?=
 =?utf-8?B?dVhxdmF3WlJRckJab2tKZ0tVUW1oZDN6NXp2K0lLVUxLUmNyMnhCZno5K1Fm?=
 =?utf-8?B?RmNxNWtuNXkzeU1admoyUloyVkQwMGViMzRMeGtpejFuLzIvbjE0dVVWYjJt?=
 =?utf-8?B?M1BPaXBWdzZNVTN5ME0wYUNvZ05yeXBWazlRMUtBUGtTSk9JOHQ5MzJCVk51?=
 =?utf-8?B?dmVYQXpwcjMyS3J6cEF5bi80SXVnRG1Mb3pzdWEraTZGOE5GZzZLYXFLTnFh?=
 =?utf-8?B?bnVOeWdMaDBaa0t5cmNjK2pqQ0JKbmNoTlBoSEZCR2JOS1ZrMWNuRytUb1dT?=
 =?utf-8?B?Z1FHUDkvM25JUmQ4d2k5NSsyQTJ1bE0rd3dISk1rUzQwSko3MG5wU3cvVWhj?=
 =?utf-8?B?N1BkRE9WMFNDU1NNTHRUWmd1NzIzZnhRakQwQldyWDROZzlHMnJPOEoxS3NW?=
 =?utf-8?B?UjA0N1pzRDR4aGt4cmZqVmNvb0FyNWp1ZDZwTFJQZm1mMlFrYkVkVkVzRXVm?=
 =?utf-8?B?MFg3UmQ5ZnhjSUdITVBUREhqbW9IOUtCbW5Mb2huM1FQYUdyN3hYTTV3Tk5N?=
 =?utf-8?B?ejVyVjFHcTIrZVJuR0VETmtJSFBFZDhGYW1peEJnY0RwTnRXU2d0WGpiTVpj?=
 =?utf-8?B?dm9XTy9aNk9ZMWpuWTR3WjY2aVZRbVFwNHNnK0tFTDdGR0dYWXlXeVhtY0FN?=
 =?utf-8?B?bEkyRkNiVmQ0amtmUjBEcVBsa3dTOENlb1FxU2lXNWpMSU10dm1veitmSFo2?=
 =?utf-8?B?OUdHSU1NVWdHdUd1MnUvV1RLVUY4QzBCRzU1WFE5Nm5rVjZYNDJzMkFKa3BN?=
 =?utf-8?B?aDdkWXRPbU1nPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzliUFhlWTMrQkhoWThEdW9MTlcyVTRVTXE1eUUwZmNyT2ZTQ1VjcFpWT1o1?=
 =?utf-8?B?ZzhSZGNKeGx6N1lvVm9tYW1DL0JYeFZMN0dJenFrVkFnTEdMdzZDZTRiL1hB?=
 =?utf-8?B?dmVVeHBBN0lXclFnbVZ2Q2g5MjhaYWtFcFl2dGd1RFZDc3A3K1k3SkJZd25M?=
 =?utf-8?B?cW10RlFSOTByckJLNHJoMDJSUDY3TWthWHd2SWt2MURQbi9qUWNiZ2FCeTAx?=
 =?utf-8?B?NW85dFNxVFRZNEVnVEhva1RubmY3cFlXTERWcHNRQWNncHpwRmRmbGo4cWpa?=
 =?utf-8?B?NDc4dStTTkl4UTUydjFjaXA4R3Z1Mm5xZU5zTEw5djZZaVVRdnhTbUF6Tjdz?=
 =?utf-8?B?L2hqci9lYytwZkF3WS9ReWhHVXRBa1IvZVVldkVxMVVQckJidzNjakFKOWhp?=
 =?utf-8?B?dE1aOEtuQlYyVVJGanphQzRtOE1BK2grRHJLeFhMSS9GUUNyL3I1bU9yZHhy?=
 =?utf-8?B?bEpEelRLNDJMY0t5bThwU21OdW42aFZZVW1lNHBld3FNN0gyQ3A3UnRlaHdQ?=
 =?utf-8?B?OGFGS05xcmQ2dlJXK0h1aHIvZEVnd09nRFJZdmhiZ0UwNzIvS29tS2pLMW5M?=
 =?utf-8?B?eUprTDVwNGVQbmdnTEpqeGJJRGRzYWFVSlZaYlJHZGFNTDUvenJVRkZtNjJG?=
 =?utf-8?B?NXdjQk5GcWhkTTkra01FS2pvUGl1SmxnMWZZZEtEbWZPVHM5ZE90TGIwZHNx?=
 =?utf-8?B?YzhDVkt6TlMxWUU1TkJmRWl5ODkwa0Q2dG9LRlRHNkh5TlRUdTc0K1d0WlZZ?=
 =?utf-8?B?b1N6NFFYSDdiOUxvcDU1SGNMQ2xyUVZqNDBMWGlaN2V3eW44Skd4aGZaVlps?=
 =?utf-8?B?RjVLajBNbW5ENnBWY1hCVGdWYU5VZUdPRWR4OFM2RGN1a1YzNloySXpTdjhO?=
 =?utf-8?B?RThpYVpLTThxODNjRlVDMElHLzBKMDV0VDJlKzgvOXIvckRVUHNjbmJpWGJJ?=
 =?utf-8?B?V3IraHlmejZoZHYrWjlKL0tUYXU3OXg3M0FnQTVMRUQwQ3hoS3hxSlJIMGRu?=
 =?utf-8?B?L2JoUUhKSDlpMG12amE4b2gyK3oyZTNnSDY4ZDVYSDcyMEk3eERoa3VZSGF3?=
 =?utf-8?B?UnBSUU1tSDkvMkkyWEtOdnVSQUlrVTBzRUEvUWY2RGpkdjlXYkVXMnNDaE14?=
 =?utf-8?B?MWcwSy9OVTdzWVdrb2dPR0Q4UDNQc2l2U2lHY2l6ZGJrYnJTVW1RNmxNSHhk?=
 =?utf-8?B?UmhWYm1HODJWOWNFbHY1RXFWaEF0QjMxck4vQnlFV1JOM2tVR015SmtXNFZs?=
 =?utf-8?B?eWVxVDJkSlN0Vm80RFBwcTZ4R254UWQ3R0ZVU3NEV1dwMHgrOW5ZYWV2MUhu?=
 =?utf-8?B?RXNOa29yYnBSaWxmNXNYcXRhUm1aa09mdHZEbWtzUmI3SG0vOGJjaVNSRVhC?=
 =?utf-8?B?NWV5enJJeU5TSWlrYkxvWVM4Vy9VeThCZ2xKcmh6WTBVK0taVDMzTVlEOVNH?=
 =?utf-8?B?cGxFNWw1cnB2QzlmOTUxRUt2TStWZGU3L09zdXVOU0Z2K2ZYeTloUEQzQkVa?=
 =?utf-8?B?MTZBb0dKNndLeDVWOE5VWFYwOWZBb2VIUGZwZm4rMGptZm83WGx6RkM2cFJ4?=
 =?utf-8?B?R09KdFUvVVk5NDhyQnpFTHhJNmNjeEFyNGsrZE8xTGx2T09PVXVBK1c2SDhO?=
 =?utf-8?B?aGw2ckJJRnZYajJTRWt5WVN3L09WSk9SNjhzd0R5djUyVU55eC81N3hWbC9h?=
 =?utf-8?B?OWZMbEM5bENLdHUzTDVYZ3dJZFFoc0pIUEZ4QVlGY0p1Q2JTeXVpamIzV1h4?=
 =?utf-8?B?RjZsR1d4VTNZVDV6cUZxdGY2cW5pS1F6M0ozZCtwMVJrZUlMOVZzTllkcTJ3?=
 =?utf-8?B?MlFUZU83NENPc3BEOTVQNzJpOXFOOGtRMjgyMmhpMVRHZUFld3R5MCtUUURT?=
 =?utf-8?B?MlpmRjJFNXlCSnhPWHJFZW0yaEorbGFzTTlOZTBMZkIrOWJLZzlrQm1YWFUv?=
 =?utf-8?B?c2t0WGlaM3lqYWVUV3p4OUZ3bUcyVVM1bmFDUWJDOTRYWXN6bkVKVlhNc3dp?=
 =?utf-8?B?amxuRVFsV2ZSQUNNTWZhUDR4TGp3UXVRaVhGS3dDdTBWcnczbW9JK1QzanJ4?=
 =?utf-8?B?eFdjMUc5N011RzByWkJ0cFk5VW85SVdXakYra3h2cnI0ajlBRDdWUTJnbXgv?=
 =?utf-8?B?MDh0aThmc2ZKTWxXV0ZLbG9jWWs0VTNRSms0bThMNVJ6SWI4RW9jS3ZTZVp2?=
 =?utf-8?Q?qhSzMMEj6tK627qeVpQAmaE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f3a267-964d-4bdb-a926-08ddefc6d601
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 17:32:23.1603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZoOPc2zWPNW1DcdMTBQla2BT/eYCo7UPi85OiHEY0oHo/7yUXKWOYkaTNumSq5BqD1Nrc3GA302iCVjlBRPLvhazC4TzC3665Pg0SjuugM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB7988
X-Rspamd-Queue-Id: 060D48000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3psp7u63jbx6izj9ewt5sxuzio5yk3eh
X-HE-Tag: 1757439146-222636
X-HE-Meta: U2FsdGVkX1+UBKu6Gf/Hebmh89ogbyZ+J7Q6r5b2Ag2cuZ7NTdxHXZ/ZDNLb4xg7oK+cYptGcsXbMyjfMnHFLSuyYfTJZfivykXCxSBmHnKBaF6DtEb3pGO2BeAHIhBcI0cmIV0srKQ8dO3nLgd1+RBO1Hg3bSWS82igxHq6wUP+WTUxAn8efZUkBu4kDRsAoHZcn4FlLvNS5Auj9efdLC8ppbrsEgVmQSDAEdCyCzIy0HHi4UNszf2lqyKOqaRORe72rtMuFqX+uMlTGW5z+3RnK+54WR+RnOoO0DhaXbfDe+vRUBWwyWTJqTay5lvr82g/HEEe2FR3fvo+w68kcIdoZjRcGnNVoWKiqqLbqniOuUs+ePb7Pqruf/7GSNLApVspmc8hszRS6NejGk3xC9jSI/UbvP1SkerRuDKB4AyCpGNhjjn+ztpNFZqbq3VpJqsYAbTjbylTG+QQqArCtUMdRX0lQdVhqDi+JU0HMhMNP0oK/7FmP/56GoTWH8+/K1a6XktVWAl1HlIYbZsDKwtlZPMYzOZoS+nT6xPObwxwJysEOdWi30NNiqeVqK8/sluHEJB5mSvOgvOeDbPVVe53N8wZj+ydpcnhb8aFgR9r+XpoBhdVPXvynX2evQhacwK39Vbzl984LB9/BX6+gKV7HSt9TL/a+KFfim20OSqfU9MABatVwYbXYsKMN0JGnqL3q/+eonds5UaHRPITOLI026QM307XlCBPzRBpH42TZW09fvdhPTwU4fwCw/ifZvRuWhK8k7Sj5Y9fp/oBiy6lSgt8dJfPBeywzpxQ/5TVABKHPfbCRrL6fBAluhA1zB6RiJvtKXJkIsFvByg+ywJaDr0/hlyht6fCvbV6+aUB78fcV5Tsl2/SHjXP4EM8DO6kYd82jXqryOxgbF02sgsgzlzhiUX9eHQNIezhpwCcjiAOFx8H8WZ7FQ+9wtByCoYiNvzqnRaezDoakW9
 zXDZE6NQ
 gp74kdiaOXxdmoYVk1+vlsiQH4LA46qQek3UtUE6bys9/eQq5Nhd96LpzD+55vg8mYqzREYUtJypERq9XnyjkDif+PvLXTSkvvgY0GkQfjNqiPover69oEaK8NNbMHB4EP523jDMVko2yFENddyIB+K8MqiFzKM4mtKuHqO3PU3kElo0sgSeS/mhENsoBFDJSDfay9NfKoX3T46cVKphk8K1t+1xXvpDxVbbmqOLvUO8oK//Ra0v1wDNOf2cWywkkuWJsCd51fmoApRCLVhpOvEyXNBRgXOa/JlaeQ8RtK2BrQ5hIYzxn243FxegDk7R06r+dYkRlOh8PLio/wPSmXKv84BwBrLYD+T82Eyx9LFE17z/el+BtzMZ+v6uuT7aybcLOocdESDwvmlJ119eLPJEUsAgr5cj0BEKd3W7SRzt+PfzIuEQuo/i0QiH3EkO1HEKZsni4tktVpnAeDQMd100paVh9I0bDCqUJGqNxNVGi8gP3GBG12dL2Zox6fMYmdqh5lzl4zSLBcsz23QiB8lBJolnsefX2MmEwNeRwxcQSbfOqWysDE0dhIToCS0M+Qew9ZXz/NJdXOaCPbPKXh0n3FwPFfzl/PHKfR3dNYzdqLT5UlI0wSpX+SFGlV1lFPrBLvpSP/oPdKIlpAaHnHPlD2rDRZ4pdT6Rr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/25 9:32 AM, Ryan Roberts wrote:
> On 09/09/2025 16:32, Yang Shi wrote:
>>
>> On 9/9/25 7:36 AM, Ryan Roberts wrote:
>>> On 08/09/2025 19:31, Yang Shi wrote:
>>>> On 9/8/25 9:34 AM, Ryan Roberts wrote:
>>>>> On 04/09/2025 22:49, Yang Shi wrote:
>>>>>> On 9/4/25 10:47 AM, Yang Shi wrote:
>>>>>>> On 9/4/25 6:16 AM, Ryan Roberts wrote:
>>>>>>>> On 04/09/2025 14:14, Ryan Roberts wrote:
>>>>>>>>> On 03/09/2025 01:50, Yang Shi wrote:
>>>>>>>>>>>>> I am wondering whether we can just have a warn_on_once or something
>>>>>>>>>>>>> for the
>>>>>>>>>>>>> case
>>>>>>>>>>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>>>>>>>>>>> suggested in an off-the-list conversation that we can maintain a cache
>>>>>>>>>>>>> of PTE
>>>>>>>>>>>>> tables for every PMD block mapping, which will give us
>>>>>>>>>>>>> the same memory consumption as we do today, but not sure if this is
>>>>>>>>>>>>> worth it.
>>>>>>>>>>>>> x86 can already handle splitting but due to the callchains
>>>>>>>>>>>>> I have described above, it has the same problem, and the code has been
>>>>>>>>>>>>> working
>>>>>>>>>>>>> for years :)
>>>>>>>>>>>> I think it's preferable to avoid having to keep a cache of pgtable
>>>>>>>>>>>> memory
>>>>>>>>>>>> if we
>>>>>>>>>>>> can...
>>>>>>>>>>> Yes, I agree. We simply don't know how many pages we need to cache,
>>>>>>>>>>> and it
>>>>>>>>>>> still can't guarantee 100% allocation success.
>>>>>>>>>> This is wrong... We can know how many pages will be needed for splitting
>>>>>>>>>> linear
>>>>>>>>>> mapping to PTEs for the worst case once linear mapping is finalized.
>>>>>>>>>> But it
>>>>>>>>>> may
>>>>>>>>>> require a few hundred megabytes memory to guarantee allocation success. I
>>>>>>>>>> don't
>>>>>>>>>> think it is worth for such rare corner case.
>>>>>>>>> Indeed, we know exactly how much memory we need for pgtables to map the
>>>>>>>>> linear
>>>>>>>>> map by pte - that's exactly what we are doing today. So we _could_ keep a
>>>>>>>>> cache.
>>>>>>>>> We would still get the benefit of improved performance but we would lose
>>>>>>>>> the
>>>>>>>>> benefit of reduced memory.
>>>>>>>>>
>>>>>>>>> I think we need to solve the vm_reset_perms() problem somehow, before we
>>>>>>>>> can
>>>>>>>>> enable this.
>>>>>>>> Sorry I realise this was not very clear... I am saying I think we need to
>>>>>>>> fix it
>>>>>>>> somehow. A cache would likely work. But I'd prefer to avoid it if we can
>>>>>>>> find a
>>>>>>>> better solution.
>>>>>>> Took a deeper look at vm_reset_perms(). It was introduced by commit
>>>>>>> 868b104d7379 ("mm/vmalloc: Add flag for freeing of special permsissions").
>>>>>>> The
>>>>>>> VM_FLUSH_RESET_PERMS flag is supposed to be set if the vmalloc memory is RO
>>>>>>> and/or ROX. So set_memory_ro() or set_memory_rox() is supposed to follow up
>>>>>>> vmalloc(). So the page table should be already split before reaching vfree().
>>>>>>> I think this why vm_reset_perms() doesn't not check return value.
>>>>> If vm_reset_perms() is assuming it can't/won't fail, I think it should at least
>>>>> output a warning if it does?
>>>> It should. Anyway warning will be raised if split fails. We have somehow
>>>> mitigation.
>>>>
>>>>>>> I scrutinized all the callsites with VM_FLUSH_RESET_PERMS flag set.
>>>>> Just checking; I think you made a comment before about there only being a few
>>>>> sites that set VM_FLUSH_RESET_PERMS. But one of them is the helper,
>>>>> set_vm_flush_reset_perms(). So just making sure you also followed to the places
>>>>> that use that helper?
>>>> Yes, I did.
>>>>
>>>>>>> The most
>>>>>>> of them has set_memory_ro() or set_memory_rox() followed.
>>>>> And are all callsites calling set_memory_*() for the entire cell that was
>>>>> allocated by vmalloc? If there are cases where it only calls that for a portion
>>>>> of it, then it's not gurranteed that the memory is correctly split.
>>>> Yes, all callsites call set_memory_*() for the entire range.
>>>>
>>>>>>> But there are 3
>>>>>>> places I don't see set_memory_ro()/set_memory_rox() is called.
>>>>>>>
>>>>>>> 1. BPF trampoline allocation. The BPF trampoline calls
>>>>>>> arch_protect_bpf_trampoline(). The generic implementation does call
>>>>>>> set_memory_rox(). But the x86 and arm64 implementation just simply return 0.
>>>>>>> For x86, it is because execmem cache is used and it does call
>>>>>>> set_memory_rox(). ARM64 doesn't need to split page table before this series,
>>>>>>> so it should never fail. I think we just need to use the generic
>>>>>>> implementation (remove arm64 implementation) if this series is merged.
>>>>> I know zero about BPF. But it looks like the allocation happens in
>>>>> arch_alloc_bpf_trampoline(), which for arm64, calls bpf_prog_pack_alloc(). And
>>>>> for small sizes, it grabs some memory from a "pack". So doesn't this mean that
>>>>> you are calling set_memory_rox() for a sub-region of the cell, so that doesn't
>>>>> actually help at vm_reset_perms()-time?
>>>> Took a deeper look at bpf pack allocator. The "pack" is allocated by
>>>> alloc_new_pack(), which does:
>>>> bpf_jit_alloc_exec()
>>>> set_vm_flush_reset_perms()
>>>> set_memory_rox()
>>>>
>>>> If the size is greater than the pack size, it calls:
>>>> bpf_jit_alloc_exec()
>>>> set_vm_flush_reset_perms()
>>>> set_memory_rox()
>>>>
>>>> So it looks like bpf trampoline is good, and we don't need do anything. It
>>>> should be removed from the list. I didn't look deep enough for bpf pack
>>>> allocator in the first place.
>>>>
>>>>>>> 2. BPF dispatcher. It calls execmem_alloc which has VM_FLUSH_RESET_PERMS set.
>>>>>>> But it is used for rw allocation, so VM_FLUSH_RESET_PERMS should be
>>>>>>> unnecessary IIUC. So it doesn't matter even though vm_reset_perms() fails.
>>>>>>>
>>>>>>> 3. kprobe. S390's alloc_insn_page() does call set_memory_rox(), x86 also
>>>>>>> called set_memory_rox() before switching to execmem cache. The execmem cache
>>>>>>> calls set_memory_rox(). I don't know why ARM64 doesn't call it.
>>>>>>>
>>>>>>> So I think we just need to fix #1 and #3 per the above analysis. If this
>>>>>>> analysis look correct to you guys, I will prepare two patches to fix them.
>>>>> This all seems quite fragile. I find it interesting that vm_reset_perms() is
>>>>> doing break-before-make; it sets the PTEs as invalid, then flushes the TLB,
>>>>> then
>>>>> sets them to default. But for arm64, at least, I think break-before-make is not
>>>>> required. We are only changing the permissions so that can be done on live
>>>>> mappings; essentially change the sequence to; set default, flush TLB.
>>>> Yeah, I agree it is a little bit fragile. I think this is the "contract" for
>>>> vmalloc users. You allocate ROX memory via vmalloc, you are required to call
>>>> set_memory_*(). But there is nothing to guarantee the "contract" is followed.
>>>> But I don't think this is the only case in kernel.
>>>>
>>>>> If we do that, then if the memory was already default, then there is no need to
>>>>> do anything (so no chance of allocation failure). If the memory was not
>>>>> default,
>>>>> then it must have already been split to make it non-default, in which case we
>>>>> can also gurrantee that no allocations are required.
>>>>>
>>>>> What am I missing?
>>>> The comment says:
>>>> Set direct map to something invalid so that it won't be cached if there are any
>>>> accesses after the TLB flush, then flush the TLB and reset the direct map
>>>> permissions to the default.
>>>>
>>>> IIUC, it guarantees the direct map can't be cached in TLB after TLB flush from
>>>> _vm_unmap_aliases() by setting them invalid because TLB never cache invalid
>>>> entries. Skipping set direct map to invalid seems break this. Or "changing
>>>> permission on live mappings" on ARM64 can achieve the same goal?
>>> Here's my understanding of the intent of the code:
>>>
>>> Let's say we start with some memory that has been mapped RO. Our goal is to
>>> reset the memory back to RW and ensure that no TLB entry remains in the TLB for
>>> the old RO mapping. There are 2 ways to do that:
>>
>>
>>> Approach 1 (used in current code):
>>> 1. set PTE to invalid
>>> 2. invalidate any TLB entry for the VA
>>> 3. set the PTE to RW
>>>
>>> Approach 2:
>>> 1. set the PTE to RW
>>> 2. invalidate any TLB entry for the VA
>> IIUC, the intent of the code is "reset direct map permission *without* leaving a
>> RW+X window". The TLB flush call actually flushes both VA and direct map together.
>> So if this is the intent, approach #2 may have VA with X permission but direct
>> map may be RW at the mean time. It seems break the intent.
> Ahh! Thanks, it's starting to make more sense now.
>
> Though on first sight it seems a bit mad to me to form a tlb flush range that
> covers all the direct map pages and all the lazy vunmap regions. Is that
> intended to be a perf optimization or something else? It's not clear from the
> history.

I think it should be mainly performance driven. I can't see how come two 
TLB flushes (for vmap and direct map respectively) don't work if I don't 
miss something.

>
>
> Could this be split into 2 operations?
>
> 1. unmap the aliases (+ tlbi the aliases).
> 2. set the direct memory back to default (+ tlbi the direct map region).
>
> The only 2 potential problems I can think of are;
>
>   - Performance: 2 tlbis instead of 1, but conversely we probably avoid flushing
> a load of TLB entries that we didn't really need to.

The two tlbis should work. But performance is definitely a concern. It 
may be hard to justify how much performance impact caused by over flush, 
but multiple TLBIs is definitely not preferred, particularly on some 
large scale machines. We have experienced some scalability issues with 
TLBI due to the large core count on Ampere systems.
>
>   - Given there is now no lock around the tlbis (currently it's under
> vmap_purge_lock) is there a race where a new alias can appear between steps 1
> and 2? I don't think so, because the memory is allocated to the current mapping
> so how is it going to get re-mapped?

Yes, I agree. I don't think the race is real. The physical pages will 
not be freed until vm_reset_perms() is done. The VA may be reallocated, 
but it will be mapped to different physical pages.

>
>
> Could this solve it?

I think it could. But the potential performance impact (two TLBIs) is a 
real concern.

Anyway the vmalloc user should call set_memory_*() for any RO/ROX 
mapping, set_memory_*() should split the page table before reaching 
vm_reset_perms() so it should not fail. If set_memory_*() is not called, 
it is a bug, it should be fixed, like ARM64 kprobes.

It is definitely welcome to make it more robust, although the warning 
from split may mitigate this somehow. But I don't think this should be a 
blocker for this series IMHO.

Thanks,
Yang

>
>
>
>> Thanks,
>> Yang
>>
>>> The benefit of approach 1 is that it is guarranteed that it is impossible for
>>> different CPUs to have different translations for the same VA in their
>>> respective TLB. But for approach 2, it's possible that between steps 1 and 2, 1
>>> CPU has a RO entry and another CPU has a RW entry. But that will get fixed once
>>> the TLB is flushed - it's not really an issue.
>>>
>>> (There is probably also an obscure way to end up with 2 TLB entries (one with RO
>>> and one with RW) for the same CPU, but the arm64 architecture permits that as
>>> long as it's only a permission mismatch).
>>>
>>> Anyway, approach 2 is used when changing memory permissions on user mappings, so
>>> I don't see why we can't take the same approach here. That would solve this
>>> whole class of issue for us.
>>>
>>> Thanks,
>>> Ryan
>>>
>>>
>>>> Thanks,
>>>> Yang
>>>>
>>>>> Thanks,
>>>>> Ryan
>>>>>
>>>>>
>>>>>> Tested the below patch with bpftrace kfunc (allocate bpf trampoline) and
>>>>>> kprobes. It seems work well.
>>>>>>
>>>>>> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/
>>>>>> kprobes.c
>>>>>> index 0c5d408afd95..c4f8c4750f1e 100644
>>>>>> --- a/arch/arm64/kernel/probes/kprobes.c
>>>>>> +++ b/arch/arm64/kernel/probes/kprobes.c
>>>>>> @@ -10,6 +10,7 @@
>>>>>>
>>>>>>     #define pr_fmt(fmt) "kprobes: " fmt
>>>>>>
>>>>>> +#include <linux/execmem.h>
>>>>>>     #include <linux/extable.h>
>>>>>>     #include <linux/kasan.h>
>>>>>>     #include <linux/kernel.h>
>>>>>> @@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>>>>>>     static void __kprobes
>>>>>>     post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs
>>>>>> *);
>>>>>>
>>>>>> +void *alloc_insn_page(void)
>>>>>> +{
>>>>>> +       void *page;
>>>>>> +
>>>>>> +       page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
>>>>>> +       if (!page)
>>>>>> +               return NULL;
>>>>>> +       set_memory_rox((unsigned long)page, 1);
>>>>>> +       return page;
>>>>>> +}
>>>>>> +
>>>>>>     static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
>>>>>>     {
>>>>>>            kprobe_opcode_t *addr = p->ainsn.xol_insn;
>>>>>> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
>>>>>> index 52ffe115a8c4..3e301bc2cd66 100644
>>>>>> --- a/arch/arm64/net/bpf_jit_comp.c
>>>>>> +++ b/arch/arm64/net/bpf_jit_comp.c
>>>>>> @@ -2717,11 +2717,6 @@ void arch_free_bpf_trampoline(void *image, unsigned int
>>>>>> size)
>>>>>>            bpf_prog_pack_free(image, size);
>>>>>>     }
>>>>>>
>>>>>> -int arch_protect_bpf_trampoline(void *image, unsigned int size)
>>>>>> -{
>>>>>> -       return 0;
>>>>>> -}
>>>>>> -
>>>>>>     int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *ro_image,
>>>>>>                                    void *ro_image_end, const struct
>>>>>> btf_func_model *m,
>>>>>>                                    u32 flags, struct bpf_tramp_links *tlinks,
>>>>>>
>>>>>>
>>>>>>> Thanks,
>>>>>>> Yang
>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Ryan
>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Yang
>>>>>>>>>>
>>>>>>>>>>> Thanks,
>>>>>>>>>>> Yang
>>>>>>>>>>>
>>>>>>>>>>>> Thanks,
>>>>>>>>>>>> Ryan
>>>>>>>>>>>>
>>>>>>>>>>>>


