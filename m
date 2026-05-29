Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E9A3CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D153E6B008A; Fri, 29 May 2026 08:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBE06B008C; Fri, 29 May 2026 08:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02636B0092; Fri, 29 May 2026 08:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B31096B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:17:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4197F120D3A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:17:53 +0000 (UTC)
X-FDA: 84820358826.29.24711D8
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020140.outbound.protection.outlook.com [52.101.195.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4956E12000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:17:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=kcCMigjk;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.140 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evFSl6reJy3lq4Joswy8Q/5XrD4+CnW9uJ15pMopzcQ=;
	b=v1gwtz+YAknDhgc8gEg+atSuv+skQC1ZWKarAobYdAc81i+GL002/aoDRkH33w6DW1SsKi
	Ed7MZZNG/fxbepQzxitSnY5nTvxDwophFIZRqij36hlBPrFopagYewJvyIjGzn4/xbOUL+
	2hO8DOC0OXJmbPt2pnLAAgg4s3YtRTY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=kcCMigjk;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.140 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780057070; a=rsa-sha256;
	cv=pass;
	b=TqUrKiC59fbU1TUhBMqM9mmopwlMAycvD4YS3RB+Tiox4xAVkGkywnAU0HDBtBsZHmDPKc
	o6u5QUlWK/poVKuk4qRUXldpESLKi9X+QLCb+dJz/acXQW8+ZOXbd4F5c9dWeAxZHeZF6i
	ObrEDv/XYrB+AUXJRgKN8vj8yPaWYdo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nFy2xBI39bS6JUi33/FB31ul10w46rEdH/WHRX8pzwWZJ/+7ma0A/Uvt88jH49jvzewnUUmG/BkvGUdL4VDzESBQ2R3N340qIH7VHOx/6nlBI7ETTIJU3kvhb6sA+e+Ezrzexh1uBxXMbUcTzHlxNhhldHKFYt87orWnWd5oJsMfQLUK7NfZdx3or92UXC4z2qnBpTNpG81xCctuU7GvyB7NeBOGUB78lDvSHh2O2JNf7s8cm6PvdIGQfm7m5TILfxik1ry84xTXe1pXP7phnhv+Z/U+Qp6hGUJZYqGaSd5cF2b6T5NweXckGUTNIr69KWx6yg+hVE7Bsfx4lEsCaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evFSl6reJy3lq4Joswy8Q/5XrD4+CnW9uJ15pMopzcQ=;
 b=nQXgpjbFdPviRDorE1pYmx/UML7mToHFJgmVY3C0LCnzInjnPE0mZda94Vkb4B8V1+64ZF8Mrcla+CZ2zoO8hrOiSJUCAfyMcv07Svp8U2RedvDHz0hFypxUt8celrqJy30qvLYEkMm5unIX5hACWjTaI5Yw6LT6RFfyL8/h5WK8N9W7C0TBc4YDKMNH2qjKW7V1W7qP6f3Ol1114oVpyY7DoB1k8AIQ2XevRh/yQ65/icR9IHMLXfOVb1bC7Fsv9CuMtxaonmOUfNOTipLaD8rnsbI5ayYUUA+8h5zP38t4Y0UcSzJhcRhvldEscotB64Tv0PL8ddvFkRlNmDhMfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evFSl6reJy3lq4Joswy8Q/5XrD4+CnW9uJ15pMopzcQ=;
 b=kcCMigjkXnvHlurUUZYbKzTITE8yG+Y6/56qihlBo5qKsuTsijr6mT/4f7C5H02aOhwMMsfXWsgAVKklLD+YNY4wD/xT2d8pmHjAVcfcJtDSYVUgeoDtSOupL6C16SO7q74IGx/Ep1zyAtagqifbfQxXq0AamRN08+NAVg7ncHg=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LOVP265MB8757.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:489::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 12:17:47 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0071.014; Fri, 29 May 2026
 12:17:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 May 2026 13:17:43 +0100
Message-Id: <DIV5KDONJ2NX.1HCIRZLQBZTK9@garyguo.net>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rust: page: mark Page::nid as inline
From: "Gary Guo" <gary@garyguo.net>
To: "Nakamura Shuta" <nakamura.shuta@gmail.com>, "Alice Ryhl"
 <aliceryhl@google.com>, "Miguel Ojeda" <ojeda@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260529085316.27432-1-nakamura.shuta@gmail.com>
In-Reply-To: <20260529085316.27432-1-nakamura.shuta@gmail.com>
X-ClientProxiedBy: TLZP290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::17) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LOVP265MB8757:EE_
X-MS-Office365-Filtering-Correlation-Id: 99799805-a65f-47f3-e46b-08debd7c4b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	EifIeGHu8I68GNnltzqDmeQvlhufJsdLV+nd6JuLfUbD0ZUKirllpHTIPqB6+MDmhBzwYKiOP2bnbZR0TSo4tuo3+efHSr/qOYdfGFRF/gMPXARm9gk+7uxoe452PZ/gPl7yPjmHct+cR8w/QBH8bKM+abGlc8PvuxAvc8ZrICpQhGmJCCBgJdWvfYACdobUlQ68JMevRqkk51n9cufW6bcmvRn73YWb6E+gYTb/BQWhlU5ymHJ+i647VYcUUFvmRQuuVoxYOKQMsIafNy1y0fqEOpgZZjO1FNNX7RGl7JFvvmNc8dBN6Vv9G6wJjAXkEnzMfcgURe+yGIXixwAD648gA9uOTgyJg9OTLFidS/13PE4zuv1piDTzPRBFvVluTExqU4KTHA9I8H2k2cu8bUjPt+TnWg/4mx7FcT7o6lc+Li1pCa9yM7/Z0nSvgwlIvC9MXmuHoFWOfSKjmhU4KVJf2fdKLSlPiZKh+5vqTg6NXb2ZlA0KOYQ9+CI8Zga8ow5WMdG7Zk0GfccToD3mMD7EsNtPAVA3A76AvW5x6qtFopdMFDdthCjN7GjwU7twSfmhpVC00TX7m/TKVL3dGNLMAPivPsr01o7OjHHW5UGEOzqHnRoNBr4CGW/Z/Y7jMId+jpA+F1Z0llQTSR7mOcZ/hMAJ4yFwy93fryXiOXivzO48oJjxAOynfAPHwMPCWjQQ9spZTxFFgIBwQoklog==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTRxclN4c0dUemlrajRNRmYxNlNNSkNNZnlHUloxM3Y5YmY5NmZsU05TVk5o?=
 =?utf-8?B?c1VMbDRZNzM5RmpjaTY2ZndPdElZRzM4QXMzamMyN0R4UTh5L2N1cGRXSTdQ?=
 =?utf-8?B?aVVlSU1LZHZveGZYaE1JcjdvZnVSQnd4QlVkTVVFWlhTYTNneFE2Rk5NWXFj?=
 =?utf-8?B?SzFyR1pXZWZINDRrWjgzUENNUG10UEV3Z1V6RzdsdVBGZmoveVRWZy9OYllS?=
 =?utf-8?B?SHV6cGxJRlZMTy90Y3NBR0ticjBmdG80TUtiOHZLUldpN2FSK0dRTXN3dmV6?=
 =?utf-8?B?QWRHblk5a1RHSXRRSDFSQVA2a1FoUFN2S1pKdHVqaTduQTlNM2ZjNk11dWdE?=
 =?utf-8?B?WUxEa0J1cHNBME5CalJoKzNLY09yM1JlZ29OTEtiMjQ2bjdEN2N0K2dVWGVJ?=
 =?utf-8?B?NTF2MkhoazhrRUw1RXIwVHdpNTVCTjlaVXg2QVJ3R3BVWGc1bE9KUzExaHIz?=
 =?utf-8?B?eHdyWW83bnVXVjBrZGZueUsxN1I3M2xxNEFSejBaMGZpdmdVUDF1dFJMMTNr?=
 =?utf-8?B?OEVpQk9VOWVXbFBmY05TM1BLdDBUUGdUWXhLd3VwVmE3TGlTVGs3SUtpdlBL?=
 =?utf-8?B?SDIwNjkzWTJCMnJyQ01qRGZ6WEZIdnhDYmtVczJQUnFwSUVuRzhyWjRUT2F5?=
 =?utf-8?B?NXhGTjlFaUplU0dzNnJMWXJza2dBVS8xZWsxdXhvMGliVmF0dmtQL1lvTUta?=
 =?utf-8?B?NGtHb3pDK1RocDFSeTFzM1hQeTA0OFQrUUQyMUhrU0V2MVN1ZkNQQzVSTm9N?=
 =?utf-8?B?cFpBYm5kVVFIekdhZVloMkNrTWpzUlRjNndHR0ZURDhPNTc4R3lyRlhEV0tQ?=
 =?utf-8?B?MENpL0F0THFLeWdPWlNvZ25TZ0ZnQXV6akdsUFRDQllVcWpCL3o2Q3NNamFo?=
 =?utf-8?B?QkF0T0pIWnNCREhLUENvYnY1TW5CTXlrNjNFWHJiTUlTaXZzRUp1dGpVUGhk?=
 =?utf-8?B?b1Bmc3pyeHduNUgrckZ3WGdyRzlXV3JYUy9tUWtRLytEQWtxS2g1T0NOM3Zv?=
 =?utf-8?B?eitBQlJqY0JPTzNQQ0pQVUJ1aEdaYk84L2lEc2dzSG03SFVIaDhlYllnZ1g2?=
 =?utf-8?B?YjlqcFcrMjFoMDk0STlkb2cvcVhCUS9wVHMzM2F1Sk9nUmNwQzlueFoxV0Nu?=
 =?utf-8?B?NTZtZFpPRy82dEZpRUtRSzl0SHVnMHc2Z29FVDVpUEM4TVEwYTdVUWRrWFJ4?=
 =?utf-8?B?aVl5V1IyTUp6Wk9RNzd2TEdpamp5cnhaTEJHcy9UQUtnNkhMSDNRRDVDR2Ju?=
 =?utf-8?B?dk0xaXorSW5WUWtNd1kyTzVhczYwclZFNm5jbzR3TDZpSGtuUVlHMEtkdzJo?=
 =?utf-8?B?RTBSNTg2ZWM2elAwM3QvUFI0Vm1ma3JpckJUb3NnQmZuQnNFRE1zdVVrNmxG?=
 =?utf-8?B?cFVoWjQzc0JGNTdhUHFWQ25vT1QvNHoxUUZlL1ZNWGU1Z0k0RUtIMEtCRGoz?=
 =?utf-8?B?MWQrODBvS0FuWHVENFgwTE94VzdQcS81Z214RFFaeDZrVWxTeHlmZnM1cS9r?=
 =?utf-8?B?dlJEdFhGWUR5OFh1RzVQUUNxSFQ4SkZwdW1XRVA3aHJFbUlpZUJIQ1M2cFpw?=
 =?utf-8?B?WVhXbjBsNGtQdE5mMUNNT0hhZzYxV282ZTNrRHVGUXNzZE9pOHh1RUp4eWMw?=
 =?utf-8?B?ZVp0VWJhclA4T24vT2Y5QTdlQldKNDRhVU9OUWFOMWRMYkVJYWwvTkpYYjBk?=
 =?utf-8?B?eWV0MVJ4bHlvY3lteEpCZGE1dzFvK3JLMEM3a1hoci95SVc0TTRTLzZNRElx?=
 =?utf-8?B?TEcyakNLL3Y1ZkJKMnBFcGNoNUc3RG5aY2VxQU51ZWgyMXlVUjhhUFRCVmJT?=
 =?utf-8?B?dmZHR2hlM29SL3hiSkNnNDkyaEgvbjFQMUx5TC9UWHU1aXY3eUkxQVpzazlK?=
 =?utf-8?B?MHlnYXVOM2pnbjkwY0g2ckVTUDhCcDhzQ0ZwTFVsUFR0bnZDOXcxVkYwcjhT?=
 =?utf-8?B?SE8wWTdOR3ptVUJ6ZXNYVDB2K3RJcURNQWU4d0N3WjZDOWQ1eGFidzFRQnhT?=
 =?utf-8?B?UUJoM3FPZWZ4bFM2T2ExRDBuZFZxVWh6ZzJxYnR1OUlSRWZyUzh5VHp6czBs?=
 =?utf-8?B?MDBnQjBPUFpkdFRTUkdNTnVYVmpBTjREbk5IcytWNWxpM3liUTlycGFPeHRH?=
 =?utf-8?B?RThMdk1lSVNrL3pFbjB2TFdRTU96bFJSa2hNemN0bzZQVFZ4Z2kyVzhxVlda?=
 =?utf-8?B?RXB4Sk8zdE1xMmt5RTJQV1E4NEYyYThuZmEyQWhwSVFaR2dxbzlDS2I0K1VP?=
 =?utf-8?B?QjBIVmtPMUk4MDdOaFArRkh0dll1QUdpU2JTZ1lSY3hzREQvOUVJbGZQNzlN?=
 =?utf-8?B?NFNUM0lhcW9hdjhLS1FuTjlKM0NYclFxS2RoWW0ybVUvTmlsRzl2QT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 99799805-a65f-47f3-e46b-08debd7c4b61
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 12:17:47.2070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HF46ss0kInsSNg57geY+2sWlwPil/2aIkLLRt0jols1Xlf4NAdNIn8Y5o9jHs+2JbHaOWraLRdqwX2we1QIrfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOVP265MB8757
X-Stat-Signature: jt9yf55cno4wb1mxjt5m7rmtyhbzs613
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4956E12000B
X-Rspam-User: 
X-HE-Tag: 1780057070-255079
X-HE-Meta: U2FsdGVkX1+QAUTluPUCv0/S3NCo6ZV4nd3L6yNP8F6B71jTFdciSSe3fVBcqH8jHF2VuyLczz8ynJ/DbQxaJ7LTnSbmnTwk3s+bFY5bKIPlkCTJIh9ZCKeiOFTJXZmM9UKr9CYCKUZUjDBXgqONkJluk4KKuT0BZc4Bq/DBS2BnvbmSjIwJQzWHsWx2KHJKnYycGpqR6Y+l8VNG2G1xpKMbRQT2k/oCRvBgjR5ROBFLiYdkCNQVy3AHpauiFvgcyOg5NgiQ0/HAFNSpQfkcPccmv8YcTwwKsu2hkOyl0v/l9eQXj2URj9utbqb4MlNHCs4g2y4zpxYdkFhR7H4eU8gEO/OAJ3JQT8sL/qzVq01mki4eQnUvFTLJSxIN5HUQqV6yCKpHdFrkjTjSVAluHLX59kBH9khkT591p8yLTKo5xEl9rguUBFW2vCP/YYS9S60WCyV8W8W9iTYnJvtyzBemUyokLYTEcVv9waXtu1zwqaap4Eu+Ayx9FUEK5hGuGJ39nIup4uz0cqE9msf1ySc7wp53rZKDTP2qzurfIAT2j4ly4P70nnUnjtEgiLJUpgU0t67pPStN0xsOz/5hy3vCuK5S5psiPaNhO9Z2dyEfdi99P+T5UuJnTPoqn+uCzrgMx6d1mLa5puG2utJ+NBiYxJhs78aVFqkHCnRyohTWlA8snA+Yt+KCNxILVNZ85KgdVqQV1UFPbT48qv7sqmPgsGjePN2Rt2WvMEVnXqEo3HCKqieYwqHoTPNKX6jWMFkKO8jIf3cDG249qAo3TfS28rsTJuNzQqRwT92R0XT+B4nIZkZqT5QMGenrmoJpR3MZGX3PdjQuLxhWXGgoux5PqggKyK3H5DjwEkEZ/raDwqtNEWhOZDCHAGuA+lJuHbd6mUdr4sihuvMnNhrFBTIMNL9HVXYE9HygAkafYa27wpbMl2gxi7CyROWVj1u+G0tUIcthoJDP3WCpwKY
 lIlNvP10
 1tuInCFOmPGsIl3lILQlPLhHFr6DTfBzjY8jrhuUY0lQ0KM9oQN/0WsHILzfkUQRdAoBPuGPnqg75e/tZ9x3qV8JRBMn6I0Ch9sn9s1F5hzvvjpyNXqY/d7uEGwW4IyA2aKu5SkdZVV/TeFj4qLtnWXKocxKMnpz7FNXbTTsvN//wyvbou/hvjXlc/ozkkLrWTRQLSw7TNhPJpo2CT54XyAe3gxemUSmpnqM8GLw4bs18BRRQ9mSdRNCd+pTDGOAulN9Q2zxhD5l7zG+XLgS8yZPTnQy+2MIhYU0a2cXNfteOWth+bbDJVupReLqS0E12MLn0ONzVhQiX3O1fZg5ysvkVsweUn9Fg39kd7A02wm6uoruPZTgSwmAXBi0SKgK4pi4c2zih5xkAMyqEnI0XbiCzaycmtUduwx2RIZ6G0AIw2fN31cxikxSwEg5g87WM3lLNmiBgesJRsFsQYBPqEHPLWQlI3qo2gGkjq8hNwxXvFSXoq9jOKPnAczE8Rng5dtdTIHBL69tITxSV7XJVVI8vVbcOCVzrGQxVe2+2uf99q5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri May 29, 2026 at 9:53 AM BST, Nakamura Shuta wrote:
> When building the kernel, the following Rust symbol is generated:
>=20
>   $ nm vmlinux | grep ' _R'.*Page | rustfilt
>   <kernel::page::Page>::nid
>=20
> `Page::nid` is a trivial wrapper around the C function `page_to_nid`.
> It does not make sense to go through a trivial wrapper for this function,
> so mark it inline.
>=20
> This follows commit 878620c5a93a ("rust: page: optimize rust symbol
> generation for Page"), which did the same for `alloc_page` and `drop`.
>=20
> Link: https://github.com/Rust-for-Linux/linux/issues/1145
> Signed-off-by: Nakamura Shuta <nakamura.shuta@gmail.com>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  rust/kernel/page.rs | 1 +
>  1 file changed, 1 insertion(+)


