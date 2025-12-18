Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFA3D6E2CA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211466B008C; Thu, 18 Dec 2025 12:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD966B0092; Thu, 18 Dec 2025 12:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CA66B0093; Thu, 18 Dec 2025 12:54:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E38D66B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:54:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81D4BB6FC7
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:54:14 +0000 (UTC)
X-FDA: 84233340828.28.9B23323
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020129.outbound.protection.outlook.com [52.101.189.129])
	by imf20.hostedemail.com (Postfix) with ESMTP id A1E681C000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:54:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=ADLToAb6;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf20.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.129 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766080451; a=rsa-sha256;
	cv=pass;
	b=HZqXM27OfIVGDMtgqbjU18iweq72PIUHiLe/8wu6KsR/yFsqbX7jz6RuRRh9d2obYa5MLu
	4r4puSGAJz1iyG/eCGTy+bE5tZy81cLlgzweA6e/2DGqiBdVcOT3LJ8yXwGxyb2lXVQQBb
	iKhxTdfMWOIxtQzd7AnEhR2c08Uizgc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=ADLToAb6;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf20.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.129 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKEP/rhlhIAzj8GUfe1dbOwqvomiqpqCMHsP+TxyDn0=;
	b=odePtrSvxt517hw63PnW5ppAQMLTWyz0ikoqZjWMU5dglfj6VZ53C1gR9lc3yoNp3PeFJY
	xxKXsj09JwJlkgKLT5rSxPUNv1e3RufdDN3H6wTf1ncJrdMP1HnRoT4hz/Y601HQAC7K08
	NJyzPAt21XgNyFNdYhrYzJztN6CiJF8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TcAKdcPJRTU7ErAX3lEqjv4dYeCPzTr21juoZe0isNHSmvz8hrMJUfeYX0eaXd7Qy7WNL0PfGoHCdOCNX00n6+edmKPR9E5MZs0y6E2bTsR1oezdXXZnuGBf+PZy4MgCnCGhreGMRwZNXbYxOO53kQBHdSDhCvsrzQIN/929upp/Y9IYLXkk3l2DxkUwbvBFVRJ6ptPCKhRNQ/dChgU2GhhvUKcHgY2pvDrxkygvnCWKOO5vojw4ZUsX30SMWLmOHPu1RHgSpSfUInzYWmyjJ//r7HDWv4wK0L4XFcWN+aNSA7u0Zxfbj1q6qgdRXG2zYYkdccwhBFC7Ou23aTWsEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKEP/rhlhIAzj8GUfe1dbOwqvomiqpqCMHsP+TxyDn0=;
 b=F67SS4kcTHyUTGctRuK+jFrzFsslwO0chFk4LOmBmdrmobJkS+dbEYmj3/z+rf5XxGZfETNadVv6QaQS+e420B+iAjKFKQaM5CcBXT6D+4TYeen9U6yPHu/YeWlOPlQgrBhc1z1npNXb8S5qxeKlZmZzn6akZu+qBd51jf0CJEkYBlAJmuzlIyNYUYu4LmqswEGEFMgeHUn5/DFixmtMHdIuck9if5f1HPngEZidnuEVuhUGo1QqoWx7sUOQZiy5wAh9mKdeOXQg32GOK18wcHMrQ3GJudmNoIHPdzUIa5EddJqckqnQ4JVxvnxKtvXTihRQvq3UgzrLYjjQZlc/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKEP/rhlhIAzj8GUfe1dbOwqvomiqpqCMHsP+TxyDn0=;
 b=ADLToAb60gl4LgT1B1jHNpVCceZD+A/t0vy6f+ycghISx14Wfy7/H3buWnjvg2OkK1+VNQS2HGlBRFcNCA/9vKq70KxZUkmRsHVidqBiLIZ4WwRD9+ryMjnNactYH21bJeKwDAN45cDP1GFvS3RpEq2l3lDs+f8PZtsNL8CAMDDFw3NgMVVci0TngCFWrO9On0X0RSUjJmVepy6XLi0cbjCG65JDALe1IkkU2cSvdNqcWLFyO408Y4/uIR5QIiCOuQvizW4T3oiGC2ALNHAld7tmC/nnEgJDvno1siYxrEgSxYDfEBlHjBWbpsfyg6CbqhL5krAnyEXYTiCPy4LTlw==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT2PR01MB8693.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 17:54:08 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 17:54:08 +0000
Message-ID: <67bbeac3-4158-4eab-b42c-ca31adefef70@efficios.com>
Date: Thu, 18 Dec 2025 12:54:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 0/4] Hazard Pointers
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <54E94704-92C0-4F10-AED9-46DFCA61233B@joelfernandes.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <54E94704-92C0-4F10-AED9-46DFCA61233B@joelfernandes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0384.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::13) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT2PR01MB8693:EE_
X-MS-Office365-Filtering-Correlation-Id: f6fdae99-bf8d-49cb-46a9-08de3e5e70e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bTJCRVdick1DblNOQlZMY0JVVkxaYVhZdzB4ZWdGVkF1ZVJDMmN0Vnc5Q2tZ?=
 =?utf-8?B?S2tId0tRUE92cFJ1b2o3aTE2dk43eUlzZTdPVFdqcldMZDZIck9RM1VGeHhm?=
 =?utf-8?B?Q0hWZEtaTThnU3ZETDUvWmlXTkEvSTFIdHk4aUxOWFdweFpkWGcrVzBYa0I2?=
 =?utf-8?B?WnpNQmY5MTJNRFFqQ0kzQUN6dm12Wmp3K3pzM2ZIUDE4VVpEVXlvRmErZWhv?=
 =?utf-8?B?RnZzcGxpaG1ZU3pMb2ozQVpUZzJKN2hCaGllOUpCM1BwTVJmb3dCbXluUmZw?=
 =?utf-8?B?T3dLcnN2TmhCRm16YkV5aEIxNzNabmxNOThtN2pZenlTUU1PRVdVb0FpbXZ1?=
 =?utf-8?B?TXBSa0pnVWJ2S0tSWWdOOVJ4eEhlRjBpU1dyOXE1Nkd4czB4aVlqOEtjUHdX?=
 =?utf-8?B?Y0V2RldHcmVld24wSHEwck5LRnAxUVNrcUM1VjlNK1NpbmdlcnZIQ3hkN3My?=
 =?utf-8?B?L1FoeUJ3ZnZINm51Q0hqb3ZPbElxUGlrdXpxZGs4dlIxSXUwcU1Fb3BkSndS?=
 =?utf-8?B?Rzh1ZFFFWGIwSDhtSWx5STI5bkVhaVFqS0JpV1hVVTBZUi9vQ0VSRlhwN05P?=
 =?utf-8?B?cTFZYjAvYWpvM0V2bTBtK2hna0RkUEQxRkY0YnkzWlpSeEdUVVZjUjcyUjlV?=
 =?utf-8?B?b2hGSDhUeS9SRm9Da2NoM2NKWWQxUWNLajl1cjd4MmhXTm0xb3Vab2p4a1Rq?=
 =?utf-8?B?MVppLy9ob1k0SWZobnFFb3Bma1hSbTlaNTRPT0g5dVI0RTFSaUZ0V0s4a3dI?=
 =?utf-8?B?SVI0VVNwRkZFamZWd0NxRDgwZnp0aURPQ0J3WFp6S3gwOUdWdFFGR0JpeG43?=
 =?utf-8?B?REVJcXBsK1JEUUVMZStyWDl6aDRqRVVUYk4wZmsyOGlJSXl3dHdiWWViQkp3?=
 =?utf-8?B?dkJXWkdvMEY5NjRNZTl1MlFLRkU4d0lmVEtqNnI4V29qVGxadHQ4YnNZdi82?=
 =?utf-8?B?U1k4T0VIVHY4dHFMSkVSdVBURW9XMmlwb1BSc3o5Kzk5K3drZUZHaUx6VU8y?=
 =?utf-8?B?WmFJb1F5WFExNlBjWGd0S1ptMFpxREl2U0pQZ01PcjczMmVFdVBUVElkLzQv?=
 =?utf-8?B?Y3pKT3Yzc2tNRW5EbGlCdytXbVd3aUxqZi9mekxNZkw3YXJHVkQycU1USFhD?=
 =?utf-8?B?WGdLSlYwWGdlTEhlR2VxQjRDN3cyVWx4QlZsdEVPYlN1elZQbmpjT0xUbEt3?=
 =?utf-8?B?Q3duQ1d1RG9ncCtZRENkUzlORks0RGQrd05FeTVzQk9OVUtYbEtUODhpVEs0?=
 =?utf-8?B?bVJjUXJaNGlnM2h6clpmWUxnTms1UXNGZ2QyTzFxWTZweGlpTVBtdnJDclVK?=
 =?utf-8?B?aHZybC9DWDhaL2hYclA5VDlUeGxHYWpLU3JKVGErVmlncERFZm1EY21ZbVVO?=
 =?utf-8?B?MkxCR1h2aU9TeEc0c1BoeE9EQk9SMG9UNEVEMkJiQW5mTWNSQ0o1TitTVjRs?=
 =?utf-8?B?cGpqdk9HbWZjUTZBWDBrR3IwM0J6OHhMYllZR2lNaHVxeGF4Smg2cGs4akd0?=
 =?utf-8?B?U1JOK3NnRDFCVDFRZWUvMFpGSzJaZVcwMXRSUk9DNlJDYjZmTDlPWDRUQ1V6?=
 =?utf-8?B?d2tPcFdYbjFTTEtiRWtkL1dWbXpray9VcWhrN0ZrOG5NL0x0N1o2bzBBaGZv?=
 =?utf-8?B?WTlnSERCU1lmZ0VOWE5iL1J1YnpjdlFMaXB5RExUbFk2Z3Nmcms1bkNrQTFY?=
 =?utf-8?B?bXc2MmhTaHFOU1pJYW9NbDIzYWV2dUZMeVROQXdIWGZuK25OSGdQVHVmZVBq?=
 =?utf-8?B?ZWsxblA0UUlWaTBuTUVEU2pDMUl6NDB6cTRVYWlhbE0rYmxnek1wSlJWZG84?=
 =?utf-8?B?TmdnZzU2VDViVDRaaSt0S1QvY0RHaXFXVU5sbjlRcG0zNDMxMVREdzlBcXc4?=
 =?utf-8?B?RS9kSkVkMU1pbWxtMzBDdkUrd21qS0tNRXNNTHl4dyt0K0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1U2T3dqWlFDcTdaWldYa0I1cm1RTjhjN1Z0SDRQTzVSSE1aV1pJQ2RjMmN5?=
 =?utf-8?B?ZGxPdzQ2VSt5S3lNNzZnNzBMRFhCd3JkVWRWSXdlNUNKT2IvVFhoYW5zZUI5?=
 =?utf-8?B?dDdrcVloNExsY29FMWlnZWlNd1FtbTI3UlpFSGdDb1FDbEJMV0tYZ0R5eHdX?=
 =?utf-8?B?S05ucHN3VzJLUnptSjFYaTlzaXUxZHhEQmh5dEg3RFQzb0czM2taaGVtRVFD?=
 =?utf-8?B?OW12U1VHK2VGNHJZYTV4eENnSUhlNU1aVkdtQUt3VVJkRWNoUDRENUN4Szkw?=
 =?utf-8?B?RTBuVE1EZVcxemtlb29zYUcxWGN0d1FiMUl3a0lMd0dkV2kzclZSUm5pUTUz?=
 =?utf-8?B?WUJVK1RvSE9QaWJNWXhmRFNvTm9LVGpNdFJpYUR5eVpOL1k0OHFnNlJBR2JS?=
 =?utf-8?B?V0VlNTA1TGplYkxndFEwUzQreHRsV2RybGpIaFNWWStGeHNNRnkxUzROYUo1?=
 =?utf-8?B?RU9iSk9ES2dDWWpIbWxRSmZFa3JueXh4NjYydTRzT1FORmk5dC85RVpSR2dW?=
 =?utf-8?B?QitNWWZtc1QvcW9ta1R5enM4ZUR0eHFzNU93VDVCUzZMT25kbWIrUEp6RXFO?=
 =?utf-8?B?V2ZyU0xnaExtVkhsZ1V4NFZOeVJ6K3l2QmpYOWJTNDVDeTZQVlpRdEMxd0lr?=
 =?utf-8?B?SWdwbjNWWmpxT0pxVHdJVGliZi91T1VVQ1dlTGZpNXlWRjNjOWZnWVlmRXFC?=
 =?utf-8?B?ZmZ3RHdpdnBBdVpzUEp2alI3dW5OMDhSNyt0MUdyT3VENkRWaWZYb0ZESjlP?=
 =?utf-8?B?YmhVcTVNTGNhVk80ZFRGWGJ6UWxxSEpzSEJXRkx0RTdLZG9UUGIyakcwYnJq?=
 =?utf-8?B?aDJCb2VjbGZGOU5TY1lDcmdVMVF5OTIrYzdhMWRRUmFReThMNGVyL1BlM0Fa?=
 =?utf-8?B?Ky9MWDhTVnh0Nit2UGJwOUNaOXkvQmY5Rmx2Zm16ZlBXa1hlTWpnWk5pQjlx?=
 =?utf-8?B?MVZkUFhTSi9mODlTZDBuaWUyOFZZbWxMMVh3ejJFNTZ3Z3R1eC82VzAxOVhF?=
 =?utf-8?B?eVBST1dwdTh2RG5BNjROTHRmQzUrUlNyS2p6SmR4Vk4vcW9UeTRybVY3eWVq?=
 =?utf-8?B?UVBGYjdqTkpMdjRleXdNVnJ3SXJEZVBPK2dQaUVBay9yVzBQV2Z2ZG5rZ0JJ?=
 =?utf-8?B?K0dCS0U0cUJnMnd6dzEzY0hZNVAzbGdsVEFFOHE2S0xwNGhmczJCTWg0T05S?=
 =?utf-8?B?WFBGMHNXVUVPUDBJV0lYWGtCWHhQTldzbzBXUm1nL1pQSm5wL0plSUM3R0dI?=
 =?utf-8?B?Q3gzT3kvZUh6c0hYcEJXUU9MOURINXBCZWxxK2xyTytqUjB4ZHZuMDI0RzBF?=
 =?utf-8?B?ZGt4RVJsU2w1TUdlUUpMN3BNeXcvUDRLSFhtd1dUWThjbG1za1p1Zk81MVJh?=
 =?utf-8?B?dm5OVHFqbEpLWnFVekkrMGM3MThoNWNIVTN5ZkVZc2V5M1htZlQ3aDc4cGRa?=
 =?utf-8?B?M1hqVFFvL3NYUjg3TlYxRDNuZzN2SS9YcWFvcGc4RWtGbkZ6ZlV1R0JOa2Fv?=
 =?utf-8?B?KzJXd1BQZks3TzgzK3FJN1piU0RVdS85d3E1OEF1OE5VaTMwN2hOSlRhdDVp?=
 =?utf-8?B?UkU0djFjZlRuTXRzTC9SVFNtNXFzeEN1MnZ3Q216WTJsRTR2NG0zNHpoSkpW?=
 =?utf-8?B?SytJdm4yekhhKzZUZm52ZTlIL2VHWkUzakY5NEcvT1ZLRitDalZXRGdXYTdY?=
 =?utf-8?B?b3JEZXpwM093NXdwQmhkYUV3SFVPMEhIaUNxK2JhaGtpWVYzYXBWT1dNYnRF?=
 =?utf-8?B?RStWb3duaTcwcUtZcjA1NzB3anBIWmtTTm1LbDh5TFpOUGJQVVliNDBaMTdU?=
 =?utf-8?B?aWRQbWRBdTA0N2tONzNMbFFGZllGNG1ZYTBxMGJHQlBFclFLcnhXSjZMUTA2?=
 =?utf-8?B?QUtQb3RYbGkvQUtHSlduRVRCU2ZvczAvZTROWWRJckFNeElLQnhGbFhjQmZy?=
 =?utf-8?B?aUlpUnFEa3UyMWVTeEQxWFRQOG1GTy9SVktKMWQ3Ylk3RmxpNVRpRUgxZG1j?=
 =?utf-8?B?a1pWWFFSZEk1THZLUEJTTHRRZ0g1QTZaSWVsck8wVmI1VXdURTcxZDdjek9z?=
 =?utf-8?B?bVdvSWhzTEFQZTZCK1c4am5VSTBUeG81WkI5MXF2dUl0VGZ5QVJSRk5XUXRz?=
 =?utf-8?B?dUgzOHNvRTNLRlFFcy9jbVB1KzJyQnpXYkhieExZTTB5UHhxMG1QUHBmeFJr?=
 =?utf-8?Q?x3Wr1C8c/s8kBUsJhLlKmqw=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6fdae99-bf8d-49cb-46a9-08de3e5e70e1
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 17:54:07.9094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBS6VlaP1f8nFe0KTM/CkHsKz0xF2C1UfsO6i6b/3AsReTGQXgXhGwv4xX3g7DoERFpfFApmmVsi9zBAZbDUFqWi1X31yzV6kpeaEL6lXM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB8693
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1E681C000B
X-Stat-Signature: yqqozk4piqgns9riyq1fgjfom4hu4dc9
X-Rspam-User: 
X-HE-Tag: 1766080451-121473
X-HE-Meta: U2FsdGVkX18jlWRSZ4UcnKtsFcyENv6uPg1VHKky2cwqpdLArytage3iNCLZX38SlzlLhohUPd1iceNGkwe/EqJ1ReIRrtpFFg0MJcrCXBsQMPMn+eDyCKF3+YQQueCLD183ssxYCo3sD1J5siyS1XChGNpkv6sgzmSfLvq5qQ2/lacpoMZrZefSeBR8y60KvBJq5fVzvYWycqtE21nbeKYb0OdxCD5+sRSK6tb52sQBhMtbTa0/qFJUGkmCxMF4zCpbh3jLwBrGsA1dp4rN286hmiNylHB6D7TmZhill2nkXnNCXII0IM2APtziIDd2qfAwfZIeFw9FsgeH2GGkjf1qzDoXZpb9OPNWKskXzBYyj21mZDF5ku01hvJCDh8vqwZr0T2HrE/ZsnRrBAptE4FoDSuQXe8pon/SPjFpL8zifYma5q4xSdstUXj95WOzU1NYnmBEBYRhHlqVslwI7jlBZjiwsQ8S1Qvym43s15hHF9NXvR8PkElqcNpdFj79pjaUi5a//z/dymp6cn0Isgg+0b4Kq1XaR/81L1QPp7buPZeND+4hkRRzgf/VkCD2ccQN3Z4zVjeD9dkvPVjqxklO2FkJhOLrdNiaawMsIoF8hjHanPueOnHHWxI8x+olJEawddI35Jiqwb/tdtum/SLjKPDyHxHoxrDP3mXD8FI0hvsts3eeFb/8EwOaGTPZsaSqUO0ebREWn2KiOd/VQ/Irr59HiaeFnyYfUcBXhViU7BrM2MtvURiNvi1gDrKNu4M+oyv5pGoDF9F0qPGDYthgKq420YB1pzMyNw/BQmUq+ZSf0Jfqb9/2VolMdiGzDDriGfoS8MPUorxk7YtqwFccU9V/QFD40lkE6CMMd1oGWDS4Rn1mrnjZKQMwLuujV3FnIdOO2d06c8UFSCqAZZo6CLKUrS3LIatf9o/g3tmRXvy6QvzAFDbPBGzQsQAcUsPcvJQMIqzZimx3zCp
 PiVk1bTz
 W+bGNmw77dhxNe53MI3xtw4fdlMzdoGvaBu5rjXYrURkwD+G9pV2tW8cxKwKbLQsUezWojALgi59cTvVYjnI2fimP6+d8yBYomrbN6snxJZ4edSQjfbI2x9XL0SHZ/SoxZXK4tWF03Yjb4TfQJWXT8mIxadNCzG6mAbELq+OwXfvYUF4qiorfc06YGOHiKfVX6BsHSF7utv7zL7vgTcxQxRv3wB2qZUgXcE7J2E1V2NgjT8BN8HwUScfVd2LcdET8MmF27GXgd0znUjYtKj0ujD84gByVd0PNYqvB2uxrIqfoeVY7BUJSZaiAtQN9/edxxuaCkzZ8NW8yKrT4iOnKmc0qrAKCQOQ7wgafizzVx7f77kOLs5HCElAneYeBPDN9H4IkXtjqRpbSKoHJlHAUrVcuqY4f4xdgoMY8XHXCqIex0i1P/g4W9WNsPEBdshjrhZoQLFsyRRI2+hXN13xkWtkTY42K1IA7HLuQ0KofZGv3pQthptscvtHTTEPmBZ07G9GYBoxr4YT4zDc/hrHzPc9IxVtGQxRZIw3XMgDGcxMr5MM5N4QPsn9Qs294/WJU3Q/R7Quemxw5npk6V6k6h9B45AQ0gvEMdC/ENmjoubxC5TfoTx553mYKebS5nZTdrqU8nYxLmHLpxlOvq8stkIZom6/F+4MHfPLseeUnWywm7x0w+IokWVsVW/B04BRXAeSSTLX4PDh91EHNQtHXYqjtw9VLwm5TfKf6miswJmCV9zRobMtwRpEloy7sPeUFtgDOVj1MDk3Jmp7ZAUamh/LpmCSrZb28P0N6x3VEOcIGuhGCNRiRiJz211iqcojDRW5knrdch9QRRRqR1lApu13FTFsdVrr7SieoSBZUvhAa7cX5LOVZmTv70mMq7DerzYNehIHSykqJKGRWmWFLOtOZSzaXLMnxtL4ELKOj6zImkKLxxH0ta17i/JbLuhPMCsYoH20fmowZSPhS6L2vOJV7WHB4
 v7KHSrd1
 Li9q2XzpGmO3sBSjvuDSPD56O+2GYQpjVw5MsH4DN75XZT6/EjEOXUzfk6314RRcaHOaNyCS9awMI3YvpnUXudUI89gQcdHIklQxRN6Iw0WYcsvQcccxfxfWuS5R/b1bqn+OUP10s5/qgKu+V8mFSV9OF7UozBig9+zui0J8srhf57odL0XokDkeqllLnLg08/cCCAVNqMqArwmtDA0rpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-18 05:33, Joel Fernandes wrote:
> Hi Mathieu,
> Thanks for posting this.
> 
>> On Dec 17, 2025, at 8:45 PM, Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>>
>> ﻿Hi,
>>
>> Here is a revisited version of my Hazard Pointers series. Boqun, Joel,
>> if you guys have time to try it out with your use-cases it would be
>> great!
>>
>> This new version does the following:
>>
>> - It has 8 preallocated hazard pointer slots per CPU (one cache line),
>> - The hazard pointer user allocates a hazard pointer context variable
>>   (typically on the stack), which contains the pointer to the slot *and*
>>   a backup slot,
>> - When all the per-CPU slots are in use, fallback to the backup slot.
>>   Chain the backup slot into per-CPU lists, each protected by a raw
>>   spinlock.
>> - The hazard pointer synchronize does a piecewise iteration on the
>>   per-CPU overflow slots lists, releasing the raw spinlock between
>>   each list item. It uses a 64-bit generation counter to check for
>>   concurrent list changes, and restart the traversal on generation
>>   counter mismatch.
>> - There is a new CONFIG_PREEMPT_HAZPTR config option. When enabled,
>>   the hazard pointer acquire/release adds and then removes the hazard
>>   pointer context from a per-task linked list. On context switch, the
>>   scheduler migrates the per-CPU slots used by the task to the backup
>>   per-context slots, thus making sure the per-CPU slots are not used
>>   by preempted and blocked tasks.
> 
> This last point is another reason why I want the slots to be per task instead of per CPU. It becomes very natural because the hazard pointer is always associated with a task only anyway, not with the CPU (at usecase level). By putting the slot in the task struct, we allow these requirements to flow naturally without requiring any locking or list management.. Did I miss something about the use cases?

I start from the hypothesis that scanning all tasks at synchronize
is likely too slow for a general purpose synchronization algo.

This is why we have RCU (general purpose) tracking hierarchical per-cpu
state, and specialized RCU flavors (for tracing and other use-cases)
using iteration on all tasks.

One of the highlights of hazard pointers over RCU is its ability to
know about quiescence of a pointer without waiting for a whole grace
period. Therefore I went down the route of scanning per-CPU state rather
than per-task.

> 
> I did some measurements about the task-scanning issue, and it is fast in my testing (~1ms/10000 tasks). Any input from you or anyone on what the typical task count distribution is that we are addressing? I also made a rough prototype, and it appears to be simpler with fewer lines of code because I do not need to handle preemption. It just happens naturally.

It really depends on the access pattern here. If you want to replace
refcount decrement and test with hazard pointer synchronize, a delay of
1ms on each hazptr synchronize is a *lot*.

Of course perhaps this can be batched with a worker thread, but then
you are back to using more memory due to delayed reclaim, and thus
closer to RCU.

> 
> First of all, we can have a per-task counter that tracks how many hazard pointers are active. If this is zero, then we can simply skip the task instead of wasting cycles scanning all the task slot.
> Further, we can have a retire list that reuses a single scan to scan all the objects in the retire list, thus reusing the scan cost. This can also assist in asynchronously implementing object retiring via a dedicated thread perhaps with the tasks RCU infrastructure. We can also make this per-task counter a bitmap to speed up scanning potentially.
> 
> I am okay with the concept of an overflow list, but if we keep the overflow list at the per-task level instead of the per-CPU level, it is highly unlikely IMO that such an overflow list will be used unless more than, say, eight hazard pointers per task are active at any given time.

The PREEMPT_HAZPTR scheme achieves this as well, with per-CPU scan
rather than per-task.

> So its lock contention would be rarer than, say, having a per-CPU overflow list. I would say that contention would be incredibly rare because typically hazard pointers are used by multiple tasks, each of which will have its own unique set of slots. Whereas in a per-CPU overflow  approach, we have a higher chance of lock contention, especially when the number of CPUs is low.

Contention on the per-CPU spinlocks would only happen if threads are
migrated between chaining of their backup slot (either if 8 hazptr
are in use by the thread, or on context switch), and release. Do
you expect this type of migration to happen so often as to increase
contention ?

> 
> Other than the task-scanning performance issue, what am I missing?

Task-scan performance is the key issue. Also you have to set a limit
of per-task slots. How would you handle the scenario where a user
needs more slots than the limit ?

> 
> Another nice benefit of using per-task hazard pointers is that we can also implement sleeping in hazard pointer sections because we will be scanning for sleeping tasks as well.

The PREEMPT_HAZPTR scheme takes care of this as well. Sleeping with a
hazptr held will trigger the context switch, and the scheduler will
simply move the hazard pointer from the per-CPU slot to the backup
slot. End of story.

> 
> By contrast, the other approaches I have seen with per-CPU hazard pointers forbid sleeping, since after sleeping a task is no longer associated with its CPU. The other approaches also have a higher likelihood of locking Due to running out of slots.

Except for PREEMPT_HAZPTR. :)

> 
> Of course I am missing a use case, but I suspect we can find a per-CPU ref-count use case that benefits from this. I am researching use cases when I get time. I think my next task is to find a solid use case for this 
before doing further development of a solution..

Let me know what you find, I'm very interested!

> 
> By the way, feedback on the scanning patch:
> 
> Can you consider using a per-CPU counter to track the number of active slots per CPU? That way you can ignore CPU slots for CPUs that are not using hazard pointers. Another idea is to skip idle CPUs as well.

I had this in a userspace prototype: a counter of used per-cpu slots.
But I finally decided against it because it requires extra instructions
on the fast path, *and* scanning 8 pointers within a single cache line
on synchronize is really cheap. So I'd need benchmarks to justify adding
back the counter.

> 
> Have you also considered any asynchronous use case where maintaining a retired list would assist in RCU-style deferred reclaim of hazard-pointer objects?

This would be a logical next step indeed. I'll have to think
about this some more.

Thanks,

Mathieu

> 
> thanks,
> 
>   - Joel
> 
>>
>> It is based on v6.18.1.
>>
>> Review is very welcome,
>>
>> Thanks,
>>
>> Mathieu
>>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: "Paul E. McKenney" <paulmck@kernel.org>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Boqun Feng <boqun.feng@gmail.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: John Stultz <jstultz@google.com>
>> Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Boqun Feng <boqun.feng@gmail.com>
>> Cc: Frederic Weisbecker <frederic@kernel.org>
>> Cc: Joel Fernandes <joel@joelfernandes.org>
>> Cc: Josh Triplett <josh@joshtriplett.org>
>> Cc: Uladzislau Rezki <urezki@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
>> Cc: Zqiang <qiang.zhang1211@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Waiman Long <longman@redhat.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: maged.michael@gmail.com
>> Cc: Mateusz Guzik <mjguzik@gmail.com>
>> Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
>> Cc: rcu@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Cc: lkmm@lists.linux.dev
>>
>> Mathieu Desnoyers (4):
>>   compiler.h: Introduce ptr_eq() to preserve address dependency
>>   Documentation: RCU: Refer to ptr_eq()
>>   hazptr: Implement Hazard Pointers
>>   hazptr: Migrate per-CPU slots to backup slot on context switch
>>
>> Documentation/RCU/rcu_dereference.rst |  38 +++-
>> include/linux/compiler.h              |  63 +++++++
>> include/linux/hazptr.h                | 241 ++++++++++++++++++++++++++
>> include/linux/sched.h                 |   4 +
>> init/init_task.c                      |   3 +
>> init/main.c                           |   2 +
>> kernel/Kconfig.preempt                |  10 ++
>> kernel/Makefile                       |   2 +-
>> kernel/fork.c                         |   3 +
>> kernel/hazptr.c                       | 150 ++++++++++++++++
>> kernel/sched/core.c                   |   2 +
>> 11 files changed, 512 insertions(+), 6 deletions(-)
>> create mode 100644 include/linux/hazptr.h
>> create mode 100644 kernel/hazptr.c
>>
>> --
>> 2.39.5
>>


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

