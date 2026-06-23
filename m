Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23411CDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989906B0088; Tue, 23 Jun 2026 10:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B776B008A; Tue, 23 Jun 2026 10:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802A06B008C; Tue, 23 Jun 2026 10:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB206B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:55:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFE5340524
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:55:26 +0000 (UTC)
X-FDA: 84911475852.10.9589763
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022111.outbound.protection.outlook.com [52.101.66.111])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC89614000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:55:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=eYaiEI7H;
	spf=pass (imf09.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.66.111 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782226523;
	b=D827isGSzO/lUCRTGlyszR2fNgyD8b8HYCwNq+CwbZNi3FFCBWOmCw7sxxgG0oZfiVKCm4
	fh++V3/CBHg2nMDazgW/SP+dTgZIXe+mQTzP5Hf79fePthQQGORH3GtBft16YL2gb8c8ll
	jod3P9eOjDbWtUPBXPeNhr7I74RFYZ4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782226523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJhp0e+1GGv+vy/YtsLflMDkv+lQR3xG2kA52InrL/s=;
	b=6+W7UMcY5s66TsMlQS1NYMvq0Ok8qmalxFboSWQskRguLGH3ONR3r1p9/ui3yXNlNScRu/
	q7pzxXKaE+/QbuwpFrlEZ1BTn+dapcHpj7fttLS+GuLCE478cvjhkceQWxEc1FG0LSRTWk
	bxoXFYoUKR1iLgPOSI9Mll3JxynJn9c=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=eYaiEI7H;
	spf=pass (imf09.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.66.111 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RbUJiyUIgEJKm9dLbczaeroyx0ezQtwymzcMnj2oIHpHII6P6AwEfHc57Ziiem9qkErOQR0rm/RW8TQl3G3kV0b/yEW2KzSsx2deCBBSrsx/ZXxdW9sq79MF7/ypVPPj/eXFoXjz+i9/Kexamt9exW+oYHYpQrfOFfheEatpJfvVZqvtfMF/cXWypbkU1/U9SyAD/L8cBY3hzysSWWHo4TNSGY3t/Rw2jYCLNJ25UHQd4E84nyVZWpXSYuA1RO9soKzE4oTwJGxqTroPEqYQxHG0OiXfRQR4exBcRP9HCtsD+szcMJKmuitrUoyKxvF/uS/uuyfvEPGvNHhqekL2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJhp0e+1GGv+vy/YtsLflMDkv+lQR3xG2kA52InrL/s=;
 b=tejXKr2PCtiSLEuw1zMuIJcNv6Y/JY93WAbpoXnp+kRMrlFGSE7zzU32bhvI7cjCESzgKJSY36aE5rSfz5r5lnmvfQq3xh33wX/PCMrltOB2xjt430oRXUzw/Yzln5mgwwkakK/MqQ5Dxz0VJTlBTQaLzUBPPN97uxS8eom/d5rFRfHRTp/kY2+zKLjNre+8TvgE5nLQBWMd1RZB4bHYwPCXb4xAumpU0m+WnnJYxlkcoHk7qG16b/fM4sLgREm5JnzfoNm4igzBsTZ7YytQ0xXn3oaDMSxKZuvGKPDMwo0hYa9U4m3+c1TlsIyXaDev7jRhSKnh2p1byYS4bKPoOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJhp0e+1GGv+vy/YtsLflMDkv+lQR3xG2kA52InrL/s=;
 b=eYaiEI7HRC3T/ue3EO/Flx1/Ug7dkGE8xUFOQl9wwuZUQIuZnsuSFZxBWrWbdrGGeTiorEwAJvBtEYJFFreSzC1kklV04aQ3PNJD7PVu0zfaSw/JADTZxNidZJCHv1tHkRO0/8yf30l8KF5LZWWRa9aq3BEBe+i20mRhnA2SqPwEtUwZKL4EvaBbxwPKP/eXBKbp3M4I7ix4W9i7zdeWE7dmlHCIOvw0Z5ai/p8JuwF3xNKcnPtm6Ef+qUY3bFpIUdmLJNdwp85WCu1P3GaZB5rckyef14z9DaQdABq+/WurVq7Ev3SuKpiHsMDRGWnjcB0aTci+nVnbj50FRcxJfA==
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AMDPR08MB11631.eurprd08.prod.outlook.com
 (2603:10a6:20b:73d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Tue, 23 Jun
 2026 14:55:19 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 14:55:19 +0000
Message-ID: <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com>
Date: Tue, 23 Jun 2026 16:55:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>,
 Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
 <ajqOyIA8tPQsxfz6@cmpxchg.org>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <ajqOyIA8tPQsxfz6@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0313.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:85::13) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|AMDPR08MB11631:EE_
X-MS-Office365-Filtering-Correlation-Id: 46fd8ad5-793a-49de-1000-08ded137719c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10070799003|18002099003|22082099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	30uiE+07sCUJyYX8AhZQnqVTpmggIeqzbb4JyIohIRLGvZ1MDjbFz4AWaWmQKe3mlTlLTKNz4c+BBKMDbAZQSOTEbhwvB2/wGa9ghPHVJ+bJdX8IbIuQZnUKeBS//u368K5eJ3pp3LjTuXLlIbzm5dourmHkkZx5jfvIwEJ3xROKVBpotDiKR1kuPe5yNv2ASP7fNVU1lQDbqbG73Ir/q0cggPKkh/ZCQYCg2N5wSQDizcFynR4/mZ6kYXD1+TE0RzG+Q/BzEuM+G+92RS4PxtPpLF9v0NK1AkNmv8p8vWZr35LvsstWXajMFPpFGVh13kuVlSBd6DtaLJ3x6q+JUBg8qvpAur5OyoJ9Hb2X8QN9h3iOqFcjhqARq7kqDTVqzrWuXkRD+WqF7G7C4tWFc6vhWAbLtTNv0M0QEfC1q7kIyEzordmZLLrQI8cjbCHL132hr6traWDM+2Xfmir/5Tvi3hc6R2IQTBmwfHTWQiRzS9Bmwx7Cmid/39IcoUpmH+2+RBEajb+bEUGKr5qJIkF5nnCdjecmekso4bW5AW8eMPEFTNw23XQz3NKW1FjBSVXDwwyND3/lMdVVUh1uaiwW0k9E0qbldTHTrqkpKm/8cVtjQPP22Eioo3i4aE/9mmBJLP3OUfpQhhfy00N6iis3ypDjKUfQNjSYX0njuN0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10070799003)(18002099003)(22082099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QU1qc1krZWl5WlZmNExyejRYWnlrWXVCQktFdWlnMUgvWERhb3o5bkc2dENV?=
 =?utf-8?B?TjVmSk53V2lITTVIZGZxUDFQWCtTNDM3N29PclhWNTEzZ1JrSHhwNk9pbHkz?=
 =?utf-8?B?VklCQWY2d1NuQkpVSWMyQnJkMmlKVVQxa2xzV0dhMlRyY2RYei8rU1QvRGh3?=
 =?utf-8?B?akhSMTFlckZWTFF5SVByZC8zMnZ1dlJocnRQZG9tREZVVHBENmx0NjFNcW91?=
 =?utf-8?B?MUhlSGxueHk4Yk5lRVhyUVY1dUgrUmoyQkJZN1JlYXU3K3l3bys1SHp6bU9V?=
 =?utf-8?B?SGRaRlNpcEZiUHdTK2tDYXk5c1UzRkR0ZFdDOWZseE1DNkJrb2xmSVl6aHRW?=
 =?utf-8?B?cTNkeTQxQkFmN3RvcHlvSUxvTjkyazlRcEJyUDdISytYeS9SZTVWNTR0MGQ1?=
 =?utf-8?B?amhVSlhwaTA1eWJqUFNSV1FKeGNOdmdZOVc1K1JTRnV4VmhVb3ZObUtONFl6?=
 =?utf-8?B?MktvNjBmd0dNdzRpeHV2SmpKN002S3NRTFp6R3ZEN0hYbDgxUFI3dlNSREtL?=
 =?utf-8?B?RW41M0s0Y2Jma2xMQmtaeVpxSkVTVUN5Z0R6YmlXVTZGbTVVOGV6VzEvRW1L?=
 =?utf-8?B?R1NsVDBhK3Y5ZjFhUTRkV1ZoSzk0MytNUmxTbTd2RDlBeUYvTGllL2xSYVVX?=
 =?utf-8?B?dFlhOXNQSWVwSHpIV1dRemxDZ0o4WnpHYmxlNjN5ZjNCVVFoOVpZOEduZnI3?=
 =?utf-8?B?OXB0WWdFdWgxU1RKaVNrVUljMW5aUHNlZmNhRzJjY2tvbXQ5RFFYY055S3RK?=
 =?utf-8?B?cTNaenhqUzZXdzhFblZoWU5XUnQrV0xSMWZkemYxeWNoblIrN0tlZkkyZXYw?=
 =?utf-8?B?NkhPSDRmOCtMbnVXdEQ2OTN6cXo3MDRyM3ozaFhKWHJNTFBiMWR5WUZXR3dX?=
 =?utf-8?B?VHlXOEg0bmRmVVF3b2QyV2pHdDNEUjl2ay9pU010ZFlYZE81TTU4cHdHQ25m?=
 =?utf-8?B?aitBMFI1MHhETDhteEQyNlZlUk9CeCtUdDFrMTV3Rlg0cjJnNWcwK25rMXVu?=
 =?utf-8?B?ZzlaTVZLSVVYV0ZLbmNTWTJlaDV4YjYxVmc3NE92aFFlMmpNbzI1cFFQRnJW?=
 =?utf-8?B?WHFQakhETnBOdGxOYXlkV0xUZWxDNEd0UitURk9LUllsTTY3bmZiaEw4ZjZM?=
 =?utf-8?B?TEZ3dUduL09oUWhzRVNIYW1Ed0RkZENOVlJyU2VYL2F5bm01M05vOVVKbGs0?=
 =?utf-8?B?Vkhqd1puZEUxeVdPWmlJNzlmYTNzRnZGQUlRSWNuRUkrNHZ2NU10Q21PbnBM?=
 =?utf-8?B?RUgrbEZFSU9VcDZXSWlZdWRKTnRDVmwvY3l1L3hhRmQ0V2d1L2JkRURsZkVi?=
 =?utf-8?B?NklTU0hYUHZVV1Q2L1hvZ3VFb0pZSEJPeVVJRmhta2tWaDJWM0Y1dHR5NllF?=
 =?utf-8?B?MC9FQUJSR21QYStnb2NYa0lSczVZZ2t4VnUvR1RuOHJueG80WEQxakRuMEtN?=
 =?utf-8?B?RWJ5QWlJcmdLUkVpK1ZWUGFxOXJEK3N5OVpzRk45M04wWjdrSFVvSzRyWVFa?=
 =?utf-8?B?eHRqeGdFTUd4Tmg5c0NMUjFWTTZPUE9OSkhMV0pKRnNOS0ZqTEhzR1NNZk9L?=
 =?utf-8?B?WFNiVm93L0Z2eWJpVFROUS9qRjk1alNGS1B2bWF2OHdqdzdWUEZvdEJnbmtR?=
 =?utf-8?B?S1htZS9WZUwwaWtWcmhNcE0veFYwaFdoSmJnUmtEK09WaDB6TEpjdkVpVGMx?=
 =?utf-8?B?WnlPYWlkM0pPdzRhZXR6VllqU0czeGw1STNnbVpPa3dGUVpFOTVhSGdkT2kw?=
 =?utf-8?B?UXZmOEc2bHh1a1R3NjFKNmFiT0tEK2ZVVlZZR0Mwcnl1RVRhbFEvMlEyK0dv?=
 =?utf-8?B?SklsVDV1SC9XWTVDSVkyelBIVWFreXRwOWI1cHAwNGpnYUE2MlpldFhJQ0xC?=
 =?utf-8?B?d0xXbDFtaDV5aGNPSkxLZ1BFTWJDck0zemdMd09FYlZGNkd3OGJLQkFINmg5?=
 =?utf-8?B?bC9sY1BOS2g1TWRWUUpTVk1QblZ4QnpZMTExMW8wZU92aVZ2bXpGMHRnakE1?=
 =?utf-8?B?TktNZkdjYi8rcFdWY1AxWVpyYlZhWjh5clFrcXlFY2h4QTNHc3QxMlc5THBt?=
 =?utf-8?B?SzVZbzlBNjBkajFJeVZQNVBTSkliMDE4aDcwdjluckd6OHVmUTNQREJzc1lk?=
 =?utf-8?B?NzllclRyRUptNjJFUmpPNkhXdEg0WTN3dzNPcWRvbnpwbWdWY3JwM29lWEVt?=
 =?utf-8?B?UG1aWTVvZFVBWVNvY2c0M3Q3c3ZwNjJZSzJqSEMwSWE2dWlmVGkydkpoYTA1?=
 =?utf-8?B?eDFyUE5vckMrZkFyYVh6c0JPSy9MREs5NVNFWUhmaW5jbjFmWnRrbmVCbDgr?=
 =?utf-8?B?ZXJKNkl6NExuRi9kTnlqVG9VSStoYzNNd0JxSnEvY0ZXSHV3eTJWUDN1VTY3?=
 =?utf-8?Q?nNKzSFd+U0YghS40pth+Cn/IYpyet5kFPp3GfsGPSrp6+?=
X-MS-Exchange-AntiSpam-MessageData-1: v51dHhg5FZ4090Ty1sq0goBO31QCCLcoVQ4=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46fd8ad5-793a-49de-1000-08ded137719c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 14:55:19.3946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6ajuVZknhykFgh0u6jgCnSPSJruOTln6e9TH3gQORde0B/rKUIzFZEy5CtqJkPv65FX8Ht30NBdsPh+cqq/yUerlbdSCVHtiLe6eN7er+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11631
X-Rspam-User: 
X-Stat-Signature: sjgw4dr4unffsttxyn41s65618twca1d
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC89614000D
X-HE-Tag: 1782226523-44162
X-HE-Meta: U2FsdGVkX1+6sNup14qT6kADmpZOHm+W+FUGlzHmaXIMPQ6W2obfI9t5q8+dyIS04wKXzM2IUr4IJ0skR8LAak6ELn0qBmCe2bLRMWPTQmLKCQqXzv/+ubgxqXaf/FM5vuMK+xvjC6q0S4i5vdDxMPCSzFDwVO1/93SbrmpNQf5Qngwc8sE5prHQUOvEeyu1cZMqSlovkoqLBw3NWBAP5b3XDU6WyVhoPMxxp4K9wDmLLjckMOnfAiK0AK4Iv9oaPWLw4kBB6Zppp1ZxRbvpSTnF6deE7E+yM7VMvyAajHMUIP5SFWCyV77YOeDe6zfvFkT3fNLWPBKlVVxdKPhcuyqaI+2tsf6dz6xvZ8vm1DYT4wBADSsbinsXa+yakekwlGwUSl95Q0m5W2Uy1vTUr4PFXT3+2yLfHg9uXUGyXVwaVR51FsWSABm6suJk85tTUhwoEmSqXKkbCY56JfxB44J8OdBQQxm4b/IAopXcnsnn1httAN07Go8ArjHaKkq0Yvzl9T0QXFW+/Yz6EoyLXkq/T+Wzd5lUhQiVCQEcDenhrdztOwweN0m5RdEotpyeU//TvXsbNY5UNp0uJCuzZtzuyu4M5XDJ5FwQ/y6Rs/T5nrZK8KAxmFERomipxS9Q86wm71yo66JhVs9KBA2ggcU+wZGhCKc2ulXqQLof7eIr6bH299sDxJ0UbHlJtRJ5Le0wepkQaUpCe+COcn2uOytj+Os7FkvQ33mvpK+s7t0ivlenLbtPOm7PZJeZ2UMJPFe5Dvc7ih8aDWssj7RNj24a2VZizExBywPIyMONUXn3UXzSA+aEtmaAyux5c1Y19fLDcUcfWaV1r9n4Hckfd4XpB4BHBBmpU610Kwh85mEw3UbBZRfIeIo9T8jO/7+BFC2DiAVL4Upw2hF7Qd+PF4Lbt8RDL4/vAiF6i+bxY/s5VtKAxjvaiksSy6I9+eFtns9dccKEJD7QOkFs0Eg
 nqhEhtqy
 xZJ9fWaokIq+Ai9bpNDEcqGadeO6CtZNEwFCsdRxt4zQ0raCvZ31O92TvquVd2JJt6r32oSbdKJAGx1Loi68d7cUOg8yIKKP0A1HXryBy+r/lO4xYfxyScavVY5k5ZsKhEAmfk8qqQd1t+JN2LEzxouuyRl+aIX5lzRtm6hB/AVV6ATMDgMNsbhHjCZZUluwiXZ689y6z8vORuh947VrhHmUo17lxbjH2hWJCKGFeyhN4KUQ5d1tS+2FWu7lnh+3CqParPusbjsds5zbarnE13OSPdaQyYYC+BaFeYEovHD2oVcqxH/5JAlSkNUvZmyHh+pzbeSX11I7Wk20RpeOlKdFR5SzHiOS2Yv+mWPmXahk31SBPCbtzJpwXVE7xJp5SO6ZawHbcaZ7z70sHU8iNu+7k6dM/pq3art4TAC9XTAkTM8j0a450UY8z8IRha5yJViqk1ty4iKHyWc6HKV25ckarGEYOXJFNd1CMaJFvL8mikq2ueXDucfo8qk86SWCNo22qBoXK+FXWckXbu/9MhB+4n0VHkA7/uul6AD4SNpHhhLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/23/26 15:48, Johannes Weiner wrote:
> On Tue, Jun 23, 2026 at 01:14:48PM +0200, Pavel Tikhomirov wrote:
>> The cachestat() syscall reads page cache statistics straight from the
>> file's f_mapping. Stackable filesystems such as overlayfs keep the data
>> pages in an underlying inode's mapping rather than in the overlay
>> inode's, so cachestat() reports all zeroes for them.
>>
>> Add a ->cachestat() file operation and route the syscall through a new
>> vfs_cachestat() helper that calls it when present, falling back to
>> file's f_mapping otherwise. This lets stackable filesystems forward the
>> query to the file that actually owns the page cache. No behaviour change
>> for regular files.
>>
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>> ---
>> Note: Memset change might be a bit tricky, I moved it to no
>> ->cachestat() path to avoid multiple memset on nested overlayfs, that
>> means that ->cachestat() is expected to be able to handle unitialized
>> cs.
>> ---
>>  include/linux/fs.h | 10 ++++++++++
>>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
>>  2 files changed, 45 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 6da44573ce450..966b6564707e4 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -53,6 +53,8 @@
>>  
>>  struct bdi_writeback;
>>  struct bio;
>> +struct cachestat_range;
>> +struct cachestat;
>>  struct io_comp_batch;
>>  struct fiemap_extent_info;
>>  struct kiocb;
>> @@ -1963,6 +1965,8 @@ struct file_operations {
>>  				   struct file *file_out, loff_t pos_out,
>>  				   loff_t len, unsigned int remap_flags);
>>  	int (*fadvise)(struct file *, loff_t, loff_t, int);
>> +	int (*cachestat)(struct file *file, struct cachestat_range *csr,
>> +			 struct cachestat *cs);
> 
> I suppose you can't just have it return the real file because of the
> with_ovl_creds() scope you need during access?

Yes, AFAIU in overlay when we use realfile we should always use it
with_ovl_creds(), even though I don't think there is anything cred related
in filemap_cachestat(), I still think we should follow the common pattern
other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).

note: Actually some places get ovl_real_file() and use it without
with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_read,
ovl_splice_write. But those look more of an exception than the general 
rule. All other instances use with_ovl_creds().

Also there are simingly no other file_operations which return "realfile" 
for further processing, mostly the operation from fsops simply replaces
general operation with its own logic completely.

Thanks for your review!

ps: Hope overlay maintainers will correctly if I'm getting this wrong.

> That would make things
> a bit easier. But short of that, this looks good to me.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.


