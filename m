Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FDA6CCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E25C6B00DC; Mon, 19 Oct 2026 09:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193786B00E0; Mon, 19 Oct 2026 09:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B516B00EA; Mon, 19 Oct 2026 09:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D15206B00DC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:10:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B50D16055A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:10:24 +0000 (UTC)
X-FDA: 85339409568.16.6F78B62
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 205B34000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:10:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wn9+QGYq;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.5 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792415421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5nuIMkDu43dEBLcvLIet4X2HEH+Q6LFUS+JsbUe8ks=;
	b=rIreB8zV3alXSw61gO2UMV3s4KSloiwWmFPNtBe7QIlTvIhXzoyldchnh3yOA3XEZCmmsA
	d/s32Iv80ZVvf/iRBKZM1s3MN3PP3t9C1q6kgX3xNHNvXj4eSt2mBFbhTLkiLgkmjg62r/
	b+dWW9qNqBP1Uf5hjE9WuLpushZoMH4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wn9+QGYq;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.5 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792415421;
	b=p5egI8elGBKtqapM3rl2Bq6z2y8+01mFSf6G+UQ+KL9OtUWAi3NG1yU3tm+Y22PovJOLNL
	+mN/jv8v3fQcguMwFyXsg1+O8sgb7ETZglxZdH9a1X/3aRUw0IYALrRgniIw0+p1Uk9609
	ThV3Nh9+Wzkwv4fbXUsU5jBrzRgfCJ0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IJXoUjZuF6PP5OqsxcKLuHcT3ptlJj9WTIvg/EvUtIVs0aN2BRCSbF+9EyqEwVSi4dJEmbsHq28YKBy9SMvjJ6ldUChtXjgf83AVUg/D55+cAvKQoF+PBaXrjhuGRa7YX/T7VIYTfDlrknjTWtn+RH5KmZ4cmCQJmzNRCFw4qEdlglKedl9N0un/5A7HcdgR2vRWqr+pNXdjrHspn4UjXrWu6qEivq33BP8DXfwgXwTtAUWwWo0rVZiSdqQpjMN5ycsYLvb+IndgDZkB7XvZ/s6W4LhuiBbv1fMS0nyQudrMUVaSx+X53s9uJmCrVbgBdRI2tayQ2QeqSDDw9wtVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5nuIMkDu43dEBLcvLIet4X2HEH+Q6LFUS+JsbUe8ks=;
 b=yGhaUhCCAygJIcIz6j/0CcviW1KJfWcrSZMvf6waxQQSGLgmrDL9TYBV6FEoaz+YXZJ2EWtLFZvsSkj/suTdhqPcOFOvCYPymmf7d/pPgCFGfqBa5yKnHo/v1i0SpC+ITJ9CSxwBPCroxtcxQpKtSvEdbR8U9mDEofZS1AjpLeTJZWF+HMMHo+LfyuxIiX83/54sdshb8Rv0rl24G54GmOf85+pSftHUw82hbQatvCMvh9jmQitFhULNkneyokIWKcT/6qsbOGt2dzC7lvVgqS5lDV+X5MGToulv6O9wDcmOREySdf2NPNbxT3K6xdxjb16bMNQ0E8u4px9uIBXdkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5nuIMkDu43dEBLcvLIet4X2HEH+Q6LFUS+JsbUe8ks=;
 b=wn9+QGYqCtWbQnaACTPBhWBLEoXsOAd8ueelIGcZ5RhUe7hDexIdHA9EH9+RrKNNyANRhtqgR5LDuo4UjtIhgCuY22b5rQagVHohU+zgSxm/ipJ+wu1kE900v97grIp5NGyx2JAX/Ag/48Mld05bd4Vk8u5XpuKmcFcl8Ofkme0=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MW4PR12MB7382.namprd12.prod.outlook.com (2603:10b6:303:222::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 13:10:13 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 13:10:13 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "david@kernel.org" <david@kernel.org>, "pfalcato@suse.de"
	<pfalcato@suse.de>
CC: "tejavojjala@google.com" <tejavojjala@google.com>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"surenb@google.com" <surenb@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "nhuhuan@google.com" <nhuhuan@google.com>, "Salunke,
 Hrushikesh" <Hrushikesh.Salunke@amd.com>, "tglx@kernel.org"
	<tglx@kernel.org>, "liam@infradead.org" <liam@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de"
	<bp@alien8.de>, "ljs@kernel.org" <ljs@kernel.org>, "rientjes@google.com"
	<rientjes@google.com>, "torvalds@linuxfoundation.org"
	<torvalds@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Thread-Topic: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Thread-Index: AQHdX7GhnuOfO5oRrU+HnM1hVhc+T7cEtTAAgAAUroCAAA0WgA==
Date: Mon, 19 Oct 2026 13:10:12 +0000
Message-ID: <0346e29faa551efb6a4e21a920d344f5f9b918e5.camel@amd.com>
References: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
	 <atX3lpXQBHH1JPhW@pedro-suse.tail5790ac.ts.net>
	 <ad34dd6d-f106-42b1-b8b6-a4487822285f@kernel.org>
In-Reply-To: <ad34dd6d-f106-42b1-b8b6-a4487822285f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|MW4PR12MB7382:EE_
x-ms-office365-filtering-correlation-id: d1cc8fd2-bc9e-4048-8ab8-08df2de24f85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|38070700021|56012099006|4143699003|11063799006|261009223027099003|22082099003|10067099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 +e4rRFDWvjq1nlERowQ5FbqpcLiUSggP6sMivsFl6oQ6PedNYFPL+BrU5jE5dDTuud8O/cqgcSEm/V8kytoKLKTZCo2Ai8TMfCR8wC5Rk49aEYnrttCNTsnTzIBNZhxybN7nM9CngUrak0v9df4HHNODFec940gi9EeBnCXDekwCG9eSIM5EChqh4gLFbjHTCdvuTP8hvC+ckfoWZH9TsFwnTVfZxiJsDsO92IqmoFxoHdaGMnomNR4vO6QeFRzVzd0cIvXO5pKWQ3xeS9QldOuDz7d41Hwv7SRodA2VzQQzvXNloZkYogKSMlqFq1qGwdPMGCodWEjzoVVNwdXTLmDsC36V1pEgoJKRQsG3ThHzK0bzMslKRTynq4ZDOMsof9124QGnsM80vT3efwQ2t0vkWJpLsxGc6HxcG9Mrivmqu4+2Qo86UNQ2CtmiyikKZYz6jiKHhHrFqgG3qJrDcD/Bna3Qv7xYm1PudJIS901EfqFCHKdPfjXxDmemIZEJ3MTNpC2xjc0OnuFJEgelvQKe6rUfbdobiQGsr11qzahY6AQhhaCzsnSknelIOvm7xZ7bi2VdHZ/9i9k6AMSQ77MgaZFmesTeZ0LzuF3QgFXDzc+L27KlQqGZHfsX0XPVTg8selHfOgiMIGUtuOqx4qyaktjd1yncMjcxZ7knFoyZdLlK/aoXAXRCUtLHSjUC2whydNZ6hLQ/GZ5ZCdeVKwDZWguqA08buHv45MjLUuE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(38070700021)(56012099006)(4143699003)(11063799006)(261009223027099003)(22082099003)(10067099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bjA4S2xHclZPaWo5TW1nNE9rcVI5bFpkOWJPZ3M3SDJwY2RjT1FObW1VTXZF?=
 =?utf-8?B?Sy80Q3ZJNVV6aUhpWXZvL1NGb2xvWXU4T1ZaNFNxU1lrNmUwNmZveDJEbktW?=
 =?utf-8?B?Y2k4dDVJWXRLdFc1WHdBTVl6cnQ2Ulg2Y21jREVXWFRWWDlEM0tMRW1NRlh1?=
 =?utf-8?B?cTZJc0tYVHJTZDFWUzNxQ2cwSlE0OWdvdk52ZXZhbDEyeDBXMWt4QURRdG9L?=
 =?utf-8?B?TDV1TVlDR1k3QjUzaDJXUVBQN2ZhYkRLR3ZlYy9XMEF1YkFTcWFhM3cxaUhy?=
 =?utf-8?B?LzdUMVpiVDU5Y0N1cE11ajVUVjN1aTBxUG1HTzZVeU9ZYmRpcXQ4d2lBZE0r?=
 =?utf-8?B?U3krQ2xES0xpZThJYXUvRGhzL3V0em5kZGxVUjZqZldoaW1aUk9WeHlwRGJn?=
 =?utf-8?B?T0o5bVJhOVM1eE1wYjNJbk1ERkk1dElKUFZjQnRlK2FFdkxDQmErcmxzQjVM?=
 =?utf-8?B?ZGk4cndiOFpmejRYSzZBUmdKUzNpZXBrNkgyVjB2bXc1d2FtanZhbU1KQk5l?=
 =?utf-8?B?UlE2NHJuSHd6SGdRV1JHZFptcWdrNHpzWEV5R3BPYWFkVFFMa1BZN1BtNHJh?=
 =?utf-8?B?TEgwODB0Q3VocEM0bkYxZGxMUVlUREpMb0FlRmpFZDd3dU1YRFdZcFJ0RllR?=
 =?utf-8?B?dGNmdUExdTBSY09JMDlya3ZaNlYzSlpkZ0tETkZuQTFIYVJMTE9hY1dYWFcr?=
 =?utf-8?B?cnJVMm5uOUlHTXJyMTl3L1JHblV2WWphSHczUlB3bzFUR3FpMjFWTnZLQkN2?=
 =?utf-8?B?WXF0a0Q4K2FrYU9zTjlLTGdzVE9HV1VtUEVtanlTTVRpYUIyek5oWG1MT2Rl?=
 =?utf-8?B?Rjh2L2VaUzdyeDlDZEd6dUp4RThyeGxTYStybHRGL2J3MysyVWlPWGtWR3dn?=
 =?utf-8?B?L1NLSWc0TWtxVE5lTXZHUFpQdmMrLzBqT1doYTNFYU8xZndsZlFsRE5FWUlz?=
 =?utf-8?B?NHpvNUN4bG1BRC9lcmhhaEhQNDlYM21JNzA2bG5VU1B5RGViZzBQZ3I4K2c2?=
 =?utf-8?B?cWhmRjRDRFdvZHpKdnZ3clh1T1lGL05vZTY4SWoxUE5laUdOWk5wVkN1VndG?=
 =?utf-8?B?a01Ud1RHaWM3dHV2c201bmd2NFA4aU56TW5wV1pHWGprd3hZREFhVGhZVXoy?=
 =?utf-8?B?d1BuckxHaFZGejl6aklqSWFsVlMvaElTSHpQaG5hcEp1VGVRNnhqdU9yTlF3?=
 =?utf-8?B?RjQyNDNpVG04NGFBcjU3aEFBZTl4UjAvcWxNanhBOTlPTmE5Qm9YeEFueGRE?=
 =?utf-8?B?dlFjenl4NWZIUnl4WDBycU4wVHkrZm4xU1E4M1V2QXRkOXdGZFI1S3k3TmhF?=
 =?utf-8?B?Y1VNc0JsRFpjTUNhb1J4YzI3djR4dEhEVW1odmRkYzFrMjh4OHJueW1UUXpQ?=
 =?utf-8?B?QnJMMmlQanlUL3hqLzNycWdZV3RZV0V1L1hFNkRIRTRyWVJ1dGs2STNCcDR6?=
 =?utf-8?B?V1NMajhEUzNSUEtPMFJhdW13QTNnUkdnbFhvYklMRDBXVUx2aWVYR0VlbmdD?=
 =?utf-8?B?bm0xWGhIRTBzTFFKUlA3QXloWkhEblRUZG4wdHg5aFdoSzhZc0R6NmhMVXJC?=
 =?utf-8?B?dTFmdktmcHdqOTFBbXVSSDdJMnRoTXQwM29yRFdWMUpQSUhCMzlDT08vdjNl?=
 =?utf-8?B?MWxwdDY1LzVqeUxqM0tkRjl1T2ltL0VJWXd3SFpHVmMzZ1ZwU2ZCUmdPSjF2?=
 =?utf-8?B?R2R3c1ZKb0UzYnFDME5oOUp1eHZMU2dJWmRubUU4cndUNUdvMWtmTlBLb3RN?=
 =?utf-8?B?dk10SXdLditEdTJrK1JOcXlRVkpaUC9zYXhmbGIydnpCTnFhV2hHNUV3ZGhp?=
 =?utf-8?B?b3V5ejdrZXNqa1R5em9KdUg0SUN5UFJuS2tqbHo5dGJzRElxWFpoNFo1cmF6?=
 =?utf-8?B?K2VIckRQZnJ5Z1REQ29pdDhuYnRQTFB3NVNrVFRKbFlKakloRENVQVU5bUVm?=
 =?utf-8?B?bjlwZkhXSFppODQyMGdZak1jNUU0SFozUDJlRVdMS2pXbmJaMFU4alJqWUVy?=
 =?utf-8?B?YVBWb3NTYURXdEFMUHpvL2FKUEdLRW4yN25rczdzNytUSU1Oa21jVTlZejkv?=
 =?utf-8?B?SVIxcGF1U3pYQXB2RExvQnpWSG81MzlkZkx0ZGpobExkK1BLUndVdmJ1N28w?=
 =?utf-8?B?RERIaGh5Qm1weGpPWER3QmJBV3UzMG9pb1Mycmhpc051R25aeXBVYXFRRFRD?=
 =?utf-8?B?WDNWVlh2V042dnRBWUtiem1jMXcwR0VqdTl4N3NWRExaSldaSkUwQm9vdUg5?=
 =?utf-8?B?Si9JRUpsR25laC96OEoyVjVSTU1sWU03S3dGRFhlVCtBdkpJM2tHcTAzM1Rs?=
 =?utf-8?B?M2JRSEV5eGR3cjJZb2wrVHhYbUxLMEF1NWxHdDhJdjI2SWQ2VUovQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D46D18B53981254FB46EEE0A29D55D3D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cc8fd2-bc9e-4048-8ab8-08df2de24f85
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 13:10:12.9686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LVf/eka63C+fG1lUcjccka6n78aWoNyINgmYyvuMeelK66kPBeNXSmwtC6UC4enVlm2Q7NrQ0NV2AgHBb8rBmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7382
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 205B34000D
X-Stat-Signature: 9k5cdigdc9ecxdkqfxankaq68bu3pshg
X-Rspam-User: 
X-HE-Tag: 1792415420-151078
X-HE-Meta: U2FsdGVkX1/My40JQ0+U/HWw0+g9v7FBCzSHWN+fZk3fpC8mUHXrmHMTf2kVcK5Wj+h7w+Fs5Soo8o692SlKXLYNUiMnAAbAi+EYbZ4owoit/BLxFVP536kOOq45ffNVeGDnRO5yXg0RIUvbPzbE+Re58UgNtcG0Gsn0ohX2785CMGSRGA+FRndnbP4oiP41NwrtAlbmPzBjhGXwWqvHNdTcp84z2rPGAb+g5ENiGDXByFi1Nz4O7L3KzJejTmvpj7CzoAO2ijLJadKtChBm0YqdZPK4h+nb5B/ZW9iuXw4b84YuDHdPGqMgnJygQslzyr6R5r8sPhAWdlRBtFYgDOOaqknLgbGL8Rk1RJuwbjXlWO9AuQ58/mXa8IsuHXiOhXXhGs1Ne3rjqsJEOEgFdyNW24kg+bnbg9XdIAM/qksChxf800Pz2R3CmO7QHaA0bATHCswOoz8byszHFTnPK1JQRvfh2T+AMVn34IHQqozg0mCB05oI3TeAsqIsIc0+/CCXuilXcStIkXQUW72T5zSILbMqxXA4FDayHr46JhsBAxU1YiSsbA6ok6/d/2nzjQH50h8juvIzd49ZwzwY+SO0jmEtK1RNETfEgO2Z3gRgTzTY9PeilWr0UQjYIHZXnbKkyEnFs0tK7Jq5FHhQIFRt+MdMpV9SQTEBjy2mRP4WAUfyRHQj2UTHq0ShK7a/0NtjRN6VYofE6cu8Njgz+aVt7h806WZmXN4vVkpqZ/dEzBx12tgbJxvByfYio6inxOCT1JwiBqY5IdaWNcUi3oJE2yrJiqgR/0iJrRNOnBGoFHMKHcK2yeVtgkBevraO2TaCxU4IhisKbCii+tcGXeEx3pb9GppjW5nJMNpTNtmJnyqiBQ1IgmtEG2KsX9lxeCRGE93tDrtioGwjvkwEGzgX+x0XKMkTrlni5UGTEsalJWOiiy7QuMahXcjxkt3V9h20Z7OH+bGKtcO5JK9
 DAhIu3nu
 flyGHYtAOqQ976rPU/S+pSmXmIW7ztql5/xvGrcEMynSGvMaPHzEUQaF2fH7i+clFbj2SA+YMLYugu8ufVW1o4Staw3fFzcA8No6Q2OWaqtd7E1CYkImsHuR8xbrc94yErBbLhknRU5rsHh2lydzKtvMHBDYFS6BwxDHuroydw+CJCDk9l42xdj8ya/ZKbpnUv09W33vQzQOw+RB/LzBUFKeP99RuvRy6qbEtcTJpwnPmzbj7A9U1e/yGpLMD+uSbw53baFeNOTqhBspShEA+WBDYPG7yRU9iVqS3LppygprKaJ7bH9FPtUnb03Or90+KkDQe6CnvVdd0GKwZcYszQdDniJZMt8+LhMPbIPdSwWOF7qGQXNS3JdB7zbK10igIGjXYQDGdmGXcNqvl7sKuYz7yzhv+yPtIfEvWoGt/c2pGCAXMj8AfJxqyX/BrwZmKPb7PsnEwahuxXWLZ30P+dkJxFvMF8LWz9KLCII+6tubUGdWXE3vKkHlfm193AskB0BIfyhkzekxorOnjtwpMTqkxOhO1j5WYQLXNSlPwMQQIEW1dMt3U/Mic8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gTW9uLCAyMDI2LTEwLTE5IGF0IDE0OjIzICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gPiA+ICt9DQo+ID4gPiArI2Vsc2UNCj4gPiA+ICsNCj4gPiA+ICsjZGVmaW5l
IENPUFlfTUNfUEFHRVNfTk9OX1BSRUVNUFRfQkFUQ0gJCTENCj4gPiANCj4gPiBJIHdvdWxkIHN1
Z2dlc3QgdGhhdCBwZXJoYXBzIHRoaXMgc2hvdWxkIGJlIHRoZSBmYWxsYmFjayBmb3Igbm9uLXBy
ZWVtcHRpYmxlDQo+ID4gbW9kZWxzLiBCdXQgaXQgZ2V0cyBhIGxpdHRsZSB3ZWlyZCB3aXRoIFBS
RUVNUFRfRFlOQU1JQyBJIHRoaW5rPw0KPiANCj4gV2h5IGNhbid0IHdlIGp1c3QgdXNlIFBST0NF
U1NfUEFHRVNfTk9OX1BSRUVNUFRfQkFUQ0ggd2hlcmUgd2UgaGF2ZSBzaW1pbGFyDQo+IGhhbmRs
aW5nIGFscmVhZHk/DQo+IA0KPiA+IA0KDQpJIGRpZCBub3QgcmV1c2UgUFJPQ0VTU19QQUdFU19O
T05fUFJFRU1QVF9CQVRDSCBiZWNhdXNlIGl0IGRlcGVuZHMgb24NCndoZXRoZXIgY2xlYXJfcGFn
ZXMgaXMgZGVmaW5lZC4gV2hpbGUgQ09QWV9NQ19QQUdFU19OT05fUFJFRU1QVF9CQVRDSA0KZGVw
ZW5kcyBvbiBjb3B5X21jX3RvX2tlcm5lbCBhbmQgb3RoZXIgY29uc3RyYWludHMuIFNvLCB1c2lu
ZyBhIHNpbmdsZQ0KcGFyYW0gZm9yIGJvdGggd291bGQgbWFrZSBpdCBtb3JlIG1lc3N5Lg0KDQpI
b3dldmVyIGFzIFBlZHJvIHBvaW50ZWQsIG1vc3QgYXJjaGl0ZWN0dXJlcyBhcmUgZnVsbCBwcmVl
bXB0L3ByZWVtcHQgbGF6eSwNCmFuZCB3aXRoIHRoaXMgY29tbWl0IDdkYWRlYWE2ZTg1MSAoInNj
aGVkOiBGdXJ0aGVyIHJlc3RyaWN0IHRoZQ0KcHJlZW1wdGlvbiBtb2RlcyIpLCBmb3IgUFJFRU1Q
VF9EWU5BTUlDLCBwcmVlbXB0PW5vbmUgYW5kIHByZWVtcHQ9dm9sdW50YXJ5DQphcmUgcmVqZWN0
ZWQgYXQgYm9vdC4gcHJlZW1wdF9tb2RlbF9wcmVlbXB0aWJsZSgpIGlzIHRoZXJlZm9yZSBhbHdh
eXMNCnRydWUgZm9yIHRoaXMgY2FzZS4NCg0KU28sIHRoaXMgY2FuIGJlIHNpbXBsZmllZCB0byBk
cm9wIHRoZSBDT1BZX01DX1BBR0VTX05PTl9QUkVFTVBUX0JBVENILg0KDQoNCj4gPiA+ICsNCj4g
PiA+ICtzdGF0aWMgaW5saW5lIGludCBjb3B5X21jX2hpZ2hwYWdlcyhzdHJ1Y3QgcGFnZSAqdG8s
IHN0cnVjdCBwYWdlICpmcm9tLA0KPiA+ID4gKwkJdW5zaWduZWQgbG9uZyBucl9wYWdlcykNCj4g
PiA+ICt7DQo+ID4gPiArCXVuc2lnbmVkIGxvbmcgaTsNCj4gPiA+ICsNCj4gPiA+ICsJZm9yIChp
ID0gMDsgaSA8IG5yX3BhZ2VzOyBpKyspDQo+ID4gPiArCQlpZiAoY29weV9tY19oaWdocGFnZSh0
byArIGksIGZyb20gKyBpKSkNCj4gPiA+ICsJCQlyZXR1cm4gLUVIV1BPSVNPTjsNCj4gPiA+ICsJ
cmV0dXJuIDA7DQo+ID4gPiArfQ0KPiA+ID4gKyNlbmRpZg0KPiA+ID4gKw0KPiA+ID4gwqBzdGF0
aWMgaW5saW5lIHZvaWQgbWVtY3B5X3BhZ2Uoc3RydWN0IHBhZ2UgKmRzdF9wYWdlLCBzaXplX3Qg
ZHN0X29mZiwNCj4gPiA+IMKgCQkJICAgICAgIHN0cnVjdCBwYWdlICpzcmNfcGFnZSwgc2l6ZV90
IHNyY19vZmYsDQo+ID4gPiDCoAkJCSAgICAgICBzaXplX3QgbGVuKQ0KPiA+ID4gZGlmZiAtLWdp
dCBhL21tL3V0aWwuYyBiL21tL3V0aWwuYw0KPiA+ID4gaW5kZXggN2YzNzRiYjhiZjM2Li41MDE1
Y2ZkZmVhYTUgMTAwNjQ0DQo+ID4gPiAtLS0gYS9tbS91dGlsLmMNCj4gPiA+ICsrKyBiL21tL3V0
aWwuYw0KPiA+ID4gQEAgLTc2MywxMyArNzYzLDIzIEBAIEVYUE9SVF9TWU1CT0woZm9saW9fY29w
eSk7DQo+ID4gPiDCoA0KPiA+ID4gDQo+ID4gPiDCoGludCBmb2xpb19tY19jb3B5KHN0cnVjdCBm
b2xpbyAqZHN0LCBzdHJ1Y3QgZm9saW8gKnNyYykNCj4gPiA+IMKgew0KPiA+ID4gLQlsb25nIG5y
ID0gZm9saW9fbnJfcGFnZXMoc3JjKTsNCj4gPiA+IC0JbG9uZyBpID0gMDsNCj4gPiA+ICsJY29u
c3QgdW5zaWduZWQgbG9uZyBucl9wYWdlcyA9IGZvbGlvX25yX3BhZ2VzKHNyYyk7DQo+ID4gPiAr
CS8qDQo+ID4gPiArCSAqIENvcHkgdGhlIGxhcmdlc3QgZXh0ZW50IHBvc3NpYmxlIHRvIGFsbG93
IGZvciBhcmNoaXRlY3R1cmUgc3BlY2lmaWMNCj4gPiA+ICsJICogZXh0ZW50IGJhc2VkIG9wdGlt
aXphdGlvbnMuIGNvcHlfbWNfaGlnaHBhZ2VzKCkgZG9lcyBub3QgY2FsbA0KPiA+ID4gKwkgKiBj
b25kX3Jlc2NoZWQoKSwgc28gbGltaXQgdGhlIHVuaXQgc2l6ZSB3aGVuIHJ1bm5pbmcgdW5kZXIN
Cj4gPiA+ICsJICogbm9uLXByZWVtcHRpYmxlIHNjaGVkdWxpbmcgbW9kZWxzLg0KPiA+ID4gKwkg
Ki8NCj4gPiA+ICsJY29uc3QgdW5zaWduZWQgbG9uZyB1bml0ID0gcHJlZW1wdF9tb2RlbF9wcmVl
bXB0aWJsZSgpID8NCj4gPiA+ICsJCQkJICAgbnJfcGFnZXMgOiBDT1BZX01DX1BBR0VTX05PTl9Q
UkVFTVBUX0JBVENIOw0KPiA+IA0KPiA+IFNlZT8gbm93IG1tIGlzIGF3YXJlIG9mIHByZWVtcHRp
b24gbW9kZWxzISBld3chDQo+IA0KPiBZZWFoLCB3ZSBoYXZlIHRoYXQgaW4gY2xlYXJfY29udGln
X2hpZ2hwYWdlcygpIGFscmVhZHksIHdoaWNoIGlzIGdldHRpbmcNCj4gcmVwbGljYXRlZCBoZXJl
IGZvciBjb3B5aW5nIGluc3RlYWQgb2YgemVyb2luZy4NCg==

