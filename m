Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCBB606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=CwXQlqVl
Received: by kanga.kvack.org (Postfix)
	id 10AA26B05B0; Wed, 28 Oct 2026 13:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094A96B05C0; Wed, 28 Oct 2026 13:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50B46B05C1; Wed, 28 Oct 2026 13:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C30E56B05BF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:04:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5BAA1C0CD8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:04:14 +0000 (UTC)
X-FDA: 85372658028.23.600F900
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010020.outbound.protection.outlook.com [52.103.12.20])
	by imf09.hostedemail.com (Postfix) with ESMTP id 07E53140017
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:04:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=CwXQlqVl;
	spf=pass (imf09.hostedemail.com: domain of x-professor@outlook.com designates 52.103.12.20 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793207052;
	b=wXTuul3dYL6nbKn1BfpW3+JW2HOowPMACUxyOAik0Ze42XYkxcsNnl2Cu0s+rfb3vn5JFr
	Ia7g12La+R0Bl4dn9ZdRaicKQMzt5hkU+6wUDK2v4kPpyEOUoUb2wfCj0dA6eOwrnvKBef
	HRExkZEKqIq2I7quXw2ue/SnEyByt+s=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=CwXQlqVl;
	spf=pass (imf09.hostedemail.com: domain of x-professor@outlook.com designates 52.103.12.20 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8igprn/UOyCqFPmOG8oAlfP8pOfRCS5h0pQlsfqphP0=;
	b=8ldz7zsJgY+P/NHEWmdzYetdfC2fN6hfOCSy+Jyjlh28JarYc0yYj6IwPpjh0+c0SxTzZN
	FLyUkk5WVlY8GsWCSHWBSIdWEGUzQYEUftYmPzfb/TXGOCRgjzO2rboNFv8ENndTzhAB8F
	fvGOeol2cXr62+9o/0+zFHDbvHviEsI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPATaKhwqgzNDPAl7nGoF99ZxV9sGxwvu67RHMm/et+ILWeHnB9+7PEPe+3PIL12G1JZ9b0SwX3SJc7L6do16qwD1XnAzWGbGz1FPwaI5ySnNivxPB6c2gB+agiUNQrNie1zGzzV8ydmzwzFVY73RbK1A8UjoztBgeUFZJmcpdND5jyyyxuoc9jisAl0SFFWHk/KjEKySMc0tfh6ucLb5Lat49ScnozAkap0C4p7mHKjXCgkULj9+JbU70trANUJVFdvhg0Jr5LUO3c+ligpBD3PEG3PVtS9apj9Xx5Ipn3s3BIoZ7BILenoDjPWOA3rmbE68nmBmBHU+vfhPIObKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=8igprn/UOyCqFPmOG8oAlfP8pOfRCS5h0pQlsfqphP0=;
 b=htD8KR+UTuzmTtnpts9JscXvJpz/mfXX+LyN6SdJ/KFFPogzsNW9CoMB/WDPWf61NBs9Q2WuvbbKY07tiTcxJ58eWJnnPngqT+SR8ZvKAMnCMob47rXBfPkR05X9CKvxZdLkzyF1rUlgJ+7SYratdBf3wEpc4iOeTfvp5UpNs3jDZp7+lnep9+0Y271SJ6mUK+JKblvu7DMOdIxC9a7XRtannAxwdbqy62/H87r20mP6L2SyW0kvHVNMDM73GeCwSbFjUSaC3q71HqvBcd600/xfvRMB69RMRh4tvh3JzJpCDpuK7mpDDRAOLycZFMvUWoACPrjfU+/ncmNiTSpmJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8igprn/UOyCqFPmOG8oAlfP8pOfRCS5h0pQlsfqphP0=;
 b=CwXQlqVlMWxuVqYxRIXcBDQFZc2yCbmsdW03c3gBsCWoL494FQ8wGxBJKSS+H34lb1d0WYTTMukFs0EulbjMwBztQghf8AZavjOi8k8B3UQOeIqXVNuDZBdKqUJcUhq0Z7DgbJMsvOKKhulLTwzwvvwVqGDrD6Aq99+QYgaBrYFQP/Xm6g6MKTB445mk6W8vNaGz92BL9I2a47AISxrdt4YI0mMneoM34k4o73iUqJK60OEOuY/wx/f1aK3VLoFOisW1Fc0dRVNoYV/0ocr/8eaxwkc8yWc1BeQAPKW24hyHffHLrpVpV4Z3W8rdtmT5efl10u5bbukQS5WD5pw58g==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by MN7PR05MB211011.namprd05.prod.outlook.com
 (2603:10b6:208:633::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 17:04:10 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 17:04:09 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?iso-8859-1?Q?Michal_Koutn=FD?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: [PATCH v4 3/3] ipc/sem: remove obsolete SEMOPM fragmentation warning
Thread-Topic: [PATCH v4 3/3] ipc/sem: remove obsolete SEMOPM fragmentation
 warning
Thread-Index: AQHdZv5UKU1uJ5rxGEyHwtZF/j741A==
Date: Wed, 28 Oct 2026 17:04:00 +0000
Message-ID:
 <b15aa81787be84bcb7620e472885090d64b6bd63.1793207025.git.x-professor@outlook.com>
References: <cover.1793207025.git.x-professor@outlook.com>
In-Reply-To: <cover.1793207025.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|MN7PR05MB211011:EE_
x-ms-office365-filtering-correlation-id: 8af45324-56ad-42b6-52b8-08df35157aa3
x-ms-exchange-slblob-mailprops:
 dx7TrgQSB6cUe9t9Fs5HiQGsDL5YS4Qs1hmvLTozAuHTFo7WzRAWr5Pkm0wm4VDDgolulvSj6HtpdJ/FNvf4V8ZmI4Sfg4biMLGLxSgIScGYYLGrcEZDJvVF8hFlFKguBHmDdlAsAoWNUjhllovfVyeFA1sgEvlyB+A21TFzIRE14EHwQIsaipk3d+FChUwZziX3BVp0autYhBW4KrmABfE6MS7QMT3KSDKg3nthNSyO164V5NSqmKp8FOiRqT7d16VxjN6Yd6mEVgwbjv/TIC2QmrcEL5O5F5znm9fsT4r1sIVo1I5vuu+fAuvdx1tkYh5BWaVDq86rlEtei0i76dgR8PWeY6mQoSFrIEW5b5KTlemwdKvnChSuZ0vFnMc+UZeEKLPOc1zqpKz48J7U4yofmcEJrO5NBqsNW09BcryKNbGJDssEaXizPCtyVobCI4ze3+t4ZkMRb7blC+f+jMd+uXmEAGE1JjSuquIQ59SU1XGAIcevI9KDgP/f0w4e/ZSHU8xT7ITs1ueYuOmeWtF0k+19nvJgwcvVv6iVfg985xy07y8T0H+lj2ap9WZV0FYYwDwmScc8ZtSfG1k9uylr5KlSX/iaHXssrsxCBeN0sbY5BB2wuDf+boXJ+Uyd40PJwnNYdVm6emRBrdnTizxPnqyD/H44UbQ9+LrH1aSNF+MXolc3KHB30ZEONq4LMavxbbPiFa86qPS6dfxwks88dfTnBU88Y+Wj7U01Sc2lG3j2AbzIykcDL8FAUP8x3DwneWRtNr8=
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|15080799012|24121999003|16051099003|24021099003|31061999003|8062599012|8060799015|38102599003|4140399003|25010399006|19110799012|102099032|3412199025|440099028|52005399003|40105399003|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?/424k2lQpFjqS7ho4P22RKmfS1u0ZjQJgGG0zhZhyvbzcCm7B6vCpanvSU?=
 =?iso-8859-1?Q?q1vrIBxtJclb114Zrt70qjtidaCrwghx6Tw+RAJta8SMQiV4IP+nRI3T0H?=
 =?iso-8859-1?Q?ws3ABH35UbB1trLpaFYqGbjjEBiGclPPojdnkLkz3t84Vw+188Tj0ACVsU?=
 =?iso-8859-1?Q?q8gcePt+BsST2zbaLXqsROJOyKgoCW8HsiZPGQhr5PT+YAhvtgfGObk5RD?=
 =?iso-8859-1?Q?NDhBMOKXzZJEEufW82OTSFQrpP6tmnn/vFbUCo+JhQGmoBE6Q+hDxj3net?=
 =?iso-8859-1?Q?w3stmkwtSN1JjX0CGMjZSV5f9NdlzvytCZ+fg13yrmIT6SbnFdDbQtg6p0?=
 =?iso-8859-1?Q?ROwa9+eiUHctp/sHZxr6yemdhXSd8HKJ9gkUEnOZi5QHXGP9NWLlyVgUNq?=
 =?iso-8859-1?Q?COpv+p+kdy7SgBYHyWQo+CxAPjvldExX+7gHJDFHqerNNbleOZETuBpVwW?=
 =?iso-8859-1?Q?w3g6KxcEuShg8IQW5JRO83wKPIKrBgLdgXrvqWRm4GESAdI+U1wS7nJgTs?=
 =?iso-8859-1?Q?cqwmLvxg2PByz0cUXESvFYOAvx+tG3y8usr1eRqla/94MGT1kTVUKnPwM/?=
 =?iso-8859-1?Q?AznMDWNLuWFwsdv2CpP1eqPA502/YIKcZU/EzafCyGqucrO0HqC6T/4hb+?=
 =?iso-8859-1?Q?rpLS782FVwQEFDQZ3AOxd3tcbxb+vLdbdELbYKXaCHGjZi9ygXy5qMOO9m?=
 =?iso-8859-1?Q?jJoCwKsnROdhCfxDSt28N5Bg0aEIxVgjr59Xx+h57CSTLeDEB0XeFL4PEM?=
 =?iso-8859-1?Q?t0fL9wJARWsibV+AJig1bWwNxpLEuxvg6ke63iqAerqOnzdzkhiAoFlj7s?=
 =?iso-8859-1?Q?8dwCAiE+fOgu1TnO1HlbXSI7AZbM7Ok4ZpSZi8f89MijgtaFMEWeZQ9mOb?=
 =?iso-8859-1?Q?mXJDh/qw5xuBsr+ZTgExraaQq34qBYC8atvNkUMfq9yBksZ0ECT9YDKKCw?=
 =?iso-8859-1?Q?G8c4VuVgmUUnf5s0ZiZT9drkbTN1StmQHYWQQOsNh0qkMeIH+DKI2vvcmR?=
 =?iso-8859-1?Q?nXfqA1PFz73Z+Fs8UgRmiICqQx0zGZSM0ZsJ8EEpkClEOKIaesEkP4s5zF?=
 =?iso-8859-1?Q?Fhsbhl3zfypDAVhCULrXgdSj7czdjb49gFYrbEpC0nJUVUVb3Oxir+c/Af?=
 =?iso-8859-1?Q?tSMihUk3Ts+dd5j6FIX7gIli5MTBvZExImOTqajB+2CD7dkyff?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ZPWYktwBYO4cet1DZxv+L93tHucuNNmmgtt1m49n2PWsTQUQgp5wrZB8h1?=
 =?iso-8859-1?Q?AQzShDNeJQcuiFC95Sos6FCJ0IsEsvPygz8Io3A50Ze8PoOUc5RlU+4Lg7?=
 =?iso-8859-1?Q?PMTenCV4m37b5+iBMqERzNsF7g9la6+m4D4XafXLyDc+KiXVaGk0uvyHxh?=
 =?iso-8859-1?Q?35cFHqauHoBBgI7ml9cauUOxw7HIEXVV+ZerO7btUD2z98roKKdC+79g7i?=
 =?iso-8859-1?Q?HCZKI+9wf40A8TwrNtWrthqV/vH4oRuXrlqP319jvBjIrEDplDjl+6C5o1?=
 =?iso-8859-1?Q?Es2++X9VdL1nGA98TReiXeuFBdzYXDZx3QMLYfEf22ft6Ca4VLB5XGjfFo?=
 =?iso-8859-1?Q?Y1iSwJIMZe/idIyshCrOOIvWcLEdtiS0wFX+hQ1+PJEnAAidJ2uZi/GG2w?=
 =?iso-8859-1?Q?ciRu+7vikFOGc2dxQXhIPoeZCPWWQBhSCwOBZpk7hDnI1iznAXt5tGCCrO?=
 =?iso-8859-1?Q?lpB9OqvX7cf8KlEaxiL6QQs0crkVybfCWluql8aArCvntv3eY1l195yp7F?=
 =?iso-8859-1?Q?i58Y7Wl8CLEVH04Sk/k+jsYGs+uTzg55uo+h9QwDjY+schhSf0RIwtjP2W?=
 =?iso-8859-1?Q?e8XiaUD1g9NiVaaLMgI8wpjyUHBfu+7lpSGt6wmWOckw40j/Gd327FeYMm?=
 =?iso-8859-1?Q?fEew8nQXoyu7UFlsbqaXlGq5jf2hqr+XK5Rhw6D4Pkm/Qbf+dPlsXbJZrs?=
 =?iso-8859-1?Q?MYpLv38/qGklSddYpQnRqwvdCXHSHwDWEVnx3Vcuq2wM8r+KaTN0aIgfCt?=
 =?iso-8859-1?Q?ZMNSf8rv8MA82Ne/CxRPRSns9IcyPzgMtS5FZQ0SgmS8MC4MbmvCITwXgx?=
 =?iso-8859-1?Q?TFpl/b5bwg3oUAKF9wob5hmVudFDf5cPCn6qaFFKW/ZFIEKKyTOtnFwafG?=
 =?iso-8859-1?Q?dLlpJs2MxWhz2IIPpR0/1FbYP4/qzolGnDnrvYDUeeTl8a+Ml1uZtZCjG5?=
 =?iso-8859-1?Q?d+9FWib3Ax7wUCFPOjX0SpTgosY1vUY5jXfPTDUT/LnUV9mlS8sKKFw5DJ?=
 =?iso-8859-1?Q?NvR08DgkgUkCm5RLMGuqfanAjwzTjO7nUwsSd01nXOSXcmlKtBBKJCDBcw?=
 =?iso-8859-1?Q?aBuTDMECVxJ2g/I3EQMXCd48GHQmTKB+04mXZudonuNhnAGra4bnESTLz7?=
 =?iso-8859-1?Q?OBL3N4nr3zELpJEvXw8fPTvhJ+1LoDrInK6StH3TtLO610hHAjh/Kth3HL?=
 =?iso-8859-1?Q?szayivUjs1jbZ/qMvRKHK85jR2VXjdeoJa/ev3p9T78iHRLq7M4aDZpLPX?=
 =?iso-8859-1?Q?YuE5sJWcpkQRHgFXt27zOQkbnZR79PyvN/yc/Sif+bOb/7HYECiLCmYceQ?=
 =?iso-8859-1?Q?9MI3rEt/aouiiaEQg/SF5DCl6dn+wXR91GFBQfSp35cLqCODRudeUlsDkr?=
 =?iso-8859-1?Q?vYbw+HYds8W7Q5ZlUsrusTjafYOaJkIOI+LqgP5kvIk7km0mgWOgygCp9Z?=
 =?iso-8859-1?Q?7MUnsrayVGbseuDm?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af45324-56ad-42b6-52b8-08df35157aa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 17:04:00.8633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR05MB211011
X-Stat-Signature: nh5kbn5i8nsinsmg6asj18s6ijby368n
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07E53140017
X-Rspam-User: 
X-HE-Tag: 1793207051-770406
X-HE-Meta: U2FsdGVkX1+25LIWzS4iZ5nW0NDmXGMmMsloLz3R5dp7vPC8bBPQxF9XckJs/yR282Q85y6oIYU5ejy9BUJfB6eMrr/DRowibwmarRuwGYBO722tWeprYoDASQtlGDb//6w9cDKSFhV+oqHdC7fGDXkO7LQxtEmeUdLpoQfraBAeOk8zO0XOI0AvRCYZiwc/6qt+97jGReqtH5w9oCaHoVJ2hxNbHCgwfcrZSjCXGabI9NT5AlkaNPaACzxJZhSx/Orw/AGGUjntgURb5EZCjKTmI0x7SLM9Rhf4pO5m2m+GfFUzQIH7G5hw+b9Fz4UcHc77OGNoF4QqysZeZlzTsvM5PoZmeYCDtQBr4jO3yit0D353BPXhDDtvkqPyCXGBrGaoMoWhSBh65lZOZDkBZelPJG1z4hZRASBaCxcXGiAl+eEunBYLBZeMqA3wGp/CfUgYipNcjkJcB+XlLLikRHomIxQH3yGQylodoEilWkuB/0X+IMWoq7KKCYAqUJn4reUfUQRubv8UTC1nhmzWF6XUgNfVXYd9viKWSZLhXQP7MIcRTHt2j0huvt9RSuw/v4mG9ZXwIn/IOTaa3ikMwntev7jPm7FtUOdTw9q0q2PxyPAcWaovdWCAlg9yRf9AEP1g+DqNMFrMY4aamMa+KZaSJorWvLgs1fXP5EXJeSTcSuucWVmohRYYMpJiscCKguM/gZB7e8+sqdpZIvLGrMqVs43eD7TlH8ZpilrKZmaNAdFgdB4dSBUlX2FwgS68SDbYEkZicw2hX1GGeIWYm27lc2JuMuQlgYcL8Fxspb6TpvR/7flqE4AMFQL27zr4WBd2u6qqFrj+wME/aB42znW/NyQ/k8dbi3qHSV2GFsEFy4U8KvlppLTzU75oQX22osbKujL9HWGxy/BaW9oKD+xTMLxiF0XYAcLPu2W27zZamy6DpKBg6NOJv5nDtsfFlTn+Cn8hRi8RuosKb21
 4+QUEKgU
 36BTmDEWQXL03vDYfgCMtKBqDUuHBqI6910aE4MyS/y3dPNBH35iEG1yF9X5KAa6BVJ541ce+758HXV5XhUQvi5BsInYOFs+EdVxmZVamqZfy2rk/ucsQ0UT7tFDmTABz621Hkc3csu1ejdBwoDJ/X4+RtdcVynRHYoeMryEKrTZBvo8O8/AKUK3cQ3HU+nPr7s0aOnEZ9Tyk+qvFoyzRoYTkTJIEjui7Bqy8TWFFp0a/uYkS2zuVvkmz4/mNQQt+Cq8ua+1ul6I1wF/qpL7akIadrOaIwwAzHBKKNX9dj7MgOJ13Yh9iI5jto7TMKUX23gh2ZJ9Wd77UXqVfft0EgPYzdwI4VZjgyPVVAPcJaDUv/ULUTk+4l9G83zoUFAFfZItNWNwlx+fruDUPfQpLeZgyPpmhhIDVaHVrR6d8AvTPTtoUnYG0t+Dl9FR2K04ZCUrDUrSNt/GnsW4qeuBw1M5FWQtONuOBTK5KadKNSv2vIdvB9sTT9YWiJ/JmF2TuR/Ygmz2Qrs4/yH2com03IXCwxG73l71MhqODWLAEc7UAOv0l2K1MCwrViDU5o/lzEyOBuGR5lxHRJhHvgfBMB1DT9LNlNQtxUsbWB3IxP2uGqaVsta2eP26JtvGR1hzU2Ag/BsUyKYaJTYOrHGQba7RHWMKtfc7d+fqfoUOiofWKPNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The UAPI comment advises keeping SEMOPM at or below 1000 because a larger=
=0A=
operation array may fail due to physical memory fragmentation.=0A=
=0A=
Commit e4243b8062c1 ("ipc/sem: play nicer with large nsops allocations")=0A=
changed the operation array to kvmalloc() specifically to support larger=0A=
configured limits, with vmalloc fallback when a physically contiguous=0A=
allocation is unavailable.=0A=
=0A=
Replace the obsolete warning with a description of the compiled-in=0A=
default and the runtime sysctl.=0A=
=0A=
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 include/uapi/linux/sem.h | 7 +++----=0A=
 1 file changed, 3 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h=0A=
index 75aa3b273cd99..d9f961a1592c7 100644=0A=
--- a/include/uapi/linux/sem.h=0A=
+++ b/include/uapi/linux/sem.h=0A=
@@ -71,16 +71,15 @@ struct  seminfo {=0A=
  * The values has been chosen to be larger than necessary for any=0A=
  * known configuration.=0A=
  *=0A=
- * SEMOPM should not be increased beyond 1000, otherwise there is the=0A=
- * risk that semop()/semtimedop() fails due to kernel memory fragmentation=
 when=0A=
- * allocating the sop array.=0A=
+ * SEMOPM is the default maximum number of operations per semop() call. Th=
e=0A=
+ * runtime limit can be changed through /proc/sys/kernel/sem.=0A=
  */=0A=
 =0A=
 =0A=
 #define SEMMNI  32000           /* <=3D IPCMNI  max # of semaphore identif=
iers */=0A=
 #define SEMMSL  32000           /* <=3D INT_MAX max num of semaphores per =
id */=0A=
 #define SEMMNS  (SEMMNI*SEMMSL) /* <=3D INT_MAX max # of semaphores in sys=
tem */=0A=
-#define SEMOPM  500	        /* <=3D 1 000 max num of ops per semop call */=
=0A=
+#define SEMOPM  500	        /* <=3D INT_MAX max num of ops per semop call =
*/=0A=
 #define SEMVMX  32767           /* <=3D 32767 semaphore maximum value */=
=0A=
 #define SEMAEM  SEMVMX          /* adjust on exit max value */=0A=
 =0A=
-- =0A=
2.43.0=0A=
=0A=

