Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8FF606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=est.tech header.i=@est.tech header.a=rsa-sha256 header.s=selector1 header.b=S78x6J7p
Received: by kanga.kvack.org (Postfix)
	id CB57C6B083D; Tue, 27 Oct 2026 12:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DFD6B083F; Tue, 27 Oct 2026 12:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55FA6B0840; Tue, 27 Oct 2026 12:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 900CE6B083D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:35:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 047F240A87
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:35:06 +0000 (UTC)
X-FDA: 85368955854.18.4A225BB
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011028.outbound.protection.outlook.com [52.101.70.28])
	by imf09.hostedemail.com (Postfix) with ESMTP id 171D6140007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:35:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=S78x6J7p;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.70.28 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZAvvvHun6aalGq5kU3xbJGdnoWrIc1LoWTmjMlrfpA=;
	b=YTOV6vc3kdI4eGQuYzNhW4mqS+OUS6jx+RDftAd1+5rqy6rFD2jYbiHXJFfezXy0KHYk4T
	zqSSEIGQajgvZ20zEnSHuVGq3Iow1F+gUA914kqRbNvdnJ8NYsVvS6G5cgqEWrv+9BXpwv
	UxIwa7O668FRtnx+kjr5RRgDhlmtkLo=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=S78x6J7p;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.70.28 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793118904;
	b=ZyIcdqmO4vFTlKafKH8CVy5ZDLzRbXr5NoW2sZJFAvC2+GwT+T1vQp3aPVIhNTSr4q/Oan
	hVFHhuzQFjhb0tRVGkAtSOyXXaXm1Ps4PsJJy+pyrLfchDR40FeRy+P3z6h/V/NUKalIzi
	cEj/3iWBxmkax3+MA+iAPxt/Y5O9fFc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqq1wciStRazrrVS3ROLro2uA6yVZBlJQtVZmogVHeGWiYuPHaETSAnQn2MoFC1HmloFXEH/xX2Znn/bCK/jFFd2JdDt7uHtKIa0M+Mey13TEYbuVe/ghAkGp8Fhb9du+p4ytz6MfsFKw3XFuLzkS+oGkQCPtTEUIIHz0CEX0/qhn3r4UVN7/VE9IMHiGx4kW+sZebo9PuNBxMlxO2SFIZ6pqbmHu2qaCNZGyF6klP1d+urzQUwdUX1DfBMtNpDKBYB7IQW6IVbJQLbjISWVPBEz43EgieLyzs63I8Xgl+x2Fn+iNXHaZ5rtPPdacqqK6YE4zqM3vnjHkcb8x8vwRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZAvvvHun6aalGq5kU3xbJGdnoWrIc1LoWTmjMlrfpA=;
 b=EPVbDM0/WTu7nNI/0GLrxaQ1SqoZnjU/TDXYSgx4Z15oNMgp1nG/++wbGUjUACmdqF15sIMh8RSPUcN8po3Li3DmTzGAudE/epaA30JUeqCX5HsipwJMvRs4Sux1NeckY6B+fI3xfLNYTOOoUGWPV73Daao5CsqI8xU7VRWogIgU7z/hzTxCi3bc+KZ/q5izeatDSZo2vb7rO/Ch2kHHukHRUEAeerpRJHnsmVUuorHaurCKlCkKHbwVJMXp+O0JTsWQBlQyPd/bYO0V0IKbQGw/HA/uGD//lalW354hi1DiWzCyRNopeFeueAa9pVwIvLH16cEPITuYt9lWsfCtXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZAvvvHun6aalGq5kU3xbJGdnoWrIc1LoWTmjMlrfpA=;
 b=S78x6J7pzZK+Grs+p2XwhAVoM273emPqJVXRuFB+Wl8cRvW6+EuP++U15O1KuvEf10OJ1JFlq/GQufmTUKdY4srrBHoLmey4lXjxYnLTej7E2wEZJi2xQ0WVM/kknSwLihyIv3BEqYDwb2w6rpyAvmumpitNMPmMxYWVpkXW7pmACfaaPw7Mt2siKH4u15CM7KyCX/aK5F+R/v4VIr/N46aLGw2feObgBJR/U4jp+Poo+45Pvv+6//BGV2DZYqNFnRvfatnDeM9lVbNZ0pSjIrP9me63cQOvm/G9/WP59aYmqOicQb4SH9FCZN7Jfb5jVlxJd5TL4lmn83+ml49FJQ==
Received: from FRWP189MB3398.EURP189.PROD.OUTLOOK.COM (2603:10a6:d10:1a3::22)
 by VE1P189MB1135.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:148::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 16:35:02 +0000
Received: from FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 ([fe80::4658:dbd6:d572:896a]) by FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 ([fe80::4658:dbd6:d572:896a%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 16:35:02 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Tue, 27 Oct 2026 17:34:09 +0100
Subject: [PATCH RFC 2/2] x86/kcov: allow instrumenting noisy objects for
 early boot coverage
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-early-kcov-v1-2-6f2f053255ad@est.tech>
References: <20261027-early-kcov-v1-0-6f2f053255ad@est.tech>
In-Reply-To: <20261027-early-kcov-v1-0-6f2f053255ad@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793118887; l=3249;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=XFup3h7UWloVBflNudxisL9cA+gOhcl+s7k8IxtKVKQ=;
 b=21InQGEVzGa/xXsjiaQcAKIzvWuhynLYuI5/cWIYRBiNPwLmEGn/X2vBrjeMyDVkYE3/ErMMk
 OB3Wg8bZZk0D/b1kYnHii2X+SjhEDjib8INCLs9Yn6hsXkxGtJ7ZXpv
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: LO4P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::22) To FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:d10:1a3::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FRWP189MB3398:EE_|VE1P189MB1135:EE_
X-MS-Office365-Filtering-Correlation-Id: fd0c8e78-ddfc-4148-774b-08df34483fa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|921020|261026121527099003|5023799004|56012099006|11063799006|261009223027099003|261021123027099003|261022075727099003|261022105027099003|261021121427099003|22082099003|18002099003|6133799003|10067099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	QTu7N3PHQb36IBbIPETx1Bfo2DSurdJHbifEnc6xTyDtDxHpAsWzVlaqs862Do/GOoti+BPm9zuCrNN8caBIEN7InRM4iDXszD7vwITPKphMq++TTTOKOrdCuegExqrP7GsGoCoo4NpQm689r2j9iHbebUNpp4MzYzQ4AzJYa+UTUBErd0jvnYTfSeteNp46iVdFqgcetx6E17uk2tGuAszQE+ciVgWLXxP/uBq3hliHLwj4Bd8zur1N/59xsZGXR8Vzs2XW0d4RqzOej7XaBUykQXMmBYjhA8PIMT3qtUyNWvMBTmAj5bDjkZcnhCNYggE/6xUG4MDSFixnif4IS2SfKTvnnkeRIH1jhNBI3gf80BglW1+9dKa0T49OLJ2C25G2/i/LAYa9CIwBfOKprzqEylXds7d+hTNKlBLw6bmd5+8STtOrxjO7cwyBXgwsGCyWQwta2v5nppYulH67HJlefvJcCoDqEkU1eXIK7+UTAjIFOkRONk05X+xwPNU+W8O7p2xprMkxhSTCWApiHd4P6ZnGk2Hm6yc5P0DepJTO222Iw90JJAT+KxOqCJ5NnMmExSEWdWVgs/pOs85JmqGAiJ/1M5HARIqq0+GYOcuba2YBw+pQ8j3R2Yvi6Rf/mdZeExFvGmeDIGp7YjuX8bSt6zY+7fuBUGJyiO3UDER3+inEeAypq2A03AgkViJ43Lvedmwn371bjjl56JuIsg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRWP189MB3398.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(921020)(261026121527099003)(5023799004)(56012099006)(11063799006)(261009223027099003)(261021123027099003)(261022075727099003)(261022105027099003)(261021121427099003)(22082099003)(18002099003)(6133799003)(10067099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTNCZEo1cm9JK2ZsckVjSFV4dXNXejJTLzJ6YzFFZjRzMkIxd1JMMkdDR2ty?=
 =?utf-8?B?aXkzQ2d1WGRnb2grWlI2Nkt5Y0k0T2pvUTFiOWdPV2crOWNTc2JqeGcwSzEx?=
 =?utf-8?B?TFRjeUhjTXdLalZEL0xETitmeHUvTFZxTVp0TlAyai9tQnpVaFgvYko2M0xO?=
 =?utf-8?B?VnNwYVJLSWwvdVNrdjc1NU1VRkg0WUd6REtHZEpHQ2ZFNk9aUnpESFdpc1pU?=
 =?utf-8?B?SjBHYkJBUGZLaGM5Qy9RZnFWNnlLWUpzeTBZbjQvUklwcDlKVW9tdWxXL253?=
 =?utf-8?B?d3BjeGExeHA2YlhHenNpNWdocVMrNHdWaFZuS3Y0a3pSWE0yOTFYaXc4L0NL?=
 =?utf-8?B?bE9YQTZSbXlEd3dVbHg4ODhQYUtPTVRJbERObU9tczJPTnptV1lYU09ManJH?=
 =?utf-8?B?VE9tNFdlL2QrMUZaOHZ3c1BOR1lpTFpXU0kxUXdhSUpsZ0xibDlSWTFnSUZl?=
 =?utf-8?B?anNWck9VRWRYby9EcytIWGc2UjZNeWVyN2UxR2tBY1RJQ0Z3V2JSUlhoc3Jk?=
 =?utf-8?B?SDIzUFJyVEMrWnkvMytxUm1ySWZtckh5Tm5Hd1NFK1NFcjlUcnphZU91dzJY?=
 =?utf-8?B?SngxK3VNaGNmdGc0aHJFanpNV3FIRGEvVzlZTUF1bHdMamV3emV4RGhCT254?=
 =?utf-8?B?dlZlMlVTTVROL09wMCtlUENDZEhOWjdCREp0cGx1bWVnWTNFSldQdVdvVmVn?=
 =?utf-8?B?M2tMWU53OEpodWtrUGtNQXBxWno1N2NpMFhpSi8zNTA2SXJObE1tbHYvZVo0?=
 =?utf-8?B?bmlMeng2dmQrNklqN2FRQ05Hc240VGkxbFRqNmFXNDIxdENNMXBsc2RVVWRU?=
 =?utf-8?B?UFBhSS9hT2VYaTl5OFJzamxPSWJscG9IZkNLUDdwMmRQUmU1Uk1FdUhqTitI?=
 =?utf-8?B?V0N4Zk9RakRGdHdweGl2K3o1eFZCQlk3QVg1clZVb3QvY1RtVmRwS3RLVVZQ?=
 =?utf-8?B?VHZxUjkzK1FoVmhhNnlQNVZQVGcwWCtERldHK2pOclNRczNNNE5LRVZ5aEc2?=
 =?utf-8?B?bk1FaFFwVjk2SktWd1dwLy9EL3pDNGtkak1UZ01DNEJXZjJrc1U5SEJKbzho?=
 =?utf-8?B?ZFZTaDA0N0d2VDhLZFNQVlpQQU53WUJ4WVBHOVFUTjBFS0NSVEpuQnY3SDFF?=
 =?utf-8?B?cUFPc1ZGMjRxRytwOUlDYnFROTV5UERpVVg0U1JGRlpvcmZLMFVEWkl4aVhr?=
 =?utf-8?B?b3pVY1RSNmpMZ3VuVjZDcUYzV0czWDg0SHJqVEZJeFA1YmVteDRWekpIdEUz?=
 =?utf-8?B?TUxFNHptK3J2cGJNY0VTc1lkZU80VEQ3ZmpsOUZDN29WYXZZMXhOZDl3dUpH?=
 =?utf-8?B?TXBmT2tqdEVIZURBbTZISWlMQVFLeTlCSzNVM2wxYlZhdmd2L3p6VnhZRVZh?=
 =?utf-8?B?UjU5RW56SnlteUY2N29Rb0NUZDNoUnNZTTVVYnBZNTk3eVN1TTNwenovWms2?=
 =?utf-8?B?R2loNGZzRmpUZVF1NFpPbHZ3VlNzVDNFMExhR0pDTE9EYk95aC9pN1FVUlhV?=
 =?utf-8?B?RkFBODMvS1NWeHA4cDd0VTZTT0hYS2ZKdEsrQzFWMnFVOHFXbDJ4a25sbFBS?=
 =?utf-8?B?OUpPVUNCOFBOOUplM1VpVmlvN1gvbGNmbCtGY0EyTitMOTZ6S25xNm5DTW9V?=
 =?utf-8?B?aE81a01hc0lpZmhyMHFIcUNqZGY0RHBtSXh2L1hPVEppNnFkQkdNcmFQYjRR?=
 =?utf-8?B?c2d0UThUN3EwdVc1OE9XS1Q5REx3Tk9TRGppcUVobDFOcGpFaUg0NVY2WXpu?=
 =?utf-8?B?MFRvYUpwWnIrWVlPYm1mMjhabE9kNmV2eFVBNjU0c2VoUUhVL2VBRk9zVnlZ?=
 =?utf-8?B?UTluNFpoWHdBZVFtRzJzKzFoZmkvcHplYTRLb0ZId29LbEdiSkdqaEVCMHlq?=
 =?utf-8?B?SGtoN3NhWmdmdWQ4Y0Jzb1EwTFJVVlFSNVplYkMvWnNKSnR4d0lmcW45RmVn?=
 =?utf-8?B?RHY3NjZUUzZ0bWYrRnlSb2RHQjZaVmtSc3I1MVgwTGlEeGVaTnYwSkwrbTA0?=
 =?utf-8?B?TnQ3SEJFUlNyZTQ0dG5QRU5IaTRETElnMVNmVkphWGg5MDdJTnFpenV2WDZz?=
 =?utf-8?B?UmtHaXhRWDc2QU1sMlZ5RW5GQTAzcHdyVmdaQktCT3BYU2RpUmFMNkdsczJV?=
 =?utf-8?B?WUJESFEwYWhxTjRmL1ZkTVoxSmlJeU94VTNKejRMaTJDVHU3b0RlaElIazNa?=
 =?utf-8?B?bkhQWDE0d21PZ1lIVmUyQkhrV0kyaGNiZm1sRkhGejFZcURYZWk2bUg5UkZQ?=
 =?utf-8?B?ZWsyN042NjhqbEdmTFlvY1RFSGk4WHVGbFNXMno3QVhkR3hrTUV3WTBDeUVK?=
 =?utf-8?B?bExhclZsZ3pDNWtKZEw3RzF4SjlzSW5Rck9jdFNqZmR3S1MrckxrZz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0c8e78-ddfc-4148-774b-08df34483fa4
X-MS-Exchange-CrossTenant-AuthSource: FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 16:35:02.0795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UoDXaGbTsjbnfmeD6lNiwRCbDlR7PmmTmUWoB8oAvL47/P+Ce3r05M/oqitw3YZwj3Ncbxk/Hhp1WmYRzlIhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P189MB1135
X-Rspamd-Queue-Id: 171D6140007
X-Stat-Signature: 8m51nzp8cpa6djfrfiax346umozc4wre
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793118903-420914
X-HE-Meta: U2FsdGVkX1/p5cOtTALi1X5OV8DSej9xjJDmlqASTUuDo4jAQhH0Z9cfPhOaw1A0J+49L8lgXlULaXpqNoSEFcoIC20wB1sM3b+NwIDG01TocCZAS0D0ROl4r5RutKCwUjsCQ2A0BefygJr5Ip9WX7wGQ3VJJYsEsWUWoPbzOEHTlreTOYyaPcHa7Yx+bARAJrDuYY5gFZd0DCi2mz53Ga3iAcp9+LUmij0soOh+hiIkJjAFyUBVyR3veOS8XvAf1Scd9vTXxVIJJSLETPd0FV+7bb2hzbZlDdlNm7fjZSU448kFQlrSTlfB7qfXgUoZUvVXdFZ5lJCwaMPQjnv/52XnmrPqvSkK7klmNluSzaq4ReM3RfCMB8dIm7Cbrsv4lACy1+tvPr1ma8oNz2iEHgRtg8lTEkZZiOEnrtSTnQ+8pGABMCEvf86SzX2bnV1Jly1vp+KWzsKsNNlapR81yPwJo8J2/AU9F+CfQ+gFvubotv85IZyvz7B/Ox/GUIFmC53Y9gNIYbYGPocGfod/gJwR26TQbls4U/mPsJZVMP7kKqLKAivY8/l7nWLp8KNaigGFNLPIJcslcJI1EovPqaTiGYErzjal3ijE9Ggmn23c8QMBjfWIaEMbgvjHu1t6x/5ll42OJOgnRs+SEpAfh2yQ6ijV1H/BcdvSiIrxKoWIMaAGjKhod2cs9Uoy8zbKPsM1hVmUEln9aLIVKtDTOeJLKwI+5spWGrpIe7WZsFIrAO0i5u1GRSnBzn1c0xe4w4C+kTs/HGsjQ1S7x/TvjPDfwQdGUXbAwiYiDuAZGvA6XWQR1wkxBCTvalh+d5hwOSQCOsbtU541SrEePt721m0au2RVVtunV3zNr7kYZSRSa7xHTKQrZbWo2esjIb+N1vH4wXFwcaopLNpWwVPndj7kK2FSnTfmwjTocFYcG6zXlTofbhiCW+I+DkRSBS7lgYVKY3uT5I6VWU4+w/J
 l7BLFrWs
 rkWloCwTxeH12wDspwYGU8nwn8SwfzJdRtPhkP9nf/EAvgq9fvandugKNkDE5yt+o+LtigPapIifnN+jF+caKeEBucvuvwUh4/JAxomu1EQXGH/jjAJZOP0k2G2V88lvOT/nZvViujSJEJ4bK0FQDY/KuuBN8wmAjU+E7d1K7yDAK/F+c5kEboXitdYMQ7aqH+CtYxEZeuJhcLBKPbJ+tzAGdnSvn6wEcL5kbSLsp4jdsLsQMDcmGhLfbScGPe8zG6qnclQXpFujthN9uJqHO/s8wzk/aB5ChMozE+N/MCrH6hdT1T0g1a0+0MPmcpAVeT/XgERLobYO0U65ucHfQnodfJPk1N5aT1wcJuPJ61Lf3Q/5RhT5JPcXm/KKZeMqbSzrqIEC5sezDh0wjmf6btzj/I1a/pOoHJyKB9z/3phVsG+N7LqOatoBZWckMs5y3pa8RwFNjfLRlN+em0k6mfA7NiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A few x86 objects are excluded from KCOV only because their coverage
is noise for syscall fuzzing: the APIC code (interrupts land in random
places), delay.o, and the stack trace, dumpstack and unwinder objects.

Use $(kcov-noisy) for them, so that CONFIG_KCOV_INSTRUMENT_NOISY=y
includes them in early boot coverage. With the option off nothing
changes.

The objects excluded because the kernel does not boot or hangs when
they are instrumented (head64.o, cpu/common.o, perf_event.o, tlb.c,
mem_encrypt*.c, pgprot.c) stay excluded, as do machine_kexec_64.o and
physaddr.o, which must not use KCOV during kexec once load_segments()
has invalidated the GS base.

With FRED, the system vector wrappers in apic.c are not noinstr and run
before the hardirq count is raised, so with this change interrupt PCs
such as the LAPIC timer can be recorded as if init_task executed them.
The same already happens for the wrappers in irq.c, smp.c and others.

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 arch/x86/kernel/Makefile      | 12 ++++++------
 arch/x86/kernel/apic/Makefile |  2 +-
 arch/x86/lib/Makefile         |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 31f46fd005278..44cfd3781c30a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -37,12 +37,12 @@ KMSAN_SANITIZE_nmi.o					:= n
 KCOV_INSTRUMENT_head$(BITS).o				:= n
 # These are called from save_stack_trace() on debug paths,
 # and produce large amounts of uninteresting coverage.
-KCOV_INSTRUMENT_stacktrace.o				:= n
-KCOV_INSTRUMENT_dumpstack.o				:= n
-KCOV_INSTRUMENT_dumpstack_$(BITS).o			:= n
-KCOV_INSTRUMENT_unwind_orc.o				:= n
-KCOV_INSTRUMENT_unwind_frame.o				:= n
-KCOV_INSTRUMENT_unwind_guess.o				:= n
+KCOV_INSTRUMENT_stacktrace.o				:= $(kcov-noisy)
+KCOV_INSTRUMENT_dumpstack.o				:= $(kcov-noisy)
+KCOV_INSTRUMENT_dumpstack_$(BITS).o			:= $(kcov-noisy)
+KCOV_INSTRUMENT_unwind_orc.o				:= $(kcov-noisy)
+KCOV_INSTRUMENT_unwind_frame.o				:= $(kcov-noisy)
+KCOV_INSTRUMENT_unwind_guess.o				:= $(kcov-noisy)
 
 # Disable KCOV to prevent crashes during kexec: load_segments() invalidates
 # the GS base, which KCOV relies on for per-CPU data.
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 581db89477f92..146cbd766c924 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -5,7 +5,7 @@
 
 # Leads to non-deterministic coverage that is not a function of syscall inputs.
 # In particular, smp_apic_timer_interrupt() is called in random places.
-KCOV_INSTRUMENT		:= n
+KCOV_INSTRUMENT		:= $(kcov-noisy)
 
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_common.o apic_noop.o ipi.o vector.o init.o
 obj-y				+= hw_nmi.o
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 2dba7f83ef97c..151ecee2229f3 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -4,7 +4,7 @@
 #
 
 # Produces uninteresting flaky coverage.
-KCOV_INSTRUMENT_delay.o	:= n
+KCOV_INSTRUMENT_delay.o	:= $(kcov-noisy)
 
 # KCSAN uses udelay for introducing watchpoint delay; avoid recursion.
 KCSAN_SANITIZE_delay.o := n

-- 
2.47.3


