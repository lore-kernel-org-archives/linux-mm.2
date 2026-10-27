Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827D760A2618
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=est.tech header.i=@est.tech header.a=rsa-sha256 header.s=selector1 header.b=u2Mzdg4n
Received: by kanga.kvack.org (Postfix)
	id 8E57B6B0839; Tue, 27 Oct 2026 12:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC416B083B; Tue, 27 Oct 2026 12:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7847D6B083C; Tue, 27 Oct 2026 12:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BAE06B0839
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:35:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D678A1203AD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:35:00 +0000 (UTC)
X-FDA: 85368955560.25.13762D4
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011028.outbound.protection.outlook.com [52.101.70.28])
	by imf09.hostedemail.com (Postfix) with ESMTP id ABDDB140005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:34:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=u2Mzdg4n;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.70.28 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8O+xpG/jv5MXEVUhyLy5QZKQizt5PhOCbu1XIwG02Jw=;
	b=V55+m6Sgar3+wbv7HHVkOaPS119CWybeqS4uSb5/6vVbDxTuyFsXXsBDzqgcdOpFtZKC8z
	mUGjLx3KnSCWra1gFpT4z76dYW7XoMy2O1LCVhVDkXZ/8HLFoZxkSJetpp+4xl2Lc/eJJf
	59dKw+mvenQyt0zbwph1I/3xT7TvHTQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=u2Mzdg4n;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.70.28 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793118898;
	b=DroxXwcs2y3POOmfZL+3y93vmbWiG30w2SxtWaRtphRtdmjhukKQpWy2DuitO6ycnb/+aI
	TaVPkHqr5lcBRMNeAGR88hJCThS2iOZ5ANRfEAHR4ugZvHAFt7Ozdy6EPfpkOf99PKBKLG
	S7Q9VfwejIsJdJIi+xiEJHAEV8yqZg8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQpny+F7gFrGawF6kt5RT2LCFBDs3wzPgRHY4D9HzkBt3++1nD6xkEeUkvV8/bCqU9suieuwmkb4hGICBvt8Jy3r7Q5tL3PLhbOghTcbMNm7OK+MLy75rVUGmsS5PlAiDbFdhYK/2Lm4962HvPsnc2vq/ykNRcjdPfxMvr2ZEiW8WElyqobT6fCgthYLiDMyVvTPUuw2d4JAna5qjgXZhI++OqNkVnBZp6IswiKDgkkEkn8GrO+ur4L12zM7GvgJhQu3Xpxi1NhJoY5vhWJSUPzk784KlfB/gBe6eX2tpFsMLxm1qoHPKNiWXmib/oVsapsOXb3kDfu3QmExhcUAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8O+xpG/jv5MXEVUhyLy5QZKQizt5PhOCbu1XIwG02Jw=;
 b=JlyM/YDHjfLSiXOWcZdl5GT8UEnT0QTOafXvvcySQK16Zyi3AbXb0y6jOPWzZHAf0KkCzwSCt3CGpWAEyZc9N7vzsPEKjZIK3DGL/eGydj0Hzq/VC4p3zhv9ElNDbAdqPHEEDXZmHGpkoogv+DAOZufqoAyiOefwdkTv11DIsRfcNg3dHgHFHHKXdceo6b71WKXRbFTyNRkyMavk/W+5XWAZqOAeCQjWsxhpDhwnewGYKMiCoX6vYUg1weylh+nZ+JBgtff/+CzNUvTHAQrFIjBGbOo6/bABz4IWR1G7MhR0w/jxmy1yD6KXuzRJbPFu2fhuRfo3pkFU6n8MaaPSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8O+xpG/jv5MXEVUhyLy5QZKQizt5PhOCbu1XIwG02Jw=;
 b=u2Mzdg4nUGXdoMaTtriSW+xR/gc13964qcFBS/OUTGD+bQ55cfHehybGr4BcJMwyqUGgRrN+5+Trpr5H9ALM/Z+KpgFRFyJGaRW0+xvU0DiGyTU6ElwZ3LWTGg2mDRvXb0AVlpURaksDhgLHmlE2laI42DEFg0V+W9wFluucHDasIp8e8DfZFotsEmk1Wqt2TDHjV1mxiBEaOwGwijJ+zP52iKqbo2UkPsiR2rv3CmBkKf7ybEMvmPujoK6PiUAaypfXb9ASpNF3cQ3/0pUoxSRsgoRQ51e1bLtwVIVWXKsaVj7AKWQioGMtHgw0Y4UIpPyKsdCOcfgF87KqfutecA==
Received: from FRWP189MB3398.EURP189.PROD.OUTLOOK.COM (2603:10a6:d10:1a3::22)
 by VE1P189MB1135.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:148::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 16:34:52 +0000
Received: from FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 ([fe80::4658:dbd6:d572:896a]) by FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 ([fe80::4658:dbd6:d572:896a%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 16:34:52 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Subject: [PATCH RFC 0/2] kcov: collect early boot coverage of init_task
Date: Tue, 27 Oct 2026 17:34:07 +0100
Message-Id: <20261027-early-kcov-v1-0-6f2f053255ad@est.tech>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAH/S4GoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyNz3dTEopxK3ezk/DJdgzTTNGNzgySTpNQUJaCGgqLUtMwKsGHRSkF
 uzkqxEMHi0qSs1OQSkDFKtbUAgQTCdnMAAAA=
X-Change-ID: 20261027-early-kcov-0f5f370b4bed
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, James Morris <jmorris@namei.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Waiman Long <longman@redhat.com>, Luis Chamberlain <mcgrof@kernel.org>, 
 Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
 Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, workflows@vger.kernel.org, 
 linux-modules@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kbuild@vger.kernel.org, Yunseong Kim <yunseong.kim@est.tech>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793118887; l=19672;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=E18MFn5ASooP1dYLkTmFIJov+sC2Upov8j2lwnUoq4Q=;
 b=pgPhIuOz8y7csCQ0Y6vr4MqxQv+vf5++/M6+fddx+RtxnHT9yAeF5Ri8kJG2+pomJOrMUcAxx
 D8ImHojshSdDWgMQvbS8bCakOC2xmFYnc1W1aJ78Ygrlk/C3uFvCub9
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: LO4P123CA0636.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::14) To FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:d10:1a3::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FRWP189MB3398:EE_|VE1P189MB1135:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a1a69f2-3e67-4601-2376-08df344839d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|921020|261026121527099003|5023799004|56012099006|11063799006|261009223027099003|261021123027099003|261022075727099003|261022115727099003|261022105027099003|261022113327099003|261021135927099003|261021121427099003|18002099003|6133799003|10067099003|261026140227099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	glldPtzUPPAm20Of7nMfbiecfas/Jx6uDk2sMQLILg0wPEhIF5bY9Xpyo4gGGWwX5uIoomCeG9m0oYnMzypQBLjV4RXBfcfyL58Zi/ccmS4kTWFgfcrRlkzZPlwulK/MX+Yq7/Fw1d769aATIRIcKTU/Iqf2gtWa7Q7L6uZjjJyrJQafDMI+ZITjY/aduowjBKsVc/aCiVF2iHLoGH6aqF3+0GmP5EMxcbn3FwwkGfCQp+dbnfSEbj/6T9/F64C8yO84FdoUhw0bvaZsVZPyGhuj3rHmtO7fT5dIR6brj0Kz3L+aGZP01kOJec1sRhsecaq7cvqi4gz7OUx8KrpoJmiRCDmgJJ89mhTUXDM5JxFGCrngsGuI/H5Vd115R8PN10rAb8rs38wi6PuMLNwxxS7KWBPU6jRddxiffdofsGaLOir7jLcOFFrfcoFVMQZsbpU62QmRXYD4bD3DQNCD9lu85F4rBEf49p7F6J6jYbWW33lXUv/d1yzAs9OMJoAQ+7RHwBmKTDFjWURWkWw7s9kPZSxImeFK2M/4RwQLuoZkpxIfNNj8Ve5y6iKDPwo3KgxYMu0qbH9jaDqi8AnGEkiqmX1BOVIfrE6tAzEUKIO6e89EOgRF3da8KFDiLp0n1YDLZItnoiiH36Oq2+hkr5yZAiSsprNchoJJw20TXG7Y9F/SOZKNKbzVs6rS5BwVuTfBGq63jocsUSmpJAGb3Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRWP189MB3398.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(921020)(261026121527099003)(5023799004)(56012099006)(11063799006)(261009223027099003)(261021123027099003)(261022075727099003)(261022115727099003)(261022105027099003)(261022113327099003)(261021135927099003)(261021121427099003)(18002099003)(6133799003)(10067099003)(261026140227099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXlJcFlDbUlDQWlFRTNIVVN6Z0VjaG50UldGN3Bua3ZaVTRpWCszYTlNYnFa?=
 =?utf-8?B?Wk0yVHZjTWEzZkVoaXhIeVE3YzFaZnRtZjZSOG5hRGw1R09JcDBKQ2Jibjh6?=
 =?utf-8?B?S013dWJERFhSZm01ZkJKRU5XOFBPNFFWem1zR2NiRkRhMnRjS2lNbnVhQzBk?=
 =?utf-8?B?Wjl1Q1M5MVp4RE9ZTUo1cnBTZ0YzUVYrbGFyMXMyUGhYTWRBMm9SSmdWaVlB?=
 =?utf-8?B?c2k1ZXhYYWJIMmRQc250QndCU1NuVXYyREFZQ0tvSHljNEhvVkMvWUVEWW5G?=
 =?utf-8?B?NHdnWklYOEpldy9acmxzN3pzWWdpVTNtTVp4V1VSdTl2ZDcxVDRYZWFyOGJw?=
 =?utf-8?B?OW1YaDIwNFc1M0c2b2dlL01IYmpRUklXY0ZMY21yQmMxdFNPK2trQ01zS2Z1?=
 =?utf-8?B?b1pJWFlxUXk5ZmphV0JXOW5uRGh4bmNVZWdCRThkQncwdVJiOHpOKzNiZkI4?=
 =?utf-8?B?T1JHU3IyYkk4MmozejR5MHE4b2M5bmltTE1PVzVmMFl5NkIrVWZHOEJwbHND?=
 =?utf-8?B?TTFNTFR0bHFPb2YzYVpqckhFeVdBQ1hybDJKdTk1cTVIMW80OEtnL2NLeE10?=
 =?utf-8?B?TW4vUXpMOVBPWDVGS1F2M3VyTm5wcVRxSkRlNmVPUHB4SjJzQzEvSnVydGVP?=
 =?utf-8?B?Ky9pVmZEeEFGU3pDZkw1a1JMYzZXK2I4bmcvTEJyRXMyMkJhcVJmVklob1JZ?=
 =?utf-8?B?Z2ZTa0NaR3djSGxkN1JvY3ZnQWJlTElBRVlZV2RXaHgxb2VpaEZ2VEtUaVRz?=
 =?utf-8?B?ZjAzekR3NVUwV092SzFKNnN6Tm1pQlllU1RSVm02OWRPVHQ3RlVDdWFQSFBz?=
 =?utf-8?B?V2htUVJrZjVWNUo1c2JCd0dvQ3p4dHJmZzRlVHhPRHJEWXl6UWgzU3Q3QlE0?=
 =?utf-8?B?TEdndHdnQVc0OWYxNCsvN2ZOUm00ZHJ6UEJPNjZBOE9GZFpPQTdZU3JoR0VL?=
 =?utf-8?B?SDJVU0FESGxvMmxPMUdvUkxyeFIzem1mSm40dElLMDI2QVdjb3owaFVRMi8v?=
 =?utf-8?B?UjFHN0VwUGdLa2I3dkF1VWR1YU9QeXE0M1lCMmtpL21mamtLZjBMM2NzQTRq?=
 =?utf-8?B?WlovZ1h4cEQ3ZVgvV2RCN25VUm0rK0dYZFpWb0N4K2NzanFrR1E5TDRwd2Q0?=
 =?utf-8?B?TCs5RHRKSnZ1Vk04QnMwQW5nckRJVVFRV2lIb1B5RG1pYWNEODN2RTUvamw2?=
 =?utf-8?B?cHhiWThVcHlLM280KzI0WlNSVXN5RjFpSXQ4NjlvZDFySURnOTZidjBSdi9q?=
 =?utf-8?B?bVlkTTQvbnJlQUxYYkhVZDlJTUU2WHZNbVdlYWJWUitXQzk1VWtpMFNiK1U4?=
 =?utf-8?B?WURVUEZNSnFzd2JvK3J1VVhXdnJwWklTaTN2djdTMFlMVXRHcTNqUXQyeU5F?=
 =?utf-8?B?SUhYNStiQUJqYWZWamMwNjVWMGdMWVBnR01sZlIwYjBpQWFFWEtiZGYyVzFX?=
 =?utf-8?B?K0hYOWpZMGtKTGp6eldRZW9TMGEyc3dmb3I1MmhweE9SeVpKYWNZbW8yNjNM?=
 =?utf-8?B?bWVHcEZidHFaWWY1cWFtWVhoS1ZyZk5DaGY3RmZLUktnbitsS05lSFFBRDc0?=
 =?utf-8?B?MGFBQzVhaHBpYjlmcGlNNHgwdDNGVjR5YjlTL1N6MCtTRzhBbGF3NDQ0MWMx?=
 =?utf-8?B?S3BwUjBXNDVFY1pHd0tCZ3A2VE52ZWlqeUxBdjJXRTR3NHJRZTAwRHAzc2Nw?=
 =?utf-8?B?ZTI5b2NSWkhScE85VldOa0hOaEk0cVpiRVZ4bGxyaWdtVkY0SDNCbUNtcER0?=
 =?utf-8?B?ZEFJL1RqeFp3YjFqTGxDcWlzV2JVUmpBdXY0M3hSNVl2Rk41RjQwbWFlWTZH?=
 =?utf-8?B?aVhITXkrQWs0WWQrckIyOXhjM01wVmdpZUxDL2t5UlE4SU85QUUzZjFhVFpZ?=
 =?utf-8?B?Q0V3RVpidFp1bHBQVDR4bW5rV3N6Z0lxQkIwNEYweTZDNFpKcTNuS2FKOUVN?=
 =?utf-8?B?N09oUytjR1U0ZHNheDlBcTJhYTNhRDlxM0NTR3dPY0tkWXpac1VqNGl2b2Zh?=
 =?utf-8?B?dlRwSWJlQWIyTlNiUnVQejVYTStBc1JGQkFhTUxwRXExemNhWGtBVC8zZ0Rv?=
 =?utf-8?B?VXYyZzlvaFZqRXFxM2lKdGg1cXlzcEFaaTBVdUsyekU1eFZHb3JUcUNsc24v?=
 =?utf-8?B?T2UwTTAwWU41RHJ3QXlweHRTL0xaK3lpMFpaMlBhTWk0ZkNvNVNqTHZVa1lB?=
 =?utf-8?B?NG83c3RFcnJmYlFPUXJUU0dTRGF1dHJ4TVNraDRaUWplbWFySEJLNEZ0K0Zt?=
 =?utf-8?B?YmJ1MjJCM2wvNjljeUtmOGt4dXJZMi8vMk91c3BadisyeS9wbnFrWVpzVVV4?=
 =?utf-8?B?NGwzYkkvRVB2Z1BWakFkb05MejdWNXYzMDQrdDM0T2pzL1BoRHU2Zz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a1a69f2-3e67-4601-2376-08df344839d0
X-MS-Exchange-CrossTenant-AuthSource: FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 16:34:52.3459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGtVEERUnMy3ZJJ9Ww9gp3jkDqmx0MJ67xeXBCK/6LBNscdyO2SkutfInu8jsVaDyES8RwXMd38HKKctjL9uOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P189MB1135
X-Rspamd-Queue-Id: ABDDB140005
X-Stat-Signature: iwazm9czkwfcx1jkdau1a3g8iaz4uhym
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793118897-270549
X-HE-Meta: U2FsdGVkX1/XSpetoYHMZIo8qhy7HulvV6Jz36JRrrgaole6S/Uao/V2rxCtusrd9+A3i2fOylUg4SnVyU2Z4w45UbwtUe8ni7QyiLHx+EXzF5eZReyD8ar9R8FpiqLg450zWV9uI+9PSN6sntnOtKiM40pNI/Yi626iSyRiAaygdeAg/N0oJt4kiCkaIzBPfyvrPgEdb89Gm1bTttElIyDuaF0irB6uBUqQUtqqT7+rfpZNdUUHiNWzgoqgVrr5zcXdBXYqlSpffi59Bf0oU+HEo6WWcrBrGvSpd4u6AaLAHgsgaBFaWiY95UX2DDiHIRdrIYBFfo8JJW08uk7czaetugrXXlVC8gnHDgm+gn2hvpZ57e5aU+kouEyyPOnyS0XOjBCnmNeppR51abTKJYXSFHz+uXeS4zFbAlDuUKld6vOxVVNzMpYiIzgZ4HLfXjLQY+n8/KZXbtDhLnnDAPyWSlv0CcSwN7b5oQIf0uoO7iVmNciQIp+98b+2J7MazL58lWefhmQDXjInI46lmzcZWXDp5lHqZkZ7h57Lw6yLue8HdtW91DmigxTDsnR5EG8ZNw+pCBwZRw4M/zCoTH0bhiDnz5nHfzg6NBhJQHQzwt/CD7JriMiicBTjMqQAKgKF/YlWKA0qkq5mti0Ko7uPELgo/9VxIJUC/4Clk78va7N7R0usFuyS4LZDuml47OOiO0oq2yL6agLN5HG3KpUoZQc1/SZd9KFjsCHf3xPU1KC4bXlJVv3f4c0DmOroc+Kht/FK7PE+1htHwnWu0cs7pqV95LixPHRHCTB3n3WLrd6s7RsewrBzNLYMFnJUC0E5wqBIl3Xpk5/vTWIzT8bM7aDuHsrBx/3yPwAIYeBVJIH0U9Itkoi0dzPZqdF3GarT+SsEwfi4skb1YKYPKJ9UsqFFa1Hd33aUJ9lgItnwAq2r37qP/AjrbKnsvfNXtDG6yTgs7ga3MfcHLr/
 nLzhF7Cd
 R33TmoJ9x+J/Q9XC0I2ZtBSyc2U1LBVWPlSK8MAgi175T5vF/QJxGeUjFaI2xld/r/uIu4tyG2Ded+bLTIzh4qCYgwSs5Uqf5UBGnmmqa//oBab4Mdu8G76yF128bpln0O5J05Oh2bejy/9+ZBZsEkxwudZSbdLu9A2r/Lrkarq8S2T+YgtOmnPmLR0WFkNnXIt9Nw6IFLK5TiUMEBklTgK8RECZ3FO8wUJwThtoEbf493nWWTeQN5tjX+lAClxowDrAABl7h1ObTvPfqmCQjN7d/VLETMiYPvqM0n46gkgs6FYCtoQW1fjgiKvNXUNkTwDBVDlybT4yi5Y95Xc9RVPO36t6uWSdQGfBgRjqZxDhebZ0hlDHNVrFL9wrauYDRTEMOSUDpStqhqhYNV9CbO8kx64wTvNJI3bD2C9I2nH/b4KSPp6I1lGuVzxOdVKFuHyAaxkDqGGwkvytuVpME5ExJ4i+koDWFujuqykefiwm8juw0mTmw3PxkCozML1pv3VkIMsym8Ld91vfS6WEgbod9TBEUYd+eco4K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This RFC adds a way to collect KCOV coverage of the boot path, from
right after early parameter parsing in start_kernel() up to
rest_init(), and to read it back from userspace after boot.

Motivation
==========

1. The boot path depends heavily on the configuration

Reviewing the boot path by reading the code is hard, even if you stop
at rest_init(). start_kernel() looks like a flat list of calls, but
what runs below it depends on the kernel configuration, the
architecture, the firmware, the command line, static keys and
alternatives. Many of the calls are empty stubs in one configuration
and large subsystems in another, and a lot of the work happens in
inline helpers in headers.

Even the top-level files are full of configuration branches.
init/main.c has 13 lines with #ifdef CONFIG_*/IS_ENABLED(CONFIG_*),
mm/mm_init.c has 34 and arch/x86/kernel/setup.c has 36, and each
branch leads into code with its own branches. Some examples from the
x86_64 test setup described below:

  - Without KCOV_INSTRUMENT_NOISY, a boot records 17.3M basic block
    executions before rest_init(). 10.4M of them (60%) come from the
    step where arch_cpu_finalize_init() applies the alternatives. With
    the retpoline and rethunk mitigations enabled, that is mostly
    apply_retpolines(), apply_returns() and the x86 instruction
    decoder they use (93% of the step in the NOISY=y boot below).
    apply_retpolines() and apply_returns() are empty stubs unless
    MITIGATION_RETPOLINE/MITIGATION_RETHUNK are set.
  - The tracing options (FUNCTION_TRACER, EVENT_TRACING,
    FTRACE_SYSCALLS) add another 6.0M executions (35%) in ftrace_init()
    and trace_init(), which set up the ftrace call sites, the trace
    events and the syscall metadata.
  - Of the 11,131 distinct PCs executed (with KCOV_INSTRUMENT_NOISY),
    544 are in tracing code, which only runs with the tracing options,
    and 500 are in ACPI code, which depends on CONFIG_ACPI and on the
    firmware providing ACPI tables.

In total, the part of start_kernel() between parse_early_param() and
rest_init() executes 11,131 distinct PCs in 1,529 functions spread
over 568 source files (10,877 source lines). 131 of those files are
under arch/x86 and 109 are headers in include/linux. A different
.config, CPU or firmware gives a different set, and reading the source
cannot tell you which set your kernel runs. You have to work it out
again for every configuration.

2. Early ftrace does not show the code that actually runs

The function tracer is the usual tool for looking at early boot, but
it cannot answer "which code ran":

  - It starts late. Boot-time function tracing (ftrace=function)
    begins in tracer_alloc_buffers(), called from early_trace_init().
    Nothing before that point can be traced: setup_arch(),
    setup_per_cpu_areas(), and mm_core_init() with
    build_all_zonelists(), memblock_free_all() and the slab and
    vmalloc setup. (This series does not cover setup_arch() yet
    either, see the limitations below.) Even inside the window this
    series covers, 2,758 of the 11,131 distinct PCs (25%) are first
    reached before early_trace_init().

  - It works at function granularity. It records that a function was
    entered, not which branches inside it were taken. Those branches
    are exactly where the configuration and the hardware differences
    show up.

  - It does not see inlined code. 1,739 of the functions executed
    during this window were only ever executed inlined, and 4,912 of
    the 11,131 PCs (44%) are in inlined code. None of this has an
    fentry call site.

  - Large parts of the kernel are built without ftrace hooks. lib/
    and kernel/trace/ remove CC_FLAGS_FTRACE for the whole directory,
    and kernel/, mm/, lib/, init/, arch/x86/ and drivers/acpi/ have
    55 more per-object CFLAGS_REMOVE lines doing the same. Early KCOV
    covers 30 files in lib/ alone.

  - Its buffer is sized for events, not for loops. The ring buffer
    defaults to 1,441,792 bytes per CPU (TRACE_BUF_SIZE_DEFAULT) in
    overwrite mode. With boot loops calling the same functions
    millions of times, the earliest events are overwritten unless
    trace_buf_size= is raised a lot.

ftrace remains the right tool for timing and call order. Early KCOV
answers a different question: which basic blocks ran, in which order
they were first reached, including inlined and non-traceable code,
starting before the tracing infrastructure exists.

3. A learning and review tool

With this series the executed path becomes a concrete, ordered list
that can be resolved with addr2line against vmlinux and read next to
the source, for exactly the configuration and machine being booted.
This is useful for people learning the kernel, and for reviewers who
want to check which code a boot-time change really affects. That use
stands on its own: even if this is not accepted upstream, I intend to
keep it as a learning tool.

4. Coverage-guided fuzzing of boot-time input

A lot of input is parsed while the kernel boots: the command line and
early parameters, bootconfig, ACPI tables, the e820 map, the device
tree. For confidential guests (TDX, SEV-SNP) much of it is provided by
an untrusted host. KCOV cannot give coverage feedback for any of this
today, since collection only starts once userspace opens
/sys/kernel/debug/kcov. A fuzzer that boots a VM with mutated inputs
could use the early coverage as its feedback signal.

5. Comparing boots

Diffing the coverage of two boots shows how two configurations,
command lines, CPUs or kernel versions take different paths, and the
first-hit order shows where they diverge.

What the series does
====================

Patch 1/2: kcov: collect early boot coverage of init_task

  a) Collection, behind the new CONFIG_EARLY_KCOV (default n)

  - early_kcov_init() is called right after parse_early_param() in
    start_kernel(). It allocates a buffer with memblock_alloc(),
    attaches it to init_task and enables KCOV_MODE_TRACE_PC. The size
    defaults to CONFIG_EARLY_KCOV_SIZE_MB (256) and can be changed with
    early_kcov_size=; 0 disables the collection. The memparse() result
    is range checked as a 64-bit value before it is narrowed.
  - early_kcov_stop() (__init) is the first statement of rest_init().
    It disables collection and detaches the buffer from init_task.
  - A late_initcall frees the unused tail of the buffer and creates
    /sys/kernel/debug/early_kcov (0600). It uses the regular KCOV
    layout: word 0 is the number of PCs, then the PCs. They are
    canonicalized (KASLR offset removed) like other KCOV data, so they
    match vmlinux directly. The tail is freed there rather than in
    rest_init() because memblock memory can only be returned once
    deferred struct page init has completed. If the file cannot be
    created, the whole buffer is freed.
  - Writing to the file removes it and frees the rest of the buffer.
    I would have liked "rm" for this, but debugfs directories have no
    ->unlink. The removal runs from a work item, because
    debugfs_remove() waits for the write to return. Readers holding an
    open file descriptor get an error afterwards.
  - __sanitizer_cov_trace_pc() is not changed, so KCOV users that do
    not enable CONFIG_EARLY_KCOV are not affected.

  b) CONFIG_KCOV_INSTRUMENT_NOISY (depends on CONFIG_EARLY_KCOV)

  Many objects are built with KCOV_INSTRUMENT := n because their
  coverage is not a function of syscall inputs: the scheduler, RCU,
  locking, the page and slab allocators, parts of lib/, stack
  unwinding. That is the right choice for fuzzing, but for the boot
  path it hides sched_init(), build_all_zonelists() and much of mm
  setup.

  The new option makes those sites instrumented. The sites use a new
  kbuild helper,

      KCOV_INSTRUMENT_foo.o := $(kcov-noisy)

  which expands to "n" unless the option is set. Only sites whose
  comment says they were excluded for noise are converted. Sites
  excluded because instrumentation is unsafe are left alone: kcov.o,
  kernel/entry, head64, x86 cpu/common.o, tlb.c and mem_encrypt*.c,
  stackdepot, and the KASAN/KMSAN/KCSAN runtimes. This patch converts
  the generic sites. With the option off, the build is unchanged: no
  object was recompiled, and page_alloc.o, rcu/tree.o and string.o
  have no coverage callbacks.

  c) Documentation

  early_kcov_size= is documented in kernel-parameters.txt, and
  Documentation/dev-tools/kcov.rst gets an "Early boot coverage"
  section: configuration, the covered window, the file format, how to
  decode it with addr2line against vmlinux, how to release it, and the
  kcov-noisy convention.

Patch 2/2: x86/kcov: allow instrumenting noisy objects for early boot
coverage

  Converts the x86 sites excluded only for noise: apic/, delay.o, and
  the stacktrace, dumpstack and unwinder objects. The objects excluded
  because the kernel hangs or does not boot when they are instrumented
  (head64.o, cpu/common.o, perf_event.o, tlb.c, mem_encrypt*.c,
  pgprot.c) stay excluded, as do machine_kexec_64.o and physaddr.o
  (kexec invalidates the GS base). Other architectures are not
  converted, since x86 is what I could test.

Measurements
============

Test setup: x86_64 QEMU guest under virtme-ng, 4 vCPUs in 2 NUMA
nodes, GCC 16.2, the virtme-ng default config plus the options below,
on the base commit given at the end. The config has FUNCTION_TRACER,
the retpoline/rethunk mitigations and X86_FRED enabled. Each boot used
early_kcov_size=512M so that nothing was truncated.

  NOISY  RAM   PCs recorded  buffer used  distinct PCs
  -----  ----  ------------  -----------  ------------
  n      2G       17.3M       132 MiB          8,837
  n      4G       17.4M       133 MiB          8,864
  n      8G       17.5M       133 MiB          8,861
  y      2G       31.6M       241 MiB         11,131
  y      4G       34.8M       265 MiB         11,194
  y      8G       41.2M       314 MiB         11,169

Without the noisy objects the volume barely depends on the amount of
memory. With them it grows by about 1.6M PCs per GiB, from freeing
pages to the buddy allocator. The 256 MiB default holds a full
boot without the noisy objects, and with them up to about 2G of RAM.
When the buffer is too small, the remaining PCs are dropped and the
log says "buffer full, coverage truncated".

Where the executions go, attributed to the start_kernel() call that
was running (NOISY=y, 2G, 31.6M executions in total):

  executions       share  new distinct PCs  start_kernel() step
  ----------       -----  ----------------  -------------------
  14.3M            45.3%         603        trace_init()
  11.1M            35.2%       1,091        calibrate_delay() and
                                            arch_cpu_finalize_init()
   3.0M             9.4%       1,466        mm_core_init()
   2.7M             8.6%         254        ftrace_init()
   0.2M             0.5%         493        pr_info() in early_kcov_init()
   0.07M            0.2%       1,690        acpi_early_init()
   0.05M            0.2%         862        vfs_caches_init()

arch_cpu_finalize_init() is in arch/x86/kernel/cpu/common.c, which is
not instrumented, so its alternatives patching is counted together
with calibrate_delay(), the call before it. With the noisy objects,
the lib/string.c helpers (strstr(), strncmp(), memcmp(), strcmp())
are 73% of trace_init(). Going from 2G to 8G adds 9.6M executions,
96% of them in __free_pages_ok() and __free_pages_core(). The steps
with few executions are often the ones that reach the most new code:
acpi_early_init() is 0.2% of the executions but 15% of the distinct
PCs.

How to reproduce
================

The essential commands, from a tree with the series applied and no
.config. virtme-ng adds what it needs to boot, including
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y for addr2line.

  # Build
  vng --build --configitem CONFIG_KCOV=y \
      --configitem CONFIG_KCOV_INSTRUMENT_ALL=y \
      --configitem CONFIG_EARLY_KCOV=y \
      --configitem CONFIG_KCOV_INSTRUMENT_NOISY=y \
      --configitem CONFIG_DEBUG_FS=y --configitem CONFIG_NUMA=y

  # Boot with 2 NUMA nodes, save the coverage in the current directory
  # and release the kernel buffer. --rw gives the guest write access to
  # the host file system, which is how the file reaches the host.
  vng -r arch/x86/boot/bzImage --rw --user root --cpus 4 --memory 2G \
      --numa 1G,cpus=0-1 --numa 1G,cpus=2-3 \
      --exec 'dmesg | grep kcov:;
              cat /sys/kernel/debug/early_kcov > early_kcov.raw;
              echo 1 > /sys/kernel/debug/early_kcov'

  # Resolve the distinct PCs
  od -An -v -t x8 -w8 -j8 early_kcov.raw | awk '{ print "0x" $1 }' |
      sort -u | addr2line -f -e vmlinux

The helper script I used to build, boot, measure and decode (it
produced the tables above with "measure" and "decode --stats") is not
part of the series. It is available at:

  https://gist.github.com/yskzalloc/44d2e20b48f4971fd4ab91756369b526

Testing
=======

  - Booted with and without NUMA, 1G to 8G of RAM, with buffers from
    8M to 512M, with early_kcov_size=0 (disabled) and with
    early_kcov_size=64G (rejected as out of range, "Malformed early
    option", default kept).
  - The last recorded PC is in rest_init() (init/main.c:745), and
    nothing from kernel_init() or the initcalls shows up.
  - After writing to /sys/kernel/debug/early_kcov the file is gone, the
    log shows "Freeing early boot coverage memory: 235932K", and a read
    on a file descriptor opened before the release fails.
  - Normal KCOV from userspace still works after boot with the noisy
    objects instrumented, and no warnings show up in the log.
  - Builds with CONFIG_EARLY_KCOV=n and with CONFIG_KCOV=n. The changed
    C files build without warnings at W=1, and checkpatch is clean
    apart from the missing Signed-off-by in my local tree. I could not
    build the HTML documentation (no Sphinx here).

Limitations and planned extensions
==================================

Collection currently covers parse_early_param() to rest_init(). Two
extensions would make it much more useful:

1. Start at the top of start_kernel()

   setup_arch() runs before collection starts and is not covered,
   though it holds the most firmware-facing code. On x86 it calls
   e820__memory_setup(), parse_early_param() (so the generic call in
   start_kernel() does nothing there), e820__memblock_setup(),
   acpi_boot_table_init(), early_acpi_boot_init(), initmem_init(),
   which does NUMA discovery, and acpi_boot_init(). For the fuzzing use
   case, this is the code that matters most.

   memblock is not usable until e820__memblock_setup(), so starting
   earlier needs statically allocated __initdata storage, and a full
   trace does not fit in any reasonable static buffer. Collection also
   needs current and the per-CPU preempt count to be valid. That holds
   at the top of start_kernel() on x86, but has to be checked on other
   architectures. Code that runs before start_kernel() (head64,
   startup) is already built with KCOV_INSTRUMENT := n.

2. Continue past rest_init()

   After rest_init(), pid 1 runs kernel_init() -> kernel_init_freeable():
   workqueue_init(), do_pre_smp_initcalls(), smp_init(),
   sched_init_smp(), page_alloc_init_late(), then do_basic_setup() ->
   driver_init() and do_initcalls(), until free_initmem() and
   run_init_process(). Driver probing and most device/firmware input
   handling happen here.

   pid 1 is created by kernel_clone() in rest_init(), and
   kcov_task_init() resets the child's KCOV state, so the buffer would
   have to be handed over to pid 1 explicitly. Work done in other
   threads (kthreadd, kworkers for async probing, the deferred page
   init threads, per-CPU threads) is not covered by per-task KCOV.
   That would need remote coverage (kcov_remote_start()) at the
   relevant points, or a boot-only global mode. I would like advice on
   which is acceptable.

Other limits:

  - The data can only be read after a successful boot. If boot fails,
    it is only reachable from a crash dump or a debugger.
  - Interrupt entry code that runs before the hardirq count is raised
    (for example the x86 FRED system vector wrappers) is recorded as
    if init_task executed it, and such a PC can occasionally be
    overwritten by the interrupted task. This is the existing KCOV
    behaviour and is described in kcov.rst.
  - Functions marked noinstr are never covered.
  - Only x86_64 has been tested.

Changes since the previous internal version
===========================================

  - Added CONFIG_EARLY_KCOV; the feature was on for every KCOV kernel.
  - Dropped the "unique" mode that recorded each PC only once. It
    needed a bitmap check in __sanitizer_cov_trace_pc() and loses the
    execution order and repetition that a trace gives, which GCOV
    already covers for "what ran". __sanitizer_cov_trace_pc() is now
    unchanged.
  - CONFIG_KCOV_INSTRUMENT_NOISY now depends on CONFIG_EARLY_KCOV.
  - Writing to /sys/kernel/debug/early_kcov releases the buffer.
  - early_kcov_size= is range checked before narrowing (32-bit),
    early_kcov_stop() is __init, the documentation describes the
    covered window accurately, and kcov.rst documents the interface.

Questions
=========

1. Is early boot coverage something kernel/kcov.c should carry, or is
   it better kept out of tree?

2. Is a write to the debugfs file an acceptable way to release the
   buffer, or would you prefer a different interface?

3. Is the kcov-noisy helper the right way to opt in, or would you
   prefer a different mechanism? The subsystem maintainers of the
   converted Makefiles would be Cc'ed on a non-RFC posting.

4. Is there interest in the two extensions above, in particular for
   fuzzing boot-time input?

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
Yunseong Kim (2):
      kcov: collect early boot coverage of init_task
      x86/kcov: allow instrumenting noisy objects for early boot coverage

 Documentation/admin-guide/kernel-parameters.txt |  17 +++
 Documentation/dev-tools/kcov.rst                |  60 ++++++++
 arch/x86/kernel/Makefile                        |  12 +-
 arch/x86/kernel/apic/Makefile                   |   2 +-
 arch/x86/lib/Makefile                           |   2 +-
 include/linux/kcov.h                            |  13 ++
 init/main.c                                     |   4 +
 kernel/Makefile                                 |   6 +-
 kernel/kcov.c                                   | 184 ++++++++++++++++++++++++
 kernel/locking/Makefile                         |   2 +-
 kernel/module/Makefile                          |   2 +-
 kernel/rcu/Makefile                             |   2 +-
 kernel/sched/Makefile                           |   2 +-
 lib/Kconfig.debug                               |  45 ++++++
 lib/Makefile                                    |  14 +-
 mm/Makefile                                     |  20 +--
 scripts/Kbuild.include                          |   6 +
 17 files changed, 361 insertions(+), 32 deletions(-)
---
base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
change-id: 20261027-early-kcov-0f5f370b4bed

Best regards,
--  
Yunseong Kim <yunseong.kim@est.tech>


