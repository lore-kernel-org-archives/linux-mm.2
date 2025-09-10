Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F39CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 04:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6578E0019; Wed, 10 Sep 2025 00:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D6D8E0002; Wed, 10 Sep 2025 00:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C4E8E0019; Wed, 10 Sep 2025 00:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7511C8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:01:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EA3E160749
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:56 +0000 (UTC)
X-FDA: 83871992232.01.CB0C519
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2094.outbound.protection.outlook.com [40.107.223.94])
	by imf04.hostedemail.com (Postfix) with ESMTP id D0D6340002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gatech.edu header.s=selector2 header.b=YKgvOy2l;
	dmarc=pass (policy=none) header.from=gatech.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of molivi3@gatech.edu designates 40.107.223.94 as permitted sender) smtp.mailfrom=molivi3@gatech.edu
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757476913; a=rsa-sha256;
	cv=pass;
	b=LStmwbUV/FBtT4weuRWjfYy9bWoNmUFShqQf/Y1TM6PjHgrzE1Pl9+FdtrqKG/g0wTLAca
	Cg44Nhfr94wwJpd2J0ES90xDWQ7fuPXAf3hjGN6FiH2nSHbkWYo8Aqav47CwomDjp45kLp
	bXBjM605uI8f0PA6ps/8j74e8Fa4epw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gatech.edu header.s=selector2 header.b=YKgvOy2l;
	dmarc=pass (policy=none) header.from=gatech.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of molivi3@gatech.edu designates 40.107.223.94 as permitted sender) smtp.mailfrom=molivi3@gatech.edu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757476913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7gXEEvr9ywq3M3mFJIloGeHSrdSkemAPXczxDnCKTEo=;
	b=chM0IUsFj3cszOwJSIpJZ0tlarfGMs1D0C50zxl8ldjpBshtgcQcs52hDotHMRYG794mDF
	Nt+VibiE82M90dSzczHpiwx9RQDSFauLM5yJLQCLPTrhiVo43A5arFp2x8QKY5v4IVXI9Q
	RXTxCqj6595EHB34HkST/NRrbaxYsSA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NgaIaigmUWRYAFZmCy1gCN8F+wfMWc2XnnKDywAvVThjsV8EKt0ydlRY1VCIvB0XWXceZgI/rTRbmewyZOvlitfAkHSk6C3rb7QZmKwzJK6EYzJ+EH0yxllQPpVrRfSSgJ7uQGhNlgVYdOJhuIl2O0aigItckjzHxGI/ygxf0Gd3w9yo6Ddmm3BO8xbihzRvB4HuxBcGjGT9eZk0wI/K/Lqlgt2V7kGG8/hZibuMEqYoH8lA3Zr0QfaIWhc/xmY9+6MqV6mBTyUXw1B0k70FUP5C5KF0QIeJk3WOf8JRWY6AdZY1CZ1ZkXUoYL1CVSlC/sDkgp5kwnos+qZKIFO6pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gXEEvr9ywq3M3mFJIloGeHSrdSkemAPXczxDnCKTEo=;
 b=gmL0zxBwsK8fXmheoE1zn9rO8FUoc5LchZmRrA8mRacLVdFAS2IWkle9Uet9xE48CVCmntMToC/0QvYLOWwZ4CLwKqWUpAK24wDUIy5BOBhJ7dolG9eQmB60c57NO3BGYyRNcJJmjVrRgCZ5H566SfLWZuQ/2cvnaNoJdfXoQ48afWDawZAC38y3zA3zqNgkuEbfJBMV+Ej2/+N89xtaZCicgUf0zj7aMnJkqgr6MrJ6OXPNba7dBQo/B7rxZ45vug1TltrJ51LjEolLYRf9+z6aiu55jDKA075hVtchM+r3a9B5QR6fDPWqnAtl0YprmxFTMFkvMZpgm2kDqbia0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gXEEvr9ywq3M3mFJIloGeHSrdSkemAPXczxDnCKTEo=;
 b=YKgvOy2lUEJFmQ0waJN6g+B9DK8vyVkwzFPZQG4xiflbPxOU8Coey3DB6xBA7IYA8TN/Tz4jbai+tdOkgupNy18szM8JhOQTnVcypsaVHqkn/5CAZpj6NjbSSJDGE4lgp5mN9dOe0194vXGRAp4ntWZDHoC9oz5S5E1Fw2NORYojxfGARmVculg1TCeSDzXsuqYvs2Pc2kePEUBXSQKfBiMDMsCacl/TjSR/BqjpWIqFzrsVVP2YRTPWaLBy7ZHLhWviu1BMusFyyIGHu91ZXvAjDRP8QFtIYU2ByjIlbhAFcvXs1MUngwq1BcyK7zX/z1UbkHz/9aLNysDJmWwFXA==
Received: from DM5PR07MB3548.namprd07.prod.outlook.com (2603:10b6:4:64::13) by
 BLAPR07MB8290.namprd07.prod.outlook.com (2603:10b6:208:321::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.15; Wed, 10 Sep
 2025 04:01:47 +0000
Received: from DM5PR07MB3548.namprd07.prod.outlook.com
 ([fe80::c71d:8a93:a3ab:4ceb]) by DM5PR07MB3548.namprd07.prod.outlook.com
 ([fe80::c71d:8a93:a3ab:4ceb%4]) with mapi id 15.20.9115.010; Wed, 10 Sep 2025
 04:01:47 +0000
From: "Olivi, Matteo" <molivi3@gatech.edu>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: How to find out how many pages for a memory cgroup are allocated on a
 specific NUMA node?
Thread-Topic: How to find out how many pages for a memory cgroup are allocated
 on a specific NUMA node?
Thread-Index: AQHcIgT9xuqvZBW8GUCGNYn6zDGtlQ==
Date: Wed, 10 Sep 2025 04:01:47 +0000
Message-ID:
 <DM5PR07MB3548339818AFDC18C4A5255C970EA@DM5PR07MB3548.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR07MB3548:EE_|BLAPR07MB8290:EE_
x-ms-office365-filtering-correlation-id: 5a6d9579-c2ab-4265-c31f-08ddf01ec32f
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?O9t5JK2P+5UNYxLYzwJBbMiU67jVyJnXQyMLxH9Ja3ibVxISzTWN3PSHi6?=
 =?iso-8859-1?Q?zDKTAjoN0Npp/4sdfIXqsVyANfkJV3WiDIiIc170o4EXIMsoTUMtxlIG7W?=
 =?iso-8859-1?Q?z1M4GpdRkZBkQ45m7JsNUpqJJER1zmTKDbWrrJ4mirxHSvfuWsz8J85g0F?=
 =?iso-8859-1?Q?WkmvqivnuQpi8p75jsu4F2dp6KJKeXF6ZmeqMwGprPi0FC1s4k3/zcBvVr?=
 =?iso-8859-1?Q?s74YlUw3aJ3ULgNIOcTwPsUjOqHfKx7OzzPOJ4sjZsbeYkHGn+vj0az/FQ?=
 =?iso-8859-1?Q?IzydBN0UAZjExPMTuN1ikRYJJeTMCUBM+DNihsCoq09afGLoXG3Cry1Hq9?=
 =?iso-8859-1?Q?XtREdXj2ltAX/aXGpHKap9OltBjSkhSQtJusGUyt+L/6CsYqfgyQr2vW7/?=
 =?iso-8859-1?Q?SWwjvr5HGzR/gFYMi6dUXUiB7PDBQ+fsnp3RZ7YDnieth/bv3KZP8xmP9z?=
 =?iso-8859-1?Q?iy93Y/00TDI+pwF2dF3A3w8yQkgaYmO4JKyVVh1nyDs0sbAfAd7yBXKXBI?=
 =?iso-8859-1?Q?IQBf9KnXyGssVLZHtQMWh/aMd+gKXRNqGhALiAt7/IHhNJsEGbaAYDvIBK?=
 =?iso-8859-1?Q?xqo6jQL6oypKqt9rEwwYkrX6p+Z2TlajU2/VSzqfRn83yIFkOAhAez1teq?=
 =?iso-8859-1?Q?9TQbIjzM3ayl7BUczKSBMGbznRXKptBB9okbghKQuep17EP1N0l2DWuLc0?=
 =?iso-8859-1?Q?Ox2IBfK6dSoQx9ITuWoQRwwX6Zsp7Keffob6Lp42zc+oX5PegaWy3sP1yn?=
 =?iso-8859-1?Q?iZ4hpCfhLGybrPfMMoa7jWYeXgfTTFVWCMs1COnxAkguoxW01kUQcIT1Zv?=
 =?iso-8859-1?Q?r8vs8VzUCqLYXTMGAZbWIsflTfheM0SooiB7rdDrqVhZyR3Z0qU+OgJIpI?=
 =?iso-8859-1?Q?sL/XSg07B2RCHBV91MOjYhqXcg2yHn5jfMNoKnNGLsfLasqCgL7PmKbCfS?=
 =?iso-8859-1?Q?didraFqCqtfGujuAkJCJIjbjLSBVpbriLyOtSi5xvE1FFgs8sbgxy8xiAY?=
 =?iso-8859-1?Q?FNHW8qVJJUWmpSIq74qCwk4hJNUDLHnJRZpp6NfGdz0rKT4uS9zfJq6W2P?=
 =?iso-8859-1?Q?adRIENdaGwj2oyeKeY34DdG7+Hv7M015s9MUBq1znFydWa/E4uG2HcqcGW?=
 =?iso-8859-1?Q?0lzf/+kJjdLpmc6SSJHgZ/yeAc8fRoYRcBAapQC1OZKmSrbPJGpkKtS1rD?=
 =?iso-8859-1?Q?ILnVy51Q+rT3jNDDur+Vt9y+zkiHQdDfqZmT7DvQk8XCzROfxUMRr6gzBX?=
 =?iso-8859-1?Q?dhVJus3Ir3u/x7N4KBRQLCMkT9WKB1ToxsqYkLtgcCVZDenTxjtI5pRpRc?=
 =?iso-8859-1?Q?aAjMuO4UfSHMOKhu/ZVCZX2XW+DcDUb6lKBxBiEY1WiHTulyq/upfgCAzN?=
 =?iso-8859-1?Q?7j7u8mxJgOLggtS3OPfXV9PvTkhirGVGPfk6M8N0cVLY7XnVgi8WvxqcUr?=
 =?iso-8859-1?Q?oHq5gaYM2ovnPROJnZrmLf51FlhOZwVaakhPCnnDjfaYHTaaNWgCC8pT8K?=
 =?iso-8859-1?Q?OG+WCWIBtfPGB7ZUep7V5gb5N6HcMuusd28fumUdWxTY04lHH9hy5mt8BH?=
 =?iso-8859-1?Q?Allnvfg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR07MB3548.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?yLJwjT3z8TFPEtakxOVmwMvSHCxtf37QaA4fGBFXYnsy69jQdC+QBTIBnX?=
 =?iso-8859-1?Q?xWzWygbo6/y4XDNHVpCPQs21hEc9SxF5HkuQIhqw5MkhwSly7Uida/Gn5j?=
 =?iso-8859-1?Q?eif/jWupS+dR766x468xYUBlz7l7c/s9ZHUJd1Afpwnurs/ppw0WscgU7q?=
 =?iso-8859-1?Q?niqzr5UBu+t9rPTXL3v9TpmwAFJtU0d5TveaK1UBG48z5sbXEJf+yVIq4m?=
 =?iso-8859-1?Q?MSZ2zPJXMG/f0y9Nd64se620qlDUUaOpYJMhQRaX97NpGcl+PEsTmFaj+0?=
 =?iso-8859-1?Q?xYlMJMcjZwSQGk4GAvMFzluTW1L2rSVM8reHi4MG3usik61QNIsjp3y0AX?=
 =?iso-8859-1?Q?RHSxiqEmplat6jIZFZt7oGsjyd3KNj+ag3rTmr4NB8wtJUJ2FgMrJlk13Y?=
 =?iso-8859-1?Q?d1VZCzkqu05L/ssAfLvgvZ958Nyu48x9ryNL4GqgRA6wX3VWcMfQZmQuHZ?=
 =?iso-8859-1?Q?tstekbkaf5aP/ol8dcMvA/2jbyRpXiBqcQ5XDwAlXk6QJ9uaUKV8Kj5y2r?=
 =?iso-8859-1?Q?wp9SAoaqJOXrWrwykbfHMIqZZw/yR7aQm9hnelsuhlzbLFgSO4r6cBaVmI?=
 =?iso-8859-1?Q?CZa0ZdFKEQGd9acC5FmDv1l5XQgBVhQOhYp04xvhcVunkxJp7LLHDBBZd3?=
 =?iso-8859-1?Q?IVTynPrYjvkIANbwW7bKeL8w1lqqTSRhsjUVQh2x0NpmbexSG3VjEZqWP2?=
 =?iso-8859-1?Q?dWGFiuwHFKq+djqJPMcgAc5UIeB+TdxgurARbjiUyuxB9S/wxoAtQfG5v8?=
 =?iso-8859-1?Q?IMnMtCKhUj6Ffcj2Ybb/yoFt/RR7ogGIW87Zg4MWI6lmf7DShcySJyscEF?=
 =?iso-8859-1?Q?g9lT3Z0w3HwXr3f3IhpZ83gCKHg02it4MdgOKKAuOL9EGjulGYxeuCgbRK?=
 =?iso-8859-1?Q?lbIjlAldrWA8OglgCBMDFemONKdp2a/ehaq6wR6EQFy8VpXEbL+bmD2oU0?=
 =?iso-8859-1?Q?q3ou0f9HjPCq6qHHBKW6nwJF4zWHNfZrJZ+SuH5B6/MIFeeS8U2hQ6JgVd?=
 =?iso-8859-1?Q?5HQBHepZxHR3LlzHFg31/MCLQM942bSA2bGmBbaeR9icDQ1WrzyvanqlcV?=
 =?iso-8859-1?Q?YSjhyezumbFWegBIfv0BSxks8D/wCyg2C1DWdn0NGvZ0E8Yd3wAnwoer35?=
 =?iso-8859-1?Q?AAv09bZOQqi/MfFuZwWBojeWvLscaSlag0nBmFyvSbbwpNTE7uuS/HTuuc?=
 =?iso-8859-1?Q?8aXPz7Xy1cNa6pelMDKdV9mUdqxP+/lFFQlOdIgHmPKNUk6w3p6clKq285?=
 =?iso-8859-1?Q?4tsMv6Y1QgKdMsbqnC1MAwRtCuP56M4+5qyS1B0iw3k4pCC2rbP+jeh+cV?=
 =?iso-8859-1?Q?U1ewPM/4QYiQPWUOEnzJB/rocnaqDfPn0U1okPJCv6jDYnLECKVnswVZZn?=
 =?iso-8859-1?Q?i4xCwfOh3sQF5EyZiu2uSVdCflWj9AQzglgTvTv+qT2rjSksEf4Zg4rv2q?=
 =?iso-8859-1?Q?2KzMbNj6EbSAY0lgocGiPP/Jby6OiuZDg/6Jc8f12HRLOdC2d9YjAJzthO?=
 =?iso-8859-1?Q?T3PCU4BBXZu0AwYQ9j27Ua6g6qJ1GzlqxOkN9eO6NisOfil4GyrUryifM6?=
 =?iso-8859-1?Q?GdjdDC6qoITPvPtc2h9TwG0wRJ5ln5+ylfUosQ5ypsn4qeR/c5Wv2pDMse?=
 =?iso-8859-1?Q?FA8sybwYQzl0ENLR8sENHiHEp6ECkhGjuka7CwK2E9qnHzhuy//dGEZbFw?=
 =?iso-8859-1?Q?2spTU+96w4lYWyr8D73UasCciIIMdaSUEnsq+jxt?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: gatech.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR07MB3548.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6d9579-c2ab-4265-c31f-08ddf01ec32f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2025 04:01:47.0755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wbnSFwR1FUKeE8/h2FXhFWFD7ZiCNW4tY2MEBfAYBjAebPB+3G44t10W+2Xvdkanbb/gXpU2l1Wo0x7bnq+Vzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR07MB8290
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D0D6340002
X-Stat-Signature: wq6guboqpxrih3a5rs99xcqi5j4znh97
X-Rspam-User: 
X-HE-Tag: 1757476911-193442
X-HE-Meta: U2FsdGVkX1/3gmkH0KUZri55poZxBw8dL/bR4hsxtllcRLt32dOHfiT7xT7WIksltmylT5DIq1qyf77hhtdKBWyiZ9cfEK7DasjPjB1JhRF0ogCOcGpfBDHETMmMwMv6Z+IkAEtOY28zbTxP1ozsd5MSGDTlruqOxtAsCN3R7zt5eG9Iwmnvx6/Cc2qSW+s5fKHJ2ZDB+SS3yghHl/mNp36zyAzodEl0ccHagG6g7814ptpSMAWYBrNb8qM9efeWKGYZoF8NZtDw/7046Asmz5HXgJAcUT3dgTwVbu9nsLvuKYmPyLcNbjy0oJ3eRD+k8NSLbh34+ItdRXeOOotjzX9Zf5o0X1DHzMXLVULfvGQVmvQAubP3APSP3eLqSl3grw5a4MPnTPMxx+rTvwA9y8QDCVGblayUiAddQL7PaonbKQU5rW+0OxV1LuB0Kp8bPktLY/gvKgnkI8LgGrF/x0Ny55+xrBAwtCg12ylDCehP7D5WyRn3F2Cv9/rV8O3Cq9B2bCTbHGErcoLIKsVI0rBtQ+6fh7mLtuy/q4TcyesjtVc/FUznRVKgwYuUqevho1g6uSuB0l9IvfpyrKT4edn7gecienO6hYPCEWc2Ld1EfyUWZbi1ct9nWnjUSEzGZKvXV5sXmWaCYjBb09ufqMsoH+RJe+d6BFBZAjn2dJm+eMM68+oQCWYhLJtOyLcKuSUPp//lCjM0p2m+eS/vwHydQ9+g7m0Ys2xoV+e7L2IsR+zOmIp55am/iCE5hCcx/ipT7UUlz8PNozOtCxOb7RohMK1Ih9JIwTEWQlqrcP/FC7vTNoSh0Nbgqq8olt3rDAxDx/MxCmwvs7xAoW702e6ObkY0eFnBD4a4w1QTrkqRiu1HInscHPlOfyR0eny1gHzQyA9t6/w5p6kAc5+Pam2ULYKu4ZmLMpbBN15T0dF9EDbnTi71/Ns2FYZD5SGiWSYyAysYZ0H8hagzYR9
 5CVrGCQE
 aegNskIJcxrBqQh0zqR7PE6OeRB1r63TGb1CNhliP6RL3brffgaI4C3ibCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000500, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,=0A=
is there any data structure or variable that tracks in real-time, for a mem=
ory cgroup, how many allocated pages are on a specific NUMA node?=0A=
=0A=
To that end, I thought about using function mem_cgroup_node_nr_lru_pages: h=
ttps://github.com/torvalds/linux/blob/v6.6/mm/memcontrol.c#L3973C22-L3973C5=
0 =0A=
=0A=
which counts the pages in each NUMA node's lruvectors for the cgroup.=0A=
=0A=
But from my tests it looks like it lags behind actual allocations.=0A=
I have a test application that allocates memory by (indirectly) calling __f=
olio_alloc (and allocating only 1 page at a time).=0A=
I instrumented __folio_alloc so that upon allocating a page, it prints the =
value returned by mem_cgroup_node_nr_lru_pages for the NUMA node that holds=
 the page.=0A=
What I see is that mem_cgroup_node_nr_lru_pages is incremented in bulk rath=
er than in real-time. i.e. over time my prints looks like:=0A=
=0A=
got 1 page from Node 0, pages allocated on Node 0: 0=0A=
... // 1.3k allocations=0A=
got 1 page from Node 0, pages allocated on Node 0: 0=0A=
got 1 page from Node 0, pages allocated on Node 0: 1300=0A=
=0A=
Is my analysis correct, and if so, what would be a way to gather the inform=
ation I'm asking for?=0A=
=0A=
Thanks,=0A=
Matteo Olivi.=0A=

