Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B03A606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 20:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=KY8BO/JJ
Received: by kanga.kvack.org (Postfix)
	id 2C5766B05B1; Wed, 18 Nov 2026 15:39:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2750D6B05B2; Wed, 18 Nov 2026 15:39:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1640D6B05B5; Wed, 18 Nov 2026 15:39:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D98EA6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:39:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6AE9C0379
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:39:28 +0000 (UTC)
X-FDA: 85449405216.02.D414EE2
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022094.outbound.protection.outlook.com [40.107.193.94])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A421C0006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:39:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b="KY8BO/JJ";
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.94 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795034366;
	b=DJ1cTD2CpJlDgCrcGSkgN5Zwl/ZQ8+bjqOqvza2lA/KF9KZ4S59RB4oitS/C/iFeXzXmcb
	/0oUwApPR29/Vmkm5gAsb5fKNk+rgvpWjnGcz2bMogInwgRftn/7D1DbjI6FBQkeEXS16X
	BkQGXMIU4apE+66gSwueFL9sFVwpX38=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b="KY8BO/JJ";
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.94 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795034366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83j/H/J+rxmrbgD1SJLO3bS/KgKSsHR/yi8Cj5l/W08=;
	b=Q9I1FRUFL3Mw3bYJ6GR+AXoiWC4+JyAGKdIk/zcq/YJmbH/fGXGyoV1LfGQr5Fl0hVPsq+
	EAq50QZi8s+57FxSj+wHs73LRD271Gcmc1Uytoa/UEfez5mCMHNknSIUepaIvgAb8lXAnO
	aPJGYsVUzShs7XBUMzkhjWk2xT/jwvk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YTpliteXFwBhRmYajvNqUVkyf2tJBH1nDeGdR91fjTt/5FwK+Femz2bVSiYsoVQPmG2nnMoD8CeVtYGck1nEHZqu4s2aEDglk9aM/0rNk93cBR1nniikpff9c9ck9qGGyTKaaBQ9uYPD7hofLUIqu4j6JGSgMosAwOnRYljUtZM4pye0Xe0a//p+txPvoF779U3Xk3XKOuNGcUWGGCE4BBIvQSqEz6niYZU4/wls3I5/9D0REQQZs6awBVYsyncT1oaLGr34lh3GqTJeFJ0TZ61zJX1Ssm5Q+B+nlIYmO6qXY1HlvHNlepunkAbQ9PnZ3z47A6g6gye32KemJ+oioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83j/H/J+rxmrbgD1SJLO3bS/KgKSsHR/yi8Cj5l/W08=;
 b=GEdBNs8hTP1OOJNHrj77HUyW37nGwzeQZsi2ToJxINoQVPjtE0BwWpOguooDiaFMS9pWIJz+AYBKXCoX/ic8+nGk+DlOze4Gf8E3JdAu3X6qP4375dnRN0Qe/kR8KHJxOhrRVpnkH4UVjU1BZzPRbSjbL6vG/ksxh2rgK2lDmd2wfBsJw790rtfxjR3+fpePiFNBC6SibGAWPv+x2J5OjDUU3KMmuGfrAtqWm8JJQPKZN9TaDjUmM1Kcy+r1FrO4uxv4rrTtmNA6eyVOaXMvI6aEr+sKjLTm7Y3smB9zoxSr1t4va4bV89t9+9odK6Nw0aYJgb2yPnqoUlQ4GZPeDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83j/H/J+rxmrbgD1SJLO3bS/KgKSsHR/yi8Cj5l/W08=;
 b=KY8BO/JJCV37nnf7Wt6BEGF41xiClwE9JdWC1yLrDIf7dya5jzUxO38NacHbKvjJ8qQA76vOfJYZ5qemKzcqsnSSps+dxCCCCnrFQWWb+HiD2OlnhO1w3vt1brxkbcs4AxCve83F8SQsjnjhlJA0ojccZc+wpGoPuGzlkHgSYGxsklHYEFjC9Enct52dhLHXUSelmd35ZWdtCbdCjhaPWXvMfHij4zbWqjbw99PSTz60O4S907bvFE0aIEElL49+mrMitsVGBHGMXrzdv8eB+fWXi2NqpPAHPNdoniDAoz4vpdPiMjSZ37+AjVhlHEF/y2L/5m6VLFFp7DhZloWlqg==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQBPR0101MB8941.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:59::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 20:39:17 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 20:39:17 +0000
Message-ID: <63327912-e751-4f72-b894-f9b4079844b4@efficios.com>
Date: Wed, 18 Nov 2026 15:39:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/17] sched/mmcid: Give no concurrency ID to user workers
To: sashiko-reviews@lists.linux.dev, tglx@kernel.org, peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 paulmck@kernel.org, boqun@kernel.org, shuah@kernel.org, kees@kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, oleg@redhat.com,
 bestswngs@gmail.com, xmei5@asu.edu, xujiakai24@mails.ucas.ac.cn,
 linux-mm@kvack.org
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
 <11039c504295ef6ee0eef55981993d8f5d1f40ce.1794932121.git.mathieu.desnoyers@efficios.com>
 <sashiko-outbox-221445@kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <sashiko-outbox-221445@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQ1P288CA0001.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::8) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQBPR0101MB8941:EE_
X-MS-Office365-Filtering-Correlation-Id: d89124b0-fff6-435f-2037-08df45b403ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|4143699003|56012099006|261026121527099003|261022113327099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JXGBARTwtFJsb+JGOXTIdtaKV6Ra3TjIRLzgiZ0VnktrXaG5NuQwKDBsSgJpVeJffsQv8olWklnI+xHi+5seiHGZDk2rcK2xA+AOSlHrcZ6mK6bun6pT2Twj3zjhs5edyYYVFImTrymzT3XTryrCbJ9g3JAtZwQw9RjqF2HRbLpXsOr1KFd+toiGac5bOo2S3byekAON0qnfCRB5KvQhl44Gh3GgyoO1D95ePqfiapiVt2lftrmTogZxkai0DQ+QSR2wPq+91YYspDvcyNt7V4l4/KKro+vDxo0+HL4lPwMWFx3i8FcfAyb/6zewvZWwRzRfQGYh1Sk/6yctMTcKBHusUCYGhMOHv4sc+AQnLhrxIraZq8QhnhJ2coMZfguonR0+XGtvchRP0FX3D/iVvRvzZxPpv7ncO4ldU2Yg5+1x6eveBMt1bCgahBirVCc1AO/zFtjCZNyUDAMONu0Sz7YNM7t5cUW8Wh5FXO7yz360JfhlS8SeAtDGsR4zAX66t1BNAjLKc3wi8ykxG5/iGRg7KUKj+t1MXobt+uH4EExr1xRp3qOcXAZnzUrnCTuBTJ/yuJnct/rVdY8itv3t8dU8lgK3utMh59Oc/Be3RSg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(4143699003)(56012099006)(261026121527099003)(261022113327099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ck5HQmcyVzhKaEhTSS8zYlZRQVRoQnQyLzJTdTk4eDVreGpSODREWlAvcEJP?=
 =?utf-8?B?b2kxbkZBc2kxd3dxZ1RiVEZtMFRuU1hQSnBkOVdlRjJ2aWdGMnpybzl6Q2E5?=
 =?utf-8?B?emtOSUZDTlFndmMyNGVOUnJFbEJJR3U1TytaSVhVeFdWTFFqTndFdTR5YXlG?=
 =?utf-8?B?dXVPNlFFSEQwbHZSUlVRYW5CS0Z0NG1aV1FBOXJhazJtTDJ2R2I5MW9hSU51?=
 =?utf-8?B?S0dQekZnVDZNSzlCZy9mK1JCRW9jM0FPd3gwWUFIeU9EdnJwR0tqWDZRc2Rq?=
 =?utf-8?B?MFhDRVVZNnZ4aVVCQ0JKNEkvVnJyRklxRjdpZVJsUmU4YmtaSkVsWGs4c2hI?=
 =?utf-8?B?K3BoMDBUWGJGSG1Ycm11RVFDWEpmL2ZobkhNU21aOXJqN2dkZi8vWEZPRDFi?=
 =?utf-8?B?SFFGeCtiVkppd3U2Mi9kcjVqWjh5OE1iOXpXL0lRS1pOTDEwQTBXYXNvbm1C?=
 =?utf-8?B?bldpaSs5WkRLZmdrTGVqSUVnSEo3QWV4cnVCSERRM3dEcU5KRmZzbmZPdE9y?=
 =?utf-8?B?QUhiQnhvWjRQeDN6Y2ErdHR5bEF4MWY1NTVpS0xUd2dRYllMNGk3VW9FV0lG?=
 =?utf-8?B?Y1k2dzZCY3EzN2xKL2JnakhvS3FUcFphQUMvK092ajJPQ0dHVDlvbitRQllZ?=
 =?utf-8?B?WThQU2ZJUXg1bWxCTTZpRGQzdnpoQ3BzS2ZZTGYybWFieHU1dlc3YlJiWGdj?=
 =?utf-8?B?b0JBTFIySURvVmFiYUVsc0M2bmlCMHNQdmZQd0sxU0hicnV2ODdUSEsydnJv?=
 =?utf-8?B?emFERGdIUzl5MFcrdlZWLzhNS0ZSQlk0ck1nVVFrMDNmbFg3d3BjSldWOTNk?=
 =?utf-8?B?TVBWNG12Z3JwVEY0dlpmWHBsYTNBQTBFUTY5amw5NS9iWW5hMXFCenExVGNs?=
 =?utf-8?B?MzY0cUhhKy92cG9zU3ZCNTA3d3llclhFK1pvMWNsbHB2R1p1cko1NVRSY2xO?=
 =?utf-8?B?VzFDZWVIbGpBL1FNckI2WE96dFJDZ0o2S0dxT2pLMnFaMzdmcUFxVlEvRGRK?=
 =?utf-8?B?QTJsVDJVaXFKc3BCcS9McGFvblRmR0pFczNLQTlXL090NHpzK0I3Nk1JN2pp?=
 =?utf-8?B?R05zWC9rNW1wTjBTcS9EQ05qM095TmRpN2dNckhGNDl5VERSekpkOHNHaTlM?=
 =?utf-8?B?eFJlbDhkWVgyS01Sc2hSOFhYNUNSSkp1eWN6dDZ3WHlwdXJhVVY3TnBzWjZT?=
 =?utf-8?B?bXBaUWl4NEg5Z2Mxd3p5eUtnOTZMOGVMZXBGeHQ0R0pka0g2amhqb1RocEov?=
 =?utf-8?B?TXo3SXNpNUJJRU5uL3NxS2FKN3A2cld6cXp0d0hwdG9UQ1I2Szh4VGJkNXhh?=
 =?utf-8?B?ek55MDM2cVB5ODc3TE4vZEx2aVZuZE9XamdaVkxUNUdtR1ViRFVrdXN5TFdV?=
 =?utf-8?B?NFpaZXpDQ1E4azdpR3I5MkluQTN4azcwSWlRazdJRW5ic0dzZjZySHpiYkxN?=
 =?utf-8?B?cFBCTTdLeFdmT3oxcFR1SThBQ2Q4MUJ4NmdWK0pnVGZzdVI5S2lIWTRsbVp5?=
 =?utf-8?B?OXI1NXRCSVlOU09EMjZZRG1KMUNmbGxPekFHT2Zmb1A4SXFaVi9GVDJpVzdv?=
 =?utf-8?B?N2FYcWs2SWtvOTNzVkU4UmdFQWNhdXRNNW1JMGlka2JJU2pQOTUvZS9ISGtW?=
 =?utf-8?B?RkpyM1ozQ05yeDQ5Q2dJek1KVDlCS3MyVVFqclZPRDBXdUdZMnpvZFE5QTFw?=
 =?utf-8?B?SkNVY083UEJxV3pkN1laL1hNMUs0TC96bTRIZTR4NGJ2bVROdjJXdlUza2tN?=
 =?utf-8?B?UFQvTncxT01FajVuSFEwTlJXZTZWRDNTNUwxRmd0dnFMMDE1M00rMk4zWkMy?=
 =?utf-8?B?ZGdWYm1OVTg2bmR5OHRpV3NDaUpGWDdHMXpEZ2k1ckp6UXhXa1h1ZTdSZnc0?=
 =?utf-8?B?K043OGpDY2lmNXN0ZEV5MlNDMG9FKzNNN2JEL3dIaTFZejBKZmlBczBtMC9C?=
 =?utf-8?B?NldETnZ5K01MSW82UklITUVOdmt2VXl1V3VRcWMvYTYzbEFXZmk3WUxFZ2hF?=
 =?utf-8?B?MHdqck9LREwwYkxuWXhseGlaeGlxcUJTcGx5Mng3czIycHJoYW5hNElXT0pE?=
 =?utf-8?B?ZlAzb1l3UXhvTUpZdFc1YnhqNml5b3BxV01CckxHUmhEc0s5Wk95d1hENlNi?=
 =?utf-8?B?QUdISWVYai9jclFMUWc4cnRoZmR0RE1sWVpFZ2tQZFVjSTYxRHBZUERSYi9l?=
 =?utf-8?B?Q01JU21UZ2VUL3ZPcy95S0gzeXZnQ1ZBd2x6T3I5cEt5WWhIUm5WdFM2UnY2?=
 =?utf-8?B?L204dHU3eTJNdndlSjhRTFJsUmp4VkFhRldNU1ZUMjVwaVVRVzkzZnhtSFU0?=
 =?utf-8?B?aTFRUWFxRXlJYS9HWWJORFk5akZiSkcxVFUrMzZUSmpUVHFSVEI0ZjAyanFa?=
 =?utf-8?Q?3R6Q4VgnSAKasIHEbpC3r64QVaNox7W9/dLaQ?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89124b0-fff6-435f-2037-08df45b403ef
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 20:39:17.3250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GiXFxRZk73nYVJNFrHYFsi/x9sVImW6l2KjLhCvJDbNPA8Yp/X/CEdwHv5SaKEGFFrZ4XGqKd4/TUSH9g+w6IomIDRalLzcCawVNdRoJ1BQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB8941
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A421C0006
X-Stat-Signature: 6jcq3hxq9mzsytoyyqpjuegei753fjir
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795034365-614099
X-HE-Meta: U2FsdGVkX19Wq93lZEdP/BpkDgBzasBoHxegg7qUKdFHL1LQkjOQbQuqz1T1YkVg4McG9kFwt5efE8zMLGKsTwVJKpAMXGu1OHvAWI8cUD7M3RgpV2efoCv1pfD81fQrObSMuMfbdt+V7LVfl8Jb+86XA8pjHRvKFTTiimur1KrH/srMW2T8Vg345031BfArTkEmGEgg0ef0PhNBlfE/5LWlcpVuFsOSewsbCofzwo1DjUcvhCiWiRm4IMauUPMvObssaM6A5qFcqW0+6RrrO/TWKCi9FO+GG/AJZjuV4sBupj02psW2tZagn7fAtskvAoZXfcEhKrZgwUWbRnhCVvJ8UAuIQZznB3T+PYLCjbHwtCu+4N/MtN3pLoWB/BvlOq2ZVDg+sEaLPnTMhX1ii3a7XeE/5jP2SQMn8g1S178qtMaqewH9kEHhnaCDRDB5W1nWvdvzjNUVlO1M95i9wiU5KSWl+ZhNRNIFlnbtOl9kkd5R4pV0sVvZMRVQO52+GENGpCxj+5HTfUZnZmfIp5qB8Wj4AniIENsP0UpC6/8c6h7wFGh+E/PcA7DHTtz/qhrv3O91qt1LWanTI8iZeOWg43LhR2+hPWVQSy2oYLACOyOSDidx4L12nWuQ9tltjurQRvhH7I1D0ckfWEegWdMkV1o3QUShgd/WE1aIywuc6Vk87W9BH151mowlnRpOs1VwVHqS12TTauvfzA74YJgaPGIg1PnHn8K7riY0cx4dr/QCzUSU8teAnr+7hMM+HSL5MOITee4DvEINikX/+y2qcxYlUUz3ywwV95MnjJVLroP8TiSagiUQ8L2HQgGPucXwngXZttc6ywnVPZthXd2zHJnoUgxfWnbifXhYMIifoqr08tIylgStqD4T5WoTtpwZDGaETOvc89dPfGFBp3D3F0AFOszOufCMbGgasVmgp2S1AnafVmfKsRVprzZljwT9OmCTKZeOrbKuV4f
 cM7Qo26M
 nC9I+rrPVsjjFrVnBqUgk9egpcamlluHrg/KUFyS48+HyvBg86mghiHbwygSsHqGccawc/GEF4trZYmOyZJziDDsxfV9Dfr5hIj5ywZ3zdzp5GRZhPOfAaDPeNQMQ5hlHJMuEsc/kwVzHfP57XWzSJnLA9XNtHWjSgrWqwcnMg3lIEDMYVHD4RWhiKKJ8f8OxUQvjOaTo1H1dBxckTUlgApW9+ea2TEbo7eYVkn6/E/Rx9NLw4NWZajfF/j7vTOtgiKIyF4W1ZiW3pnKEhMvQE3LIQa0mHvXxo/AAiD9KnlS4OiKkG3MbeRbcpUbEnFJrvihyem6XPXfR+96KzfEiAKdi7gjV5uIqs34/etzxG5ATrP36ZUKx2pz9svlP/R8u+GxhMyMmposLCCVuCV7JR+mC1V+19c3rcAp9+nPlNyPzJ8EuWJQ/yTCBupCEN4Fv3a5mXbIqCQ69tnw7KL5v24zCY0HNv8F+fIN1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Should set_cpus_allowed_common() skip mm_update_cpus_allowed() when
> p->flags & PF_USER_WORKER (or when !p->mm_cid.active)?

Yes. The next version skips it for a PF_USER_WORKER task. Testing
!p->mm_cid.active would also skip a normal task that has not joined the
mm yet.

The widening needs a process that a cpuset limits. Every new task
copies user_cpus_ptr from its parent, and that mask clips the
cpu_online_mask of the SQPOLL thread. So the widening does not happen
in a process limited by sched_setaffinity(). It does not happen either
when the thread that creates the ring called sched_setaffinity().

A new case of mm_cid_bound_test reproduces it. A process forked in a
cpuset of two CPUs creates a ring with an SQPOLL thread, then starts
three threads. In 8-CPU VMs, without the fix, they read an mm_cid of 2
in 4 runs of 4. With it, they read at most 1.

The widening is older than this patch. Before it, the worker took a
CID, so counting its CPUs was consistent.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

