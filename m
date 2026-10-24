Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8224606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 12:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=vRFw8ujB
Received: by kanga.kvack.org (Postfix)
	id 32EBF6B0096; Sat, 24 Oct 2026 08:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305646B0098; Sat, 24 Oct 2026 08:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5126B0099; Sat, 24 Oct 2026 08:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA6E76B0096
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 08:21:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B17D4033F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:21:56 +0000 (UTC)
X-FDA: 85357431432.20.08E6280
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010023.outbound.protection.outlook.com [52.103.20.23])
	by imf13.hostedemail.com (Postfix) with ESMTP id 753E320006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:21:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=vRFw8ujB;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf13.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.23 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792844513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOmA1ZeGF8a3S6Vxtj6eyuD9Thm+qTYkpGAnGLekx8Y=;
	b=ZRo3tvVeR5+PJVtyiUI3mxzyDJ2iWFEtvHtgcrR8SEP67dQiDrhw3WcTyniG5LnXaGhkMB
	txPFdj2i2oeDDAnPHdmQJn49HBkwPLYjZayZWAMEsS9Ev/ypit8EfA9wkeCseds7xCVO0e
	dEskdunBFjrGD/3PLqfMD2cdjotLlZ8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=vRFw8ujB;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf13.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.23 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792844513;
	b=oNveb1+kAoU6MnNDN9sj7VFrN5qzzCg6mf8uF3LZ0pcv4W93x+tZMOe+QaQdn41u3Rmv4r
	Tsw7fCrfhOAvEj96Y+r9dA3iRgHd4gVfanslofjPnyRgbMDQ+std70AJPoepLavS2ttC5w
	LsqbT4Do4Wq9EtpHhuqUpu6kIU0t2qI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvpkLtYHf8F28dcj6mEml/DZPFAgi9YoE4+HAe9OnX9Lw5xF1cE6gkHbkmBaIpF5lDVm55oa9PTSzexjiy67R3ZlYAZI+Fmz6/LrNv1hQVSgRPI8ExkO3iaqQzPI6w9CiWCHWanTdyxy+mYm/rzzuNMY4MLxDMAaeUr0PvIDwFhtifRu++YjssLPmGn3gDUZm7BzGA/LLLiPV8KVKThNdz4Q4UgBAWvOw5uZetSuCa177ZuoGZ6+BBLp0GWc1cUlqTZESxE8Ie8QM32cAJOrULkVCKvuMjJ+e3DoTjDc5M3qt2+HnqqynU3TVEtzIRsF1Q2JbjT3P70GizTAIGQnhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=gOmA1ZeGF8a3S6Vxtj6eyuD9Thm+qTYkpGAnGLekx8Y=;
 b=kcv3I+b6PfbBAe6NOgjU9pRS2e8STRHsWym63rFBGEi+jdGGEJSorliUTYtx2RNOaWLf6cL0i5yWhAAl71uoUg2WffdHM08RX/A4Gn4RvtyeMTW4agDp1qM+7cEZyeLvigA93CTvZxWWX7O9dgGoHWvdwSaJDgDhZDUEJDzrRIGL1ouvx9vnLUdXYGlHVm+O4SA51FYdak7LuN4gpAB8fI+6nxY5JnvN3s6JjSdrahUf4VrKn+leex40YmnCufuqVFDLahSsVwkC0iDv6eD4NoHeFLfWPoEKRKgMB1l3IClV/vMMUkQGLBOEFeFWy6vEYFi3FEaJqjhhyTZSHtWh+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOmA1ZeGF8a3S6Vxtj6eyuD9Thm+qTYkpGAnGLekx8Y=;
 b=vRFw8ujBXi20xwulJcaHIG+Hn74bbHu1C+GBsyT3iQcVv/j3B+LWcLyOMxR1Nr95ED+lZhTzaceF9QAqR5Yd8pu1VopZjyejU+WLyR4Qx1IgVnIdr+yRM4nQx/cEyA8MvCLndK2cgNwPczWRWkHzAmc5fT+ZCKA11Lpc/DHg3NpJHY1oIaD1Yxp1XSURVie0heRkzQOv9+sGkJKiq+SiwfoxdcRJ5x/g9hMJQ8gcRZuLqnVVLncRODJFh6G9hFoSudOYwnFNd73gEV7Q8hsylmQibi0jZayFva82A23+DlYWdtebtiBebs/pitqbvEzBayWPXBxFAqHSlB79hclInA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH7PR05MB9058.namprd05.prod.outlook.com
 (2603:10b6:510:1fe::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:21:43 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 12:21:43 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?utf-8?B?TWljaGFsIEtvdXRuw70=?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: [PATCH v3 3/3] ipc/sem: remove obsolete SEMOPM fragmentation warning
Thread-Topic: [PATCH v3 3/3] ipc/sem: remove obsolete SEMOPM fragmentation
 warning
Thread-Index: AQHdY7I78TSz9U0Vs0GMc6gS5bS33A==
Date: Sat, 24 Oct 2026 12:21:43 +0000
Message-ID:
 <7959bcd834d1579c13f244d4aea7ab655d2b0051.1792808260.git.x-professor@outlook.com>
References: <cover.1792808260.git.x-professor@outlook.com>
In-Reply-To: <cover.1792808260.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH7PR05MB9058:EE_
x-ms-office365-filtering-correlation-id: 0979b97e-1d04-426e-04d8-08df31c95d92
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|8060799015|8062599012|31061999003|25010399006|4140399003|24021099003|16051099003|38102599003|15080799012|24121999003|22091999003|40105399003|52005399003|26121999007|102099032|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?RmZuQkRiVlhvSmh3U3JHUGUvMG53c0FsTHFWWHNIY3RRYi9XZk53L1Q3NUpF?=
 =?utf-8?B?Ym9sTUdIK05kSEhNU0FaV2RyczhiRlpSTk91c3BycENCbWRNL0laSTJwWm5k?=
 =?utf-8?B?ZW9RL2F0NFdpellMQkhqNDFTL0RBUFpBK0JhcURQYldVVnNPOGliaVRCdDJi?=
 =?utf-8?B?R3M3SElSd1p2anE5MzhjT0tPKzJuNEhkbDQvVGN6UjdnQVQ0VmdkelNuTlNx?=
 =?utf-8?B?Ull6b0dlcCtpL1FWRWZycGhtVTRQM29vbUxaY0wrL2s2ZDZhSVBiQys2QkZs?=
 =?utf-8?B?dlkwRXpmSGVTeDJMbTBPWnl6VzFadzh1ODl5Y1FmSzRnc3NjUXdJbWNjNzl1?=
 =?utf-8?B?REVlUkhXaWx2MEF3N0JaS0tKSFRqaVRzYStDZ2lUSDllNGp5emVwQjJPZ1dm?=
 =?utf-8?B?dkNvQ2dyUk1Rc3dsdHhONU93MUE5MTdLbXNnWFZWRnp6NnFZWFM0eDlCUlRa?=
 =?utf-8?B?OUlXVUpXSkRmR05sMi94ZERZd1pPdVNjOHVUTUtwUU1YWmpySjVwR0RzSEVU?=
 =?utf-8?B?RXJ0WU9oRmh0M3dub0Q2amtOanZSS0RtTkwwOFYvSDQzMWdOS01HT29ETkpt?=
 =?utf-8?B?QkU2ZWlQVTdia0xjZ08rdU5yTzk3T2liUDd6aUhUMFRiWTRHdSsyeFZHdEJu?=
 =?utf-8?B?d0NpenYzZERISTRmZVNNWmJoOEZ2a0krdWhNRGhiU3o5Y0ZEd3dSVWRWYm1F?=
 =?utf-8?B?RVpwM2JFdVN4ajArWTQ1dGFmMjdEKzFPbE9BU3FWRWdMUTQvSFg3RTZmT3FB?=
 =?utf-8?B?VkxsdXRuYkdkRWI4WTZUMWFtNjVTRlNxaWdsazZQelkyRk9PNy9yM1BrZFpo?=
 =?utf-8?B?eUdNR2p6bU5aQjZCcldMQjhuVUVmUU16RVZOMFJ3ZWJJSjRHK0t5Q0xUZEpm?=
 =?utf-8?B?eW5LRXp0cUtLNTJCZmEzSmRsaWpsNTh0WnRyMGd5ZFNJU04yUERjeDZmcmNJ?=
 =?utf-8?B?Z3VqaGZtVm5NQjVEK1A2VjY0TU96QjU3a2l3REtkMjUzamNPempsSndhYkdZ?=
 =?utf-8?B?Rkd0cUUyQzMwZ0ovQm5zNmxScm43b29NQmlsMUZ0Z0FHbXlZMElCTExHRk9F?=
 =?utf-8?B?eXlubS9Ma1JQOHFiNXlFWUl4ZStLRzdhdHdtaXRMZi9LdEtoWEF6b1AxeEh1?=
 =?utf-8?B?QWcvdkQ4RmVtMnNxZUJ3UW9rd3NqczJDaTd0R1VJYkM2aEp6OTlmUGJ1OUxv?=
 =?utf-8?B?SEtwTStxQUZHSjkraE5LTUhoalRxeGQxdGZXbWRNMUNPU0FycE41eTZnNUJo?=
 =?utf-8?B?N3BwNEJ2bEc3cmRDS1pWd0RBQ1ZMRGlXK1orTTZkQ3hNWHVoVFZiM2E3Qnpz?=
 =?utf-8?B?NUNwMnBHNnBrWmxPZFduc0FqL2Z1K042NHp2YzZ1YkxMK0pLK3diVm5FWG1a?=
 =?utf-8?B?WDN1d0d1RlVMN2oyOFQ1Vm13bmdHcDNkTWVFWGo5MHNXVUxZdGpkZkJLRXVr?=
 =?utf-8?B?SnprZnoyZFdEWDMyVlBIWDN3bEFWMFcxYWVrWVJ0MmxjWFFRLzVNVW5tUllF?=
 =?utf-8?Q?0OxTMGiCW3BHFstuZUjjo2meAGe?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MHZJS1grR21xOUp5eTIwTnpnTHRuQm1CWTYySTR3N1JzVUxYbDc2ZEdHZU1I?=
 =?utf-8?B?VC9POFA5MXN2OUxoWWVST1ZYLzZFNzFYRFdRc3lRNWMzRERFbzdFKzRWY29T?=
 =?utf-8?B?Qm5ITzhRWEp0Z1ZjMG9jcVB0R3ZKQmRWdVhJakxydDhPZmpmZDBoT2FITWZY?=
 =?utf-8?B?OUhJM1MraXV3enE2bFNNK1liR1lhQm1MTXhjWWtJRUlXK0VPVjdlTW1aOHRD?=
 =?utf-8?B?dkJNZlZWVkhOTk4rbG9vYy96MGw1bVBES1pmcDdZbUdxc1MxRGFtb1NVcEZM?=
 =?utf-8?B?OHNXV0VaRk9XdDNBbVkxc21VeG81WVJDUWRnb1lGOWpLemJidGdSeFlaZU8x?=
 =?utf-8?B?cG5lQ0NIVHRkcGhFd25FNDRtNDFqbnc3MHRZMXVZemw5Ymx4ODNTZlJ6bGJh?=
 =?utf-8?B?OHhCSkk2OFFSNGJ5VFk5VzZFRzBFYTZMMnRReFd5enhOajF6VTRxaHdEUHNR?=
 =?utf-8?B?c2haN2NQNVVCQlZSQnlhMmVERlIyRUR6WUlrYlk1enQ5dC9wVzBOZlhWWnRu?=
 =?utf-8?B?RFgvWnRCK0xlbm5RdzdxVHh2cFBWUUdKRUM4R0ZLSHdvVUZrSnBpdExBTHF1?=
 =?utf-8?B?bUZHUDd5TkswNXM0UkhVYTRTWm1SUlg3UXZuUFBQRjdPWkF5NkVBTHl0azIr?=
 =?utf-8?B?cVFkZUVVY0VwT1lQNmR0UUNhbHpSQUpvYlV5SjF2c09PVDM4Z0RsSldIL0Fi?=
 =?utf-8?B?cjZkRWQ1SHZvenJmc1FhdDFPcC9PRC9FcTV4Zmx1SjdUb0dHWWkwZ2dRdnU0?=
 =?utf-8?B?SjUwbW5EcGJjc2tQQzNhSkltNnh2UmlJODl6dkVucVBQWlVScUhGZXN4WjhV?=
 =?utf-8?B?ZWdCWjluN1kxaVg2L3J0OFVoMUJCM3FBdVQwallCYmVONmFXb05pMTM5Sjlj?=
 =?utf-8?B?SXdHeG4wb0doNkg0Z1RQNG9zTm1yYUZ1V2FDcGdoRXk4UEVEZ1RxSStBYmNj?=
 =?utf-8?B?THJES0xKZnNNTlpMQ3FKWjR5Z2pJZzlwcElFY1FQeHF1RXRzZmJnL2VVdmc4?=
 =?utf-8?B?ZWY1a1hUSzh3R2d1RnRpRGx6RnlhanB0bVhLMWVuRVZVQndkVTJXTHlwUTlK?=
 =?utf-8?B?OTlZU3k3QVFiaUVxSjdzaElVcjY4QmFRaUZuMDllRVpaQkQxdU50YnVTTmRr?=
 =?utf-8?B?MGxMYXRrUnRNbkI5UmwzWlJtbHRpVDVjSUlINWNaZ0NxbXczTDlNcElyc3FH?=
 =?utf-8?B?bVQ5b1d4elNRVGdBZ282MC8yR1ZCWkdVQVB2N2kwVEIva3NUcE9ucng5SVBs?=
 =?utf-8?B?aUtpQ1Q3U3VvZFNvNC8xUzdibXU0UlJVL0d3ZGY2NDdkd21mYU5lS1pKYVZS?=
 =?utf-8?B?ajJaUmd0cnVNMHpQdFgyb1NVejNRRm1OdWtQbGhMSFRId0lkWUxXc3dhVGVB?=
 =?utf-8?B?OXY3eHVtemx6VlNVd0ZsanJvY2lpSldOc2dra1lqa3g3K1ZWQ3N0T2ZBbVRF?=
 =?utf-8?B?ZWx3NVFFSm93dUF1S0lYK2ZCVWcrblhlOGpVZm9wWHNDcHN3bnhLV3UvdlVK?=
 =?utf-8?B?QkhJNER5RUV3aDRlYnAxdVhlbHVrd01qSVROc3k2V0IzQmJDangzVE9PdE9K?=
 =?utf-8?B?TkYvc202R0JacVpOaFdnU3FmVVQxcUo3U0V4TmFHN0VzcUpIamFKTVptcWpZ?=
 =?utf-8?B?R21sZG1rMWNmeUxXc050amltdXRseGNlV0MxM0lYRVloYThBSEJ2WUdjclZ5?=
 =?utf-8?B?alMxV1lncTVYMytCYUpEbGNqR1VBRWpJSWVLZHhUVGozdlFraEd0Zmd4NFdo?=
 =?utf-8?B?cEhQeTNXcDB5RmExUWphbCtKZVJpcFpNMXBKYWhnUWk1dGhGWFlUSERDSitF?=
 =?utf-8?B?WWNRK3IwVUJjVDRkRlA1NFRFTFpXVFRRTnFLRXZMN1hQS1RCU2RETjk1U0tn?=
 =?utf-8?Q?ewY5ANLcIgXdM?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0979b97e-1d04-426e-04d8-08df31c95d92
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 12:21:43.7422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 753E320006
X-Stat-Signature: s67cz8c58hddfmhwm8dhputgt5cjac8h
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792844513-128814
X-HE-Meta: U2FsdGVkX1/sHq63wGPBUxLHMjqerYrteyakmK1zq/G5X6BQgFFag/HXvP8XR1tztXphjNStnM7yHjftOIxDOLpfoQX5WdH3tq5HTBOdseUxHbwZ2t7gzzBt9xzm9Vsa9XcTM0OF70yauEUmMypt7miarV9MWW18KhPNgO021LSIvut/s4qb3CDBGQvtsl2YXydy0lESptydEgiOK5WcP/jnpJtOLs70bE6CzIwgpPhtx3ddzkcogmSNfMeLw3SvlL0T5ZSYf9zTMBPlesj6//RUO6lUiC8v4FOBDu46+S2928VXrgwEfW+I/piU7f6PLoKIIukXYMxSTloguvR3NNwDr50c4ZUfNE9ynmd/yGxCyOirkOMR+UK+yqczsbwTzAAvkcDATGW4l88Yyfh2Prxv+ZqrE/GSAWdBoDyBi4TaQ/c69JyiucJ9XBnYBd+qAfHOT7vBz4ruebVANrR1E312UtgjSYpyupiL3m0ln5tRpzZKMSb7B1bqb9ImjWHj4CBAc4W1BM4tRaMd+gctX2gBTUe398/5adWbSDSNT8N8DbdFgfHTFJDH7q4E1ZbsA03FlpfwmcJZNq8jJrJhvsDWq4Ik/NTAslSsK0c+FiIoiopm+SLGpUrIs7Z4TI5NR/uRGqfI3G9Ncea5XWhQ7jUCEi7MtI43Ag1cg9i2UiQRJaV9VAr0Qp/2bjO7GQCBc9Q/3BPZBik5W0a+5+U65rIFztxUf2A53MlT4X4hZOIeK8DrI8gjPtV50T6B+6rPNybBWl7ZzOjm1aHcgbAkzdiNWn1/qF+xkuKKeR1d0uYnlfb1Yw/Nx1tRslMzAr5E2X6/xLvxQ5GXoqHdLDXGVKchwDbWEw0EzCr8DZJNM5bIUYURKabCpDVhyZIty+ced+cVoXggHDzQfnqeAV2WrJENzekY9KGlDLbgiZmUhQEAgghbVLeLgBVTazhE0IJiEAAWuQs+Qf8ORzbP9oG
 lJMQ4bpp
 vS8brIY3ti8pQj1AJFUdhp7ahJu2WbdiRieayn6BlGQv+aWViiJPMHdWK4sPL+8CuNzS3R0S9cpEfo1eshniWNjHizUxLiEgxJMf5zhzSSeI0vp20TnWuJG7lLLUBZJIkhKeJiSgUrEXziOdaLGKZHNfNNcMJ47SOGSDf3Slas0yutfxLY1o9Mn3FfLqaAsA8BnZl4Tyx1ZR4Df+MGb5iVtfhfpgw+mTw9u0LyuGArS2lBsZ8O/5D27ZO3SBwiO9HSIT5a5mjXLnRg9d9nX1diJB8gP5iL7fnMaFG3EmUGu24CvcDvILQXmJu4cE9Oqg8MDAbCDXu7XBWDSVkJ+eE6wu2Y0eBUFPqRTT4AQiDvsHgytPtfrYiCoepBjgTWLQmgTRSE7vpgpiMoAFO+cKK1oETS4i1H7K2GwlJdc9y7jNs/1DzgMTJ/56Xv+EDLwJAhO9yyf+2kIsmfTuYjNLziUu4nROcF1KOxiK46Jg+SVdUoeY3/WIVnkI5Hf+QqKsQSr4/dOOA5WSkiFqZM/hhxa3RoFgJzmbGgz3q2F0ARh2T5ypIb3BTgNVicTwWcvtr30vv6t6XV3XrNmz141rMNyW5UL0LaKZcLe5MhwnuzUPRp1f/n8aKPCFXg2UntZ2J58+rSLwIGf62sg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VGhlIFVBUEkgY29tbWVudCBhZHZpc2VzIGtlZXBpbmcgU0VNT1BNIGF0IG9yIGJlbG93IDEwMDAg
YmVjYXVzZSBhIGxhcmdlcgpvcGVyYXRpb24gYXJyYXkgbWF5IGZhaWwgZHVlIHRvIHBoeXNpY2Fs
IG1lbW9yeSBmcmFnbWVudGF0aW9uLgoKQ29tbWl0IGU0MjQzYjgwNjJjMSAoImlwYy9zZW06IHBs
YXkgbmljZXIgd2l0aCBsYXJnZSBuc29wcyBhbGxvY2F0aW9ucyIpCmNoYW5nZWQgdGhlIG9wZXJh
dGlvbiBhcnJheSB0byBrdm1hbGxvYygpIHNwZWNpZmljYWxseSB0byBzdXBwb3J0IGxhcmdlcgpj
b25maWd1cmVkIGxpbWl0cywgd2l0aCB2bWFsbG9jIGZhbGxiYWNrIHdoZW4gYSBwaHlzaWNhbGx5
IGNvbnRpZ3VvdXMKYWxsb2NhdGlvbiBpcyB1bmF2YWlsYWJsZS4KClJlcGxhY2UgdGhlIG9ic29s
ZXRlIHdhcm5pbmcgd2l0aCBhIGRlc2NyaXB0aW9uIG9mIHRoZSBjb21waWxlZC1pbgpkZWZhdWx0
IGFuZCB0aGUgcnVudGltZSBzeXNjdGwuCgpTaWduZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcgPHgt
cHJvZmVzc29yQG91dGxvb2suY29tPgpSZXZpZXdlZC1ieTogTWFuZnJlZCBTcHJhdWwgPG1hbmZy
ZWRAY29sb3JmdWxsaWZlLmNvbT4KLS0tCiBpbmNsdWRlL3VhcGkvbGludXgvc2VtLmggfCA3ICsr
Ky0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3NlbS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4
L3NlbS5oCmluZGV4IDc1YWEzYjI3M2NkOTkuLmQ5Zjk2MWExNTkyYzcgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvdWFwaS9saW51eC9zZW0uaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvc2VtLmgKQEAg
LTcxLDE2ICs3MSwxNSBAQCBzdHJ1Y3QgIHNlbWluZm8gewogICogVGhlIHZhbHVlcyBoYXMgYmVl
biBjaG9zZW4gdG8gYmUgbGFyZ2VyIHRoYW4gbmVjZXNzYXJ5IGZvciBhbnkKICAqIGtub3duIGNv
bmZpZ3VyYXRpb24uCiAgKgotICogU0VNT1BNIHNob3VsZCBub3QgYmUgaW5jcmVhc2VkIGJleW9u
ZCAxMDAwLCBvdGhlcndpc2UgdGhlcmUgaXMgdGhlCi0gKiByaXNrIHRoYXQgc2Vtb3AoKS9zZW10
aW1lZG9wKCkgZmFpbHMgZHVlIHRvIGtlcm5lbCBtZW1vcnkgZnJhZ21lbnRhdGlvbiB3aGVuCi0g
KiBhbGxvY2F0aW5nIHRoZSBzb3AgYXJyYXkuCisgKiBTRU1PUE0gaXMgdGhlIGRlZmF1bHQgbWF4
aW11bSBudW1iZXIgb2Ygb3BlcmF0aW9ucyBwZXIgc2Vtb3AoKSBjYWxsLiBUaGUKKyAqIHJ1bnRp
bWUgbGltaXQgY2FuIGJlIGNoYW5nZWQgdGhyb3VnaCAvcHJvYy9zeXMva2VybmVsL3NlbS4KICAq
LwogCiAKICNkZWZpbmUgU0VNTU5JICAzMjAwMCAgICAgICAgICAgLyogPD0gSVBDTU5JICBtYXgg
IyBvZiBzZW1hcGhvcmUgaWRlbnRpZmllcnMgKi8KICNkZWZpbmUgU0VNTVNMICAzMjAwMCAgICAg
ICAgICAgLyogPD0gSU5UX01BWCBtYXggbnVtIG9mIHNlbWFwaG9yZXMgcGVyIGlkICovCiAjZGVm
aW5lIFNFTU1OUyAgKFNFTU1OSSpTRU1NU0wpIC8qIDw9IElOVF9NQVggbWF4ICMgb2Ygc2VtYXBo
b3JlcyBpbiBzeXN0ZW0gKi8KLSNkZWZpbmUgU0VNT1BNICA1MDAJICAgICAgICAvKiA8PSAxIDAw
MCBtYXggbnVtIG9mIG9wcyBwZXIgc2Vtb3AgY2FsbCAqLworI2RlZmluZSBTRU1PUE0gIDUwMAkg
ICAgICAgIC8qIDw9IElOVF9NQVggbWF4IG51bSBvZiBvcHMgcGVyIHNlbW9wIGNhbGwgKi8KICNk
ZWZpbmUgU0VNVk1YICAzMjc2NyAgICAgICAgICAgLyogPD0gMzI3Njcgc2VtYXBob3JlIG1heGlt
dW0gdmFsdWUgKi8KICNkZWZpbmUgU0VNQUVNICBTRU1WTVggICAgICAgICAgLyogYWRqdXN0IG9u
IGV4aXQgbWF4IHZhbHVlICovCiAKLS0gCjIuNDMuMAoK

