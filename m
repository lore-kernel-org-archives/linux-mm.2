Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23F94CA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 19:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9AB6B008C; Fri,  9 Oct 2026 15:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D536C6B0092; Fri,  9 Oct 2026 15:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4716B0095; Fri,  9 Oct 2026 15:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 985A96B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:07:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D3B31C3C61
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 19:07:36 +0000 (UTC)
X-FDA: 85304021712.11.7AD6434
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020123.outbound.protection.outlook.com [52.101.189.123])
	by imf16.hostedemail.com (Postfix) with ESMTP id 027DA18000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 19:07:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=snJos3cz;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.123 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791572853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pP81Eq0z7BLAd72JQ9whwsRcEOvedvt9jGRcBDgh3rk=;
	b=TE6Xl2eZNBflwm2ej2qgefMtSQCvHxDtcobW0HfLUcSGwQjY/Do4rnqHfdFnXC1Fw/W/l2
	nuOJRXtMy8d/vz6aQzu/UgnkFElbGQefQpalScMoI4YEMuHa6uUChw7x9QxOOzDxzyzuWS
	oSO6f6BJjaTKUCsCwBBlXMXJjUEqnHg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791572853;
	b=pLQcv3EMAlsIinpu782milRG8TrgUeOsCVMZYCEb2N8d6O/f5/vQjOqlsOXB0HxdPiygTE
	vzucczz6+jkFHc8/6xQiUMvOMOa8677DXgxGknWtrGHRqI8i93hwxeOQeMXBo9BTXi4ur8
	hXTgayqaiiG7t7KpFEMTJplla414o08=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=snJos3cz;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.123 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SgAXRMK1Y6HqC5aAn9OeGSw1y6DHv1G3tXivRmOa2LZqMmGS1ddyb316mJYScUXOhAJvh2aueLuk744sFkdhMxc+dIATIip83GRf9/f1IsjyGY/xsekSwmkKLKG6dO/IVRvyJsFf+w+cPUL6edDaxn57jYVr95jMUTaYH6wghr22H73s+IU3EdWQk27XS+jFRjqYncMsAEOY3MmzMN7loUFJhoKkmJbI83kzj1CYmm50cXbapQocw7CFdWF5X4+OV2LAeRcWFuLrLZenkGaw9Sx8bbG8CJjDr6laHL8x7HRKOh3UMZ80Tk/W91PCEh/5Z8xIhtc4MBoyqjLh4u/QjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pP81Eq0z7BLAd72JQ9whwsRcEOvedvt9jGRcBDgh3rk=;
 b=E0gRw0HYp+eq0bRQjMWQmn+W2J9DcgsWOfPmFUBb4fhg3jKDKdpX/w2Jh7KsVVaCi0YI2Zp6XnDoc9dfmdyJTnHwzzcebJ0MYjzgf/TX9gRrEQDfpa6QDDxWKbiWfXJAIncemykK5RKQEAr1RkL37k+FvNN9tPC526JdWHBncDGuHQFZTw2yK0iatKZmCcVXDDxMXuorXAKX1qcH7IzpX1ZMjZP+ey4hV1ErkkyzUt8dQKmVYDuGqbkIoslIrbwmFBF63EFrQNai83MaLd4dSfbDKntudeL1y1l1s088Ba4RIPXzNm9l5bifoSd1gGyf9hw1PSRqd0f2FU96+Z2jlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pP81Eq0z7BLAd72JQ9whwsRcEOvedvt9jGRcBDgh3rk=;
 b=snJos3czM9Bsm+/MgBmePGZGiVDiMJkgdi93I70VF4y+lNY+Mi0Q19vBi/Z4l8+xfl/+6YCMPpBPX3FUxHTEdyxlKRUMi5Gn53vlwQMXbuo9Z5AtnZVU4+kxkNchpKoGkmMlhGaOo1EquqxH+Im5GeIUVnFgLSlpNmS5DVi49SAvWtmBHoM5Gxnj02Hjo4thbCvP3cQMCX8ay4XA08cRonreS/WuMxrojp0hcf6oVEYVXPKehkX3GxtdD6NhOj7iaEaQ26AzVBH/HPlfjAlxyggbHJdxr/SM6udTi43PILkDYDp3A1nOJdMTGd7gBWwSDl1X9vCWnASDQZLXbU0BLg==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQBPR01MB10255.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Fri, 9 Oct
 2026 19:07:28 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0496.015; Fri, 9 Oct 2026
 19:07:28 +0000
Message-ID: <f3d74794-a9da-478b-a005-be842b87102e@efficios.com>
Date: Fri, 9 Oct 2026 15:07:27 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH hazptr v2 2/4] ptreq.h: Introduce ptr_eq() to preserve
 address dependency
To: Boqun Feng <boqun@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Boqun Feng <boqun.feng@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Joel Fernandes <joel@joelfernandes.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>, Gary Guo <gary@garyguo.net>,
 rcu@vger.kernel.org, linux-mm@kvack.org, lkmm@lists.linux.dev,
 Nikita Popov <github@npopov.com>, llvm@lists.linux.dev,
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>
References: <20261009182142.6311-1-mathieu.desnoyers@efficios.com>
 <20261009182142.6311-3-mathieu.desnoyers@efficios.com>
 <ask6bmsDCCacOkKb@tardis.local>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <ask6bmsDCCacOkKb@tardis.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4P288CA0031.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::9) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQBPR01MB10255:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dd87856-f86a-478c-a351-08df26388ff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|7416014|366016|23010399003|376014|56012099006|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	YuK9u3z2Q8PI90w1Ouw/FGXHI3AuPzEUcTTAm21WVhQYMaM5sfGlF10JNaqg3Likj9kswsCc9eZrVNFrKMM8vikBfAE3jYOBohTeQFr07DAIVo6TkLKooNhD17pZ2CZpmAy418UIN8bY6++cHbpdhvqg7i18W8atLPbn0l9J6tC6fbVwCY8Kt3tH5fbpOKtlrIQA9fbnamo+kDJyXB1gLQYTQDIBCUdNq3CB79NyvNirBzTrJARkSROT6pJ3o4O6ZJdCklY6q/fztP3cIs79vOhHRzUhVf+4cYVVyz1mgyfwdxL2XRFbsv2LxrKZPCkIPbwSNPwefGFHHu3LHx4UR6BVeZd7ARovg5u8MWHlvIIbCzriAA2bAV0vgFM2RiJg0j4hqZzQ/iQozFhZBz9LgQ+gOhJAE9J0J7BwXfhDPPX1oeQ4oYDsB7vpdwh4BLdYPQNX8qzm+m67hvDujbCuhXbvfiibkwTumWWlxWEDrtU2OLWjYC9cFGowxpOgvxAK6RFCbBHYGS30TAcgkDqRwNw53fAZHVw6DkDg5EunAHuWtnsmhQ/tI7MxDWTnURCzAlODNrrHw4X7sAl31KpGkeTrTjMSUI2xlFFIQXbx3lk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(366016)(23010399003)(376014)(56012099006)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KytJWVlVL25qZHFwUTFnYTc2dFIxTDJtdHJuZFJLK2VKRmhKNXBWOVJ2QW1E?=
 =?utf-8?B?L2luMWwrSS9DWXRhNjR5TXNwc3hybk9CMHFlKzJIYmoxUXZ3ZFA3MHN3SThI?=
 =?utf-8?B?VWhTRDNJblM5Q1diUmdteXRVYTJ1SzUybk9LeUNON0tvbTBaMEhLRHowYTR5?=
 =?utf-8?B?RUpldStudnQ4M3RFMDB4TUdBZmEyVW9JOENmL1dJUWJaQzZZQzFDZUZVd1lX?=
 =?utf-8?B?K3JkRlpwV0hMVFBIbmRPb2txQi9sUWJVYWE4bEpRU3RiVVdQaFc3SmFKNk1M?=
 =?utf-8?B?K0E5b2xBQ0F6KzBLczJyWHZCOW1INW5GaTh6Y1Nkdk9CQnFrWGw5REFtZTZU?=
 =?utf-8?B?c213a2FRZnpPM0lVakM3RGFITTRObzMzQWRNSzZaMDFsZTBjZUcxblVTV1Yw?=
 =?utf-8?B?Y3kwK2tiQkZhM3NtNWdBUWx3eEJMaVZZVFZETDhZenVBcS90dmw1QTkrYkhP?=
 =?utf-8?B?VDl6ekxyM1ZJM09oQmRoWkZxeHdGOElpNFRROFhNSjZzSjVrcEpmc1BTR2du?=
 =?utf-8?B?ZGJDQ3pTL1dabE5hK0Z2L3F0aVo2ZkZmRk5tK0YxOC93MWVXdStxQk1odU9R?=
 =?utf-8?B?cG1iNnVrZFNiRFpMWU9VS1FrZWh5c245RTJFYlgrbC9qUlFRMDczQWRPNUdu?=
 =?utf-8?B?bXFyL3BWdldrZ0UyK1JnbXNJZFZ0V09GZVdzVCtJb1ZKNUFXeUI0SHJORTF2?=
 =?utf-8?B?OW1MdTloT1VJQ25qZjhpclpQTWVQMzJHZUQwR1dtR3dRYndVUTdxM3o5TEJz?=
 =?utf-8?B?ZmM2MWEvOFV1WUw1cTRGcUF1cTdXNlBRekRWYUJnQWxRamZLWGdHbHdsZ3VG?=
 =?utf-8?B?VGsvS0NBbG02ZXBYWWxzcy84bFNQMm1JYVJ3bWlDK2JDRlI4cTVQVElFNzha?=
 =?utf-8?B?ZzFXc1RnalhaVVN1cDB6M1cxb0VsaXYrbFArQStpK3NWREl6MFVZOEZVejlj?=
 =?utf-8?B?eEZINjJwZHpLclE3b1FTR3VBWHBYd1dYZzBybGp0RzFoaFFKYUptNmdaOW95?=
 =?utf-8?B?SHZqL1NhSktKRFNHQmFmVXJncHBkcHRDTlZ0N0l4MnlrT3M1bmkzY0R0VWxo?=
 =?utf-8?B?UEpBNFhpeVZGcUY5c2dIM09hQmJlbWQ3UW52Tm1uVXVXMTRWRDNMMlMvOEZh?=
 =?utf-8?B?WjdIdW9kU29nNGNnTWRTTU9ISHprQS9uWm1GelhQR0Q1alVsNitjNWc5STM1?=
 =?utf-8?B?MS9KdmNTU09SRWNOM2liNTdnd2psMzhacnZRbjZXbzM5VWNFQmFzY05RcVgx?=
 =?utf-8?B?WGUrRHBjanIzUmxWV2tpV2kvMzZCMlVuM2NDd1V6N0hJcXBjcjgxUTdGVzBQ?=
 =?utf-8?B?WUt2SjQvbUlNUGpCYUlhNjBFaHRyZDRSZnBlcnVIRm8xTC95OFFEVzB3Ym95?=
 =?utf-8?B?YnBlUzJoTktoVzljYUhCSi9NeE5mcEVZbTVKMWFNZVAyZzNlUkRrbXJsYnM4?=
 =?utf-8?B?aUorazlNMU1CT2t4OXI0VExBVDVmeDBueEgyNXBIcS80bFJPcEtwS2lLV2tC?=
 =?utf-8?B?VGZPYU1Xa3BGM2MvdUErT0MvY3hmZCtnSTBsOWRsamszb2tWUXk3aTgxTER6?=
 =?utf-8?B?S2xaYXArSEhMMEJQUXQ2SDlyVk0zR1FhaHR6QytOUkdpaldxWmcwMExYY0FK?=
 =?utf-8?B?Wko1cFNyck02TXBscEVleGFIOTJHU1ZlUWcxcXBsejVlaER6L204czEwMElN?=
 =?utf-8?B?Mi91WDI3NkFjMzJSbHQ1ZnNPUFlaRG9BZnRxY1ZCajF1VWVadFN6WXlHV0x3?=
 =?utf-8?B?elFmRHlQUnpiMkEyZDZDaE9LeHJld2ZKR1JTM3RBV1J1ZkNReVA5eDlMVnlU?=
 =?utf-8?B?Qk5RdWFxMFBNT3dLVEhUN3RkU3lXVG5vS2xacTF5ZTBDQ0NxdnhWaklDWWRR?=
 =?utf-8?B?SUNqTEtVdlQ1K1NwTzQ0OFZKUy9pdjJkWEJOcHFDWlMvU2FIUmFON1l6UkhM?=
 =?utf-8?B?RzQvQ2kyOTVnUGR4UzN0MVZPQjFwN0hyS1pKSllqVlp4azFDbHhDSmVHSjF2?=
 =?utf-8?B?VXNuM0FYa0l4Tk1Wc2xBSW0walBaKzZZQkhTRk9HaDAxM0hRQm1tMHZoUUdv?=
 =?utf-8?B?eEJjcEVaenlKQVNOMDlrRUFxSU83d0xRbzRPaXhLdEpFT3hmU1Z0bnltbXYy?=
 =?utf-8?B?ekpaQ29nL3c5T0t6NEF1ZGx0WldrWFdnY01ySTNjQWs3eFlIVkVZVVlJVGNh?=
 =?utf-8?B?Z0NaM1RVZ1NJK0krbkkwRXJtdXVTS2U5bXBaZ0Z6K2JZenVSSmp4eTJxTnQ1?=
 =?utf-8?B?L1BKTy93dUJSUVhtZjJwYWRYVmp6Qmd2SjlmbU1pcXFnNEMvZjZ0ZllwbE93?=
 =?utf-8?B?OVg0MlhkeDZYOUEvVGpUQUtacFhGK0NaWmY5U1FEMWNsMzhackQzSHJBdzVY?=
 =?utf-8?Q?jiMopA/gyThBekITLXNVfWGT2kZ9N4Iwke04KJshyAznM?=
X-MS-Exchange-AntiSpam-MessageData-1: G0uKo14TGE3fO/0uQoYJGcZ9RRizF4U30LU=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd87856-f86a-478c-a351-08df26388ff0
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 19:07:28.5625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cAqDclFDgPvSnfeZKLQqzxyVFjboDwYxxZOh039geOT4dGIaQ6Tx9EhwvzIG0DPVYEyrBa1/4qtJK+WyF5QUjXG6nlkIZAd/BNmuMwjW0zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR01MB10255
X-Rspamd-Queue-Id: 027DA18000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: twyxrz6bchty4i8w1zoyzn5rnj1t7ecu
X-HE-Tag: 1791572852-183370
X-HE-Meta: U2FsdGVkX19F+hhtl7sIA2135j5h0SbHbEwYJyn8ns52vb9+W2E/SyytbnwRmDj+tqbwQ1c4kMxaXoTceLbSXRhUkEKF9Dy+ECq8t3a6unq4kCmeKK3DWe3YdBD/E6/zdJTJmlZODF8dGSbypug8+48M0rtr2IsExq9Qap/96CsAXpiS7fqHLx2NeZVmHQVhcDpS4328471bbtzmGOMzT7IMpq+gGIAiIbr5xuc2vd8wnRqlbG5eH2wOAyqcyIykxhjIGhb8m8y5XdOOnAyAvKooNirHyM+UAhjKQQWc/IWWIlYX5HHlX0yKROWf++5yEaZom7tRrh8/xd2/bz2Bs7K/xlL+XPrzPwKPUlFP/702u1D7lgXtbaSXnwzevIiJf5bkMw9OYGmOi/5qFIhp/OtvQixgB2zhNLNXRh8uvrRBBzZWUqgfWn9Dn8y919Xt2SSix3ENSU3gcs3bn4zrk7aQ7egLnPasKlaNCxJDamwlbw/nirBD9TgL6wPLaL7j2+EKAskD13KXhUYSfUda43KqJgu5tPxL93TyOhjwMSfvok4sPVIJ4yg6DvRvdb7uyVLj7hwkyyvUKgpJQ3qWU0I0rqQeForkSXXg/iMJkOe1PghzoYcgXlGMK6sE8SFGyD+2N55Q1jYSeVaYGj3BiYzJ0nZP3uswqEDjgPoM+Y8K8geE/Z1FhbVgHhZKBfNiiXwBUbjhT/2+9kwPPw8d2fIkA27LpnAeeXj3DX/LWexFOcFteWpFlIK21T5xdDMSoe7S6nhFNwTTaV2XeJ6vvmPMG7nAAb6UfX8oF/lUVVcYoeNKTdfHCySf4XJemgpAqIRk8XTn99Ax0Ne+R+UiiXu7cjKhaQs7LMIbWn6r1EVyVHUzWcuu9Rv3pUP2pU7Qkcwew+/HTzNlDzazzBmHQPU+9G5WivqxhLZalM3KIw2gj5KSEwfz9AYjFQPTss5gbPaUXMB83iGPXTvpFmH
 jNRDQOKh
 WHC6es8Ixz5uzjw1QBcjuD3UGBzZNh1rs1CQ8/B6YHEUy60FEZxR3wfRpP4nSpcTCrj3rPw8NFqF12ZN9O2wd1NNvzV4orhB0N09pc4k1Vb2Lm4d1yvq8G9waqjOWiJSeNU9si2BsmFll2qKyyaKEyCIIcWnRkn3PD6+LF/CWYE4K5c508ezlDE8u823ItQh4gHuD2zbNTV0QVzqia1DFOv7e2q/eztApUGTQxcCXitWY/e6Jnz05t2TboCC8HSWp+7HSm95BxmoPGvjRmjnIfwwlayvTO9QThP+4dFtCZJ/Eh/DbmPtQiUIWSdOfuJ/jbpobAJnnw5h8PFmuqWrpoPiYQ+EOphVBnfptxC3GO4caodDoIwuwi/JxfhM/ZiQYDUo3zbWli3FZpYD2scfwPbNUKqo63Y7Qw6SedYN+LhFUH5F03FFihoIERk5ilDJ5L+Wy6bgKURdZ7JddsE+RpHp+3jwnabg3rO2D8cbMITua3C0HSJjPHuuODoOTZoteOLebihrZP95HNu8tnLGZY1dsoxsqOejEmJOpls5+WryiZFIpTtNTFLukFogjCawvFu8hMIKB0f77puTcwBKgPK8Rgn7yd0RTNydF2H5AUXasC6GHmOsBOVas/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-10-09 15:03, Boqun Feng wrote:
> On Fri, Oct 09, 2026 at 02:21:33PM -0400, Mathieu Desnoyers wrote:
[...]
>>
>> An architecture specific implementation of the pointer comparison
>> can be implemented by each architecture as asm/ptreq.h. The x86
>> implementation is provided initially. If no implementation header is
>> present for the architecture, an arch-agnostic fallback based on
>> OPTIMIZER_HIDE_VAR is included from asm-generic.
>>
[...]
> 
> I prefer the name ptr_eq.h over ptreq.h :)
> 
> With that name fix or there is a strong reason of ptreq.h:
> 
> Reviewed-by: Boqun Feng <boqun@kernel.org>
I took rwonce.h (implementing READ_ONCE()/WRITE_ONCE()) as an
inspiration for the file name. I'm open to change it to whatever
people think best. I have no strong preference for either ptreq.h
or ptr_eq.h. I'll let people chime in before respinning an updated
series if a file name change is needed.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

