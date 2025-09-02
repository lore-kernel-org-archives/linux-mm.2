Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31130CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8982B6B0007; Tue,  2 Sep 2025 07:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E966B000C; Tue,  2 Sep 2025 07:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D406B000D; Tue,  2 Sep 2025 07:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61E036B0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:19:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D88F1DF474
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:19:37 +0000 (UTC)
X-FDA: 83844064794.13.CDF936B
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012001.outbound.protection.outlook.com [40.107.75.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1DA618000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:19:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=W9SGAOTZ;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of wangyufei@vivo.com designates 40.107.75.1 as permitted sender) smtp.mailfrom=wangyufei@vivo.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756811974; a=rsa-sha256;
	cv=pass;
	b=lm8d3ozq16gUetC3UiBRKPDlbsdjEpnrnGg28/oCymzwViD2u6U+S7FJx0kR8OYJoXhPNT
	Z9aTwQ5CwncTMV21IYHAyQ1Fxz1eoaNmyZnBxl3boOzKUkY7PxbCQSPKidc0yeMJsP95KS
	8qLnb4EijMcQFSZEcekrwRaA0qUrkdo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=W9SGAOTZ;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of wangyufei@vivo.com designates 40.107.75.1 as permitted sender) smtp.mailfrom=wangyufei@vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756811974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZtxj5bUZg7WerKs5BrVIMvoRWBEWXvF8WL4ZmhkJJc=;
	b=Fny9GYZujV1k0fOxBYjvw7UzyRsqamV7KWEWMEARI4/w2UKjNtn7K3MRxgKfrC/MdN0QLE
	HZThNGhaBZIDtSPF//3SgX+Uc6NBKXm6M9r3OS21gOSN//AN2XG2Y7mj7YtVRhDAH7c7Cj
	U8AveDQDXMx9rhN1aJLHDN/kLlk4jZU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DZMVkY3otbARFWydeWlDxuPJ/RcTOrAIPXkzjezxYNit1whzLPIsodxenmMUXLjaIXV54Asnzx7/bIp307cc3jh2kInnTNJrGiLbCbslVQgPJ3dGeXNhB6F/ai9jxuTcGTzwujq3btEtwSM4Ua5kLBZmu6epMF8JxZQ8pfDB+5yBgSxGyrWD/IdkY0KIStv+c6aChwGFnPTpNWOeoJXtxJyhJrnS0ga2HwLmlVqAPiBdIRn5bVWUtWU8LgxoOvw4Td6Xt11Islk49oaSUOzqZ6E/GECqymimVxZe12rxdYFp3S2r/qD0GzG/867Rcy/YczUZUbukrN6mIRe0P/IJqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZtxj5bUZg7WerKs5BrVIMvoRWBEWXvF8WL4ZmhkJJc=;
 b=tOtEVczUYOaFU3KvWo8nPlD+eGDTxqKJjg0CMU7ttZGbvn1dt+aIjQF71tFvP4vzb8/tiKHl20TEm+CdxjSpKsXFkzvbLzj6miRD0Pbzys81+ZjmxvAZpnRmGlZ4fdLUEkaeFqzFI7V0CcpIylmWZgdY/p3aBX4vUKuPxbGP66pFyRskzk7J8cWudAdWgtdTrPGV2Qfkwe8QS3QObhhf9z2abgsiHTk6wnOKKp9gDty4LI2L8TprssAtUIJaFyyw43hymc9Ri+a1LNZ3JUEB6LZnFpzyFkpsvvIYxOzq5d+uBgvtCH81cnahMTOIh4AJtiO+zbSnR2Rydg+PJ2iEpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZtxj5bUZg7WerKs5BrVIMvoRWBEWXvF8WL4ZmhkJJc=;
 b=W9SGAOTZyt5P9/VQGU1nfZS5MsrViypJNgZ+irfXqts1/KR8sQpSQvYW0mVyQoNipEKicLDmuCzlbnnz+lSx0tvGdLzDFeHuyJcM/0eSLDqmPdCLZ7TzJZeNWNEK7FaJl01rbxT9p8obz3dhyAif+9Jt05gJzqJ00akwS7BI0bsd6DL/qebD5q8YVZ6Am0G8fVEJl7g62iD/ofnJItBKrr+20GR5JL5EOe+9zBk39yv6AW/kmHipWwgWNolNZIzEvhGCCe0s8cWNqpkKblDEf3w+QBNbWNz/qpJIaHHXD/LM3gi5dMFBsnfoyRpArwsKeaydBpG5XJYJTvtH2I3e5Q==
Received: from SE3PR06MB7957.apcprd06.prod.outlook.com (2603:1096:101:2e4::9)
 by SEZPR06MB6611.apcprd06.prod.outlook.com (2603:1096:101:18a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 11:19:28 +0000
Received: from SE3PR06MB7957.apcprd06.prod.outlook.com
 ([fe80::388b:158a:e14b:79c4]) by SE3PR06MB7957.apcprd06.prod.outlook.com
 ([fe80::388b:158a:e14b:79c4%4]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 11:19:28 +0000
Message-ID: <275322fe-b8d7-4081-80cf-926874286ea9@vivo.com>
Date: Tue, 2 Sep 2025 19:19:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/1] writeback: add sysfs to config the number of writeback
 contexts
To: Kundan Kumar <kundan.kumar@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>,
 "open list:PAGE CACHE" <linux-fsdevel@vger.kernel.org>
Cc: anuj20.g@samsung.com, hch@lst.de, bernd@bsbernd.com, djwong@kernel.org,
 jack@suse.cz, opensource.kernel@vivo.com
References: <CGME20250825123009epcas5p1573496e2cad2f58d22036493e5af03be@epcas5p1.samsung.com>
 <20250825122931.13037-1-wangyufei@vivo.com>
 <77291508-cd85-4889-8502-73eb834e543c@samsung.com>
From: wangyufei <wangyufei@vivo.com>
In-Reply-To: <77291508-cd85-4889-8502-73eb834e543c@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0150.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::30) To SE3PR06MB7957.apcprd06.prod.outlook.com
 (2603:1096:101:2e4::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SE3PR06MB7957:EE_|SEZPR06MB6611:EE_
X-MS-Office365-Filtering-Correlation-Id: 495cd07d-a23a-44c7-671b-08ddea129450
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2krM0NLSkFsTU1GUmlvUnV0YmljeHV1RWRJaFBtRDFPL1htZVhFYjVuMjVT?=
 =?utf-8?B?Y3FSVTVQOStmMm44VUsvK01GYVoxZnJWK2cxNDNxUS83Si9NT0ZNVW9LSHIy?=
 =?utf-8?B?eDJ4SC9xN2l3bnVqcnhBMjlkMVlBRGUwQjNJOG43Z3lQdUpWcVhuS3I2b1Bv?=
 =?utf-8?B?VGhLai9vV0VMTjJHVXZiK2dPZ0ZPdklPbDc3aFBLSWc4WlhBY0lWL3paQ3RW?=
 =?utf-8?B?aDZ3MTgwTXc2RldrZ1BmbkNrVFgramNXS2JHbTVsb1RMZTM2THE0akhicE4w?=
 =?utf-8?B?RlRGMWZ5eW9qaEZ0a1hBRHJOM2sxSGd3aVVua2pVSGFWd2s2RTdFQzBkeGFw?=
 =?utf-8?B?dW83bGdDazUzblBNdnRNVm9DZXEyL3k3eEJlM0liVUdoYlhXc3Q3YkNtL2c4?=
 =?utf-8?B?YWgyYjFsS1FGODJKdzI1UTRJY3NzaFpZK2l5YklBemE2SFEzSHFQelhZL1I2?=
 =?utf-8?B?d3ptQUFweExiZGwvbGhWRmlLM0J2R1N6V3RUaElUZ0h3blYwOWp5S2dXMlN1?=
 =?utf-8?B?YUhETWMxdG5JbTNoaVgvc2dmZmQ1bWwydFo1NWJKYXVONkxpWVg3MGRtWDVx?=
 =?utf-8?B?S1psM3ZwRmE3Rk1IZWZHd29xQzdPaVpYdW42dlROazVKQTJTeTVMNy9GeG9q?=
 =?utf-8?B?V3BvaWdIWFo5WWVlMUhxdHRKNGVwa2prT2N1azI4QWhsY2ZkMU5YS1llUElv?=
 =?utf-8?B?MWJRcUd3clpZdC94b1V3Q2VUVy9USThtUFRqVWdrNVF0c1IxWTI0bElUT1hO?=
 =?utf-8?B?ekxoMkRENVpyNXlyRldwU2w0NmJWV3dETWtRaWk0ZUMzakVFbTlVcG45RjdU?=
 =?utf-8?B?dkdTeC9POUdTbVFVbWxibDRqNXJiYmRVQUNWZGpVNHl1RTBMZURWRXpUbVJr?=
 =?utf-8?B?bndMdVU3bWI0ejUrdmw0TE5HVGpMRHB3eksvTE1TcnZUTmNDcTlWTkprZnlk?=
 =?utf-8?B?M20zT0FhUXMzK0ZqN256Z3BOd0JKWmRXSkZRNEhrZEFTNjJ4UnorSEdyQ2R1?=
 =?utf-8?B?cUg3bHk1ejhBc3JzSXZzbHRPRHdpOHdlU2duanVsdS9KUERjNkxRYlFUalVs?=
 =?utf-8?B?d3E0TUU4ejlSM0hJcnRQVWtKZmVvbk4zODBEa2hhaGdNMzBNRGdoOUZpWlhu?=
 =?utf-8?B?ek0yVncyS1cvZDB5NEpvWHhUM3NYNll5WS94SkJVS0YzVUZ0TXpYbXZyQVFC?=
 =?utf-8?B?SEVLY09pbVJvWnRrcE85clV1Wld1U1lJMnFqSHRFY3RINDJnTTBCOWhaZE4x?=
 =?utf-8?B?QmRod1ozdUQxc3J4TzlyMEw4NC9RQjFUOGs0UU02dGdsS2VwR3F3VS9Dd2ov?=
 =?utf-8?B?OUpVcnZaajM2QjB2emRrd2VSUFRVMG1aV01ySXhHTmUvTnA3bVZZcjNDYmtP?=
 =?utf-8?B?dGoxYjhMQlN0akhJUDRSZ1FzUkpHY1NqQnRaeTFreVBuTnRVY3FNZTJxdzFu?=
 =?utf-8?B?VGNqWmtac1R4em1wMEM4ODA5OTVWMGJ3VnBLNzBuajROK1M0RFY4ajFnMWVr?=
 =?utf-8?B?Mi9Kb1ZSeFZyTEkyM0JlU040OVhhRXR5bXBtZkNUQk5abnZQdUdFL3NWc01B?=
 =?utf-8?B?c3V4WUpUaDduUmxXVVk4Ni80d3RNdzk4TEg0QWF0UVNpS3YyL2oxeHMzbzIr?=
 =?utf-8?B?U0Z2dCtMTDNONjFvNjE5a21uYURhWTIyRk9GRlV2K0NlaWNOY2o4SWRNWW1p?=
 =?utf-8?B?WGF4RFBxZWp4cy9vQkxTVERtU2pURUplSVNLbkE0bnFBL0ljc1ZpeXhPd3U1?=
 =?utf-8?B?U243M2JJVmJ2VEhpdnoxd2lkQU5sSjRUTUdDVVZydTM3OGpYRGtNZjR2emg1?=
 =?utf-8?B?MnAyOUR1UnE4NkNCZ0wwS3Z5bXVBREZRdDd4cUV1ZU93bkJwNzBkOEVZYzNL?=
 =?utf-8?B?NzhIVVo2cnh5SEhvTUYyaE55c21PQ3k3ZW5VTEx6RDl0MDBhQXdsV2ZCamh4?=
 =?utf-8?B?WGRLZEpsNDlCbENaSUQ2cnhlZkRHQzd1bTJlZFJiMWNOQmdUcVZld1lERFVn?=
 =?utf-8?B?di93YTFJeFlnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR06MB7957.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnBuNnNwUjZGbVBWMDFld0t4bFFrVmxrRXJFbUFJV0ZubG1ITWQ1SitIeVpl?=
 =?utf-8?B?dzlvTXJGNGZqbERwa0c1Q1d3b2xkaHlQS21jaFhNbTZ3dU4yNFl1cW9KSnR2?=
 =?utf-8?B?VEtzTEhPdnVaVHFpUUMyQWxpQldMOUpNck1JSmVwZWowbDRFUzRocmpGRFNE?=
 =?utf-8?B?YUJ2T1BQMjU2Qmt0NCtWam82TGZoRE5SaW5HTzlPZUFKNEJqQTN0SVAwQzd5?=
 =?utf-8?B?YWttU3locE9SdVNJRUhGM3BCUkk4T1M1b3lwZW1HcldNUFNma2JZbElXRFFp?=
 =?utf-8?B?TmZqL1FGbFdaeHk5K21vMllhR3o2ZnRrNmJBMFdUMzFzdVFjTTQvSU0ySU1u?=
 =?utf-8?B?U0liRU5Ibm5oRExkNDBDaEovZ1lUQzZBdXZCbW9Mc3F4eUQxOHRhUnRSTmxl?=
 =?utf-8?B?bW8xWXo4VERZV0ltdDBYZ1k2T2g0dWl5UWdqSkRGUkdGU0FLMGJ5T0tLVkdU?=
 =?utf-8?B?T2RCOWdCQ0oxV3ptcGg1T1lQTUQzeGpoU085QjVrZ3FMdGUvK05ZczNjRHpJ?=
 =?utf-8?B?RWMwdnZvRHhnZzRydzZIK1gzdHNLSkRVL3V3WklUSGhFYjFkeTJSR1V0TjJz?=
 =?utf-8?B?Ulp0L2VoZytXeHlZUDQrUmlTZGFENlhNdSttdHpiYmdHMHVsVER6UkpPZ0dx?=
 =?utf-8?B?NE1hMFA0bXlTUDJEVkx2cXgzVTNYeEo3WGR2aUtucXIwN0F6cCtOS3QwU2Jr?=
 =?utf-8?B?Vld4dVQzQUV1Y0ZzQndXcVpkL3NMNGtOSExxUFFoUitwWlJMUldxdk8vYklj?=
 =?utf-8?B?OVVBcTJHUE0rRkg2aGJIY21rVExzZEhOaXRJVWY3RHByU3ozSERpWGxod29R?=
 =?utf-8?B?VUFjdWJmNXRoN0Y1aW1OS05FYVpCSGc2MFdVbXdYNXZGNDNHQUcrQ2xoMmFH?=
 =?utf-8?B?TUMvZjJHUU16bjRrYlZra01HTFo2alFuMUxsNENmNGVBakk1VlJQbFM3QUp0?=
 =?utf-8?B?UHI0QTJTL3R4M3lNOHNVOTdkWUFzdlJncXJzT3U2ZWpndERBVGU1L2YvSU9l?=
 =?utf-8?B?cFNZc2xkeklNTzNMOVA2UUZ3VmxQN0xpSFEwTW9NZ2VGWHV5S1Q5SzY2OUZV?=
 =?utf-8?B?dkZnV3dIbjdHRVJMUUI4TGJWR0xraDBFdit6Z29pT3dIaTl4WS9PamhBWTR0?=
 =?utf-8?B?K0tMSUVveks1RXBzMzF3b3FwUUZLVURLb2FPbEcvMkhtV0x0ZlhBVDIzZjFT?=
 =?utf-8?B?QVdFS0ZnTm00TWlMTTVKUmI1cXc3M21DU1VldVlNdDk0RDFwV3JQblhtL1M1?=
 =?utf-8?B?a01LRnZkU1ZVYnNZYStlU0RUekpiZlRyVkJZSDJMWFFrTWs0WEdpang1MkJZ?=
 =?utf-8?B?R0JFOVpuNEdDVWxoRHJqZ1NTdE1kNXJFRTlwS0lrQ1k1SlFkR3BpN25CWGtI?=
 =?utf-8?B?bUlrRDRjOXFPQjJCalp4WE9TdmdhOG02SVZwN1VSUXJDQnBhcG9Ib1JKTDc5?=
 =?utf-8?B?WWNzNEZIYjJCZVY0dGJDMG5BVzNNQkdWTXhyb0swbHhJRkwyQzJmbjYydWxG?=
 =?utf-8?B?UU01SDhLN2NXUTJOckE3OWVjeUJCRXVEUDUrMjVCYkdCbzJJTjJJK1hmYm9i?=
 =?utf-8?B?RGFHM0VJUVo1cEJBZjNDOEIzVEN3U2JweUJVUEpsQmxRNWppTjd3VE92V04r?=
 =?utf-8?B?VlRZazBXUHB5NXBqR1lyK1dsSm0veThQcmdJRklNbG1WcFF3bVQ5OVBLUy9N?=
 =?utf-8?B?ZmY3NGdSVU5na0RvRGtURjdra0ZZMVJjUU90MVYvMmk0UUk1OHpiSG02OEpZ?=
 =?utf-8?B?TjkyWTJvSGxhRnIycHVTSVcvR25iNG9qSmRwbGlINlJVd0RVajhnOTE2NWxD?=
 =?utf-8?B?TlpIb3VpT1ZQY3Q3bFdwdlFkdUJ6VnNDZXZKcDVVSU16YzVOU3k2V3d3dTZ1?=
 =?utf-8?B?L2QwRnBHT0FlMHZYaVZKelA2ZEhVbk1PZmN1RTVvaHpwWXhqSkNaYmhPdEF3?=
 =?utf-8?B?anJqQnl1VW5yaWFjY3dRUHltb2dQK2FDZDcvUzdDdnQxa3VscDVxdGV6STli?=
 =?utf-8?B?bEd2SnczaGtNOVJHWER6OHdGc3hKQmNza0t1b1NFR2NITlRYR0VTZ0JnOW5L?=
 =?utf-8?B?VnNOQy93eHcxVGt1RGwzSkY1YythdXpXM01paDYxTVBXcTUyM0J0eWRlOElo?=
 =?utf-8?Q?qRHANSdsB5QTBKOaPoB5t9LLU?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 495cd07d-a23a-44c7-671b-08ddea129450
X-MS-Exchange-CrossTenant-AuthSource: SE3PR06MB7957.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 11:19:28.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i49M281qp/0onNqF8jqI/5T5J58UWCTzNSgtg5/EEo2xdyCjGx+F88dZgPcdaH8smq4znDSrMq/4fTha3Rc/jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6611
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B1DA618000D
X-Stat-Signature: eu31wcf4nsqa3f17ujgf317ejotg9btz
X-HE-Tag: 1756811973-702946
X-HE-Meta: U2FsdGVkX1+fF7sUXo/fzPgAJU/piLOkjUGY0bER5IDLIAASQ5hV+peJLNk2u6iVJIPo1Ob/eZGzFCJCIXI0VpNRvGRH99T32CDMM7pGpfy1UE1rdhBjiisylQmqGjYpQTwubGZmOIZ8VKU5z8w8/Z3ndfVEeppBXGFjynoyw56/he20Z3rfzJ7CvBr/64P3lvWOxACRwYJvSMuRcXja91Rlmo2Y/vPoJok3Px/fUsGhrbiwfnD1hydnmXQVLF+3QeBGpaAlY4ySoxh8UT+irj+KtzNCFMFIwl5rLExLbmmzXWvbwchyoc4iGZGLukowGOKHwD1/w0S2A6nHiJgPVrrHPtg1XIG/aELapcfIG13RetffIMa5Vas3D40AQFx2Yk2LP6smspPHKEyHTlB21vys+33Ouz1ALW3u+/f7gEjhInKSApOqxFIg5pFnrnS0u2WS5E4am+MqF2/BwQjyF/Ug7z6Yz/P/j6XX8/0l5OBS2H2L6FKwnHf98mGaQq4116v3mN9MPLMPfFBGz6EoEVJl/xeL7rjLswJVzsF2O398meP+UN0ZQ3+XDfY9jr/ytVBBqsO+0q3Eurj8HVmhblHRw/sHCuHUZ3PxLZamNhC0X224rSnwsWPgc/CmqYAuAo3TsN0A3HDZ+tR/JJTzkD4QhjwE4M47y2lsgcgln8iYTsbVnvXoHC42iLPYpClL5nRGCXI2jwMpbA5eh38H8f37kB37hYW8Zonic7mjpZ43Y2AqTSXiYt8Qo/lznYhaIBpbZo7aQURHAfqqBVjAEDAVyEOu/GW7uITtyUEX5RsECHza4dkecJ3SX3y5TBiXju1Uv98Zypv/P7O7UhKsX1beXvgm/xx6yUPEhYyjsKQLmtiDpOXj8nuGx9vkHJNoLBoTqPrJWSAzgEi0VIhfWbnKspv9mDcfImfdWwSwgm28a+va4oKRmzK63kgR76hUdoSwWPksBfXGzaJusfF
 szcHosXz
 hpD9XP3EiI6oZ8+S90HawnHZylBjjeC9ucj4QJRO9HaE235dcqJIsfVqz19u8HKp4OgQrUJQUQCdSi58BGy9z0dezvViXa5F287BOZ4BguIbFUjFYDKZaP81elkW3GBQPVkCpP8ez/WGSU0n5Y/e8u+nSLJGpWSI5K2dBVQP3U0VUOfMhEdIZD7JnZKM08eYPa9NaQ0u2JyxBd0NXzWndi9PIY2l6KNyEZPAlQ9BBYHgodaQFKHIi/fzbmm1iyzqhAH9U9cTbuhoBPa9VucPcY5oTV9fg9hX0TA8NPOkx7mFpjYjO6rSOjdRj1GTvyEmtoefR3vqJLIo4G0+Z+0/7MKSxLVdisIKy95ttXv/ZHD1vuXmR8n2LJfoJyIT3BVJU/RnjYh7HHyWRTf0PRak/tOmwus3uBsnrHz+rs+y9Q+bAhObjO3TmUepMCLX/IckadysDP2IfbJiL7KuBORW1WbA9tfXUWAXGxFFQlQHU32DxLVjgwZ551vSAESrNwiZhrvA9WOzMoO/kymWRi3VvPwLe21ReczBO74mrrS3OAmPZ+PoiTJcj0MNvFhgEijrPChtsqLzc5lInjIWeTWhcheQyRlkHYjTaxAfYglgAY/nWGln2jtdnuZvg23QhAaajHKr5+dY02Hr216uLR4HsQaCh+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/29/2025 4:59 PM, Kundan Kumar wrote:
> On 8/25/2025 5:59 PM, wangyufei wrote:
>> Hi everyone,
>>
>> We've been interested in this patch about parallelizing writeback [1]
>> and have been following its discussion and development. Our testing in
>> several application scenarios on mobile devices has shown significant
>> performance improvements.
>>
> Hi,
>
> Thanks for sharing this work.
>
> Could you clarify a few details about your test setup?
>
> - Which filesystem did you run these experiments on?
> - What were the specifics of the workload (number of threads, block size,
>     I/O size)?
> - If you are using fio, can you please share the fio command.
> - How much RAM was available on the test system?
> - Can you share the performance improvement numbers you observed?
>
> That would help in understanding the impact of parallel writeback?
Hi Kundan，

Most of the time we tested this patch on mobile devices. The test 
platform setup is shown as below:

- filesystem：F2FS

- system config：
Number of CPUs = 8
System RAM = 11G

- workload & fio：We used the same fio command as mentioned in your patch
fio command line：
fio --directory=/mnt --name=test --bs=4k --iodepth=1024 --rw=randwrite
--ioengine=io_uring --time_based=1 -runtime=60 --numjobs=8 --size=450M
--direct=0  --eta-interval=1 --eta-newline=1 --group_reporting

- Performance gains：
Base F2FS                         ：973 MiB/s
Parallel Writeback F2FS   ：1237 MiB/s (+27%)
>
> I made similar modifications to dynamically configure the number of
> writeback threads in this experimental patch. Refer to patches 14 and 15:
> https://lore.kernel.org/all/20250807045706.2848-1-kundan.kumar@samsung.com/
> The key difference is that this change also enables a reduction in the
> number of writeback threads.
Thanks for sharing the patch. I have a few questions:
- The current approach freezes the filesystem and reallocates all 
writeback_ctx structures. Could this introduce latency? In some cases, I 
think the existing bdi_writeback_ctx structures could be reused instead.
- Are there other use cases for dynamic thread tuning besides 
initialization and testing?
- What methods are used to test the stability of this function?

Finally, I would like to ask if there are any problems to be solved or 
optimization directions worth discussing for the parallelizing 
filesystem writeback?


Thanks，

yufei


