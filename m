Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDC5CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 11:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F01900061; Wed, 13 Aug 2025 07:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62680900044; Wed, 13 Aug 2025 07:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51538900061; Wed, 13 Aug 2025 07:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED00900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:51:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E44FA58852
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:51:19 +0000 (UTC)
X-FDA: 83771568678.19.A9152F6
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013029.outbound.protection.outlook.com [52.101.127.29])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB920C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:51:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=UGPErZjh;
	spf=pass (imf10.hostedemail.com: domain of zhao.xichao@vivo.com designates 52.101.127.29 as permitted sender) smtp.mailfrom=zhao.xichao@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755085877; a=rsa-sha256;
	cv=pass;
	b=FuUF8i/cdXmbwc+3WWjoxKhHPFbkpfVH/E/BQGtC5bcP4k5qf9UxU9AM75hJvM2zjaRU66
	5hdXs7ZuFwcb1hD3zmcRI8r7I0N47mGhdmXiXG5vjg73JbNsvC8Xj9arEUCqYI1ap0Zym5
	VgtpjAyJ9poF8EB4r0bwcvX8mKksgWI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=UGPErZjh;
	spf=pass (imf10.hostedemail.com: domain of zhao.xichao@vivo.com designates 52.101.127.29 as permitted sender) smtp.mailfrom=zhao.xichao@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755085877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nXIxnLXmalRIbtxH5pDWaa0rBKxiewMWEWUDQzsrgsQ=;
	b=ADu/a5N+jH2Rr4KvgNjiSmcW94bV0dSqPIf9ckCb1i/urNzRGsPevRL7FMMOvEAuOUb8mU
	2VtkOl4HtTm9tCmV8T9HBSpYkSqeGigFmsOIh37CZtOhDJcloMMsjiBJ2uXY/5KAczUC1N
	hEmqG9tQjjJ3nc6uKmT7bcl8ATJJqPw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VFaMYFQ7N9CmQxt8eCaCJlfpp86LxLzuFcxJv+E5rTHN+07Zca7eCbCCI58htsa/wEjLgzBFk+uL+m6sDjHD/KzLN46WcdngvERR8TFUTryxh9cBLi9ZGLMhpIYaAFXpxb/CZu51wiZorkOqGrp5dHeu2lxs1N3KcZrPO/9IwcvhfDxqAgHrADY5ZQRr2OKmkXHxNxLm8zDIZeCAKJaO75TDCtcAnClkOKyMpAa5vjm5cfpZ9ifolgCjzo5Z4+y737fi+FO7AaZTATZIbWNOudnPaGm5wcZja6jheZRGlnOYVzh7gFkiXBLK4jzK/3uLysB6Bs4iYoQFGzpx7zlPLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXIxnLXmalRIbtxH5pDWaa0rBKxiewMWEWUDQzsrgsQ=;
 b=btFWj5IhUOYm6WHCWBKiUIXL2BU70Qw/1/gCqJTrqtyZkyezSmj7zlT9miX9Yj6lnEd7O2SJQZooA0VxuUkAdOCxLJ9qtDW5R3Wc4nQDW9ztfV7Ynv9ShHEnvasBW7nq05K4T6rI7Z+hlmrYFBRuIxUK1XwtqyS1QgkIfDi2INt8cyp4Qvysav9CUQ7RDYs5HSgzu8KVdGvmmAfj2BG6tzqhKfwjOZqQv5aq+PG5VVokz+NGKwOK98AD+5Zfo9sBOhNhqNhIfWsjko8qvvZzimV/yxXuBLRFzEW1lz2uK+6Jw7gL1jMOhIC5e3Wl8SslRV42mCi/96yALVJowUgjZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXIxnLXmalRIbtxH5pDWaa0rBKxiewMWEWUDQzsrgsQ=;
 b=UGPErZjhP4wiU3u4fMKyq2W5kAQzhsyt0F+3d66J8rPtIDO5oB4Tbgv2J2yJ88pjxILVuQvy0vbySTrwwGRfyJnoy8397t1kgLJ4p5QpBpEci4rOWpIPdFZSY0m6pdVNk9vY9e+ypscMtiUZsoSU69Y5UZaQ/KmOA+3WkrU/pGJbATQuvdypDIL0pI0Jm8H/6wy8k2jHoka0gU+22fK8EsxJO0o5U3Thxjedwn+KxkyG3tdMOWl+UVxDs6sHtAV9TMMvhSFx4BJ4alSB3e+pCdsr1AZeh3GLwbIGmlJlSlYhAHbDb8VXQYfFR+fGfCyuBWMHs8vXPUOsEnOLI3JxAQ==
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by SI2PR06MB5195.apcprd06.prod.outlook.com (2603:1096:4:1bf::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Wed, 13 Aug
 2025 11:51:11 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 11:51:11 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	kees@kernel.org
Cc: jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] binfmt_elf: Replace offsetof() with struct_size() in fill_note_info()
Date: Wed, 13 Aug 2025 19:50:58 +0800
Message-Id: <20250813115058.635742-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0058.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::22) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|SI2PR06MB5195:EE_
X-MS-Office365-Filtering-Correlation-Id: c55d695b-46f7-45eb-3334-08ddda5fb296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8Zo0IbHVcUoUHbJ/iNn+YUbWXLWy0frbrZF8UwZRyM5o9k/Kg0lWTmyLuLNL?=
 =?us-ascii?Q?Z+t1qA2QkkKwPBpVh6PyB61/9IvU1jN3nZvnoEugCYoGZmcAQiuNfnOsVTC+?=
 =?us-ascii?Q?ANPBVFnzwxUyI5tjHM35XulNA1iwwUxvr5vyXu7qf6NAWGRh7isF8jEyr6ma?=
 =?us-ascii?Q?wGqkoUJ8aYztBFK1eOwp8BhWv/D2MtICvYMIM5asMrANRLgZq6LfWrOqtpZD?=
 =?us-ascii?Q?xtaw5LwDIO1+2A6X5SIcc2JcPS6zbsZB70aqkzclG6TqjjzEtlI5B7zbqqn3?=
 =?us-ascii?Q?Ot0UVHDegxQUsLkwZ5wZsUfNauJrYozf/A+HsHLNXbyYIugn23K0bcVY7IQ1?=
 =?us-ascii?Q?jLVX+wNjgKV5laa2RoMDVFBMdfRN9BYnoFJjsmXZR6UIHwsp5+WcxLDe/oGv?=
 =?us-ascii?Q?Pmrsnkk8aAmBZYPZgMXE+7nmPiTX8NNQrJKnFkGIhyP73Baa6fVyebTlLoSJ?=
 =?us-ascii?Q?ZKabMShwfGH71aMXrr4o5YOU+s1UzACddkXIFGBQ9MER4reizhtABnod8a1x?=
 =?us-ascii?Q?w8cZGtCH0YqYKzh1ebhemEy9Req/njmEBjDV+5gzqy70oPlT1gdWWw+ilScu?=
 =?us-ascii?Q?ZohsJRkBIc9dETUt5a/TYuQnScqPdMyllutQ9xcuN+xQ8e2NQF24u/RH0IdJ?=
 =?us-ascii?Q?s1mK095+sKXFIBuJNfqE6RoCwW6nFgRxW1kQSFlk/6bd44Ny5EwjcjrIiQoT?=
 =?us-ascii?Q?4xvpqJ4f/WILmmwW+sL1fu6aFjB7Y33KPF2IG26rxHq/3Kq6GOr0e4XlsY15?=
 =?us-ascii?Q?/js+9tCNpSYeKtzKRTBt3DfMsFhxIv4SERZyba/3UPyNAqPN08Xe4KhtHyz8?=
 =?us-ascii?Q?GxWHWQdPs+qxDfRdZyBv/fw4oEfXfC228WpUgOzzQJGC26eHXaohuWoJVMIj?=
 =?us-ascii?Q?6JbuBTQQQeso3JstWUsWrNgu9j+p0qpRHz76gUpIBA2E+Tb5iQPxt6UKiVGk?=
 =?us-ascii?Q?sg3BJfGpsrbdoaDf9I+xwYHHURwmG/AWf2hSNDG+/KPBfAjaBSmSA4y3w08z?=
 =?us-ascii?Q?4G/ZP+uti+xLYOWo/ibDZ0TGfIL+vF7j/xf9QJnx1uxmagMDr48g1ggvVrwl?=
 =?us-ascii?Q?ombApp7v7MuV0r7p1KLZ/gguqhOoWBK7FfNVKqrQhFQ+qFLXzDN0ZlCXl9PF?=
 =?us-ascii?Q?gCEuqVadvFeptJQ9qf8pEvfk6ML/fMQe4op8HHDIBTq/nq9df65oi1VP0dw1?=
 =?us-ascii?Q?78qDBgC3aB7r3SGcCesvv6O/4HmW5sw6QbLRDMQEf33iR3TvbGdeR9LMHuA7?=
 =?us-ascii?Q?T93N6KsLohKpNEpRJ2wN9t1YWFFqhphUy3yzEvwcBdyEltULMaTv7xwm84Ld?=
 =?us-ascii?Q?QS1bBIhhwNi0todfLJ2RVyalMUT7bGn+EXlyZ5YCXPicC3bSyMDgyI3RGSaY?=
 =?us-ascii?Q?urjlG2FyQjduBig8y+Cm8bTJfwzyMA5NbGMp8iaUCuv0T8KfoMOXVZkzweQl?=
 =?us-ascii?Q?rSKkD6fJi72ypusF0amDlEDP1UR2eMOJ3vVfRjtgAeDrzhUt9DJBIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zu0ihQA52HzCpF5n3lr11sGmsrsNh80dATjpIbNJKJAS/1ViYtvc4Q/jaCdZ?=
 =?us-ascii?Q?IUbvNYoNXqaXZHGLNaxs4AHBbpthrBuV2lk1LYBdlIeMKrrakyuV6nBKbipX?=
 =?us-ascii?Q?kykjYyysaVL+dlKlDvjxRl7ems/ksx0FzmiE/Lh5TJhaUxDmMIo8/3huRmRy?=
 =?us-ascii?Q?c9qxVUN3UIjnL3qVo/mEX40x9SJgFVdbVhTHs4UeBePnImZvnK8CtPhPALyj?=
 =?us-ascii?Q?uFB415FO/sWUGsSJGJLzkZup41DnWS58y29Ckg6qmwOy9aNR720Nl0YejMoV?=
 =?us-ascii?Q?I+1whunmEwESRxxv1/Gf5UHYGZ99/+qOL+XV9lJPM6Djm5UhEIgxHAbjwChn?=
 =?us-ascii?Q?TY1L7sKBr7IbUruClFzvnyMsGyn1vuftP2HRQy3GW1NI16fFj9POsBDyOVbx?=
 =?us-ascii?Q?FMq1+Prxz1+6Qw7maPLl3bbWaUiKc0cNMTX9mI5Ex/SS7LcOtzsDsnfEdtrZ?=
 =?us-ascii?Q?89fQd5ILQmcq9VYRWfTe/9xPAu2o09eT2GfC2Pqi/Y4gze+ZXT+WJZNBmsYr?=
 =?us-ascii?Q?GxCn+E6/ROoKn1OdBo3TldW4iWlzxEPdaQqYySGTLKRQYFn9INqd4t2IKk62?=
 =?us-ascii?Q?4jJZLT/K+3cI9VT6nDP3tjLkQvu+f10CYAd6vJdrR1CJX3goaUXGyt/Y1W1/?=
 =?us-ascii?Q?Q6sylQXQGyVfQv/JpoeA36r/Pqw4qswdvInYoylxct0CcKKNAbie6lJ+W8l7?=
 =?us-ascii?Q?s7XJm/cDedKh2lY5QtNy997XiSM6lY67ni01+WgtOKzwryMtuGR+nNp8Ajt4?=
 =?us-ascii?Q?EGqcUE2BoznNuYhN1IiikARVaUnGySVJYFX88/YrfhnTy58yIgq0xxE6DtS/?=
 =?us-ascii?Q?mZJn349paf2o+2GZmNoZ7AM5VuP2c9qEz2f4FbBFBkr+7llvXlpQMN503wVX?=
 =?us-ascii?Q?1RhhLyaR3WUGbBF2Rz3n5QrJOrEvCVRQPzw5Akh5vMTYKVPtoY03hJo1CiGG?=
 =?us-ascii?Q?EHtURI70PROMKnj+RxtObHL8UrvbwIHclgwsuUCGB/kzauFlnuzs82dpCFgg?=
 =?us-ascii?Q?lv3qX2REyDeXEGGLQKRdhPPEZxWeNa0g1LR6Uqq45L4oNy6vVvB/pJcPeBQX?=
 =?us-ascii?Q?g8oVxkoobAq+rQYhQ7Qg49Rp5YFEIAl4nEQ6JNs8dsMNotp3uEyqKRhe4hri?=
 =?us-ascii?Q?Vd95vLUsEzRHn0ootvHGJQnGWX/Q9LqAKDNP5vIak6PRxrh5SaL+DargkVV2?=
 =?us-ascii?Q?NDGabC3FTpGGcayzQB64GeYoyADd4h2Z9HMAVLms8BBUZSASeCAn6O0ZUL9m?=
 =?us-ascii?Q?TKJ9SvB7xfqypxAr1Pk3payTwKZcs+3a8EMoXhk+O1JBSeIQBHILIyXGgbOD?=
 =?us-ascii?Q?TTZNFu9HaQEhv3w6euoROLtoxu9yfMxA5soj1SXdkLc7BT9F1tVfpcPP0+wG?=
 =?us-ascii?Q?twuiy4rRE3jCsDYeJxmoNnL/N74TGQualz2RVquAxvEDpU1lSYZD7Rbu3z4d?=
 =?us-ascii?Q?N+BzSj4fPO6cQT8LJp9utG/O+TZNDbtOgsiNKfY7Tqs88HBjw1He5AmUr2/Y?=
 =?us-ascii?Q?wPNmJ3FKBelXuHtU9tCUi4rQ/vbAJNqOtIr8/3zHlkIbgvSbpVE35nQbs3Ag?=
 =?us-ascii?Q?XG1JqFfeugTOA9f8/ohMX2veAdbRADz7VNWChQ/C?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c55d695b-46f7-45eb-3334-08ddda5fb296
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 11:51:11.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+ddUJ4L3CGe87P8c8QvZ8ZbOfblJ4KIYiqfWF2VtT+cJCkcmLXQ/I8NjzGLAhTEMddW9PuLJWzGwikp+ld7PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5195
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB920C0002
X-Stat-Signature: xom3gb9mhyoaipcs6ofhtt7p4opsdoi8
X-Rspam-User: 
X-HE-Tag: 1755085876-905088
X-HE-Meta: U2FsdGVkX19wCf2+zCgMZXXqSzwspfDl78G+e0Pdxe4IOtxSnbBwcHNGYMEjqJ7Ps0o4ZyTf+UxV3g1pfy+EDPW/8hBez7lt7u+/3YrpJ+PkFQeqA69fTDI/2SWKX/l6r9afFQAt32C8jetZ/vVEMwmaU0SpbPNzTdCrn0APeYUk15qM7BSeqOhZtHwWV7OTGQn6VkJuoOBrg3l+KbUBFUmKWXSetbM0xmqp9IXPRZISLQyp0ZTcu6skyg71ppRm75G5u1aFyLLmvO1CCdEP2eVVqZueYxqZZJ9bSZbGuAQdbR7luUTCi5uWDKEBLDKCrt0/7EaSLbPsx3x0A+29S86ikYCPONfJI3j5dBN3SH6SRKXrrdwW+52AsCF7o4PHxnN+uHa27HUdGokBsqM3l1vEoVNk/D/NPbaFq/7rG85MRvBVARlJqHJYtNVYlo6tukzPt5r4W/NThBEGdM6dDZjcN4VYkJa9/nScN9YjdD6/Ip3Awq//zUhLooJHw+vqlLLvhQSd9wMHm4C1P3q5jll42r00KUUzzVnKHxhBasgKvGk0bDTByGfAcaFx9JVzzOVL+3QWLEO/l9tmbuyiz7fmcvYynPeS1lfpyLTQXyMITL0CClln3Tm4q84gkop3Y50ZZY+XCF+Qw6Ng2vwP+h+BnR6HreRDU1zyeVgdfmuHji8CVi2lfgs66qIeomIMhzTI2xC0RasUgWGYUb1OW4HILTW6ZrK6+rMulVJ8i7ZVPXBetyffA3ergxanAo6Y7I6kZCLIUKuTswMpzWNTUzXFPQr2ivdAoKMYJK10AEdK7WCk/d0EsPSuhTFsTPIlCcH5N/s2IZbV9njQHMB7l3CeoezZQWZg57oxFPQo9h3wUtKeGc5+xrpmlZMqKfe2rCIa1k1hj2NwzpZ4ktU96a54wTWV5X5NCcoKkXxJrzvm3Iajbd0vvUsf0efl3ubC06fIg8YD9RUzX8TIlTe
 I+roGUHH
 K8q1GUjXHyHFslWw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dealing with structures containing flexible arrays, struct_size()
provides additional compile-time checks compared to offsetof(). This
enhances code robustness and reduces the risk of potential errors.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 fs/binfmt_elf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 264fba0d44bd..4aacf9c9cc2d 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1845,16 +1845,14 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	/*
 	 * Allocate a structure for each thread.
 	 */
-	info->thread = kzalloc(offsetof(struct elf_thread_core_info,
-				     notes[info->thread_notes]),
-			    GFP_KERNEL);
+	info->thread = kzalloc(struct_size(info->thread, notes, info->thread_notes),
+			       GFP_KERNEL);
 	if (unlikely(!info->thread))
 		return 0;
 
 	info->thread->task = dump_task;
 	for (ct = dump_task->signal->core_state->dumper.next; ct; ct = ct->next) {
-		t = kzalloc(offsetof(struct elf_thread_core_info,
-				     notes[info->thread_notes]),
+		t = kzalloc(struct_size(t, notes, info->thread_notes),
 			    GFP_KERNEL);
 		if (unlikely(!t))
 			return 0;
-- 
2.34.1


