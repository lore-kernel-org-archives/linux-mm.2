Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2F2CFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 06:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44E86B000D; Fri, 21 Nov 2025 01:15:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CC56B0010; Fri, 21 Nov 2025 01:15:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B526B0022; Fri, 21 Nov 2025 01:15:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8ED6B000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:15:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C2A21A045E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:15:37 +0000 (UTC)
X-FDA: 84133602714.08.FADA8DC
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013002.outbound.protection.outlook.com [40.93.201.2])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16104140011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:15:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ThlUUDdW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.2 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763705734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+y6lrQA/QuFX1k5mPJEaAt45DTVBEnGWrI1nHorFwCg=;
	b=2bkTVDudsQMeOAF2RFUPRx0Obx0+DQhZkiVmH7yGG+qnme/Vmk7FVJkXfXGF1kP5ZST+Tl
	9LtC8Nw2Dk132mmJ5K9OhpTgdB2JenqucDhoJTrf8Upeg41kMOe3gdNCNZvpBBi9PXC1OL
	8HI4lyhvAdUixKoNIxZa4/PzbBtYOwQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763705734; a=rsa-sha256;
	cv=pass;
	b=tFJmg8i6H8HKUheSIK8XXvP9fJYqPCV3CT2m9RXbmQeBjTogATCTKuNDkov9EPKUVDziG2
	fIYJlAUT7S+lkef47U3GfFpQNugRaT9QJ6HLhDEAaP3TSKHnPWe7kPk/mcMh4HRUNJmOnd
	0vsQakJc5Uvzi/BeG1kr9+xf++NoBXw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ThlUUDdW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.2 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HcHXVul5kbglMDdpLMj+BK4+xPj3H7a7SgIkGq4tnvbnqlRKwmcNujf2OjeRM0Occvthh4TmnU6Z58AN/7JgxaFp1F/e/7qVa1xBYmG5DXWvKmKGbfXUsoz+1zZG7wlL2BvV/NB6XZ/WnrTZbhK3fyNWaDq9TeLTVCCXlrNMv2jlY5Rj/bFNOMiXVKjIbcRyoKxsoWxzDuPVVWCc8p/BQNJwIfUlPJ+huUbccLeSJChLB490YMha/oITU8eCdaMsqQiwfIgv8/yDT1MKRVxkFlGzPVOr69FsK9ohw5dS/fEbVEUQIfq8T/4aAIAH9kZohEVRYRO7t5PA3Rh2gEz3Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+y6lrQA/QuFX1k5mPJEaAt45DTVBEnGWrI1nHorFwCg=;
 b=yK9ESlsI1bMkcyFnV0lVrw8+CyxX70THgiEd7DBEzoUACwhGM5ZPEhrmYER/Nqm0duY3igkC3HM5nE/55QsoCNp8k5KSzcEa/dRZ/Q5pTUZD05U+UUg6WgU9gEyx4sqIdoRr/gPYqyxgrM/T8vsuN68ozb1w+7o2NJUNdH+7AlxTyb6yYRmWPyudNQcBE7y0vbA6NbBtCReX5r9He26lvlDMYeXMIx6CF4orj3R4pppCDknLm7Xj0An9sog7TMgg8QFaSN5OPb8Kf8NIlhCPPkBennQjNL2xGNrhQGlzZ142Hpms1Lb0oI09ftEsdCyiz3DVpO2R4cnWQIlHwCyhLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y6lrQA/QuFX1k5mPJEaAt45DTVBEnGWrI1nHorFwCg=;
 b=ThlUUDdW0aWXnr3wxfGTacCs7yPQ8gs41hD3Y9lay6AfwxEHm1BPAK03MbxPSaPIQ2yR5MKlKKzwshUzX0M0NBBUQeS/H9HVezWS7HZ7Oo4z9cAWmcGtYbcu6ZBaT6kYXXBqR6Dd2OhOddqxXbVF5XJtM1iUsiPWBWH/MqpPEmg=
Received: from MW4PR12MB7465.namprd12.prod.outlook.com (2603:10b6:303:212::18)
 by MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 06:15:31 +0000
Received: from MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::6b00:b9eb:486a:f10b]) by MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::6b00:b9eb:486a:f10b%4]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 06:15:31 +0000
Message-ID: <99e1a117-d6b6-44bb-a5f4-77a36b266b69@amd.com>
Date: Fri, 21 Nov 2025 11:45:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] mm/khugepaged: map dirty/writeback pages failures
 to EAGAIN
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Dev Jain <dev.jain@arm.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-10-shivankg@amd.com>
 <6c1d6b80-d290-4110-9a49-53e7404136bc@arm.com>
 <33476cb4-318b-49db-9cc1-a354eca9e883@amd.com>
 <ef4a0c2c-62d1-46de-9ea2-dd946857a03a@linux.dev>
 <81e34d93-9031-4840-a0d0-56d488f3bc17@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <81e34d93-9031-4840-a0d0-56d488f3bc17@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4PR01CA0114.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:266::14) To MW4PR12MB7465.namprd12.prod.outlook.com
 (2603:10b6:303:212::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB7465:EE_|MN2PR12MB4206:EE_
X-MS-Office365-Filtering-Correlation-Id: 2548558e-35a3-42a4-4f39-08de28c55fa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?STFJY2JYOWoxSGczSmhUSGRKT3g3a2c1QVIrczZRWHE4WTJKYWFYRFFoanRD?=
 =?utf-8?B?bEJGSlV4L1dHRVFkRVUrREhOMmt6RzFRMGtvTzhEOS8yWlF6eUxzbkVETkd0?=
 =?utf-8?B?WjUzeEJLZ2RqQmg2SjFGS1c1YXF1QWo1WUgwSVV4QWVLRTNmOGgrN3pYRW5q?=
 =?utf-8?B?VjlKdDRqZlBhY1lwNnc1RHdmVmZtMU9XVnVmV3ZlcUlHbkVtZzkya2hUdmEz?=
 =?utf-8?B?U2RjaWhYZktkcHhqSlFFd05NMFgvVUl6ZUp0elQxclJnZU5qV2kwTHRUVW0z?=
 =?utf-8?B?ajBDMXJTQXJRYkp3RVZ6aENsS2JKb01wWHdNNmFMKzU5alRVdEFhMDErTEEx?=
 =?utf-8?B?TDhmcWtsVVI5Tks0bi8zMDRjajlvbUZibUR0bjZkdUtIV1lQaVBqRERlRjNy?=
 =?utf-8?B?TXZlUEhkRlpKMEZhUmxNcXNtWVVQbmR4MFhGUkRFQ01rYzQxVnYrUU1aaEZ1?=
 =?utf-8?B?Q3QrRGhVVERkb2YvOHJ4UzN1NXl1YnFnak9VOU9yN1B6TUhGK2tlSzZMQU8y?=
 =?utf-8?B?STJac0lDTDBNSDhxRTZqVTdHL0dsd1RWZmZVOVRTbFo0akQ1UEdISVdYU0tJ?=
 =?utf-8?B?V2ZpVnJSczZUUlRPTHVhOHNNci9KMWkzN2YzaGRpOWVtVlE2TVYwdnVWa3BZ?=
 =?utf-8?B?SzBPaE12SVRPYjAzTDhoSWNvaUZiTEtXM2dDNU16bXpXa1U5dXZOOXJMTWJU?=
 =?utf-8?B?MlRZN3FDM1FuaFo3bWRLNk1mWVVBY04xZStzcklSN09ZN3RZVmNXZGwzWmVQ?=
 =?utf-8?B?Wk51UUI4RWo0RVZxTzlRMUxMVjJkYS8zdE45QUxsRmhBV0VUWGU2d0Y4aER6?=
 =?utf-8?B?R2lmQ2pBQUtubEM5RGJYeHhxYWNZUEU5SkxqK1g0Zm5tTWRXRWtMSW5GMlV3?=
 =?utf-8?B?dlZxMTVYN2xpUE9NQzAxQUhXTjZ3NVBKTFRTUDdMUDAzVHgrcVNjM2hRdWN4?=
 =?utf-8?B?NHFPdnk3N2dQOW8zemNncVJham4rTmduTDEwbmVmM21ZTXVJU0lNRmpOVlNr?=
 =?utf-8?B?OW1HRU40OENGT0hMejQvTXppRTRFL0dsbUF3L0xRQXMyMkVVL01qME44TE0x?=
 =?utf-8?B?U3V1RmlOMTZlWVp6WG5xWmRydjlzV0xMT3ROQTlWbUVnVmpMc2YxcHRpT21N?=
 =?utf-8?B?R0xsWngyZFBodjhSWlM0S1hzWFRmVjFEc2U4RXJzMENPbFNvMkZCUUhERjVw?=
 =?utf-8?B?SllxSit6YzRFSjVHWFQzMXpsOUE0b3pDVzllblBTakZYdGdGM3lHMmwzSGdN?=
 =?utf-8?B?Z2x6ZWxaSmZiK3pFemhadHVoV0oyaHhBS1dHK2FpWWdwQ0FqbmFhQzgxK2F0?=
 =?utf-8?B?a0JxaHg0Vk5TQi9kdkhscGdOZEo3N0Y0L2dmRVp6dHpqeUtiK3I2eFZTZ3Yr?=
 =?utf-8?B?eUFxTlFxZktyUXgySnFNVFdrektEQjlGNVo2ZnlFOUtWcG9CODFDbFdDeFRJ?=
 =?utf-8?B?c0ZmMk9WR0FJdXNNS1llUkZSeE96bkJaNmNaMVJ1UjIvWHRYTkt4T2tnSmFB?=
 =?utf-8?B?K0FuaHh4ZHlTcWpxM04xN095VWZTR016UldNcE8vSnJ5dDc1QWZCeFZEcTQz?=
 =?utf-8?B?aXAxVnRkZXEwZVZnWVNwdXBCQUdKazVPWmIzWWlXZktwMlZWWkVyd3pURGtq?=
 =?utf-8?B?WHJqb2xrempTMkJ2TnYwblY5QWYwQVdDcTVTS1kxWmZSY2VMWnU4Z1Z0Skxm?=
 =?utf-8?B?aStSWlI3YzVUM2J4dHpRU1RHOUo3THIxR3Z2emhQeENWam8vREF3R3BKaWkr?=
 =?utf-8?B?SDRxRFZFSW1VRStHemhuR0FmWGFReDk0TENjQzhNSWFiYytPTVljLzZralNK?=
 =?utf-8?B?V01oMUNTLzRUMS9PVjNmb2V1VFNEL1VOZ1dzVnZYTUFtemhjc00zMVBySFZQ?=
 =?utf-8?B?NGJOUmJhdVA5bDhGaU1RekVEQitKRzV3aHdrbVJQTGZjQ0FDREJINDBWK2la?=
 =?utf-8?B?SE1mLzBuOXh6WHRySDJwK2VpQytxeitwRDRXTzdDRnphbHhZaGZLRWNZbk5h?=
 =?utf-8?B?VFZzRWs1dEdnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7465.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0VlTEo0cmhIcFZRWm0zdkNGaFpqcGE0SkFIY3BCYWY0dk5MWWd5RVlqdWd2?=
 =?utf-8?B?WlZTcmtEZmdORzlzazNLbndpN1NXdHlBY3VkOUFKY3pKYUtjUGYvRkloZnpn?=
 =?utf-8?B?SllrZ0ZjdnJCWGZBdHk4bHFaZmNvNU5FazY2eUx3QkZGTlo4OCtFanlTMTM5?=
 =?utf-8?B?aU8venU5STlpTGtSNzE4bVRZc1U0cUE0U1JyeDhxQ3VwamVLU0ZKSEdVVWk4?=
 =?utf-8?B?YmlEWERiTzRmVUE3em5TbC8vR0lUc1pFRWNPZkYwUVIrcEU0UjBIRjZzYmxH?=
 =?utf-8?B?WnRGZ2NTUGxreldWMVJ6aHc1VTAvd2EvT0MrTEgwbDA3a2VQdGgwZXduN29X?=
 =?utf-8?B?a21qaUFqNWh1S3BEeWp6NnVGN2dKbDIyVmsrZUVMaVpIVFdMMHRlTzVFNXVw?=
 =?utf-8?B?TnlqY3djaWg5S1NVTzJSTG5VN2JySzFkekxSRms4T09zci9KTFB4Rml6MHVy?=
 =?utf-8?B?em5nczRRRFgrdWwveGNURGEyWlBCa21yb3BGSmZ0WGRiUTN1S3ZKN3lyZ3dk?=
 =?utf-8?B?VjRIZEgxbU5CUnZTNk0zZktSM0MzdHhEeURyMUQvVGI4N093YkwyRnh3aWt0?=
 =?utf-8?B?RSt0V2dza2FzdHN5c05hWEVSY0ZSQmQreTY4clFRbXZiT2o5NzhsM3BGMFRH?=
 =?utf-8?B?YlltOXh5akdXbS9kMlRXVjRHYndoc01MRkU4cnp4b2tHSHdMemQzdzgyRGpj?=
 =?utf-8?B?MExrZnVSZjg3aUlVYnA4aisza0NKNENJeGtQRTBJTEJBYnd2ajdZbzRmSGs5?=
 =?utf-8?B?U1c0Zi92dG1XRzZITzdQLytZTkVIek94RDVpVzVndWkyZEV5Q0VlbmF0U2Ey?=
 =?utf-8?B?b2hlcDkweGhoa2I0TmNHNCsyOUtxUFZ3WkJ2YW51SEh4KzZhQkhmQ05oOVh1?=
 =?utf-8?B?YjV0dmUvVGdNbDgzT2dTS0FRcFA3Wmo0cGFhbkxNRnFSekVvTTRKMGl6TExD?=
 =?utf-8?B?MGR0WlpCbnFwMkNydlI5cG91QzM1M1FVRXBpQlJDM0h6ZlVPQ1pXQVh2Wkcz?=
 =?utf-8?B?a2hqR0xTK1FoVUo4Tnl6clM3Z2hGdnJ2YUxmZTFBZ0QyNFhjWlFpd1RIQWJO?=
 =?utf-8?B?T0xrWjFrY1RFb3pPQ1FBakdRTDRzMm9WNU5qY2svVWROT3FYeFYvbXVIczVZ?=
 =?utf-8?B?SzVzN1hERXVWMTViWEw2bmNHb0ZERTZySFh4eHQ0OHVEZXY5MFdmVmF0Yito?=
 =?utf-8?B?N1JpYjJlWVZMZnJyT3lHOFhYQUMvcGY4ck1IamdOcjVvblovZ1k2VHFlaW1y?=
 =?utf-8?B?Q0UwWkttSVBwSjdxTW1lbVFaMVpjS2R1aFgxcFFwdFZkVGdhL2YzbUZyczNl?=
 =?utf-8?B?TjVvZ2tmbHJTOXFKeVQ1T0JKV3hpUE9IZkJWOVR2MkwvN1dXa1dxTzRWSGhr?=
 =?utf-8?B?ZSttd0s4S0JsU1RSVjQyNjM1WUJ0eCtSRFVISUJTQXB1cVdEbEJsemRUQWVX?=
 =?utf-8?B?UzVFM3lCZk50cWZTU2gvR2YyU0RGRXdCTkVnRlI4ZFRsb2lNbGRrTFk5cldB?=
 =?utf-8?B?WlV1ZER4MjVBQzZIcTVQTGxpNCsrdjdCNVhHY2hXRmZKZjFXcy94aHViZmFE?=
 =?utf-8?B?QlpvWTgrQWI1QlI2YnNmSzgzS3d6Z29KOE94WFhUQjZiSEtNeERWOGhadlV5?=
 =?utf-8?B?QWtJL3hzRC9iZWxqQm56USt2Vm9IMXU4a0FXY05XeWlIVHF3WitjNEhkdzdG?=
 =?utf-8?B?bUNjR2dsVm5XbWljaDlZa3lPT2t3c090ejU4WTR3RmF6dVhSakRYQ1QzSWJS?=
 =?utf-8?B?R0VMMUlmN3VQVTdia0F6R1BhY2h1cys0QnkvUmZIMGtRYThSeE4rZjRUM2FE?=
 =?utf-8?B?Q1dBOFBrd0tCQWFWOUtWU0xnTUxyeWxSRzdFMUZPYmorMC9ObnhXcDdtMStp?=
 =?utf-8?B?bmorcTNnZE56VTVOV0lRcGEzRnN0WExKN1l1Y1czY29oYTg2a2cvZnMxUEt1?=
 =?utf-8?B?cXBzVnFqZ2YyemZHQ0l4eXJVUmtTbEEvR2tRdlZKTGh6czQvQk5iclg5OUdq?=
 =?utf-8?B?d1V0OGg4SlU2aHhoNUdzTjJnL1BINXExclAyQ3BacFRVSi8rRDBsdVFwdFha?=
 =?utf-8?B?ZkU3OUpEUmsrV1pHaFR1NHVMaDRkcU1Yd1ZmVXh3V24xdVFuSERhNjdLbkxu?=
 =?utf-8?Q?bc0pRn33y9ILqzcuEiKVMU/h1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2548558e-35a3-42a4-4f39-08de28c55fa5
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7465.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 06:15:31.2933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FF9FEFadsKS9b2iMmN2diZsJGHzaKwH/zgPvB17ooN6ZIfNm8yrJ2UV0LUmUQhblu7oFIimecIuY3VlFQaHK5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4206
X-Stat-Signature: iupytd9aq8ejp7b9dqxzejj34w5foect
X-Rspam-User: 
X-Rspamd-Queue-Id: 16104140011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763705733-319506
X-HE-Meta: U2FsdGVkX18GR6q/0ZSiT4PWXRtVUN1k28lULJMoTj/7WEQOCvmwjW1fVzuFxwREh23RjYSXFAMrN1Ju7mO/nsuJ2F3Eo00Q6Wgf3F+6xe0cS+A3Vu5mfgjW2xDalZ05TFl+DyVChNTtiKX//dpZC8isGwnH31l7SMslXF9ipbx0kn4HXhYe+5FiONOT1XG/+Wi0UzQg9eDG33tvIFZdBxGO3BauJjsjws63saKnLm60Jfi0+9kGOWDCkr/FGWsEI/u4UBSoMVL8ig8sMQiJHtNxqxHPEO42z3mrIYmg0mzTLimN4Na2L9AQhQrccbdS/b5fkq3+jWs5LY5qr4BMcg2KbeMe9ptXK7Kg+5oXzUco6Tj0P6Ydm+RUdiCT0yTDbx4dSwRggPp/l2po+AqBo0/+yf2o2ZNbSsZ1MTbSJPObn/mxRNPL6eK8q/MZV5r1ZZeBwf9LDP6CFkdOoSe9RuqoG2xxJr4x7vfVEw0rzq2emW7dHZdf24zaBbAdDpdTRS9ysBZQjdYXrAyfusD20Kdfl9bChy9BbhLjq8hcC5FyFDaIa8ogSdBku2cRZs6a8b5IyZxIjyGAPGzySTIKsROx2Eu4DJbMIsw/c8Q+m6Wt0MX1VGEF9IYb1eSjQZhwYgqamTFcJ+SlJUoUGWJrL6bEMClq7f15Z6gtw59O6nRKYZHeq3jvz0egklHYTud2QfL1gnIw7vfvG/wrIfzAYD7PTnqs6Tnsn7S5XwaqXm9MBAzhUkRWGYNchITTk1jP1ycdoq+pg2iXGioeC5WXg1INZsPjHpCse54Q1WHcnUt0QUEviLOJhr1Y9EbczS4NiGHcJLcK9udw3kQwFSjCdXQcJK67QWBHOf9lyvx5RPkXMiC4vncrfGZTZ18Fi+LUxN9bLKhDpfY0HuOjSOIUB0BE8/1Zhhbb6cK2mcapecDDdrQBsKojXAPoEA3ugDp6CDLLSf/Od4/nSyVqToI
 5t10O4Ue
 JWCgZMEOUmxqZJF4oG72RFFCkJWFr/Nhah3nSJ5h4QAhHmCkM6tPcefFVi2mzYJ4EPXyCbhCybQL1vQTEWps0+fAsl6xY82Kq4ld+Y6CSRKXdLkTe8eeWHtsmPRkDldvdgSexZcLvz5Eh/ztPqH3cWOzGEPqyu7Vprp7Y6R/h+FAyJJ7HX8YBK0SlFCUzVn1McCPx6BjwShn9bwMWTp5PsoU2XadjpR+RQR3dG8A09me8zfeEMEgSvXgqcXwBAILV0lBewa+iYAga/KFFqR9aVDju6MXhqpsevFA0Pe7wORCCa3CIeQbtSHLJp6ytcjqacBfRGjY55+y8KjLR5vnCmS7n6+6l4RwQ+Tkz+gQN+Wr13ZVWLbpd8zcSgfLMItAkLaRTKOFmCX7P3aI46jgl8tWoybj+d4teKZHWV6h+xEZLCSysRCGoMnk37CwGk2CUlyCwVgE2syRXqHpmDxxJxSRli0+rPLKfbJEInUxzqwk7l++Z9tYVOnPuTLtT7UHn0211ZtNSJSPdnk8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/2025 6:59 PM, David Hildenbrand (Red Hat) wrote:
> On 11/20/25 13:24, Lance Yang wrote:
>>
>>
>> On 2025/11/20 16:17, Garg, Shivank wrote:
>>>
>>>
>>> On 11/20/2025 1:33 PM, Dev Jain wrote:
>>>>
>>>> On 20/11/25 12:20 pm, Shivank Garg wrote:
>>>
>>>> SCAN_PAGE_NOT_CLEAN is confusing - NOT_CLEAN literally means dirty, so why not SCAN_PAGE_DIRTY?
>>>> Or SCAN_PAGE_DIRTY_OR_UNDER_WRITEBACK? Since folio_test_writeback() is true as a result of
>>>> the folio being dirty, maybe just SCAN_PAGE_DIRTY can do.
>>>>
>>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>>>
>>> Thanks for the review.
>>>
>>> I chose not to use SCAN_PAGE_DIRTY because dirty and writeback have different meanings[1]:
>>>
>>>       Dirty: Memory that is waiting to be written back to disk
>>> Writeback: Memory that is actively being written back to disk
>>>
>>> [1] https://www.kernel.org/doc/Documentation/filesystems/proc.txt
>>>
>>> IIUC, a page under writeback is no longer dirty, so using SCAN_PAGE_DIRTY would be misleading
>>> for pages in the writeback state.
>>>
>>> I considered SCAN_PAGE_DIRTY_OR_WRITEBACK initially but felt it was too long.
>>
>> Nit: If SCAN_PAGE_DIRTY_OR_WRITEBACK 
> 
> I would prefer that here.
> 

I agree on this. 
If the consensus is SCAN_PAGE_DIRTY_OR_WRITEBACK, I'll use it in v3.

Thanks,
Shivank

