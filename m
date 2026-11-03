Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E93606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621E96B05B6; Mon,  2 Nov 2026 21:45:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8656B05B7; Mon,  2 Nov 2026 21:45:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E75B6B05B8; Mon,  2 Nov 2026 21:45:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 299016B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:45:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A66C5120285
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:45:10 +0000 (UTC)
X-FDA: 85392265980.13.CF7ACB8
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020094.outbound.protection.outlook.com [52.101.196.94])
	by imf14.hostedemail.com (Postfix) with ESMTP id E4ED6100009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:45:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.196.94 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793673908;
	b=IrzK8WTKMi2XtI87+aDWG5a/j7qU4/C1P/qvxgHfut6B+j+QYywpqf+vicz/gffoyuxyyo
	KK7pLlsXSwn3tR63I95ABnFWJgh9AHrYgVrJYPiPHZKdtg4rUKPtEtl2mNVRvJQ28/0PqW
	eJ/GvyeKJ5lJNy3ECa8JYiWtzGDojko=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793673908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ftvaG1o2ZuK9RpRIZjOlT4Siw57MMPBlDTzMlX4Vqlw=;
	b=NwvKa8uBfCZz6MPTxh+wOe+IRrzHEA/CxWROGKZWGmnMbvfDoAbL7JxgfhvoW0P23CAbyS
	or1Uok1HgfJeJ6v9BMWFdcQKW60NePOs0GomRs6l/wiPOcaC7tI7E1336Q6sbGFC1ZHaOW
	9CQjyEflOjCu3bY8x2nRDILdWGUPndg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.196.94 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fYl6d00dTDj8YFzJLc0upKLO5BJSUfhB3dd7/ptvI72jjXVWk41K7/KLLjlZ5hC1Bl7MFmqAiY81QQ1ZaIGpJWwDV1eb0fJEMYs0pUbiTBxsqatOYdC0092hrWJF1dkd//sCLEVmEbRevqhtI0a2eSfTTOBAVegH+juSmVjFHnrWclfk1cdC0LC8nMEmzlZYjPpoX13NX2nDJPpkyXTaFbJ1HjVfaMMuWVJVma8mwQtnbl6xBa5zRfGEio0+sTRkiEUqih4fFlK2KC6p8g6dnl2MgZMH6phf1tmQJAzSaa/QLzt4HYQPHWFpiG0ybXZpdbHG0Ei6Pbg7Hr5/qwJEww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ftvaG1o2ZuK9RpRIZjOlT4Siw57MMPBlDTzMlX4Vqlw=;
 b=tOqQDMjEeT3DC3vR0dMdc3cGQma3ZRPWouMdtGXtx4Q4KTndaxWAmsjUUCxcmmTTPXtRQXhY5Re5nhU4G26VyzU1y+CNliUCtY9f+Gx7ZfhiyhrInowGvRbAeN9U5MJwWIa5abtiO1lzNw6PHGmFc+iw3GxYzovFNXp3yQ5Mj+Kj2+qwn+3QnNeT8XmIh5RUvZD/QMjLlFH6gWkuBr7TzxH757TmKss7//tH4LO+uEhYYOW+iRIWwnyEfWHzNESaRpc5FpWekmFM4AtKznxHSGsDvzaBbEEKT2Y/6Qqnqj2MnJW/QTxtY6Rh/EaeVI0tiF/9vqmqNN3RpoWeI08s4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LOEP123MB620368.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:501::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 02:45:04 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 02:45:04 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: pmladek@suse.com,
	john.ogness@linutronix.de,
	rostedt@goodmis.org,
	senozhatsky@chromium.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	anna-maria@linutronix.de,
	frederic@kernel.org,
	tglx@kernel.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [RFC PATCH v2 2/5] mm/show_mem: Avoid blocking on zone->lock during Oops or panic
Date: Mon,  2 Nov 2026 21:44:50 -0500
Message-ID: <20261103024453.922373-3-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103024453.922373-1-atomlin@atomlin.com>
References: <20261103024453.922373-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0431.namprd03.prod.outlook.com
 (2603:10b6:408:113::16) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LOEP123MB620368:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cca2195-e6c3-40e0-89b2-08df395476d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|10067099003|22082099003|261102123227099003|18002099003|921020|56012099006|5023799004|261021123027099003|261022075727099003|261021135927099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	f/aurlGl/qw7tE+xWQnBOn7WxYABpXS+wKYuZunS2LcjrAR/9FKvgK3gRZYmRMo/inkdKscM3qmrOowkQGl9Hu8M3sSowr4dfAssu/ZUMyPoN1lE2ZRicsakFkrXDVNgxNS+RSspBG2O4Bxblb9WnaQG8DxF1p7Kg/NXv40FmY6kivqLO8syiCw6DT0Iu41hHlvLCJnPfNeTE7roijRdM2t7qFm50PY2WBVanhobZMnK6vGY9UY24g55HtUoaxUlUWzHvSLE7v+ovQFhji5i2pd2KqvMIgRNDN2xl+MHbmxjnAxnKe1JhBrT5XJfxFc9YQClBtQp/i5pxPA2myZJJtQylXkCyUu0lTGFX596soV3mMq4yKHb7AHU/xMrcvckjgEpKii7W61tcI1QkSB/vXLD8sm86NKfGBf5ENPcO61hn7g8S66frP7JslngJGmsL09mKp6hhfnIR1ORumF/aqEz5FUTq5/4+V/6mHuuzB6DK1Dd3gYwakX2ThcOjoofDoCOaj2Hb/leO0ecvhaAKbRRB7OpdSm7HOP6t1jUx5WDtN8sxSN1xRUWgC7s08H6W8wNJbcHOuj0lxyKe7+4txv9I9b8T3uyUibFT+z/u1K3fopHSX82NI8HkT3NfNq57mRO2OYzsmYC+H6lpEmY7T+teDm0d9hO4edq4XKl6LG0anlpQycFP1/6eRNWeY+uRL6LeCw/kMg5bFYqLvLoLA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(10067099003)(22082099003)(261102123227099003)(18002099003)(921020)(56012099006)(5023799004)(261021123027099003)(261022075727099003)(261021135927099003)(261021121427099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uWvjaBIFx1c6QgMHhhb8vgBqlBEQQvlFE9i4CsRH8beDYraLCFfuJnI75jeu?=
 =?us-ascii?Q?iE/aeHb55dRZaogYzLVCVoTEUcpNvoFSxWj6yDDJCPU0YTJVtDh9KQkR2XwP?=
 =?us-ascii?Q?s9tHTBx99VWhj2023lV7dFcFSNwLWbUyPQbmXAmUWSw+IbY4BlN7eXmQ1IFM?=
 =?us-ascii?Q?hcmWqTdrL560kkZZ+4AF/5CaSGoWHVxBirlSFV4LyaTwxyWbEbEGw0TC4dnr?=
 =?us-ascii?Q?ML6eLoA/7P1Chb6lS76u4vazGpoXG8Q1e7mG67Nk35jI9TmFDakHJni+G6Zl?=
 =?us-ascii?Q?NPcqv6+7XjBm4zVtBEk+cE7rquHrqitOUBhirDup+TSfxDq6k0kvN2BOjeOx?=
 =?us-ascii?Q?svs+tlytSgrujw3WtrUQADQ6HNOCtbkaBM248HVWlKqyNJ32oHprAEUt/yFc?=
 =?us-ascii?Q?sjRDLYmFaALVqcvwvI2L3GsRa5OXQIegIMX7n3ft+bQi8bgRiHuBybLIyudy?=
 =?us-ascii?Q?jskItb+uxc3oH6dq3yQhzmN4tns1jjQBw4QgR2W4+aTp56DdP8RKKhUyD4rP?=
 =?us-ascii?Q?zNxLfXhl2FomTXwdqaFyGnblWKgPBngxGCabz4s3fsLtmndpGXrE3U/9WycW?=
 =?us-ascii?Q?aRd2Sb7iYNoh+yx4M4fnFGk06WUo3gywrcuV3Wpam8/+5QEmE+ZwB0FH+8qS?=
 =?us-ascii?Q?iGZNW4njH5d8WvzOQpIud9So/HlzYymTjXsmcqAr6lJ2OYZHGIJYsjj8F+vt?=
 =?us-ascii?Q?pFqJo+hh8mY0Ju5j2w+ER0Wrykw6qMDpJP/C/MfOYFcLf+/7Sxa1G6uhc6l+?=
 =?us-ascii?Q?qBNHBZ2yrS0tCHNsx3YkTTQTVtE9yUC/aaB5InKRKT69aL4DtPUm/yN5NAtO?=
 =?us-ascii?Q?pIsS5XnoeksPxkqZ52DoZwvGocLDHieUjHojONqjEWiDzYth1cNR92itb52F?=
 =?us-ascii?Q?me639G4PDdtV7479qtVgiMOvPrf/UQ2LHEDk91aHTcVvYla3Kb8XHYni7jsE?=
 =?us-ascii?Q?Nt9NnLwt8Y+mfJejOATl8WdiiAF2PhAXez0qyRJwgIOd2q2ZkNuOsv9debwJ?=
 =?us-ascii?Q?vzpf0xASbD2Q3kchyUkQvVDlYReB2v0eskgjbcUgPLYNg03yIQX/d+1F56AM?=
 =?us-ascii?Q?E5cVzYQKzFUUmDFjuL9Ndj2fOwBmgJOa+amAPiwwk4muSnzY7x/7EDxK+RJ9?=
 =?us-ascii?Q?8cH4rfijNfNT9zmQYdcnficfECOB3/24/Ny+CGR7Xy8ib7YPzUwnysXzRga4?=
 =?us-ascii?Q?hBIqNBMsm8A4nR40qja0xgFjse/s7Pz2TOBcgLGzJk5FaHGrD/+755QVtVo6?=
 =?us-ascii?Q?ktYshGcJSG2VCxbh24C/ooUQquYaYXzTxuWEovs2MyEgpExVln9Uu9zaTnjt?=
 =?us-ascii?Q?Zt2a2dxM3u67o4VaZlZi2HZRkhV+8cihN6HgLf0lHEprX68YL8avS0DRyoX9?=
 =?us-ascii?Q?ofr1udujjddsYBv2vR1vdFKZ7PX+vwxy0/8gjJbYbjBu2wvEz9sUBwFfj6on?=
 =?us-ascii?Q?pTORwXoEHAUMC89yrQYGtu5iguwHuAuUTEUjimS6M4ttSRBJrsqcQRBk3veB?=
 =?us-ascii?Q?SvJNam1nlsfH/1/C7JIqIdtJBW5PiNbNHctZ3/1I9RxMpk/Unh7s+NsZbtUT?=
 =?us-ascii?Q?i/PVKNZfFMHyj23m6Ae+SaX5HJRZB+YNghMgw5HhCWlQGZQBhtT8eNcqc6mo?=
 =?us-ascii?Q?SDikW4opLpC88s8OxcAKa8MtJRX+YEqyHsAgI+WpO+oR6fMslYJ99NelDtDt?=
 =?us-ascii?Q?L/pQAwG8BQfdlLc3pu1/xwkcnCBw7QRQq21hth6/LVzaaBfdn0pxiWQiCy9e?=
 =?us-ascii?Q?5th0dFpYVA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cca2195-e6c3-40e0-89b2-08df395476d1
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 02:45:04.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJLbb7mT7AKig0wuLEe2hPsl8cIphaNdtf617Gq1aiD1mkZMPDRndOJSdxZxGN2V8auuSBui1BeA2MZWV9R9ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOEP123MB620368
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: 3so5gczopceptzhfqasuuofwbfbgzped
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E4ED6100009
X-HE-Tag: 1793673907-811266
X-HE-Meta: U2FsdGVkX1+UmFTKpxjNiE4qx83AsMDkobI9i3zhTQimlh5FZCRHIofIhmTagyEeqK/AR5dASvzSTJZVPqIpgooac1AvBH0aTZ2bWVrIvl690DZ1/roHr6zbdYXMo17/hjEkg47Zb2ArjzF00MqCunf0d9LFpqKrkg2+W2cNYaXDivqm5tmwBcf2peM/BAn8HTKJkbzyqdQRDR659h8mgq5ybGFyj3PG60HenfYkQwWTcYpdH6/Fr9Cp0ezVKOkoZtZ/ugyeoQVV4xv1PZjSyCTGTvkiI7JK8MrZFTyiRK/ybJ1ZLyGo19gIV82CC0R7gkKv7cn3RJ6S/NQRfdkanoQzX4C+rTDTtNaA0FKpbtlzxmCpfdWrM5dE8ZediQF6kH29wsUANrziuo5cmHB4DgrJoDWapTIOgaPtkwtAH/5Fp/X4zVeOsIcvtoDudIl/Ver8GgvTqZkcitvEwqvSJY8dEfrI+xDOQGqYsxUJU79W9giaCBOJWWb9psHKGnTYgSFhQAu65QPaS8jEY9RPXBMSWk350NybjGg+9TguMuaXBI3ex7ClEUEkHs/X9ltRAaG9G6wg/bOism56H71sMUMZAjCxrvh01Jcs23r5qHDP8usKgv/dSqyzY9jtZIJoRxU93yhEZuc568ac3KZ+N4Q6AnHLAZ44fgjFnojHV16Tv35AzZVKz7fe85bqAsN6auQqsnucIKCmHtz5rfSrJCGP1VRXKIcWRGAtTUetFmdpBOSxc4EXpWJSbOUwbgXkdqTKjBZi9B0bReV1kLFk//FQEJ6oMbIDhcAyZO/iJ1H6Wq0tK+gs+yuZNUA1EbGeXWtrPyCYYpI6wPD3oK6pAe4RPyYF0gc5B2asInJPO3TjwoY7fiJFGaNk8Xjvlv/HC8Lxc38PaGqolEeSZmTBNLsmrzBKohM8gB3uXe4devNeTTKm7CrDmrNdO4iTAd89i8+JsM2g61zqp8R6Jtx
 v5+DOFwR
 fiTtlFBEItZmH0GrjHS58Y2+EIB8+5GoBWY2bYJbMyvnGyX4/IzFht09HEvcwmkwBwPJch1j6OsfRFFvmMo1FESXbFND33JSjjWjk5VOZ7gjNC8qu09IDkH2xMCCtFCzEcPOpQIu1Z0Q96hEvPinT0HjsHdoPixnSWvnOczjkc8DfKdCi1VQ0oNmRL1y1E3+f30Zx4bYB/a7aEqqH8+zlFmr1IXQK+WPBQR/RPTOJbqnnyVPntCaWNSgsspLmpKwb6DfKtVZAGaoJomeHOpSxZWuGNduC7CjJTjK9REZqCdCtjuU0YufiJlUxzGtrgP3qF+obHzKuY1kaR2EJHzf3jB8NgnRqIvcKeh3S4PjHsfTnPR0w5Ctl5qehibs+tsALHncw6uvdTWyR8TXhq/YGRrCekQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When show_free_areas() iterates over populated memory zones, it
unconditionally acquires zone->lock via spin_lock_irqsave(). If
show_mem() is invoked from an Oops or panic context while the crashing
CPU or a wedged remote CPU already holds zone->lock, or from an NMI or
hardirq context under CONFIG_PREEMPT_RT where spinlock_t is a sleeping
rt_mutex, acquiring zone->lock can self-deadlock or fault before
post-mortem recovery (such as kdump) can proceed.

Check can_spin_trylock() and use spin_trylock_irqsave() when
!can_spin_trylock(), in_nmi(), oops_in_progress, or panic_in_progress()
is active, and emit the zone header after releasing zone->lock,
logging a contention notice and skipping the locked zone rather than
spinning indefinitely.

Fixes: d999bd9392de ("panic: add options to print system info when panic happens")
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 mm/show_mem.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index b938cbcd774a..77098077523a 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -367,10 +367,17 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 			continue;
 		if (show_mem_node_skip(filter, zone_to_nid(zone), nodemask))
 			continue;
-		show_node(zone);
-		printk(KERN_CONT "%s: ", zone->name);
 
-		spin_lock_irqsave(&zone->lock, flags);
+		if (!can_spin_trylock() || in_nmi() ||
+		    oops_in_progress || panic_in_progress()) {
+			if (!can_spin_trylock() ||
+			    !spin_trylock_irqsave(&zone->lock, flags)) {
+				pr_warn("zone %s lock contended\n", zone->name);
+				continue;
+			}
+		} else {
+			spin_lock_irqsave(&zone->lock, flags);
+		}
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &zone->free_area[order];
 			int type;
@@ -385,6 +392,8 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		show_node(zone);
+		printk(KERN_CONT "%s: ", zone->name);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			printk(KERN_CONT "%lu*%lukB ",
 			       nr[order], K(1UL) << order);
-- 
2.55.0


