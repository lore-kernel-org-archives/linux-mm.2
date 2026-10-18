Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6630CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 14:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EAF6B0092; Sun, 18 Oct 2026 10:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFBFA6B0093; Sun, 18 Oct 2026 10:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB026B0095; Sun, 18 Oct 2026 10:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3116B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 10:02:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 869E51404F7
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:02:31 +0000 (UTC)
X-FDA: 85335912102.09.6FCCA67
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010018.outbound.protection.outlook.com [52.103.12.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id BDF61100008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:02:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=X7BPN833;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of x-professor@outlook.com designates 52.103.12.18 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792332148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Arv3OTWQ8sSjaW2X+yaI7KlAH1FuLH+GqB7qrQzOiRk=;
	b=aKSD95iLpdu3/KhH7C/Kq70mLGqIT77Z29Mg/ujPxxVFc9tYwbziiaVLEBbpb5yR/kYax2
	S6pxanDPOcT/snclIfSD7f8g4ibbog5zsOWkn+mANtOIU3wTx2/g/kIPe1si8dQhmMM5E8
	CxoeS0PGgzqGlT/Oeb2kkLZR8DVohNg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=X7BPN833;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of x-professor@outlook.com designates 52.103.12.18 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792332148;
	b=nfsNiz01Mt0wmvtWJKPCJOTrKvTycVyewjZ0Jg1EBKah4fBfx8h1CH8Z3bnu1t2yMTIyY2
	0kZw2sfmMFP8/aeRjavSfAlfPV42UVBq38e4ZgqxioZfMmwS3nPDrkY6U0/uumnB+I469v
	oWJs1jPIyvrZFWZUx8msfHHurd2VeGg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fR6ZabQHBbMmxfpWPrDRDwJyaHMjL8grfY5AWUvUU4wi5SN/m1RxWWx2leoRYwqYM2ON5xNapI4iJaVeo3giLptesjykvCxHJ+SintlwFVNWbZMw90R06VObHnh6l+fKdbGFJsrFvCIfpO7QR7YV4q42ZT2xmFWIo/JtS98OOo09nuITs8WTA9Q4Hfvjfr/NPmSLRGu4EWzFaqmzwMvaqm6pQ39Qkyz+hRVmpt1nUZ9Eiv/62Gfunpu/2CE294L6H4xWRiXiaNZByZ+iI78kVAAp0PX++lZ0w0lnaYAws8EbS5XhQu+95YPMGDhYYA8uvks2CJ2mT3WsCbsAwMDgag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=Arv3OTWQ8sSjaW2X+yaI7KlAH1FuLH+GqB7qrQzOiRk=;
 b=yXm1+cEc9OGFeMcAW8h75batDf2cIIo5GBrvccPrEdBjG7NaQwIY/BkOjQMwpfxd51fAFX+fryt5b7ZwtW9efIEGr8BurdQj/vGrHvgWaNq0QcSMcYf6apvgvFnzd0ByQtge6ia3xlw0oHUlOfqq6+QTK5hjd3rNrKwQvwQlCEhvzkaqifvXkAAYns5Qf0cyR9sgUNl1iRZhJZqGUHz3J232iz/L8FNff6YFO9BFymq3j9zdyRkHY4OYxu0iwoyFh+mSLkc8bqzqCmoRTwv6pJgNMgvcoBAzC63UVkWuNwWRa7NhNesN7c4WDGczTu9C0YMIUNatxggypkrhg82O0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Arv3OTWQ8sSjaW2X+yaI7KlAH1FuLH+GqB7qrQzOiRk=;
 b=X7BPN833YIJxgy6Wxn1P+wP4E9bbybfW7bg4x433zYbtl1PcLTIZIgeu+NnPW/PDwJkCCATfDbYMSlPk+meIVhqcdq5lnoIuce4pyDc2X4DG4IX6KJrZIPQoKDy2qbgNXcU6trollaStKA7ctWJp9cMxRNTqINZyiBI6rl2yAsJS+1HvO3XnnA7lw9ayHp4X8wpH4YdDLKrWiYNwff+UgmqsyvJOorGAOA8ZuHQO8Lr2XiwmXqbu4nOIciJcexrawUeU0XgLKLOC0seTQGrwIZAT6+jKRAToiQbqFDgQDDsqsJDC0dCP89mWDiX4/pPIFPEyixXUrajHo5wPaNceiA==
Received: from LV3PR05MB10407.namprd05.prod.outlook.com
 (2603:10b6:408:194::10) by LV2PR05MB359397.namprd05.prod.outlook.com
 (2603:10b6:408:416::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Sun, 18 Oct
 2026 14:02:27 +0000
Received: from LV3PR05MB10407.namprd05.prod.outlook.com
 ([fe80::bfd5:df0e:c72f:4e74]) by LV3PR05MB10407.namprd05.prod.outlook.com
 ([fe80::bfd5:df0e:c72f:4e74%6]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 14:02:27 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: Manfred Spraul <manfred@colorfullife.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Alexey Gladkov
	<legion@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasily
 Averin <vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>
Subject: Re: [PATCH] ipc/sem: account enlarged sops arrays to memcg
Thread-Topic: [PATCH] ipc/sem: account enlarged sops arrays to memcg
Thread-Index: AQHdXYKsJFm8JcYiG0umhbOnIRhIB7cDAm4kgABVJgA=
Date: Sun, 18 Oct 2026 14:02:26 +0000
Message-ID: <20261018140224.3651762-1-x-professor@outlook.com>
References: <20261016152609.2528805-1-x-professor@outlook.com>
 <20261016155905.2a659b7bb7d61f33467a3263@linux-foundation.org>
 <51c93c19-f1dd-455f-8698-6b1ee30eb630@colorfullife.com>
In-Reply-To: <51c93c19-f1dd-455f-8698-6b1ee30eb630@colorfullife.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR05MB10407:EE_|LV2PR05MB359397:EE_
x-ms-office365-filtering-correlation-id: 0541b0aa-341b-4c30-01fc-08df2d20711f
x-microsoft-antispam:
 BCL:0;ARA:14566002|8022599003|24021099003|15080799012|38102599003|11091999009|21061999006|19110799012|31061999003|24121999003|22091999003|8062599012|8060799015|25010399006|440099028|3412199025|102099032|3071699003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?tsWHQr0eGVTCxUfLh99+TLKlrTRI62Unj6/fsmuzajm5MdsciBWJJkCetM?=
 =?iso-8859-1?Q?DSGhaawFwPrYO20NZTAyk49CFUc5VHR9cz5JVEIANwJUi7F/7GuCw7MnJk?=
 =?iso-8859-1?Q?5pBwVJUfcz61bi2RbsBUM/OCvdZvEpYdX8WpVKPFepqcoMV+VdnJRpprAu?=
 =?iso-8859-1?Q?u2/utmE6bzWzb/n9TxxpwNepVkK8lt5TOU7qZFo3fHEXXnSFYbDi+jq9tn?=
 =?iso-8859-1?Q?pBwM5HyYbrmeWrBaJXeUqVtZVZ7G8oSxVFwZ46zBorm/AtFcPe+JhLQ7ft?=
 =?iso-8859-1?Q?I2EUDA6ZS/Y0dlWfDkEjjMztJfxJnDp967tvxpS0nZjEgv9MrlnGS2pBOr?=
 =?iso-8859-1?Q?QKj0DtZX2PITpHlugvyDlEpzlPYK2vO8T79+1cKVp8oh07dsMnhhxa9vjP?=
 =?iso-8859-1?Q?yu6E/8B4x5xrLlQfCrnP1nkAWYbsGyS4MhjKocohUHns5EXNhmaidZUaKB?=
 =?iso-8859-1?Q?ZpxAnN2qXxxDxtKlv5e2FBSvNu9U3Y/frIkoY1impl5/N7hc3jxYfKuINh?=
 =?iso-8859-1?Q?UwcQc40Q6hwmjIVPql8rYIvYCQ3Jg/9fXjbuG7a2oMwHmf9QUdYwktglJd?=
 =?iso-8859-1?Q?Sn4JTR4AYCFBMTinxp1Jz+9DEFfo9dVCPTC8X+XtMArH+XedzBdLa/+r37?=
 =?iso-8859-1?Q?bH2tUjz0c0Xrnou50OWv3ndyasGQP1WINB8THEiqrKqYO/9eotaaoIONxW?=
 =?iso-8859-1?Q?7YRLsj/X8o8l9YnNiw2FkT9gVnux7sPTKfgYB8WRAmm721Pbn2CfkCn43j?=
 =?iso-8859-1?Q?eVUJP5nNBb7JwJeyeNHTHoW5lla5t6E1AIwMQwKmU0EOOhAkJhfbvluaD5?=
 =?iso-8859-1?Q?alXeBjWnftnopu7JO6KvbU4f87ZfSVmYdOREiiPpGdHrlo/ZpSEDB1lyHK?=
 =?iso-8859-1?Q?KhDx4tug7sVhc8v78jXvqVZ0IknLGZFlm197DtVbv34d3V2xL887sVirx+?=
 =?iso-8859-1?Q?gXJoxGl3oKtJDNBYJG6L1minGY0RMPKIH1VG4wGdeWNhwlUyolzyONBn3Z?=
 =?iso-8859-1?Q?rh11bKajB74XX0JdIWb57wOpFjZqDMvXYATbIemBkVGfMYU8WfgG1cjPn2?=
 =?iso-8859-1?Q?mWf5X/Se2vNCJJWyT5ukBUrDDMZ8EGPGT/jXbYMVGywLJavzkmbml0roeE?=
 =?iso-8859-1?Q?IXa9H+fQwSz4GF58vDGaFp1jKfROLqOgnGLU7z9ZaXVgat+f4L?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?lojTcZMOQ/+Rxi1IosUa6MkGcIla9wQ5i9tx+Vb5259I0nP+Y0sw950YG8?=
 =?iso-8859-1?Q?wBd1uaDHbAQ0xSSAKcQsQAWH+0E0PzkHpL6yJZTTl0xVu0M/+JKOV1KoS7?=
 =?iso-8859-1?Q?kcInPI8Y+Im/DkwKQC1f5rNH+8N+8qnMmxWESOXXWa/ol8BQThfSDfGq4z?=
 =?iso-8859-1?Q?So/+HqKqKV+WVEI8EWcpmxuuOeabEVErfLciARuww3Gu1/BmAskR9pyfNv?=
 =?iso-8859-1?Q?toZh/lxOijhKA5jCj8tXpjS59Q4sXGGe8VgoHrV9LmQ4dnCcs/q3GYNyLe?=
 =?iso-8859-1?Q?YAD7IsjSLey4tg6YkJ0GdJBODiGBOoXkasoVhhR09FdjhfnLrQQ97GaGXW?=
 =?iso-8859-1?Q?aipmVvH2Wtjf3NAOthryav6rJqXf9wSsbpKi/JB6g/xpIRx0aouoyYfb1u?=
 =?iso-8859-1?Q?xxjqcyem6RdZiOEwoi4oyfs8gSvGnsSzTK0CIjQOeiUKdUh7wMiWSjKuHV?=
 =?iso-8859-1?Q?Egh+EG4rpMJ/tufmwyDx2FhCShL06vzV25muS94nyPusW6xsDZNEwPwG2p?=
 =?iso-8859-1?Q?ahL/Y1nrLxmuTtA0rqSiTIpa/ke/SLIXlqyQntPu25Zii4N9D7M4TcPfWn?=
 =?iso-8859-1?Q?XjTpuT9E82J8VxJVG+Ny+1panyZf6bCVskxIB6NYWO5OqdiPC454Cu3lSe?=
 =?iso-8859-1?Q?OOW8pWxj1sRo2zrVwIJfXpi0UERJiPptoIYjkAeL7drRX9KeZySW8E9YbB?=
 =?iso-8859-1?Q?GcJLz1ngCsk8YO63fvZ7G/71DysEeKX5j+kN0vzfMdEDVKtgd4xJz/T9Uw?=
 =?iso-8859-1?Q?+DokMScW7/9dFLHVjW2v+CBtIuMHRv42Atc+xPTa/N4lCxao0rjXPpMNlJ?=
 =?iso-8859-1?Q?I5krLOHLSRer1dQxAoIiiVUfSycKZXTucViaH6b/BGVWlr9G+WpP1cdxBF?=
 =?iso-8859-1?Q?U20uYJedUSG2S/+J/sCBVSkJQwxAOo/uqCcHISI0idr0RFCt0obRWyYnoT?=
 =?iso-8859-1?Q?rW8fas7Eakn6BKSI8NZJvkOm0hCN6u8Nkvk1L6OFR1GMpUb2B6jLZJsJx3?=
 =?iso-8859-1?Q?oLN6gQDtSImYCoGjVTMna7UnVW5esnkbo/nF8d4eeS3g3/fm5l07HmOAHP?=
 =?iso-8859-1?Q?6Io2mOamC3w/aqH2h9JrlDPX8UD+qOwToNfuPvtCQSv7aEjtRda3XFMmh4?=
 =?iso-8859-1?Q?SXCKDaV3JbdhTt7VRXyB1YTgBpTVOepFpXPcB3pGMMcWaXT4ps3/By+pYA?=
 =?iso-8859-1?Q?T54GlPRfyQ4BxA7J7l/sjxUqKZIZ6b6PjJaqYaYYaEtrr2jmPesTUwvGqw?=
 =?iso-8859-1?Q?q1YP69rrYTkIyicSMtUxEd57+keprH0eOuEKvloPrQ4t1NDyOwRcB/XJQO?=
 =?iso-8859-1?Q?2rmgBQVLeXKTAnB2208HbclYgKLZP9uKIv93Hg3th9Ghv/MY+qwcZMO2qa?=
 =?iso-8859-1?Q?0pzZsENMXndBbzhH7QnYy2zYCqZGu7GrBpqXwJ22ogeUzRAM/I2McUlpJr?=
 =?iso-8859-1?Q?s3XKY+rm8xWkMD62?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR05MB10407.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0541b0aa-341b-4c30-01fc-08df2d20711f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 14:02:26.9349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR05MB359397
X-Stat-Signature: 19sir3ctsp9cbzyj5fq6exzakjjdpm1t
X-Rspamd-Queue-Id: BDF61100008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792332148-778368
X-HE-Meta: U2FsdGVkX1+Dx5kdYXjWM0qzod7SwJ9DgOB9wjrTeIORI8j7q0+hn9PJTc9cdnCkoGiUpX9cZQAYx8c62MncTaDEMVZw37BHUTn3I594b1E5WlKBgvFLIYvncr13b48XsmVLa7X6KamPHsnJRV8JqQj8sm88puYdNiDP9o/FUkwmxiD9faoS6y0hYR6gOGQ8YzWy/jLUCi/6oWRq7K9dhpgK2zOQSA4P7gI3RZJBMv4py5f9GrUGgnsLocTH2x+gqYAdl78hLDOxAF64/Xxb+pBXFns25CNzVmNRViCs4Zup0mBp34E5ou8jFF1YayGN9S7YBLzKVBDdjuyFAoQj+DWLX3sTfoD2XGIIeQGkeONWrIOy5k0aBbbB0bldKPkSQ4rg94yE5u/EPBmcmFnciM58ofdUSBJYbrvLJLSx7o/M+HU59bclyqV4Y4K7VKvvvODB5CjBRJm731xMTn+nXc+Nz4KsxZtyfgCooNbh6BqBO/bmbIQuLX7WRKwrJ475P1XhVoH+Q4btsF242pTNfk1kNGdc/MA0CJG1fJiNgt6UtoEVmAjrUKl6Wur5vqw4c9BzEq3HhSTE9zR9usB3iY5U+bTr+fbBPBimUsIny+Jiu2G3xxBROvr+JpNucB93v6NXRWyKbJ+8paOHwIPM8BzUfi/gMvc7tSA60jLqGD8aa+ptPYrs5RjGxt8scDJsYAc9SEkPl/BAjQfQB1Mn015bMFNgBdqEFA3IYsty58eFPmUhbXo2LDw4TO9AYeEZpCnXriQ01AqzrzMAtm1d8LXapPISCkdNWQpFwq1YGsF3QPCXioczAIbW6frBDm9hKSlV/7QHLFgw9msk1SOrTC0DxrGBVOl8phfzdPf8mkSc4yRcsI4cWs2szFZUbxoZ0lhgcKZf08Ky8cQgnoZfBE2gUEgIl4/3BCV4wsJ2vVxS6Y151OoSyi6MtNPq/PU12OPvpuJBshhwIkz+LkD
 zKESGsy2
 cR4KPWIIb6K49mTLty6lcDWa8YqNF5m/iSgwKssnSw4xyPq0gu/XdJQWKVJAyYcabrZU5HUJxurpfMsK7VAlu9UrSRs17ZDsRF/G7qsOVBecIIeoDN4VZ+6k2Qp8UePE1GL7ui40ESN8RLVJ8af/+UcgNbVF3k4ctsaxxhs6n8LCuWHkeKXMigk2ynH0E0OFqEDQvgpjLSYmhMrCPDCax2AU+34qHPpXHMzlv4zJ3J4NmEwNl46zJm6NqGzLUo3T+pkgWzgN7HrtG+wIx6Mrz9i0jk31lEmXN0b3d1p6Vd8VlmnHd6ESFZDoax97ghffDEL8NVu80+VxPgNG3xTt2XXY9KbkbmsmKN2sTfrMQ6rA421ndrbC0okGhdovpl8hvYrRq5ymu3n3GxPRjZnGzE3xkDGZvMNdZMtOh0KkHdYSyYw60S7xU0828Mz0wlhamrWg+DrG2J336kTufOt7lFbWmrKVtXEW2m/es
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Manfred,=0A=
=0A=
On Sun, Oct 18, 2026 at 12:46 PM Manfred Spraul wrote:=0A=
> This would mean workloads with higher SEMOPM values cannot run in=0A=
> containers, correct?=0A=
=0A=
Yes. A fixed limit of 1000 for non-initial IPC namespaces would prevent=0A=
a workload requiring a larger SEMOPM from running there. Commit=0A=
e4243b8062c1 ("ipc/sem: play nicer with large nsops allocations")=0A=
deliberately made larger nsops allocations work, so a new ceiling could=0A=
be a compatibility regression.=0A=
=0A=
I will not include the fixed 1000 ceiling in v2 without agreement. The=0A=
parts that appear independent are:=0A=
=0A=
- reject non-positive SEMOPM values while preserving the existing=0A=
  positive range;=0A=
- validate the complete kernel.sem vector before installing any value;=0A=
- keep memcg accounting for arrays above the default SEMOPM as a=0A=
  separate patch.=0A=
=0A=
This leaves the case where memcg is disabled or unlimited without a hard=0A=
global ceiling, as Andrew noted. I do not see a compatibility-safe fixed=0A=
ceiling that can be selected from the existing ABI alone.=0A=
=0A=
Andrew, Manfred, would you prefer a v2 with the validation fix and the=0A=
separate memcg follow-up, but no new fixed namespace ceiling, or should=0A=
I hold the reroll until the namespace limit policy is settled?=0A=
=0A=
Thanks,=0A=
Yingjie=0A=

