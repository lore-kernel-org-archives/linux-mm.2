Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63CFCA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 10:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF42F6B008A; Thu,  8 Oct 2026 06:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4846B0092; Thu,  8 Oct 2026 06:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C756B0093; Thu,  8 Oct 2026 06:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4B46B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:50:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B89240233
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:50:41 +0000 (UTC)
X-FDA: 85299140682.27.85D6336
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012021.outbound.protection.outlook.com [52.101.66.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6D60A140009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:50:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.s=selector1-NXP1-onmicrosoft-com header.b=idgwcCOp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=nxp.com;
	spf=pass (imf26.hostedemail.com: domain of peng.fan@oss.nxp.com designates 52.101.66.21 as permitted sender) smtp.mailfrom=peng.fan@oss.nxp.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791456638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeIhYu3/AGJfVVAw1V4fBUih+F1wZBNu8ihRQj5kdaM=;
	b=kKWUl7x7KpvcTygvlrbyAdP8CJrlY5kZmKXks1OZ6rNu310zYc6qRzhZSl1alfugSFk+Kp
	HQI2vdaMpUytvItdlg5r+RlofDlhhsGy0Ypy9NhU3Sjw1nwhvZZtaCWvvxxFqTKoO7vatA
	9zzr0ZYVSmVdvzwpJ/j+NfnDtaTcCJ0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.s=selector1-NXP1-onmicrosoft-com header.b=idgwcCOp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=nxp.com;
	spf=pass (imf26.hostedemail.com: domain of peng.fan@oss.nxp.com designates 52.101.66.21 as permitted sender) smtp.mailfrom=peng.fan@oss.nxp.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791456638;
	b=QujTHp3FZ41XUTM+UVf8qK2/QUqL42FCxfI/8bJmh71eyEuWh9i2K7e82Oiq/jCc/L6KoC
	6iapvjj0tdmnRBUQFS6VfKbzjVbIH/BrU1LDxB+FAbMESMD5o6+tuozjIrotP3QFyijOVO
	rafQLinYO2veEKIkTeF9n1DQ1u7PRNA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBxeC7xosA8U9wF38A2G8xT+DxxmY+W1DWb2A+9oCwSAFX7ZVyuJ/+ucbVAvsfDwOGKqCOBf0SWudHeL0lK9pgD5E0YTvaXhZBJfc3zXJNu//48D9ANnDUxlREo30ENLqxFDTQHiVkN5+NDx+bIxqk2JHQ5q+0TARaxVY2VmB3hsKOWw+ktcWy3mom1bQ+Vl74Ts2oZ5iSir8mVKKbjjIKYzdpzruxSRH2I2+7XB621jy5n8V//duOQ1CzkGT+YSGm9bhUzb4rpRxbHccffuzwHf3Qw9tD2KllhjG/thzywgjNePlT/JYkoYkOevtygyheF8ld1Vsh74UbIu3gTAxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MeIhYu3/AGJfVVAw1V4fBUih+F1wZBNu8ihRQj5kdaM=;
 b=Ge4mDPYi2XU/EaEZ1aoDw3K1q7hUXZp5cnWaC7XEkFJKiZJgqm5sAe7kjF+wULDrkMXTtOaCUaxzOgKw7SqclCkgzE4ed1Eh+crauCaxRP3FZV34vDaXE61ZbWeOPwNnmLxCgarudnrpFMK7eKw/4MGvfmgiwzHqEiwESJ2VhBr+5BxW9V18SidrTdod1oX3peG/62Sarnv8G5m0RMWb4kxC3bhd4zX2zg+njTMWJ/pGbm2Jqq1MuKS9md8ylvjP4TrzGmQV7CHK0xsZVGovtIpnnWXq2tw5VKU0pyovzETlGjuUR0fPMWwpcH5JP8PguTzA5N4bmU+No7rKjMX2AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeIhYu3/AGJfVVAw1V4fBUih+F1wZBNu8ihRQj5kdaM=;
 b=idgwcCOpUQOuvf7RDCV3NMIsKdPhC9TLH/4U6uQ24nKu3Z8krkLjFfjIL4D1K8W54oHzYKqCzneojVHoLQzLF/mnhY0grQm8POoCRG59nWVELHAOiTIqXJPF2gbSmtkesBCc3eNiG4soZqYNYJnzhqLDHP+SLDsm/dz7YCmKXvy7tim/TNeqly1Gk8iI21RTw/NoybAUIyxG0ErVt0S92Waq+mbYGsP3en6d/rHkrWOs54nU0sfj32Ck4NnP6bo411PGpwH2SlsCaZvVaAf9/VEU6zq+dHLKn1HGspt6RWD4A2JkdFw05iN7SRDnBJ/CyNLvIxuhYTwfm6brFMfpCw==
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AM9PR04MB7585.eurprd04.prod.outlook.com (2603:10a6:20b:280::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 10:50:35 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 10:50:35 +0000
Date: Thu, 8 Oct 2026 18:55:07 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Michael Reeves <michael.reeves077@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	maple-tree@lists.infradead.org, asahi@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] regmap: Drop map lock during cache init and exit
Message-ID: <asd2iyVAnwBG7zVw@shlinux89>
References: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
 <20261006-regcache-lifecycle-submit-v3-2-37bdd82fd47c@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006-regcache-lifecycle-submit-v3-2-37bdd82fd47c@gmail.com>
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AM9PR04MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: 886cb679-2215-4d5b-b187-08df2529fb25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|19092799006|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	kAm+rAvEWzWiIGLSGpz4CJiamH5vUpvJqGh0HEFREluevDfVYIw1WBwnAitkRapKcwC4bp2hQeYZqgX+NJJRTI9RFB9PTdOCoGv9crsVLgl1RmgqJ0vwU/zdMLRRX83Kz5kdUqA9iwi+SN6wlCClOSCi9SVt6wuOKSwLC24F+PgtcSIDF11tbRDcvjUwVQe+DMIV9OE3dFref2mtJ0AXPeymIbd+Cy2nq0q9weW+GCgb5GS5rtcslER3hRBwwQAsILogsSaCOH63Txl9jiQIj/4zFN0HQWAiFaQdG2B3Q7sav+M3QYfbPuQE8KDDRpBnwixqb01SPjOsJjINmoUCnqLAq7NxX5tenos3TU9qLzunMBz8nL8+QjLIwO50M72umNXZZqPotDH/BRac9kqtXvESTX9Dtbp6wmWEslpMJlDoLnnaiExBPiDvqhh/vJ5IkDXVAkPxwGks3bB0nInTa62qsskRw4tSpYHpa5mGv9z/lgtLwH92uBRIVtgHEQjozet4XIroxOebaAOIFmwpi1iLxsKn3q+jJvmN4XJUZyBETtPlLE3UZyl558Rujal+9Gj9U3SRuABE8rkuMVl3eNlg4gVYjaJsWK5O2JwRwvMscBwz4c9htdCT7o6sAIEgsIaSWcDLAYzggxPxpPWJJ1OczFt625QU9/uljLqRFiw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(19092799006)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?evj4l8YpwL+1L9jmaRU06BwvyEaQRF5LI2CkTsCxVAMZgezxm4d7pF9/A343?=
 =?us-ascii?Q?JyX8uyFnXpNBm1x0EEzH0m30yMM+/5VJ9eiEugGiWlT1ihUs9VUjWiq+jsaI?=
 =?us-ascii?Q?ivZNf6imGx53s/Oa1SduRNs/cqbjyTv/+hyIkF7gVR6edmpJmQItmvmD97fJ?=
 =?us-ascii?Q?MtF3z34/wryLy8LR5fwlXmPF9JRDvovag3phaAIUL3m3+w+Y9nv0stC935KG?=
 =?us-ascii?Q?v4nBjM8K7m2j5Z+GeiUupKMgJdhc0hNGq5bOhcEO6fJCp4UQOS6T5ENOv6mZ?=
 =?us-ascii?Q?XYQKp0sQXfQ95IvNXpsyR5ua8WSE3rsPop58MlZudOWXt2a37+j9KgY0xBBZ?=
 =?us-ascii?Q?8+hM5xpftSyvstsZNcbllf4YKz6n1QronLr+s4UfA3iQmkq5Sd9zFCOBGdOS?=
 =?us-ascii?Q?UBuY4epTADY6Mtwpx3OSziTBOtx6V1FvY8wLBeBRpR2IVHv3AgZMSp18chOJ?=
 =?us-ascii?Q?sw+pSjuD3lxqK24YuE4jBM3u6AorQPok1d9+hhphRzn1wHnQrhrZKNXCZVtE?=
 =?us-ascii?Q?jvI3bSZyWI7+in1Ohnm1xL9Y2yJEKjCm4UvLkUwqgV8Txws6lviuFnsYvJed?=
 =?us-ascii?Q?XxxjcqCkauk9X8AcFuTygJMI07IsIIfG76E9VUFScJkC5y7G3lot7CJ/Bdnp?=
 =?us-ascii?Q?K6qoKI5/6gK9w7Nw3Jvy23y8AQ6XCVQVa/lc18IYoP31d1FbdBY25mB3kqPt?=
 =?us-ascii?Q?UaZCVmkMfQVTta1VLSzgIIaTNIVFi9IY+M29Y0lyPzlQob6SMofoe4o1LnYZ?=
 =?us-ascii?Q?Lbi+EN4nbiqhT5n7eeQ13I8I3WPI44NlBafDDFV5huxlmviKuEz6UPvTrp6C?=
 =?us-ascii?Q?lTqkeDE14/oK+BlYVwqYoqR4HR6+1KhlsNzrb1jOF25tzIUSiWJ5LTNxTKsV?=
 =?us-ascii?Q?0LAyN9dHPwaRl5dDfIwRPFr1EELyq1sCXMQUeNzi9X2pqghfO76Id/Vn6mL0?=
 =?us-ascii?Q?SDTha8Wv8tj5yS0/cad06RAAMuxrLAeXBacbhMWD41yHHBfB1V8uWjwQY3xc?=
 =?us-ascii?Q?KyckMhpA3OH8th0aDM8jkUAXdCXLwnrGlS6E22zjjOFp+7sjLl98To8E+6hH?=
 =?us-ascii?Q?WY3E21tnIfmYx/TDBkjXFei6FJ3hPlLVskBE6BqzAtT6nVzM1n6H1PmSiH/Q?=
 =?us-ascii?Q?U9d7Jv93XqcOlbghDma/0HmY/9cHW8UvAZHltbybWbnLEQ3nVkv7TW5AsW6Y?=
 =?us-ascii?Q?4zfcibyWVGI4jiiF8lobk8Hcis3uRluZ7D1674YQ5qc/6aST7jUCFXvA8z9M?=
 =?us-ascii?Q?ykYA2/mpKWF+HvZdYjA5joTe0k3DmKUssE/uWjWxGEf4zhW/wwaGZItH/Xyv?=
 =?us-ascii?Q?CLXTu0003evJAxntogLnD+qZVk34xJ36RucxrxGQ2YQAJT6CZouSHc/E4mFh?=
 =?us-ascii?Q?K5hTPMnwOocYt6wzPFQFzVemDD6txivBGeIDMzQWdAwUqzRQnWr8Xa59lZUZ?=
 =?us-ascii?Q?NYwW/M6A6vqyJLLyRpfE4vCPr9Jt2LS7Uf+YfDHOU17VcOBRoiA5nhp2WTbO?=
 =?us-ascii?Q?uKK3LZz3FKng3ef10L2eAfGp/AL9Akv6vW/9BmCoMluOmK91zA5n+HzMgGfY?=
 =?us-ascii?Q?WbKZJ2mv2Wy5GJsV8R9X20DFkCqkjQVmfGiTHk5MNTZTBjwxgEIyPelNHOiq?=
 =?us-ascii?Q?9TFAQHbS07gygrtyIPCLM933MEs06L482dC1rtQTSmmTzQNP701hIrNhu6PZ?=
 =?us-ascii?Q?laC0MxcAIPrVu63eylrrzBPu4NuDq/FRVv+Vwq7Dr1NVnNE/ZPQdBC7M3f6o?=
 =?us-ascii?Q?nZZawofjKeAjbJcNSU4uWWsXNKn6qLnPtf/V+xzHjLbVWPzqPN12?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886cb679-2215-4d5b-b187-08df2529fb25
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 10:50:35.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz/7ViEqWu3OX7YpUl+LSsb9atOZilc6CL7nrx9dzKLlFjtCbmwCH2l19MWD01+8pRqyjud1XQk1RPbwP0QstLUvfi087XDj+oWgVM9zVMX7woT8c6bzTLSbvbJfXTNx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7585
X-Rspamd-Queue-Id: 6D60A140009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 4doo51po39dph6g4ciaqzku91tuz1nak
X-HE-Tag: 1791456638-301059
X-HE-Meta: U2FsdGVkX1+KQsiZqJ44o0HB0UCyPYIlQIekVxyWn5K8CY/IR5Cw1SDDOz+wbiL3meIZ1P+7zXuvepBiJ1LStQnNJl6gksB5Q/ncX4hG0W9re1zMisEGcymExMkJpewcZ++418H5Tdt6abxYytQihbb4n6SB5oi/kkCoJ5IbbMVSk1DE1xT/dq6kj60I2YxcInmzidWqKOcrFRdL8V7swDEwdinEZ3kOUQOvuN9APCXJQEaogD6esN+M6NGzdNz0Xc1IfRS0lk0jkrH9n8Nn7mQ8yEwcFd8oBC8lKswPnlZ2A0//roCE9VQ5Yh7Qs5bX213Zm5LRPY3FLk4v5qJQf2TQwRT8ApHCaxZc7JqltpUc4dUKkNKQFdUEGNlKxyqaVpStisSyXdaHcsn1f6dlv5qgwnFQ8+LcK9cKMgUYDxyCIR8HoPdukhAz3r1APkAV5PZwaVk0eJXeHvL9627SM9Rfsl/Z6CVpyAL/PThPXn+TvlC+juObMFta05omfO2qMRe6SdlFw7hffTEcuUHjB+KEzjt/kO5aBcEOR2B2fZ4hVdDz1joXEmBN2xrkbH+e7a3/0PxgDplOruo1bzzvQY+vS8/8nuwJv9Qg+J7IOO9KNqN+/ii/Kr8Qw5srAh5zz/wYHHqspkZRPHxxzIn8rHqhoLUSGoKOPAraQmfz/xhwrhQO2fF+GPH/Q7Idh43cPUrlu/Xi6bi5wjwxX7uEODNou1PdNDnvC6cTLptP4iH1Ah8jaaC+DUj3xvFT0+ignq9YuwflJkoU9d2kPL3O3nmzvDVx2oSygW9oy942S7cvFUJ5hHGNodUUv0xO/JEhBm3t62dp/0u6o45gCR9Sv85u606nYL72wf+Qy/IFBEu0BZslnogmkJuEgu5W+apSzdsNZ/eb88OAxAQuLdSPxUQh7iIbM36aCTw26q6eKbY64zWfeZtJJ6zwuqNsdC34GfuToSnLl9fN6BKGsiq
 WmtRpYbs
 Yr5r2233M4OGh32zhIo8y4LCjLhzrBpftCw79/7Pe1TV75GQVR2B2fYEgoGT7vFpOmfGtg2tjeIDD+iPwdbPgl/UMRh+C+shzkG1lP9wFGaitxz0JZvpIG/d3RLiFQ+mYODa0kv2POPB0y3PWkUq+2ApKY/mTv4HPUdyb4PJ8JvU9JzkRlvrHFE97xIAhpRxhP/we0Y7nIT8piFMftLEPCxEND+/pQb6vdCaWio0DGOzjgxABBMJRm9vRjHy5nBvail1DwOz1sRjpY7iDtnHlx3a9w+j6W5eeUcnfzguLxVLSDXHQ4O5GUp/B19zJPwt9JZD7MGj4gEZFnN8i7Z9h1OE1WI4Y39FoOzYTnrYGOAoQ6K4UiSkvYOYUU97TZAgDDzVgHrrxGDo0PryB9SZMWx4I0NJUUmi/lskzaT9jg80MyNIqVFNRkIAEYYd0bKogs20DrYtPSxEA+OU1MWNrxNvM68B46IyYaEkVqUfT5bQ6tzDsGnAJQKdnJ51e2FrBmwu7vXfPVC9PDa0LPI6YUjtmgENRJfP91QM7Rim/vD0k/VMDkkuYTvviknRyP5tbfQ81MBhZTiN8PRhHURsq+axzSnEHw/4AF2GeoGk7j8B6kArUbOxB6D+wBF2YsOSFzelcGz5+2PSWwHgIlOJKOy76hcc5t9GGyhItgUvSwDD24RLrEw1ObuEiu6a6pN1200kHkmFQoa5ZrAgqoZGCkMndB63riyFIJA4U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 06:03:16PM +1100, Michael Reeves wrote:
>On systems with CONFIG_PROVE_RAW_LOCK_NESTING enabled, Apple GPIO probe
>triggers an "Invalid wait context" lockdep warning.
>
>The driver uses a regmap with a raw spinlock and REGCACHE_FLAT. During
>regcache_init(), regcache_flat_init() allocates memory while holding the
>raw spinlock. The memory allocator can acquire a non-raw spinlock, which
>causes an invalid raw-to-non-raw lock nesting error. The abbreviated call
>chain is:
>
>  apple_gpio_pinctrl_probe
>    regcache_init
>      regcache_flat_init
>        __kmalloc_noprof
>          __pcs_replace_empty_main
>            refill_objects
>              _raw_spin_lock_irqsave
>
>Cache allocation occurs before the regmap is published, cache destruction
>occurs after users have stopped accessing it, and regmap_reinit_cache()
>requires callers to prevent concurrent access. Remove the outer map lock
>from cache initialization and destruction. Keep it for cache population
>and normal register access.
>
>The Maple cache still uses its internal spinlock during teardown. That
>lock can also be acquired from hard IRQ context during register access.
>Add Maple-state irqsave helpers and use them during teardown to preserve
>the lock's IRQ-safe lockdep state.
>
>Fixes: fd4ebc07b4df ("regmap: Hold the regmap lock when allocating and freeing the cache")
>Suggested-by: Mark Brown <broonie@kernel.org>
>Suggested-by: Liam R. Howlett <liam@infradead.org>
>Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>

BTW: patch [1]
     "regcache: extract locked helpers to replace open-coded lock/unlock pairs"
     has been accepted into Mark's regmap for-7.4 branch. So there will be conflicts(:

[1] https://lore.kernel.org/all/20261002-regmap-lock-2nd-v2-1-e172b0501c52@nxp.com/

Regards
Peng.

