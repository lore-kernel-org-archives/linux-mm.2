Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91655E75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E654D6B00D3; Wed, 24 Dec 2025 08:52:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E230F6B00D5; Wed, 24 Dec 2025 08:52:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E5F6B00D6; Wed, 24 Dec 2025 08:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BADF36B00D3
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:52:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67085139FF1
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:52:25 +0000 (UTC)
X-FDA: 84254504250.27.C425D16
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022094.outbound.protection.outlook.com [40.107.193.94])
	by imf13.hostedemail.com (Postfix) with ESMTP id A42F82000F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:52:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=dR75wlmt;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.94 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766584342; a=rsa-sha256;
	cv=pass;
	b=4aXVGMZ98vCDKKlq5l0rDGvIndTw0zLQOr0H0nPRcns5Wusl55gdARY6qKEfalBLuP2G73
	L2VtI78aNaMCgHggnL/ahDq4yWltSVr+OdCKHdTbGVF0CrNC8/+wMblI1xULoLVtqO8lNt
	Kt82V9RmnwJI8Xngj7166bQ+WRGjO8A=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=dR75wlmt;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.94 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cb/5Mlucnwq4Fl1N/Y50Y29hkTN5lMT6zBWJRjuV9S4=;
	b=yqX9GlLKvu4yO4U3limKopAKAkJUobbhKQPliTsdipzL9jVGlcGcGoKS/2oC3ilQ+sgNMb
	/qjExlWc+/0TIhxw/rtlY1Fc4BcY6qqNM0BCWG431RXIFhpGoeYXOf36NhjjwJWlMXteVG
	sZdJwhPN9bhZlwrhApQ7P0V1vlMBSZg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vFEkTzvCUhOMFuwXiiL3LfQFPwCo7JhgPN+ZQPvxBuV2XNSmlpsE9r3NW55ecKEKNexQxZN2cc+KpzSb+xiQVLYDfN0iTfdTc2AWzpXx+cPevHbOVOxlDUXRG+fvPoDYfD8fQmh5B/MwTTmJiQojUnpcRIl8Tyx+LXP/WuARClx+FJTmr/kGjlsuvlo2AP1luQzrbkbRMIH2fMJdz8Zua5k0WnXMAgZasDAl1xZwp6604PX3fTSdaZpYata7UctSBMuKmWKxKDfL6c/abQ8DDYgm5Cczhw/A22kBM6ZQxvnYcpDcIsgMwkBoXkDYgsFmR/7aBZWNXbxTyDi6PkTdyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cb/5Mlucnwq4Fl1N/Y50Y29hkTN5lMT6zBWJRjuV9S4=;
 b=dhh7YB6iq1tyEjS6SGDpE9xvDXuGa2rOfKfVTtwhYh5cWa9O5FUtJkGBjXKTY6bSY708Tlix6WQe/Hu2ux4uEtq6rSBpxI7aQOHmddRgYSbfxIhBjyJvVE4GfnjgjOHJG/biOaWVAf3zDg+v88qC+pMj3ir9ZWcb6992KCRdhJ4CsW/+B71oHUS/QgdoHE7xEUmTjlzyBC9IfE7KjdnEPhZRhA19Sbwpi6fECxGLrAkymtrjqqaFCr00wc2Pio6eqKkiUpOG2iYmzIgEYOIwaVWa8vUR0v5lgHw0wAw28BNXGSz3Xxt3uVrCAh+8nPwJgE8HWXBlrkwL3vpzlem55w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cb/5Mlucnwq4Fl1N/Y50Y29hkTN5lMT6zBWJRjuV9S4=;
 b=dR75wlmt4vA9fUS5GgjeOsEH+54Ed7lIo5MX6wYPeI/X2vwr4DtfsBU98lY+NdNu1e4mnKbSbdQxdyuryHhp+SVPiAhV6iOnedHyXdSOIfZghXJi5Kzfz37RweQsWRyQrvkfTSinJvZa4QFNaaNOoGl+Gx6sPeFXu4jjLE+2VtfOR0oXZE8P3D9IouXvh4ROZJdUGhV5Hs5kvJHYWvCi9GkjJK354MrqDah2FIIKmiwIfxBnl5Ny0i66WNyAsi5POoamSpG+CNQmIzpdYs73Op7R7hRMyRiLSjx8XAQfelOQ7dpqNmOy4i3VQpD3FJ0kf+4LHcr69BCY9vclvz/FWw==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQXPR01MB6219.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:2a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 13:52:18 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9456.008; Wed, 24 Dec 2025
 13:52:18 +0000
Message-ID: <4b221d91-84f8-4600-83b6-a2aa16a02c57@efficios.com>
Date: Wed, 24 Dec 2025 08:52:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] exec: do not call sched_mm_cid_after_execve() on exec
 fail
To: Jinchao Wang <wangjinchao600@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>
References: <20251218032327.199721-1-wangjinchao600@gmail.com>
 <aUvYMRmkWXUuuWXW@ndev>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aUvYMRmkWXUuuWXW@ndev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0108.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::7) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQXPR01MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: 989976e1-f7b4-4fa2-33fe-08de42f3a71a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VGpZVzlEZ0x5dzZCSFFHU05KR2ZQWHM3dW1NNG4yNmVod3BGemNCNXN3MVRR?=
 =?utf-8?B?QkVUazhZdUNoQXVmTFRlWkU5VStkU1I5M0FsY3RncytGRlhESkZzTS9UamM5?=
 =?utf-8?B?bmV0WU9JVkhjY2lkZzBsZFM4VlE1K2tEMnlHYStZckZhTzNQeGMzZE96blRK?=
 =?utf-8?B?YVk2U090ZWhhaEJOc0pZem5kaGFHSVVxRm1XYkV2UlZsbm9FTHE2ajAyVkxW?=
 =?utf-8?B?R0p6cHRUd2l4ZkJwd3hoc2ZXdTNxT1B1K1ViWVZUblRqTTVYZy9mSkpCcGNO?=
 =?utf-8?B?SkxNZG5pOHVaZFdCcnppU1F6UWoySlcyenNBcGlJU3BjS21PQzN6b3lmUGs5?=
 =?utf-8?B?b0pqd3V2SmhEai9UdFBkL2o5ZjlaOUdpVGx4YktEZUxZQkpyL0dmUXpRTFRS?=
 =?utf-8?B?N2ozOXVrSnRVcjZjY3I5RG5WcWJTdnZTRmlwTDFZZFNyR0pEWnN6Mmh4TG1s?=
 =?utf-8?B?OUlSYTByelhVTXh1SUxLNVJRVTlMRXBwYzluMmFLU1RQa0E3UWFTcFZXUzdO?=
 =?utf-8?B?R0R5bWF0RUttWmJUUjJWMWRMSHdGWnRTczY2N2J1SmxRNFpXOThkemx2cE9h?=
 =?utf-8?B?MUM4dWlYSlJySExmNFJRVDFQTXhhRjBrbU5Rb1ZSUnFmRkM3eGlNN3IzMVlq?=
 =?utf-8?B?UGJiZGh4eUc3M2g2akxCS1J4bC8xcCsrR0IxZzFUeVJuQkxJb1daQ28xTFY5?=
 =?utf-8?B?anhJWGRvWEd3YkNVVWNFdENvZ2JRbzdxN05ZdTNvclhlNGw1SGd0VG14N1JB?=
 =?utf-8?B?UkFyZDYva1BIRXNQOXk3MzVSYXdOd2RadVpHRnZjbmF4dTczaHFlLzhpVUln?=
 =?utf-8?B?QXVrQ1dUOWdab3BYY1gzVVZqclZaU1Iwb01HSk94aUU4UFhtdHNQK1NMd291?=
 =?utf-8?B?TzhWS1R6OS93MEdzbk5RYWd6V1A5U2JSMFNJNzRmVEJ5RXYyZlFSMTdabUgr?=
 =?utf-8?B?S2xaVU5YZkJ0WDZTYWVEdEYwSDdRdC9wNlN0UTlhS01HMjkycXNOTWlsY1pt?=
 =?utf-8?B?ejVBd0RYakpEV1dHR0ZNVnlkNTQ3K2U0T3JMR2ZjN0dzcVk4blJaQlhvc2ta?=
 =?utf-8?B?Y2N2Qi8wYWdUaTUzT0EvNTZLcGdaTUJyQVhMWG50cTVwcmkwYTVEcGpjRUZX?=
 =?utf-8?B?dVhpeFlveDZ2b3FDWDFDQlcvUU1hVHIxNDYzM1pEUUV0Ump5Um4rUkNneXlt?=
 =?utf-8?B?ZjdyamVMaWxnbVZZVUhaZkFISVJuV1MzQzh1ZlJ6d3c5blY0d3o0UUxOTU5v?=
 =?utf-8?B?UFIyRk5zaElpczdXN2IrVk1hSXY5bldmakdCbGlhVlZFbEZySE4yOWtqRU9m?=
 =?utf-8?B?d1I1N2oxb2NqSFZ0aHJWM1RLV2dyVWx5Q24vYXhGcU45OFBFS2ViUGxsb3lQ?=
 =?utf-8?B?TXp4QXMyRFJrZHllSkhQNGthcytueHQ3T0t2UytNb3dhSG9VYWwwdzdoa2JD?=
 =?utf-8?B?dkFGMG9GeFR1dERqaHdMaEs3TUlzeGRKUTRZazJUa3hiZ09wUTI0VWpGZW9s?=
 =?utf-8?B?VGFaSm1KV1lDdmFwei9aV2ZNSlJ5Y2pIQXBETit3cEVISm1wZVdmMnNWKzFi?=
 =?utf-8?B?OGJyNUdncjM1cGptbExhbjlRTU1hY3NTK2NBeUlqNnhFbE94b0ZVUkNZemIz?=
 =?utf-8?B?NWV6K2xJRFNIcUNHYk0vd1JUcURCRFp0VmU4VWwxMmdqTFNDaXpBME9IUDdN?=
 =?utf-8?B?OGsyTVBZUEtJdGlJYnloTnJhdmRUWEJWU1E0b01IcHNKbTVKb0lVWW8rV0VS?=
 =?utf-8?B?UG1hY0VmbFVZQnFaZWVKck03NE9QWUFmc3RKanlIbDJHUDU5dWtJZFhDZzAy?=
 =?utf-8?B?YkkzVEYrTHk0WEsyVVowTXRTMW1UVEdzWnAvTStXYnczV1AzdDcyK2tZYWxG?=
 =?utf-8?B?RWpUQ0NlWU9YNW5IMThwZVZyc3VOTEViMUZ0ek1rSzZ6eWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a21FSGJ6eGoyVS9tR0lCWlJGeVhkbmFUSTNSa2dkK2xyRGM2VStocTJiakxI?=
 =?utf-8?B?OWk4ejQvcGJ0ZFJobFhqOGt4aS9XOWZmbWFDTW1oNE1rTm9meFZOcFJMdkFW?=
 =?utf-8?B?azFOQVJCeElaNURxQ2I0VmNKclQrTmV3VUZIRGMrc1hucDhJMDVpay9BNzVH?=
 =?utf-8?B?Ti9Wa0dYUGZKa1NqTDJMMUtRUEtkbytra1BtM3ZLNHRYMjRzQldZci9IbHla?=
 =?utf-8?B?THBMdHZIa204QW1jYlJEdWFhT3k1YWNQQXROV0s2eUVBYlozWXllblE2TnUw?=
 =?utf-8?B?YnVpYWZMN1BOYlg1cUozWkltQzcrbkRWODdZYlIwb3ZZMFYyQWwwWWRJN3RJ?=
 =?utf-8?B?NVIrWlhXTFRvVlg4OXRDQUZLTUtZZWxmVzVqTWZkakpwRi9QeGQwaXU5YkZL?=
 =?utf-8?B?ai9lMjBrQkx6LzJBZUdYMkZNcFVhdnluUTh2SUdUamN1Zmh1ckhzSkdqbW13?=
 =?utf-8?B?QXJHeUpYZFc5Vnp4aThEVitTUDBuczZFRjh2Vk9HTCtodkJqRW1zVWRtNitk?=
 =?utf-8?B?K0ZuSnlweEVrTEpVakpYL0E0K1ExUGhEaG9yNGxFRWtBc3I2ZTdWUG5kTDQ3?=
 =?utf-8?B?YVJkdG9kdHZCMis0ZlY3b0k0ZmVmZDR4NnhXQm54Z0ErSWZ5QTFrTXhwbk11?=
 =?utf-8?B?R2tMVkpMVmNVczZnb2szSTVkbHVhRW9qZEk1WitoOVVZcDN2TG5jZUFwNHZx?=
 =?utf-8?B?RTN0RWZEUG1yRDk4OVJwbGNWUTFadlROa2NMWVZaZWVkTTQ4SnlXUHBNODlO?=
 =?utf-8?B?L2pXUDVBS3RLLzJJSDMvT21ES3RRMmduSGtFNmp3QUl3M0p5T1Fjb0s4djMx?=
 =?utf-8?B?ZXc5MjJtbnVQKzBYSTRrcitwVWl6QURmekU5MURqbTlTWVg4MXBNY2RmUmw0?=
 =?utf-8?B?NDdWSTFXR2ZQdkY3VWNjM0dZSUc0NjIrT3BwYjNLVG9vbW1YSjl3WlFUTkF5?=
 =?utf-8?B?N2ttSG0vZCsvTCtlQTh5dFFIWEtEclRQWXRPekxBU1d6eGxUQzRjNUlsR09P?=
 =?utf-8?B?dTg4Z1hSNVRYbVlZaE5mQXpZZTlUbDVjK1ZBRHU1NDMwQlpCMFFTc0dJN0Ja?=
 =?utf-8?B?eHhrZFlHWHE1Qjd4K05RU2FYV0lyeEIxaTFXV3NBZXZHekhlKzFDYnliLzlx?=
 =?utf-8?B?aEtQVlU0eWNIT3dqNUJYaG1xRE9jVlFzUm1PZFBpamdSZ3g4cmNDWDk1T1FY?=
 =?utf-8?B?VWN2NWErWlg1T2ZnOGVScnRRS3drVm9oY3NBdjRiQzhYN2xwbkdUclIwTk1F?=
 =?utf-8?B?QjlPMFVpS1dkUGRMQXRpSmlTOSswOFZqQXJjRXZKeEVWbDdSV1djWmJoNGFY?=
 =?utf-8?B?NXFsanQ3OS9OVmRzQVZOcXNJRkRieVMwelNTOGlCQkJ1N2tFcDJCc1hsM1Vp?=
 =?utf-8?B?Kzh5Vjc1aHdqdVNSNGwrZXB4blFBdEVWblJVNnNBR2NNck9OTnAyTjBCcitO?=
 =?utf-8?B?WDlWZjlaZndabkIrU1dhRTJHRVh0MklCQ1MwUnMwblZ5cUFnTDBiWVA2SXdT?=
 =?utf-8?B?czNsODJhVGNUNjN4bkhISGxDQzJuelBvc0pPQzZRTHFUQVZzQVJXQ0RvWi8v?=
 =?utf-8?B?RTBtZHVVcmNzMmE4VTUyRHE5RENRU0tBcDdrM2I1NFpVYXBDVTB0MlZqSFJL?=
 =?utf-8?B?eWhIRDBzRk1mTDRLWGp0R2dvZHRhK1ZDRnhBWTh1ZkpnK0xFcFdZRlBsOEpB?=
 =?utf-8?B?T1kxckE2MFZ6bXIxYWJPZjBsZDNSL3ExVXQxQ3VlWFQ2bWQ0YWJiL0ZlTTUr?=
 =?utf-8?B?SGthNExlV1JVNjVZanFsTXpFQnJodzE5ZC9rUGxJdlEyVzVqRSsxVXU4T1NI?=
 =?utf-8?B?Q1BSSXZPclVCWERsTS9GaEJuY042emdTUUdaTEdjNFdJaVJuZzJYM1NiYVRY?=
 =?utf-8?B?QUxpcWtrTC9JdmhKUGxNdVErU2ZVZU8rVEZabXZ5VnBjYnhvRGNEQ1NYdHVw?=
 =?utf-8?B?MysrWitEQ21TUGsvNDVrOUVEd0duUWh5MVhZVXJmc2RyLyt5R3FCUTM1NVU0?=
 =?utf-8?B?UGFwY2E3Vm5ORzRGRXhGTWYrWmJtUFF5dDArN0RpNXdKd0pCMjdZZVNXYXh2?=
 =?utf-8?B?OU1qbkxXekdoYmhzbDV3VGZ5cDJpR3h6UitkV2FuejVtQ0dTZlQzOU9xS3da?=
 =?utf-8?B?OEhKVVdOSXA1SXJ6Rzd3SXRtWWJKbVllbXVSQitsZEdpUjJKREVBMmhLVFh6?=
 =?utf-8?B?Vy80Y1dNVEZpb1pQeUoxMFpwZjJuM1UyLzNOOXdkVFFJbmZ0WG9QWjdoT1Yz?=
 =?utf-8?B?MFBqdGUxNFdleU85YS9RMnNSbDQ3enFUTnpxcXhLaE05SzFhaUtjMVp0WUJt?=
 =?utf-8?B?UWFRdUx5Vnd4a0dHMzJFR3pXVGdVMEp1T3orV2VJaEhCT2UvRUZ0RFQyMGZF?=
 =?utf-8?Q?YzS8h4gDeL/Amzh4=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 989976e1-f7b4-4fa2-33fe-08de42f3a71a
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 13:52:18.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZ6KWp/Cr9dj7kb1aFeP4bTI7DaoNe4u0+1WbilBShFu5J80+yj9+XJYDRMvqv6RvgZGHGKK7RKou1KBdCkoPxuM01wlVJZjUcAYa2HDvdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB6219
X-Rspam-User: 
X-Rspamd-Queue-Id: A42F82000F
X-Rspamd-Server: rspam10
X-Stat-Signature: oihk7cdfbfuoapo1856nm33jtma1jc5z
X-HE-Tag: 1766584342-444633
X-HE-Meta: U2FsdGVkX1+IacceuKw6zQ3pMltiRZ6bHUT0MQsZDbxIlu2GShT2nEvkljzfri+qI6R4r8z30rQaFRpCMgp+gKF2hJ7S6wReQF8bIH6jF9H6Ufuj4v7OOFwzD4GQ9yONGikL+YZHfX1rcz5FMa4qwLmlb0hMW0UY94VxhuVV7UyQZIbagAz2//gwM5nZKutF4jNepH0SGEcbPTaVkkpYnWkO8TafAN0zGBKDkaGYWWfiYJTlk3ZhD9wzQF5A89c4pUD88KTlkJCZOAFcyX5kzudEOfit4qw9ht6wcADIrFjO8I96sc+b1YvlWbFGYPOwvLWf7ZfoyeToYDexDbz7P6EdmEA34jvTMFj1nU5Z3DaL+ARlbMtydpOzKZIA4ADiwi921GEnHv/1yM6Vjos2kOMBw1FSfrKBXDzFp/Ci7qi69shvXg8RHGsC/KbU/7PKDoVmmvbI1W2TGj/FKb94DrxTRnW+kOnLuA2NGQaf2JpPtjZn7TitRTtliN5359pmw4tjk2judsOdE5OI9sIdgV8cevORuH+WWT0nhD/VdBNXGFi9jUEDf6WsOPB7lXuc4QEdxAQ1fHssliJS8W0CgGxFjcAcOOswhOfbK/kBTJfPpsmQYQ4xaRD1vxfOKV8BzhKCUPWvVBh0EGFBtJbFubP9NuUufdUNN34Yv4CISMdVRBFKtMYOZ32dFf4sjnSoICkLeHthr8qYMfLT1pEQKcgvfIYJe4ziZqlWC+D/DTMj2eWB/fxUp5CL3gYtU7KVUdVW0kDhsBlyfNUiky5CF2TUFOcXtv+EiXfUsmD9jp0c57aq6KEwNpXlPQT46aDVIMq+6WC6p4Z1CL4t69bGjP5RxQNP8nPHr9/tPUpumxMw/vybQgEixpUguk5RoO2xWtxJIAm/w7CDs+KaoKeGMX3dyRN48gketmbt6pgH/H9AOsU0EsAKvJTec3LlP7E2bRtKZ646S+/1Mp06XAM
 uN/++yYS
 A4FDABJjFDnldDF4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-24 07:10, Jinchao Wang wrote:
> On Thu, Dec 18, 2025 at 11:23:23AM +0800, Jinchao Wang wrote:
> 
> Hi, mathieu
> 
> Please review this patch for mm_cid.

Nack. Your fix lacks context and removes a needed call in the
common case to fix what I understand to be a init task issue.

See this patch instead which addresses an issue very similar to
yours removing the relevant sched_mm_cid_after_exec() call:

https://lore.kernel.org/lkml/20251223215113.639686-1-xiyou.wangcong@gmail.com/

I added Thomas Gleixner in CC.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

