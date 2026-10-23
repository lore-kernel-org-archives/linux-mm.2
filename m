Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6683A60A260B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codasip.com header.i=@codasip.com header.a=rsa-sha256 header.s=selector1 header.b=5zxeO/07
Received: by kanga.kvack.org (Postfix)
	id 817CE6B0B78; Fri, 23 Oct 2026 10:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF596B0B7A; Fri, 23 Oct 2026 10:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5546B0B7B; Fri, 23 Oct 2026 10:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 382F76B0B78
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:15:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB3121C3AAC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:15:11 +0000 (UTC)
X-FDA: 85354088022.08.90BCDAA
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023085.outbound.protection.outlook.com [40.107.162.85])
	by imf05.hostedemail.com (Postfix) with ESMTP id AE09C10000E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:15:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b="5zxeO/07";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of florian.schmaus@codasip.com designates 40.107.162.85 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792764908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuEivVLgJ/Fhb+XaIVUIwLAMftFslAg4MhGR08MtZbY=;
	b=TiYGH52/dnSACFxFj+zS0atAIiXe73pFGXFu0748NLrxTOTqUaPzT9z3AzlMkmjQkuTunC
	mr2dAdw5jkxcD0+Lg1h5hAen0YIrrlb+Odnh1aeUwdg0/BNFCHoF1TsBuiL1F9NAiWnpK1
	ujjVwsLuTY1FOQMplMPh1BBMYm7OWgc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b="5zxeO/07";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of florian.schmaus@codasip.com designates 40.107.162.85 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792764908;
	b=pqd8f6Rwatwt5DASUE3FTkjvrlAxC7EMM1NXm/XQjwXEgk/v8ZzUs0cq4xj3iVKSL/34ER
	n+sdrL/iGuiMDIBq5Pb14RubBUQQypuvCBMkwWe8AZEgdC1LFxHs+HzGGKEWovOdr16PHG
	1bghD2eZpFj3pJA938Vt55NJ+W8dW6k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+EeNFVf2ZY3vZDhyaxw7KWlkQlMQ3mL9cvXb7awtcjBPYH/4gzH0SR0S3a5zu4mfDbvBVM011Y5G4ZxJ9ljKMHdRVIwVX+ntK6nLA+xoqYHvfoMBPRVYdo+f0sUSW7FbFcnv6HEv7N9oBQ04IEouKyuRP2/kO6BkvN4PivakD9J8Np4SogmrVkAVbbs34ImGTlBlxjEvMCaI4eSgLbRT3igkhkCZ5LO9r/Wk7MthNLdnH0TNNhDwLSf25frt6yGWHITIwpTt2NE7qcNRxzG8FSDxYbEYntPAFKkk+Tj2Xw7CjdQz3ccl1BYqkpyFR7AtdfHILQy+n1T1yZ7QvwG5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuEivVLgJ/Fhb+XaIVUIwLAMftFslAg4MhGR08MtZbY=;
 b=R4jJQ/uq/7DpuGcXGcmA0yLTh6mM+qOAoECjW+VajX3vdIPGeQtlvR0F4rtGw3zBFLQRIghW3MnNk26AkPDJPgvVmKplqng47YmQoIKyeWTiD3LbQQDrFF4nGF5t/EpzktQKoVOEd99AdvarVJx9mZbqrrmqOkj7IBNY6LpkgKPFG3CktuvGRB+WEKlN3NkvKvIa9k2aM6Z/TgGhy+MOa17D7jawfiActJRyZiSvwM8fzTIM6LZOHKonW7XEc/5z14MS+QP+Hhf+hKu3zRUxHfP4ULx8sGZMWUgJyKDW/Tm6OUP17HlUEVlgspHqcWJT0g2FD+THx3CCFEQObqyP9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuEivVLgJ/Fhb+XaIVUIwLAMftFslAg4MhGR08MtZbY=;
 b=5zxeO/07VpT8D/PMJuowplGmpnomXvTq0wjiTS3Kh3/4WgNDBNtfveX8Ru4h1fCkfWUa3oJ11F4D5eDAK2dFVWJwsq2z6PEdHqt317NKqDi6OZctgZ69u/PZ3dfxE2Dnqv9urhjSBgdKAaxjBTujBDaMZ2y30/qYVrBI4PedqMnRp+eZjdk4vVCDSvSILuD3xv4YKJGNAonHLPSd6huLqfssgnGdg5C/mFtOHUNnAv4NoYiiIqfnrz2/riGn/hBGnjkD1n+UGdNAiCjCBar1OI4acqcPxKhLz78CrxrT8LjqRocQge8CtRQ/duWA1mx6s8jdH9wYrgPWn0x8qoae6A==
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1f4::5)
 by VI6PPF0AE9EFCC4.EURP192.PROD.OUTLOOK.COM (2603:10a6:808:1::204) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Fri, 23 Oct
 2026 14:15:03 +0000
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c]) by AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 14:15:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 2/2] test_maple_tree: test maple_range_64 node in
 RCU mode
From: Florian Schmaus <florian.schmaus@codasip.com>
To: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261005-fix-maple-tree-range64-rcu-v3-2-ebe7fb278e20@cslab.ece.ntua.gr>
References: <20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr>
 <20261005-fix-maple-tree-range64-rcu-v3-2-ebe7fb278e20@cslab.ece.ntua.gr>
Date: Fri, 23 Oct 2026 16:14:48 +0200
Message-Id: <179276488829.1655926.9998832837982828676.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2256;
 i=florian.schmaus@codasip.com; h=from:subject:message-id;
 bh=kK2/Uh1p9cOyF4JKh1MU44IYAko1XFJEO1+Pt8Tya78=;
 b=owGbwMvMwMWoZLn8xddWhSDG02pJDFm3s588D3sz83DfDJXNfa8uTfWMXLmgb9qM805hb9yPx
 dr/XyHD0sm4noWBkYthppgiy/RS1vlWinceZj/5vQ5mECsTyBRpkQYGIGBh4MtNzCs10jHSM9U2
 1DMEMnSM4iFyegwamcXFpalFumkFRQ55+SWJJZn5ecV6+QWpeQXpBXppmWklGRn5RcWpQCP08lJ
 LLM3NTQ1MLd2MHY0MXZxdDc2cXE3cnBxdjYyMLR3NXS3cTC1MjQxMjRi4OAVgrlET42CYfrRs7S
 bjz0u4ft6T3SKRvrWkPVH9z6V7XM/9/+crLrkltcdFrvH3dJ3yDK5332U3Nmy/oPRu35upt//xN
 t5yde77E+SdkS3N0MfC/XL3KYuFkU1ceQ2v9cr9RN49uxZ+P+//NAcnxmOlU6/+90za+WeCqUne
 FZs03j5bD86Cm+vn2Tx2sZKT3zD39zP2KSnabFqnmipXnD9fUjg3ozv4ouBlzsut7Cwl2RumBG9
 NmVZYXOT+eG2e2X+rS9nTPY/c2/pWeML2QxwiIVVKzocaVHd9KAjz5F3aGcbjs6r/wKrYI7c9K/
 5ecZkY+bXzxyQ3k/2M38Unx/apLebkYzITEZT7mfoy6P2m4xZnmJsA
X-Developer-Key: i=florian.schmaus@codasip.com; a=openpgp;
 fpr=1357B01865B2503C18453D208CAC2A9678548E35
X-ClientProxiedBy: FR0P281CA0049.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::15) To AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:1f4::5)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P192MB0983:EE_|VI6PPF0AE9EFCC4:EE_
X-MS-Office365-Filtering-Correlation-Id: 912f6478-6849-45f0-12db-08df311007e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|376014|23010399003|366016|261009223027099003|10067099003|56012099006|261021121427099003|18002099003|22082099003|4143699003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	HstD/s5uS0OysLf/exWJgmaWvFMAOQK2aYaUTWkFMYtStTaClVXZgk5nj2ZUOnKhxW5mz+Z2ANKv57f8HFg6AxOUXcpmA7eweHWaCw+akiBVXczo5jE8mYutG/14G9cgCssmIgO7LFQYpA29jsmZaJS6ZY1gna2NTv4aBTysNouKfM/1vEp7VHptjkS9kCJviUTbbjwoKPYoa9VkqM6owcGQt3blPkgwAnu+ek1arAMmNcQktLOk1fgcQ9keIR27W453BwOKzxjJLA7FNQmiao7SLmI9qE7/WdWqtQ1rpjBNdVycvwwLGAfmfuAZnjpMZP5MnNVqBNQSmx4rskjy3RH6IVuMNUQJnJK30vfwL5lkIU2B5HiqCWPbSlK0mUTA3GzHnxfxNt38Nkcyo9pzH/C7QGWCj7jnHt9cDl6LqlSyOyMz0LLwc/+aL4pzfm3EWgAxfqsSNPor8Jop6RvkPI2xK2GDR9PC8x7p/984ocSNCdQ7mBXVxgn3fM43qjs9Yll67vZZeBmXCmsS+cVdiXKvVWhL7iy84PzRjC57r6Fy9FGsdU4RZoO7v74PtmXxR3NPeM3E3LUYbcLUVDxwkCy4AseFb4vCqaVOVW4KpEb6lVtIftSSNDtlhmefyuZd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P192MB0983.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(376014)(23010399003)(366016)(261009223027099003)(10067099003)(56012099006)(261021121427099003)(18002099003)(22082099003)(4143699003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGJVZkFRUWNVbCtRWGc2dmpLOHV1dDRqNjl0QUh4UGp2TUQ5c01lbGhYcEE2?=
 =?utf-8?B?MnYyUXphSnZuZFZCeVM5d2F6MDdVemxFaXpUZWRqdkFOOUR5d2hVTDI2MThD?=
 =?utf-8?B?OVZnYlY3Nk1Rc1FxaGF3c0JFZTZCNm5taHd3VGZQY0wvQzIvb2I5WHp5V1dZ?=
 =?utf-8?B?TkNWb2E0S1dqR3lUZDRNWEdKT28xT3R6MUxKUXBHblNadWY0YjFhU1BKSEhC?=
 =?utf-8?B?aGNxUDFYMWcyU1BoWXo4WE5TTkQvWXg2UlpUcGczb3FiOGM1N29WYTh1NnZH?=
 =?utf-8?B?czQ4OGl0R3FoZXdNVjdYZk1TdGJzcHBrUW9Zai9IQUlZUEV6dzA4NE9DQUd3?=
 =?utf-8?B?Qk1ldjRrUW1UQk5ocnJnVFNGR09OTHlmSjA1RUJpOFNZL3lHMHZ4UFpRb0lj?=
 =?utf-8?B?ZUFkMGhGU1E1M1BnOE5admhyTVNCd3Q0NlFNSVdQc25ScjVER3BSSUt2eDBU?=
 =?utf-8?B?elVJa0tPaUxuN3N2YVRBVGJldURCMTV4aW9CNlhsbG9BUHREUzhvbTF4d0pa?=
 =?utf-8?B?VngyL202ZWZsUFRUZ0Z3V2dvWVA1THF4YmwvTlpvNlRuMEcyN2ZaYUZzcUtL?=
 =?utf-8?B?MXpKREREWkEvR25Fa1I4NjR4MzlSYnJVclZYaXVVaitzekR2OXFxb29VSDhF?=
 =?utf-8?B?MU9JMkdpb3JndDBScThXYUFUQjI5eDNQNGhZeEdzZHVEUC8wWm1QUWprem94?=
 =?utf-8?B?ekQyM1N3eW55Mk9qaFFZa3hhMWR1bThNc0w5bVNhV1FHaFQ5SHBta3JBUUVP?=
 =?utf-8?B?UG0zTHpkYlJ1VFkxdFRvYWpEblN0TjJGczBGSUtmdDRhUVg1SnIvT2k2MTlE?=
 =?utf-8?B?RzYxd3NwcDVWdnh0SGdlZEJtdWtId08wemNteXc5eU5Va25TQ21aZStqcUMx?=
 =?utf-8?B?U3lkZXpRQjlEZUczd21EZ3RyRzlzSTFWM0FGNTMrSkc4Si9Da1FIMkZQeTM1?=
 =?utf-8?B?Z0NROW5QeFh0ekpkcVcvT3QwaER6cFI1WmdTbVRiclI5YzhXU29peHdFNnl6?=
 =?utf-8?B?akQyLzEvK2JuMjl4eENoSGFaWGMzbXMwbDZCbm56bUxHRXUxY2FaZCtMc1Bu?=
 =?utf-8?B?dVgzWkVEZzV2MU9Xcmw3anNiek04UGc2MXI4Ymlnb2hQNW9SeVowT09XRkhh?=
 =?utf-8?B?K0lIS1kwS3BhelVYTjJvWFdLYWVMQUhUS2dsS0EyUWtweFZheERoaHBBazcx?=
 =?utf-8?B?dHFtRmFQNkJUbWFnQWJJZ1B5ejVsZFlRRmJMODl4NmR1WklYZU5oNW10R2Rp?=
 =?utf-8?B?aXl2eGhPYkVqSjB6QVZpSkRXaHUrRjdYdjNrMmdiSFh2M1lkM0h6dlRXaWxF?=
 =?utf-8?B?QUpKWVdFZDYxTFYwcDBQN2toTUhLWGpQUVl2d2lKeitTbmw5ODlsV2lHYkgx?=
 =?utf-8?B?NVgxc282T3FYRmZDSjF0c0hBL0ovVEJ0bU55MU0wdlFoVVQvMDc4WlpsaG13?=
 =?utf-8?B?LzZXV3JWNFNGTk1CNzkxY3NyTFV2bGx1UkNlN3UydDJqaGlaMVBIVU1QczJs?=
 =?utf-8?B?c3pGSHMzVlJZMEJreERuZGtIVzlWd2VHK2k2VkRtczJ4MDE4RVhRb21GdWhE?=
 =?utf-8?B?NVMweFhIM3RXekFOM0dkMmFCcWxnYjlUb0NyamlwUkhSdnQwdFdoT2srOEl0?=
 =?utf-8?B?Z3pwYThzM2VOM3dMdUpTM0FIMGw4c2NWNWVtOWpLSGI1N1pWczJwUFJEZktn?=
 =?utf-8?B?TzhrYTArNXM2T3orUXgwRHI2UWRORmxNd0EzYzNpRXNhcU5Wc1VpS3NRVkJK?=
 =?utf-8?B?RUZyVktCVVpqRUhMVVhnKzk1SXVYbGpVV1RRRno0UGhvUEc3amxhM3ZJbGFz?=
 =?utf-8?B?dWsyNGpSWisxR2JyWS9WL0Q3RmxMVXFjOTZ4dTFVSXZjQWlpTGtJL0tjNlJy?=
 =?utf-8?B?T3BrcUZ2REtLN2dQdzZLdzMwMTNuLzJEejVUSGJjOWV6M042a2VDQjZnSVdm?=
 =?utf-8?B?ZFdScGprUk9MSmtUMDBEbGxhQnZqSUFWeFMzMEkvUWMzeDYvK1dnaGhtSFpp?=
 =?utf-8?B?NEN5RklUcTF0aWJYUlBwZFVIV1Zsb0RadDAwUWZOdVJPZi9XeUEyeXd6cEhE?=
 =?utf-8?B?NHFReWNULzJTNUVSanh2VUNERnl1STh3MnI0d0RpaUZMZU9ZMkR6Q1JlYUp1?=
 =?utf-8?B?enIrUHNma2NQWjhGSXI4WndKWEQ0Rk03S1RVN1ZhVzlPS1ZUeTlrNUJITzh3?=
 =?utf-8?B?OGRlVUVkeklVRkVzV3dkczI3YXNZOWJ3YWJ4UG5ibXYrTU5kRUNVa0xoRk44?=
 =?utf-8?B?Yis5aHNQUDZsNGowR0RqUjdmeG5GemtsKy80cDhzUVhQSnlqeWFOVEpXcHJp?=
 =?utf-8?B?dXQ5MlFueVJPS0VRbklodXkwUVZHWitnQXFMaGZFdWpEbEdXQTg0MlpUUkNt?=
 =?utf-8?Q?mOMkq6P0zX5zNAMxYjG+5AN8875HkH8dIYlWX6SGKL3JB?=
X-MS-Exchange-AntiSpam-MessageData-1: 7yq+1OS076UTEr+IE2mjIQHoxAGRM+TxLKQ=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912f6478-6849-45f0-12db-08df311007e3
X-MS-Exchange-CrossTenant-AuthSource: AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 14:15:03.2576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JtpAV4I3x1n9sF8Vl2mE2zNTg5XFE4lDVlqCA/dRqhulhnAfLSlVweZ67jlCEQJ2hqRsyiG2197cDXYhvVMNdNuky71t8AilNEPKm0didcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI6PPF0AE9EFCC4
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE09C10000E
X-Stat-Signature: mbgoh38nqtibnq877hiqcjifohnb8t5u
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792764908-392864
X-HE-Meta: U2FsdGVkX1/vykkC1FP6Lm1vXJul+x/azcbkQQ2SyK0rfyOSZHdpzTl5E+bI1XnFKSqAwW0frFYP+Qycd9nXBtMRab/PFfgsxClRZAYKd1iorx4rVduzSP9hpY8k66cHkVvuF2rGMVqMbV8Zse306R7QeZ4ePYVQXX7ZffZxCNWS/J+FvzVVihQ5MK32iY5o9GQtcccN6u9uT7dvHIzPDZCwbUf8PAOdevY07fMemlQfAyeE5MXmYjF3RVbL3L63j7fgJ1jPe6I8cIP/VCxKRTlJ+zJLtzR9ntC7SB0dOIF7i7RWw5XwdZHGJ81LkhF9a4MYYUIBNZn92C8Qhwa3OJ5/9LN7X2kAEpFsPJHQWWrGMorWkWNcVg+17mMNVpWKoAtJkbA6kJbzUZjcPZetF/7W5BKGFs+2clIcGv9z9ZjCpNI3O8ZFOzeioxBAwYov3q/2iPR88LGhATzL1+eHGMdj5SuzWwZWLBl2hitVm6Y8phV+VDG1C0kJO70owc9LSY7XT8iiW9rG5L9rIu3QJ+fuF7vr5AyISeW1XLLf6z42Tyv7uzvuEba5hbWqyrBgOLRpJJ3YWQBs9oXxU9mVNkE9h6H8hhxYLDwWZx1sPLb3LdMKCIOUQhsljPeJkaBtaBTXibbzGD370c/prXTen8qfllfPFK/QQlnSORPx3Qh5p1Zbp3ub3OBhMiuNOat6mT0HowzmYMDlcWykiyMKIvcRvcg41PoRi2Req87sea/ZP0DHqbUcYwjCiRdZacL9kKAMvniVJzV3aBXBlRoz96WzVT27hqyCHvrGXLUnGmZoxjFVJZ1hsmO5sKD1LcPYIjAOHavls/PzdrstKP1BS9ZwvMm80TG12lDSqW++KnJga2nHFxppfmXsjjcuW/M1m5oI284D1L8IZ7sLiJ07tCX5Rl6pHjrhpW4dT53NbkkAWD3NPi998KKOv8zmW3+LUf2qAV3e9UJhIvRcNNh
 CKsIDTVZ
 2xHEUEzANYJc6ugS+ZPUp9uK4Pf+ugex2b/a0Opb7IaYpXasqYHFFd/sGoTT8LZIeRJsayfiNVHRQREDT+c1yDymZkidTWCRJkee8o0qSHSmuQYF1/rfRsjHLrNIszRCI13XMSo+CsHUpwtuy/zp6b5yoUVScZjYjLkgk8Fux7kjNZQomBQQ/rwPbBR7LhqG7xu1HgopQ06nQS5ciUn+qRDTKxEujWSavaq40L+JN77R7SCR0nqdmV7asARFnDp+wiz4bzHD4QyKidY+jAsiSEL7NgPAA4qEq67dPgoos2Jf9hbkpK519o0oxs6WwihjTcyy7MYjeAdpb7qR2t0EU5W/3QxmQKsQCyCGivvYmmvA2/xHuJfr2sPch8EU/DMLUVKrN4w2nfJtp7VE3eB4iT643ma+UqAkgkK/cMnFN8g8i0wsQfGFf1fCXNK8h2QjLthXGAvvQyM43HYyEcZPNfJZlIFwvvVO4EEAZMqxHaRYyDib4nSfLiJhbIx1D9ycJrKHN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> This commit adds a test that builds two maple_range_64 trees in RCU
> mode.  The first tree has a root that is a full maple_range_64 node and
> ensures that the destruction under RCU does not misinterpret the last
> slot as metadata. 226 insertions produce such a root on a 64-bit build.
> 
> The second tree is a height 3 tree whose root holds 15 child pointers
> and metadata in its last slot, so every slot is non-zero and ensures
> that the destruction under RCU does not descend into the metadata slot.
> 3166 insertions produce such a tree on a 64-bit build.
> 
> Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
>
> diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
> index b9367c61e8b5..fb40e193a3cb 100644
> --- a/lib/test_maple_tree.c
> +++ b/lib/test_maple_tree.c
> @@ -3710,6 +3710,36 @@ static noinline void __init alloc_cyclic_testing(struct maple_tree *mt)
>  	MT_BUG_ON(mt, ret != 1);
>  }
>  
> +static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
> +{
> +	unsigned long i;
> +	unsigned long nr_entries = 226; /* Build a full maple_range_64 root node */
> +
> +	MT_BUG_ON(mt, !mtree_empty(mt));
> +	mt_init_flags(mt, MT_FLAGS_USE_RCU);
> +
> +	for (i = 0; i < nr_entries; i++) {
> +		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
> +						      xa_mk_value(i)));
> +	}
> +
> +	mtree_destroy(mt);
> +	rcu_barrier();
> +
> +	nr_entries = 3166; /* Height 3. Root has 15 children + metadata */
> +
> +	MT_BUG_ON(mt, !mtree_empty(mt));
> +	mt_init_flags(mt, MT_FLAGS_USE_RCU);
> +
> +	for (i = 0; i < nr_entries; i++) {
> +		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
> +						      xa_mk_value(i)));
> +	}
> +
> +	mtree_destroy(mt);
> +	rcu_barrier();

This case passes on an unfixed kernel.

The bug that exists today requires a non-root node with 15 children and a
tree of height 4. The size-2768 test case in my series covers that. You can
find my test at

https://lore.kernel.org/all/20261015-maple-tree-fix-slab-corruption-v1-3-160d97f7304c@codasip.com/

and may fold it into your check_range64_in_rcu(). It fails without your (or
my) fix and succeed with.

-- 
Florian Schmaus <florian.schmaus@codasip.com>

