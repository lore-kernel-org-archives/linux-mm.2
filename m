Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97067C79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706DB6B009B; Sun,  6 Sep 2026 22:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF096B009D; Sun,  6 Sep 2026 22:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CCBE6B009E; Sun,  6 Sep 2026 22:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37EA56B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:51:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7F081A05F6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:51:39 +0000 (UTC)
X-FDA: 85185440718.03.728B390
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011066.outbound.protection.outlook.com [40.107.208.66])
	by imf20.hostedemail.com (Postfix) with ESMTP id D99D41C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:51:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fdNMuH07;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788749497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOv69Y9kWwA00zsckDOV6ICWiBKiNFOJZyNchtPUfL8=;
	b=h+w5TYKe6cbYL1tuaEFQrGSkwUtRioN5/ueBUunG+XRFOa6WTjz1CneFfVIZbna39RVMGc
	pMKvyEU8B+U1DpcdA0kiWn59DHn4P4VcnP/9iI2i3FYh59FRKsJhSGcIP/+aITwkW1aPGg
	X7MIR8hryScpT8WczgDJqf6aS7/D57k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788749497;
	b=bWrw1NilPzgdtLaH+LHrIcNuPuhFXtFwt6j5Jrym91jdEuVMA21J4qa2bk8acAW6+QKFxf
	sYIjUv9FSJF3QiLgb4KLGUasDFGAM2cq6W6APC48B5onqWdP9W8LWvU6cNdwzcYZHXD5KM
	O3FLaQm+JA2Dd56DGGmPVTVWnZENXTE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fdNMuH07;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lywMg7h5oxLj0XaRmBunzDvrRqfJH7Cu6KEzOvDFALG62u/CyatK6uHrmtClu3/PdWcXKNnzctUS/8VHEbgFiIEwAbStF5od0xEez6uqlMHNGXui5QHe2iPI9rMoW/50ITu9twOZ5igiE4gXPp9vVogeMccbrLEIgwdRj1GT34DoQgC0EJmwqDn1uIiNypy1dr+ndSQ6sAH1YnkuTgb0ETbkSdLPZEdKZbEXZ66w1ReXpSP9CHlySv98phSv2SeC2dCt88P4LlGogSN6My9NAUfrlerEBiCR6MSAESodah5dzf6hzrAB7Xn9x/MCK/Xu7tYK0W27MQQHXdd317/g8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOv69Y9kWwA00zsckDOV6ICWiBKiNFOJZyNchtPUfL8=;
 b=mh0mzfzLTqQamznuIBZsgFgXlu4hcaZadViDb2dy2C8JpSoHEo4XmtH6YjCkUy7jKiZg8jb9yJMZK13VamnP9SqbGGbpt72Vrrp95S5qtfo4Xlp5v4o8yYe/X2uK7bLNMmldYPeqoPf/rm3TciZjvcQID93BkDdQKpgUucVh8fHEFl3iApKjw/5LQ7iEjvLy+sveh05cJ/KohXz86aiLpLynMrZPRhyBCrAl453eKVu2JLke/UUGknRECyYsNEo5I9DG/6KYFIZB7ZrFoTPW10Q9q3tL6D0RJtjPbbe/6usb7tItENmoNGSaJJIYAIZGTCUj3zhKBriKAi2pZVu0kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOv69Y9kWwA00zsckDOV6ICWiBKiNFOJZyNchtPUfL8=;
 b=fdNMuH07rvOwo1C9HHir8H4McHRcmnUNNOGxCGevQtKSFBLICGDpWhXSAJCoIsqE+qwMtzgdk4LEtfXz6EFwPDjCK8ehlAshuX9V7l/X5Fa0QIGHu7U9c+k35M4Mra85CMJk5xVdUr3Tj3toNEPHRyomSCpRrzRY/nG3ApcSM7qR+TshLUIAgKRCww2kQyStcoZjLSjMQNso0hQEmJZAJU+pr/5SP/M3trJhMoxpyIVhh3FVAYd72Rntl+MTpAe7eTKLo6sMuIFWm/H+nIzruzcTHdoID01SDgCW52r3JQWnovsbOb1rZi8KCwC7OHIMJIkyMfJgU3mZ/c3rXbOTlw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4301.namprd12.prod.outlook.com (2603:10b6:208:1d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 02:51:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 02:51:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Sep 2026 22:51:29 -0400
Message-Id: <DL8QRV0RZS55.238LGA5F34MYG@nvidia.com>
Subject: Re: [RFC PATCH 0/4] mm: compaction: mTHP-friendly memory compaction
Cc: <surenb@google.com>, <mhocko@suse.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <rppt@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <kasong@tencent.com>, <baohua@kernel.org>, <axelrasmussen@google.com>,
 <yuanchu@google.com>, <weixugc@google.com>, <zhaonanzhe@xiaomi.com>,
 <lipengfei28@xiaomi.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Bo Zhang" <zhangbo56@xiaomi.com>
To: "Bo Zhang" <zhangbo0325@gmail.com>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>, <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
In-Reply-To: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
X-ClientProxiedBy: YQZPR01CA0152.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4301:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fcc5740-d678-47bd-7a69-08df0c8aebca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tVyo4eJW4KX7b9NTcCzH6Sq0fMcdi5unoTt/iYfybZe/SA81wM1y8XMXHWPszHEXZwN6sg4K7DnhwBVT2PW5hJtSyBpnYKZhaMF6zyzG3cKpXo6+WzN8dGNIk90+CUtRum/lpsSRp7+2MH7sRkmPsrgxh7vggeHFmqrt3gSRQWNFEEZxyd2MWw8Pha5e3dLWW7R3Pur/lvd/0E0Fu/rKENtw8br1c7XoIy2B6oe0HfjzAia+zyXkFmZ0hJMK2iXoTi+/2NsIfHElY/tUDukuoZNRU6RLXaDTXys2fNH60HkBv0a5vs7TPvgzzViamAqlRRjpVqa0Fq9rz3uhNX0UsQJ1cF+ARgl72SFHor6kKW3fpJaQgEeADk+wodSIdOsS4Gcg31dfztXdY4aVEuC1SdmfChl88U29iL49dLclHpo06GkBUPf+31VcWt499HfAJAjg35fS6QJ1I3crHDV6G/KTi+UqErg0+XbzxcJk88QoDMv9BNoBTm0GsYBqxmsuVwLsQNKhJiKw4f9Bx8HTQYS0vGH2/YpG5w/yR5RMLGGFcv9HZ4NgpbKtmkplwvey5/B2LUjYoX1aeFXjVRWx3IwhKM+wprzJDutByf2c6FqvKCQokAAdoEe6RdQyklUDs+IatalPRPOld9JnUO9y9ANYDyszHu2a603MoLmzBLI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0tyYXB4RjExUEQySVVURURYQTY1U1diMzNhVFBpaEhUNUlCblFVYzJMMlVu?=
 =?utf-8?B?NWNTOS90YjlWOUd3bStHSVNYRkszcHByZVRxSFlkNUFBSE1WQ042TDhWZkQ5?=
 =?utf-8?B?R3JPRmtsb2RyUlhPZTdxQmZlT3JMVkRGM1dJMlhZZFBURWFlYVBGdVo0djFH?=
 =?utf-8?B?NG9NWmNLLzNacmRsNXJ0NTUwdDJxMjAvcGdsT3RkZkN0bGRSQXVlKzJ4ck8z?=
 =?utf-8?B?c2FCVGlnYWU0SHR6N2c3RGZaRHFjWlNscmE0RkxIZC9jSmJoRnYwQzc2RXR1?=
 =?utf-8?B?TXlGVlpLZVJPQUQ1Ynh5eTFreGx6TS9FVjJrbXR4YUR2WXNweU9KT2JuSjZV?=
 =?utf-8?B?ZmljY3VhNGppam1uREdlTlo4UUFEV3hDbk1FUE44ZmtRT1NpZEUwT0tuSS9Y?=
 =?utf-8?B?dFlJTHhwYUIyOXBtS295b3ZuUlgzRFNMT2o5SC96c3h5dElvUTZlTDQ5NjBa?=
 =?utf-8?B?M2o4elNjdjJIN0E3aHdXdGNzSzNlMUxXRlZyekxkQUNxRnNlS0VjVVBMN3hy?=
 =?utf-8?B?YXdxVEZyUFZLRkdJZFVMZUU2aVo1dVg3OTFkTkc4dWVOR2xJaXJxQ2JQUXM5?=
 =?utf-8?B?RkwweTljNWtkQmxXTjkrNHIzSUd4V1dKMVFTU2xvV3duSGFIWXNYc0pEM1lY?=
 =?utf-8?B?RmpQRGZ5Z0lRSjhlL3pxTm4xVDFSOWEzZTY4emV4SUdsNzNKMC9ILzlTUHZR?=
 =?utf-8?B?dm0xTENGRUFMb1hyZExsN2dtK2NDNFh6dldXVWxqTTB0RHR5SC9zaTlCTWpu?=
 =?utf-8?B?NmpPN2pvdmJTWkYzZnk3TWM5Y3NIZTk1clY4b3dSazRWR2lSbDNZank3Q1Bw?=
 =?utf-8?B?MWlHU21hOUNDWWQxRjNTdkpud3V1RmE4bXR6TmlMUEc3WnlxdUwzTkI5SHc5?=
 =?utf-8?B?aXZjNkxhdDhxT2NFejZMMFMvSWdxUXlpR1RUdWVWSEx1b0h4ZDFkZDJMTHZD?=
 =?utf-8?B?UW14VjdMY2tIMFRYR3czdEpJdy9NUVBuc2Yxb0J6dXRBcEN2M2VINmN0bkRF?=
 =?utf-8?B?MVRNa0ZwK2lJd1R4M0ZwN3NPRXVweUYwYURXMXpRdVdnNnlqdVUvNGlWZzRB?=
 =?utf-8?B?ZmNyWU1jaVEwVGlaRXZ4dW1YNUpoYmdTdFlQTjF4WkR0S2N0V1hNUE9sRkpD?=
 =?utf-8?B?R3ZtelgzOFVDR0svMHNQeERuTXVJR2hHdkRLajhzcTNiK1dpSnhzS1lhZ09K?=
 =?utf-8?B?a2cwNTBoUUFQL3h1S3FDTzJXcUJkOWkxVzQxZDk1cWkyNVR5dWIrSkZmYnUz?=
 =?utf-8?B?WWpmaHVlQnA2M1I5SEk0ek1Rb2RVTUc1WnRNUWs4QkdPaVBjbTZUTkpPcjVJ?=
 =?utf-8?B?cHlBWFpzaUEwVktoYjNNZDY0TS9Sd1BqQ2NEeU5mV0thczdtckF5WUl5QWpx?=
 =?utf-8?B?dVlrUzZjSXVHTERERUZQNCtETnd2ZmtJZ0orR2xVZWRTRXJjUkpXZXF1UUhO?=
 =?utf-8?B?VlU2aUUvUHJQS2Z2RXVlQUlEUzVnYmduK2F0RExwMTk3azdoc2dOemorWXh3?=
 =?utf-8?B?azJMOGxaQlZkZi9OeHB0VVdCTHN4Vit5RVNDUXJSL0VKMTBtS3Y5dzB1NkN3?=
 =?utf-8?B?K2VuUFhibUIwNHZVcjlTNDdHdk1BQWIwMWNOcnAyUm9YbER6bFc0eWpYSDNu?=
 =?utf-8?B?UTNQUTRYNTVXQkVvUkJEenI2aXgzWFJoeG50TnNJbDhWd1BzSEJ5VWdHRHJ1?=
 =?utf-8?B?L1pEVXQrTW40NE9aQTRXRThwVkVnOUZoeWhjUng5VGRXTmk3V3ZLNXF1NFB0?=
 =?utf-8?B?ekwvODByMCttWlNJVlV2Qms2K1F6OVdndTlDYVo0bGZ2S3UzdUU0a2ZVS1pr?=
 =?utf-8?B?dDBlcnNDRy9BOHR6UDBYR3NqRnVIOUpsV3MrbnYwNk9TUVJHZThwZ1NrZXN4?=
 =?utf-8?B?VkY3eDIvdlRvak1Rd010US84d0dBRzVBT3NDdnhvSUp0emYvUzB6RVlKd3cv?=
 =?utf-8?B?TDZNejhTQ0FvblBNaWVhWjdOb2FPQXdQQklEWEhpWDc2eG9ZbG1YRXl4ZU1O?=
 =?utf-8?B?NndMT1hORjFva2FtWHVZK0EzeGpqTm5FNEFQdGRXU1BYQ29EcEYxUEVFYTl1?=
 =?utf-8?B?aHpGQ0w5cHh4aExqMUZhK3lWVTF4OE1zUDM1ZkliWFh2UFpwdWIrV3hWVmVH?=
 =?utf-8?B?RktNOWFMZU5ubTNDOFdvWUpQODZtNU1hdllyTEk4NEpKVkkwQWJUZjRvbFZz?=
 =?utf-8?B?UnFEalhtRTVENnJJcytqZU1jTWc0VVZIRWJQQUVTY04wZzdtRXhZTlZSKzBT?=
 =?utf-8?B?UVI3TEFGSCtPWCtnV0krOEtpK3U2RXluR3NXQnBwRkJSUWlTN1FTVGVLODVW?=
 =?utf-8?Q?9BxnMNVsxdqOVY8W5X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcc5740-d678-47bd-7a69-08df0c8aebca
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 02:51:31.1854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7fScnR5GqQIfJqMD830s2mqKjaFPACO1w6AF7D5qz62lzZCJDC1STyzp43qveHb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4301
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D99D41C0003
X-Stat-Signature: eoiwtnoxh5odmpukgeauijw7ruwxdnh3
X-Rspam-User: 
X-HE-Tag: 1788749496-485633
X-HE-Meta: U2FsdGVkX19rCQ4dSse1RF7OsZnGrx+waelKgNVHOVtmbkx+hhZqPIjOA+Dt79VNicTwQ4hb5LzEXUVnnm3tp2vRAYQlvnFnTMK60snHeC8jDQXpW5AuSRi/SjMNbyg3aAR0pcz49EdVciirVn1+58FmvuKS6n8E+Job7oh1sEJ2hn8txgmMtfuZIFIzESo0yqu/ZuVj79UfSK2sqPV3YQc2IoTSrhE7pazojk3aIEnzpeLaeCGctCjqWCOd3dxgRXJe9mPi6h85igGeVS9giO4yJxo9NEs9UUNXMxKV2ipaKEq11aDE7MFVBD3AxnJeqKOq4YWQHO/JdUTY/EqQlX+XC6kGNnAc7JvbuNklW5GCRIIHFwzzI/LrzWri+6f9gvOktsqS4Z4U1yVBpC5VN9ZOD7J6sb+bvGmUJMFORYSlcnhYX6ONVfSIT/ps8/TCEHkIukaA3T3KPLy9RLi2Cr65zgsZvwKisQq3R55yX5CU7eL/ALD0FFIhtFd17ToIRtD84O9q30Ev5SqFL6q8C2QUWC8FdHNvOt9c2s6cgnYSV0qNqi4/4j+jw4qJtGa8vBa80m2Gs8Iwe3R4bvX+p98X30YDjuvUe8pv6Km1B7fjlk7DhFH6mZ5J/juNXE0c6ZVDu98mT9OET0UjuNGiNn5nUHLxHlyvp2bZ9ZA+77FLG/d2JOEw4QvbnQlx/g1yOAuxHFRR6IrbeeGaAWRDN76Z4T5UqN8raDSfFfB0W4znKHqMDugcoKcJ3RRPDLEFWbxqRarOfLYyayu6HQQMXJO+HnkfCu4tfhKi97DMbv/BQbJeDBXoTnZbhri4EsSCL/L86chk66/+vFdqjSYZNo7ii9d/uExcFIJ0N/dSy48ovUfEqlS94jHB6rdzXPoaK6vgUOqm3WGoZSNczslde1m5ps6FKRuYgQOtgmrV1/u9BrLh+aFMAJIcrQTFvegCQl2A4cok6XOdJC7tuWq
 VIBuWky8
 A4r1UOH5sUH7js41VHuM2vXzAGJRA2A3MYBbrXzNKWAB6U2rlccEpyVYXTBoXnwV2rqMBqPOAzzjH7cXiStdY38aDySbV72cXsw3wGS2kFs3oTVEoa+W/nRnn96ltYAMjdeaaYWZXBbwtVem3PaT6TCJ+dOGYnQQ9HwU513x7p8n5JkEdiNr7o8banQoDtloXFaQzpluSS1zklGiGL4CcZjiCfTMqqO8oyOujSCcHQft/XkL+IvtlWoX0XrvLT4yfBR9c8zil45FnvfF8li58qE/wwOVm8EjJCsUqg7dtY+Nj7Th9FBuCI6tTDcqX+1pYnXM5p5qyoqPkKMKeWcNq+6jJMeQbbvdmy7QXfQ4w6IxweeKUe7++ZfkHzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 25, 2026 at 12:38 AM EDT, Bo Zhang wrote:
> Hi all,
>
> This series improves memory compaction to better serve mTHP (multi-size
> THP) allocations, particularly for small orders like order-2 (16KB).
> The changes cover the proactive compaction and kswapd-triggered compactio=
n
> paths.
>
> Problem:
>
> The current proactive compaction targets COMPACTION_HPAGE_ORDER (order-9,
> 2MB), which is unfriendly to mTHP in two ways:
>
> 1. It migrates folios that already satisfy mTHP allocation needs. For
>    example, an order-2 folio is a valid mTHP page, yet compaction still
>    moves it around trying to form order-9 blocks. This is unnecessary
>    work and wastes energy.

But skip_isolation_on_order() skips a folio with an order >=3D target
order.

>
> 2. Compaction designed for 2MB huge pages is too heavyweight for mTHP.

Yes.

>    mTHP allocations are frequent and only require small contiguous blocks
>    (e.g., 4 pages for order-2). A lighter-weight, mTHP-aware compaction
>    strategy is needed to reduce overhead and power consumption.
>
> Approach:
>
> This series makes four changes:
>
> 1. Generalize the fragmentation score functions to accept an order parame=
ter
>    and use the minimum always-enabled mTHP order as the compaction target=
.

Makes sense.

>
> 2. During proactive compaction (compact_memory), skip isolating folios th=
at
>    already satisfy mTHP requirements, avoiding unnecessary migration over=
head.

Oh, you are targeting proactive compaction, where
skip_isolation_on_order() does not apply.

>
> 3. Allow proactive compaction to proceed concurrently with kswapd for
>    non-costly mTHP orders, since kswapd reclaim alone may not produce the
>    contiguous blocks needed for these allocations.
>
> 4. Introduce zone_effective_free_pages() that provides mTHP-aware free pa=
ge
>    accounting for watermark checks, counting only buddy blocks that can
>    actually satisfy mTHP allocations.
>
> Test setup:
>
> Boot Ubuntu with 2700 MB of memory, with mTHP disabled
> initially and the defrag mode set to defer+madvise.
>
> Then set the 16 KB mTHP size to always and run a kernel
> build with -j20.
>
> For both cases below, we run a background script to
> proactively trigger compaction as follows:
>  #!/bin/bash
>
>  while true; do
>  	echo 50 > /proc/sys/vm/compaction_proactiveness
>  	sleep 0.1
>  done
>
> W/o patch:
>
> *** Executing round 0 ***
>
> real	2m1.312s
> user	25m38.968s
> sys	5m16.934s
> anon_fault_alloc: 6328991
> anon_fault_fallback: 214553
>
> *** Executing round 1 ***
>
> real	1m55.370s
> user	25m24.482s
> sys	3m52.512s
> anon_fault_alloc: 6355263
> anon_fault_fallback: 108692
>
> *** Executing round 2 ***
>
> real	2m7.579s
> user	25m11.530s
> sys	3m45.456s
> anon_fault_alloc: 6355816
> anon_fault_fallback: 107852
>
> *** Executing round 3 ***
>
> real	1m53.824s
> user	25m26.774s
> sys	3m42.160s
> anon_fault_alloc: 6355457
> anon_fault_fallback: 107705
>
> W/patch:
>
> *** Executing round 0 ***
>
> real	1m55.906s
> user	25m16.985s
> sys	4m24.480s
> anon_fault_alloc: 6354486
> anon_fault_fallback: 109845
>
> *** Executing round 1 ***
>
> real	1m51.303s
> user	25m16.456s
> sys	3m26.629s
> anon_fault_alloc: 6392515
> anon_fault_fallback: 69797
>
> *** Executing round 2 ***
>
> real	1m51.495s
> user	25m13.075s
> sys	3m28.501s
> anon_fault_alloc: 6395096
> anon_fault_fallback: 67510
>
> *** Executing round 3 ***
>
> real	1m52.980s
> user	25m8.217s
> sys	3m37.506s
> anon_fault_alloc: 6389556
> anon_fault_fallback: 72743
>
> Before "Executing round 0", mTHP is not enabled. Therefore, both
> cases show a higher anon_fault_fallback in Round 0 than in the
> other rounds. With the patch, however, memory can be compacted faster
> into an mTHP-friendly state, resulting in a much lower fallback rate
> in Round 0. In the other rounds, the patch also consistently shows
> a lower anon_fault_fallback, as well as lower sys and wall time for
> the kernel build.

What about the impact on THP compaction? How does it affect direct
compaction for both mTHP and THP?

It sounds to me that this patch series target proactive compaction. Am I
getting right?

Thanks.

>
> Open questions:
>
> 1. When multiple mTHP orders are enabled (e.g., order-2 and order-4 both
>    "always"), this series only targets the minimum order. Should proactiv=
e
>    compaction also independently evaluate and serve higher orders?
>
> 2. In skip_isolation_on_order(), the filter order ideally should come fro=
m
>    the compaction control path. However, during proactive compaction
>    target_order is always -1 (via compact_memory), and there is no clean
>    way to pass the mTHP order down from upper layers. Currently we read
>    huge_anon_orders_always directly, but this variable can be changed by
>    userspace at any time, making the semantic fragile (the compaction may
>    start with one order target and finish with another). Ideas on how to
>    plumb the target order through the proactive compaction path cleanly
>    are welcome.
>
> 3. In __compact_finished(), the original code skips proactive compaction
>    when kswapd is running to avoid interference. Patch 3 removes this
>    skip for non-costly mTHP orders (< PAGE_ALLOC_COSTLY_ORDER). The
>    reason is that small-order compaction is lightweight and likely to
>    succeed quickly even while kswapd is reclaiming, forming an order-2
>    block requires migrating very few pages. Does this approach make sense=
,
>    or is there a better way to coordinate proactive compaction with kswap=
d
>    in the mTHP scenario?
>
> 4. In the direct reclaim path (__alloc_pages_slowpath), compact_first is
>    only set for costly orders or non-movable allocations. For mTHP always=
-
>    enabled non-costly orders (e.g., order-2 MIGRATE_MOVABLE), when free
>    memory is sufficient (watermarks met) but fragmentation is high,
>    compaction is more appropriate than reclaim. Should we also set
>    compact_first for this case to avoid unnecessary reclaim?
>
> Bo Zhang (4):
>   mm: compaction: make proactive compaction mTHP-aware
>   mm: compaction: skip isolating large folios that satisfy the mTHP order
>   mm: compaction: don't skip proactive compaction for non-costly mTHP
>   mm: adjust free_pages to make __zone_watermark_ok() mTHP-aware
>
>  mm/compaction.c | 83 ++++++++++++++++++++++++++++++++++++++-----------
>  mm/internal.h   |  3 ++
>  mm/vmscan.c     | 23 +++-----------
>  3 files changed, 72 insertions(+), 37 deletions(-)
>
> --
> 2.34.1




--=20
Best Regards,
Yan, Zi


