Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BDC6CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6DB6B0005; Wed,  6 May 2026 05:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89EE06B0088; Wed,  6 May 2026 05:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D276B008A; Wed,  6 May 2026 05:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 688016B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:30:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F07781A0799
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:30:23 +0000 (UTC)
X-FDA: 84736474326.04.D7EADE6
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023103.outbound.protection.outlook.com [52.101.127.103])
	by imf26.hostedemail.com (Postfix) with ESMTP id 71FAC140005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:30:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=transsion.com header.s=selector1 header.b=fv35N4AU;
	spf=pass (imf26.hostedemail.com: domain of hongyan.xia@transsion.com designates 52.101.127.103 as permitted sender) smtp.mailfrom=hongyan.xia@transsion.com;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778059820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQQLf+N1BX4ziBIGPAezdq+hY/cgy/J5GCp6qRIeLbg=;
	b=CR7S9tDZbpJ0maORdbc+f9OPV8E3c5RwqeTsL6lUja60IyWVhpbFOzZO6tS9HGIYtAODOA
	FaQX/vmtQjyLtsgU4sOljWTNhj8ghykOBVTBOwf3sgEW7NKBBAXP+tFZraSUSEGYYu9Oaf
	Sl6n4rjFXhXXJt2BQtXzwO2ojAYPPFE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=transsion.com header.s=selector1 header.b=fv35N4AU;
	spf=pass (imf26.hostedemail.com: domain of hongyan.xia@transsion.com designates 52.101.127.103 as permitted sender) smtp.mailfrom=hongyan.xia@transsion.com;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778059820; a=rsa-sha256;
	cv=pass;
	b=hCaYyFzk1RHBWUtPQqaOwpD+MHs8UNPQd2+xrQA0PrVRjG5j1xI9HLKl5NdIw5FjKZDWTc
	DJI2Dm0rJTRTKBrFiVHO9Gs/KPy4179t8j6zUu6U6CEQZWo5hz7dhfA3Q8BRmSJpaevunE
	2e9mZpb8mmT6UDWSAkPfNxcRguK7M9U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sOaDoaL+N0IOKBLepR0i/R3HDXmLPdDOU4j9enMBdBtAAgvzd0FriSa894sUeINr4A1f64Q6GSN2xt7NzIwdRusQcaKcl9Abv0uuNAyQIfgamOFcxZhydn/bHENmVEJN51p7MlvMF7HpT/ULpJlPi2ZrdviXk+FFnq9J83KSwnsA6LPAGM5Up62OUqx7ivmrSFnQvvXN83U8f0ygjVfEWA1CRL4Hug/OeM05t2dpy1sxCoX5S6l7hebB/x+33rbn+aIo4YAPIfYMGBL6Klh/gPadQ8mL15Zn1QPreqEYNOag9zpQrd0ErwidWCoILt/Yjf5Ar5FIh1rRf+7gvwhV7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQQLf+N1BX4ziBIGPAezdq+hY/cgy/J5GCp6qRIeLbg=;
 b=DGNO4tQFm6Hj8RY/EFCoFuFWPYnKmfjEVIvN0XJEjEEoIWpPp7wzK7ygMEyKEPC24KROKiKBWv/dXizfskjtO7OQcmLVCHMIQWqY01y2z3frtpFAC2z6jgi+wW+6GchZ3e2bjWBmNbfbxGAxbJmLFNgrj05+P94NpPT+UeFmDCHelsmL8S14I+nrpp7BoQb3RosGTx1bGw/jFBIr0GRk39AhA3J036+1F203IT0BBT5DOVrbe7tLqkY4IkzAeB4EwCHhU1myLYBBO4n6mLn87VlTu3QreCZTPnU3W/BCb16Spi7UXaCg3pC+KS5phN1CAYlDv0wNDxWpG1P/sxATKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQQLf+N1BX4ziBIGPAezdq+hY/cgy/J5GCp6qRIeLbg=;
 b=fv35N4AUx1FMI2CRFYKT4gROorAH9de1ouWeBmaCkxFv4GxB/GJjL/+Du7NJ/j+sCRFDEfr4scVSbtwgVu5RWIMUAhiPQeDzhj/3Djm4ZmIft56Zg/Osp88+W09+OwJj4BX0XbHpcPaQjaNI1sr5hyeMMUPyIxVkuxKSd1pWz3E=
Received: from KL1PR0401MB6196.apcprd04.prod.outlook.com
 (2603:1096:820:c7::13) by KL1PR04MB7706.apcprd04.prod.outlook.com
 (2603:1096:820:117::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 09:30:15 +0000
Received: from KL1PR0401MB6196.apcprd04.prod.outlook.com
 ([fe80::f2ee:1e28:9022:99f3]) by KL1PR0401MB6196.apcprd04.prod.outlook.com
 ([fe80::f2ee:1e28:9022:99f3%4]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 09:30:14 +0000
From: =?utf-8?B?aG9uZ3lhbi54aWEo5aSP5byY5b2mKQ==?= <hongyan.xia@transsion.com>
To: =?utf-8?B?bWluZ3podS53YW5nKOeOi+aYjuePoCk=?= <mingzhu.wang@transsion.com>,
	"kees@kernel.org" <kees@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>
CC: "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "mgorman@suse.de"
	<mgorman@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org"
	<rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jiazi Li
	<jqqlijiazi@gmail.com>, =?utf-8?B?cGVpeHVhbi5xaXUo5LuH5Z+55peLKQ==?=
	<peixuan.qiu@transsion.com>
Subject: Re: [PATCH v2] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
Thread-Topic: [PATCH v2] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
Thread-Index: Adx/rTRj8bqCVrGwQg+fAuKQnW2x6hdjc2QA
Date: Wed, 6 May 2026 09:30:14 +0000
Message-ID: <a2885b47-405a-44f5-b2d8-f49138672ee9@transsion.com>
References:
 <KUZPR04MB8965F954108B4DD7E8FFDB2B8F84A@KUZPR04MB8965.apcprd04.prod.outlook.com>
In-Reply-To:
 <KUZPR04MB8965F954108B4DD7E8FFDB2B8F84A@KUZPR04MB8965.apcprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR0401MB6196:EE_|KL1PR04MB7706:EE_
x-ms-office365-filtering-correlation-id: fd32e267-f50d-440f-a3bb-08deab521440
x-ld-processed: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info:
 0cOsR06xgf8++eoID3v0F5wkAKhfAKFyf9Ug3qyoLXvLp/YrOu7CbU1dnQBa4QGL9sFqOPULFYRK9QybixWFpPiuzS0pUq0DzwHRZ1owJEj50/Q6GUIOOMV4LrwEIWLUw3e0k3nlHthaE0Esh5Acz+cF3t1nLlOjqAwIsUdSXKemgNDgmEOipepQkX55ok+a+Jq1eQ7NdgGwGqK4dEKBRPjX0KPYJ/6zC96YvDl9yBNW1dom/rVRqk7sXGyWWT9XWgshmhMHZiDfhoRwSi9MCDgJMyKnXvyAI+khFo1LQf1M2NncpToXbjqSe9RY10VBngCgNc/7aWzCHkIOSS7qhOdj/ulM/XAI2m+jMoHXA6iSUb+ITe2O+bk4XkYU2jsKnlHFChv8/Fb/aAS8HwQdF5r6syVqAyfvvLwV71faXK+54UC8OQL5viSb7xFEg3TSG/vVqDkCqZoOseh3H9iPq/+yZSoSxun0sTQeqJZWJuJigHABMra/YMMAZM34fJiTi6/08zPQ/61Pv5w7BzzeEe7CeXZ4okr7ekRC0BxFxBPmI3sObiFASWCjODPgMBoj+c0EwQG1G7rVRzE+4/g0a0cpGUmV0uderjJjg2OKBYerTL0zlfyAQGMdl2dy/oAhzJRGBtG8NfFU6BImKtoHXFv5Tw7BsjaEAj3a7nluAcqKcMc1ljueNxwlbu0ej+QqmyGpjwF2psmxS4WIsL9cJZkyvbTERtXS7RSWouXtXcXIDDTgePuZV8ap7+ADXbb0
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0401MB6196.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MFZwTVpwNHRod0ZpYzM0cHgwZkZzSkZFVWxhYjBsNUt6M1lhQ0tVSkZpY21U?=
 =?utf-8?B?Wk1sWWhlNm5PZWpmQ1VNOGJZbEh2UHE1OFdUd29lUklKT0piR0l1ZGJYOFFi?=
 =?utf-8?B?S0t4aHIwQWM0L2xIMHBnLzVCUjNBTks5T0tvZzNGaVJjdWwvVVp5aExlVHpa?=
 =?utf-8?B?L0JKTlRpSjFnczhEQVN5eUlPaTE4WUFqQy9uLzlRbld1aDgvanRJYWQxQUJo?=
 =?utf-8?B?cDZaY3liNnZsYjNRdUZtSXFNSG9QOFNRV1NhMFVheW1VNGlKYW9VRkdqenhj?=
 =?utf-8?B?Z05kMXdiVVFBK3NDc3I0UWtZN3YzMms0bDVjVUVYTlRSdlVWdmt1UzBrN095?=
 =?utf-8?B?Q2pFSmpJT0FwMUxHUmZ2aGlYdWpjVk9mUkNtQktJMDJmNFAwSDE5R1NKaTJU?=
 =?utf-8?B?OFY0bnZnWmtpdVBCNGJsNVpLN3N2MFBTWnErR0d5YjRLUDVEc1JOdlZsU2Jt?=
 =?utf-8?B?WFNhczc5NWxUT2hYTmJSOHgralZvSHlkam5LRGxjeFJNTDA3SkdOSmszWVVo?=
 =?utf-8?B?ZmxHK2NnOFcvRjRjZTVRZFQ3QzFHZTdPUERNWkl0QWdmMEVBN1FPRDRFWlBk?=
 =?utf-8?B?TFd0Z096a0tqeDQwUUtlbHpzK0tVbGNXanB5OHNwTGhWYWVvMjFBa2k3UGNo?=
 =?utf-8?B?cEhoWE1Zb2NPUDUwS0VLV2laYVE5NjJuV20yUXBWV3I3V1JQVW5MME51cUlk?=
 =?utf-8?B?OWlEK2p4WXN3bmNVbHIyY2xGUXRZNHloSFFMN3VMQWJ1N0Z3T0RYNjdUOFJP?=
 =?utf-8?B?ZC8xU2RRQVQvVzI2am93UXJCVit2T3Nld2kvWlV4aURmaXJITWVrNzNqYXdu?=
 =?utf-8?B?cElSTmUzYmdQRmM4TGdPM3lzNzU0YnE1Nm92M0VtaWtYTzZ6ODcyWkR1ZnVT?=
 =?utf-8?B?U0hZRkYveUR2VnVWQnBxbkxyV25hLzhQL3VRUzVQRDR2L0MxQXhaOHY0Y0lE?=
 =?utf-8?B?RlE5bERuZ1EyKytXUWZGNkRYVjc4TlRDRlVZbW5PaHM5b1htejhtUHlrWUs3?=
 =?utf-8?B?a3QrVXBWb1djOVlwNjE1VStFNDNNQ3ptMmpCRHBwY2tRVUVpRklSMzdrb1pM?=
 =?utf-8?B?bmVPV0l4THhXNHlqWFdIdFRHQUJGcjQrcHFhS0VPaWJBV1Rjc1VyS1lzOTQ4?=
 =?utf-8?B?MktVbTlYaThDalcydGIydDQ2aDZYeDIrUndyTGU3RlVpUk1VSUZYSGxkUlp4?=
 =?utf-8?B?OUxnWEFPWHZhK3RPc0NGVzNxZzlhdmkvTHZPUGo2YVFNRmhaeGFDTnhTc3Jo?=
 =?utf-8?B?cDlrYy9kdCs0ZG51MFN6bFBnU0U3dzBiOXFVZEM4TlJ5dW1vNUxFSytYbDlX?=
 =?utf-8?B?TTB3NUdNczJYSU81VnJ2SFNIVy9hVEdudFQ2a01pRjQreG1hVXFkREJKRlEv?=
 =?utf-8?B?bk5jaXZTdnNDa1ZaeEJFQnFvQzVEd0FaOElpcmg4S2w2Qkl2SFYwdmdTYkRy?=
 =?utf-8?B?NkNKQ1JLWnRINSswd0s2WjJpaTFNcmovanR4K05CRWRDUGxhQ29VL3BybkNN?=
 =?utf-8?B?WWVwcWZjMWRHYUlFL1luZEErUzlSWUkrcEZkT2dJblZ4YlBlUHdGTXNJeEhJ?=
 =?utf-8?B?dDNmdVU5aE1mSlA5bVV4djJpV0l0UFFoWXE3dzJHSkZFcENLOGEvYnZqclZz?=
 =?utf-8?B?S0JhZlF4bmVUWnBTUjVMMDdRLzdVNEhKUGovenFSa1BCbTUvWm0wOGFHVVFq?=
 =?utf-8?B?SlVnMjRJblFNL1hiZ3kvZGQ5Tnh5TW1MSEtkN1E0bkpKNS9MZmtEZ3hZSmtC?=
 =?utf-8?B?NjRpWEdTYUFTT2J4VWhTM0Qyd2pUWnF1OXR4b1VLQzA5ejhjN2Z0eGNsdDEx?=
 =?utf-8?B?RUdIaUpDd2VjS2VmZGxIUUJPRFprOVhsY1JtRkE3WjVLQk5yUTZJMWtTOFdS?=
 =?utf-8?B?WXg2VkNLM0g4bGFKbXAvMm1wdklvaWJqTllZSm15ZjVpYTFNN1RsS09jUStm?=
 =?utf-8?B?b3ZUSjg2NE9Zb013VmllSkZYMnhaWVdpenFSTkhpa1pjVW5qekV4Zm5rTG0v?=
 =?utf-8?B?b1Y3U244dDNqVWRkNmkrVER0QnVrRnJMWGJKYkhFSVE2OWwrNHY4dWpwcTJp?=
 =?utf-8?B?V2REMFlGZ2JmV044clFSdEV3Y2pUZ0ZoLzJTM1MvT2R1QzNQb1JwdWQxNjVP?=
 =?utf-8?B?eDRkTHRsK0drTnBycEN5K3dFMG1mNFR3WUI4N0pRMysyUHJiTDNIUXJrUVdQ?=
 =?utf-8?B?eWR3TFFVSmt6d2Y1U1BLVE9jRmwrb213em1mNnBTbi82dVcrWGluQUEweHNa?=
 =?utf-8?B?YTIzeGRoTjBDSFVTT25uekxzOXRPR2lvWFEzNXR6bFFyNnZLU3grcEFmSHRS?=
 =?utf-8?B?NmRuRDhXVjY4cmRmZUxTS0Nic2RoWm9SdjMrZmRSVEM4b2JOakpHenhpQ2Nx?=
 =?utf-8?Q?MZpl/CbHUJmhZ8RE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1EC6EA338F3BA4D8761397BF0670E8A@apcprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: transsion.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0401MB6196.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd32e267-f50d-440f-a3bb-08deab521440
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2026 09:30:14.8223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dXJlJHEwP3g3uP+s6Mt/MGCOuZfkQZtw++ju9h+S50GoV1zDVWgTxO35EE6S7GNY49wrjrlNjKaUpnzHPcSCuArramm1u07Gfs3qmjo3Lv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR04MB7706
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 71FAC140005
X-Rspam-User: 
X-Stat-Signature: 31katqkkrmdc66u47nbcb5qod1eor7zj
X-HE-Tag: 1778059820-434978
X-HE-Meta: U2FsdGVkX19soVzDZXKVGFW47nVtowfttKMon4Exqwew3N4zGTaMm2FLQ47Rop4Ppg46FfSa/k+doSKiSELtCgnVFy6DJHNNbhoHykJ+e4QZOr2o28pJufrZI/yb2kP6qtbGYNzgVS1qC4SK4V4dqcsPbS6O5Yxexpf5iUWTEtVqGYt3BjxdiCMQaIMK5xy9v8ONwMn/0xr3Ult1o+xSmly1bq6McZIkMVGAqR1zQkbt4RveHjktL/tYBAFesTZC4A0LS139pX6X9fkApmsjyLDshfP9JrkaEFiSYmfFUbKdY568EH2SHYiG/5BAxwy3USdz5GJ4OKbQ41Im9Lu1NtK25Dao1B+oZ97OalVPDQQYNy/o1d4HpN4rV43royDNr2H/l5FioAOunZ1381Eg2UCzBkYcTJtUghMSaY8wZ+Q024cgD8Ogy3qJEKp1nItOJenZknyCJFVa2tbHojKn4jzVOcJzIuK4tJIjE+QdG/Eql94lIACOIeQQpBTAg41b7aKL2h9FfAZZ95ebnBlrXDazPg+qCoKUV8U/5MWOSX87WjBLS0OanOQ3gZ70lBNBM1PyCi9I0DkGLuN+I693JTBLSBOG6zTx6BtQjuFe4NmmuV98cw5+AmALYgCSG9lFfmadCjzcj+SjVPHTwtvsXtho5D/2+yI8JH+Tk75YEmR7go9gJuGHj0+Qf4pehSFXgcy4Gxd+GEzEwM2CI0XxUtVXDTlgzlNqzVR9EEdjaote6pRh0ST7XpApnWCLY7Vw0xR3nTs9rXosUGNldfooBo2tFL2JNSePsxj9YhOw6tR3X162y2jNxgz5dhPcM83Seti6vuuxO8igPT9iSL1vwwCCJDYNQHsxk6jYzVPM7xqPdBXdXjPC0FXM6zdrKQVnV6+injNqn9wR9iDxJ9bUrjQa/aTjj8R9DGOAmUslyX9c8ggmIbOy+CFJ0kOjP1CQLQxqB8dsykb2/MpgJgI
 HrB86hjc
 uj+mvZgGluX6Edyn8Q+sNBSLe4F+gm5iZ7Mxb398OWHptGnU7hMGfxwVRz9xfB6H6QhUNT5qxO8D8Z8IGuDBzNd6Ji+lxfgpEebXmZxVKUa10XvKzxx+sLLeRcBhUQr4ALoG6JVtr4Su6whRwmaKRsvAk/re1kgopWNQYjzsdXGGwNI3SPEooTClSZ4CVxD4Dg2hpmvu4WCsjeYis1vek64vObTGECnlJa8YcGA7R4COCAKXdHlyG5n5E7HWPxOQgLOWz5G1ak8b4ra5/MdwmbN9l2KwoYwPY00RYfXES+Ivuobm8NWLczHzGcM9IkKnKHrIydOLM7GGJnyQDAT1IGCggcpccxehjt69cxTE+bHqavWTf3XEcX7c7C3VhLV8kB7zwrTJaTDGMXPT3jCMXBMRtriQmFBKvBQFMBDI+SLrhAa5rhK05pdggHNzY8nrttvOlddrFFH0u8zRzRZJOUCpoZuNFaGy9o3079km76zti66OvEPGsxrqnHHuM4EohkKc8zHlJTrN9lMLANXnbnHkdDfSdlMSwpfbRl3eDvc7bSIZxvt4ZNeC4tPjHUYMqHtu5weTwWJ8B839Tqdy2aE/ok1YtNZQlEdJBTRLsCoxFBA8c6JtNm9QQvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gMS83LzIwMjYgNDoxNSBQTSwgbWluZ3podS53YW5nKOeOi+aYjuePoCkgd3JvdGU6DQo+IFRo
ZSBjb21tZW50IGZvciBnZXRfdGFza19tbSgpIGluIGtlcm5lbC9mb3JrLmMgaW5jb3JyZWN0bHkN
Cj4gcmVmZXJlbmNlcyB0aGUgZGVwcmVjYXRlZCBmdW5jdGlvbiBgdXNlX21tKClgLCB3aGljaCBo
YXMgYmVlbiByZW5hbWVkDQo+IHRvIGBrdGhyZWFkX3VzZV9tbSgpYCBpbiBrZXJuZWwva3RocmVh
ZC5jLg0KPiANCj4gVGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBkb2N1bWVudGF0aW9uIHRvIHJlZmxl
Y3QgdGhlIGN1cnJlbnQgZnVuY3Rpb24NCj4gbmFtZXMsIGVuc3VyaW5nIGFjY3VyYWN5IHdoZW4g
ZGV2ZWxvcGVycyByZWZlciB0byB0aGUga2VybmVsIHRocmVhZA0KPiBtZW1vcnkgY29udGV4dCBB
UEkuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZXMgd2VyZSBpbnRyb2R1Y2VkLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogbWluZ3podS53YW5nIDxtaW5nemh1LndhbmdAdHJhbnNzaW9uLmNvbT4N
Cg0KTml0OiBNaW5nemh1IFdhbmcgPG1pbmd6aHUud2FuZ0B0cmFuc3Npb24uY29tPg0KDQo+IC0t
LQ0KPiB2MjoNCj4gLSBVbndyYXAgdGhlIGNvbW1lbnQgbGluZSBpbiBrZXJuZWwvZm9yay5jIGFz
IHJlcXVlc3RlZCBieSBNaWNoYWwgSG9ja28uDQo+IC0gV3JhcCBjb21taXQgbWVzc2FnZSBsaW5l
cyB0byA3NSBjaGFyYWN0ZXJzIGFzIHN1Z2dlc3RlZCBieSBEYXZpZCBIaWxkZW5icmFuZC4NCj4g
DQo+ICAga2VybmVsL2ZvcmsuYyB8IDIgKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvZm9yay5jIGIv
a2VybmVsL2ZvcmsuYw0KPiBpbmRleCBiMWYzOTE1ZDVmOGUuLjBjNWY5ODVjZjM2OSAxMDA2NDQN
Cj4gLS0tIGEva2VybmVsL2ZvcmsuYw0KPiArKysgYi9rZXJuZWwvZm9yay5jDQo+IEBAIC0xMzU2
LDcgKzEzNTYsNyBAQCBzdHJ1Y3QgZmlsZSAqZ2V0X3Rhc2tfZXhlX2ZpbGUoc3RydWN0IHRhc2tf
c3RydWN0ICp0YXNrKQ0KPiAgICAqIEB0YXNrOiBUaGUgdGFzay4NCj4gICAgKg0KPiAgICAqIFJl
dHVybnMgJU5VTEwgaWYgdGhlIHRhc2sgaGFzIG5vIG1tLiAgQ2hlY2tzIFBGX0tUSFJFQUQgKG1l
YW5pbmcNCj4gLSAqIHRoaXMga2VybmVsIHdvcmt0aHJlYWQgaGFzIHRyYW5zaWVudGx5IGFkb3B0
ZWQgYSB1c2VyIG1tIHdpdGggdXNlX21tLA0KPiArICogdGhpcyBrZXJuZWwgd29ya3RocmVhZCBo
YXMgdHJhbnNpZW50bHkgYWRvcHRlZCBhIHVzZXIgbW0gd2l0aCBrdGhyZWFkX3VzZV9tbSwNCj4g
ICAgKiB0byBkbyBpdHMgQUlPKSBpcyBub3Qgc2V0IGFuZCBpZiBzbyByZXR1cm5zIGEgcmVmZXJl
bmNlIHRvIGl0LCBhZnRlcg0KPiAgICAqIGJ1bXBpbmcgdXAgdGhlIHVzZSBjb3VudC4gIFVzZXIg
bXVzdCByZWxlYXNlIHRoZSBtbSB2aWEgbW1wdXQoKQ0KPiAgICAqIGFmdGVyIHVzZS4gIFR5cGlj
YWxseSB1c2VkIGJ5IC9wcm9jIGFuZCBwdHJhY2UuDQo+IC0tDQo+IDIuMzQuMQ0KDQpSZXZpZXdl
ZC1ieTogSG9uZ3lhbiBYaWEgPGhvbmd5YW4ueGlhQHRyYW5zc2lvbi5jb20+DQo=

