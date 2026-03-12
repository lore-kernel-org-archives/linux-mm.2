Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2202C106ACD2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA886B0088; Thu, 12 Mar 2026 13:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8666B0089; Thu, 12 Mar 2026 13:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F916B008C; Thu, 12 Mar 2026 13:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21A5A6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:46:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C79BB8B583
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:46:53 +0000 (UTC)
X-FDA: 84538141506.20.B3A7818
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011061.outbound.protection.outlook.com [40.107.74.61])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3AFE440013
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:46:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=OWiuQRjA;
	spf=pass (imf07.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.61 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773337610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5XSNDIzY5KgKV/C4Qw5DT2TF9Y71PF3dVPpYBwc7h4=;
	b=5KctOYF90lO5TjrEn6t074K0UhqHfMrpisS+qWCoAjXPE77TgdPlboJ2zFJVbURAW9jePN
	FZ0vqD4qU4qqTJjihnXSBWOe1Po4hnSFQkyiHu6ON27ND+AZhxn9FLHz1+ze+sCgke+fck
	d0Hl9R4+OlrhChmBw1Lwy3w7bwSFIus=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=OWiuQRjA;
	spf=pass (imf07.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.61 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773337610; a=rsa-sha256;
	cv=pass;
	b=pwvGTVJl4XZphJd8xEdGE0gRS7voSMCGlOv/nWUzoUeAx+hDv8yRjm/yJJJRe7ZaF7YxC5
	gRwSwA/cGtAtWJcbzGC0dDdLRIFPDeTxPVDstmkSaKR28AKdd07qokVhDUOuYuM1oqTSU7
	Bi5wxcuOyDX+W/ZTscjOrL8ZcrJFFjg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UERNznLgkv3TojcpbYU59PwPL4Tac8CktUieE9ofQNi6lgctT9+7zJYOqJVbNpjFwOXEgNgZnpMRN17tsq6pHpG37+5MJDU78Fs7rOLUA06E5j08peq9+YsC+4QaEj0PxiR5/DFOay6SHWT/1Ywv+1hhLwSfEY/s0Bd2IgtlMHhlX5R73ohZfTRtLcUWo6bSdrjlEIsml4Lc/gZ6m3LgjyYfvRPLOXJv1+sm/CNUNgkE6QKICbtKUb3l23kwSgKTLzvwmw3oI2on3hOUY57VF9N/Q5kYX2Czu6sPYwSP4PZwVtoJ37AHx2zwqwRoseyzMcFJQc1KvuBXeuobZaveAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5XSNDIzY5KgKV/C4Qw5DT2TF9Y71PF3dVPpYBwc7h4=;
 b=LfOvHW1ArLzwphKnbTrhDFGisBE9Z8dXD8MSles19xglU8BNZhTb2MeISZIPufgICaRNc9Kw1UXH+M6AUz+NkrQGB/9bSG5MKsBrIGa/YikxzlzoCYPGPYpwqg14LfzbF/SpnrepnOdUyM4qY9KoVCWUX7Nkpjad0YwJUfkG/RgfCCInsB6pgOFCk+49XOBdYsphtQwPZnaUOfY3yWTBUWJgWsmmnpazcnDfTuv2+TN5KgetA6oDIjoyJ0H9kO0+zjTuuRtYFBxV28Tk+N7OoJsIED9lCc9zmSfKQO4ZjP+tTd0HSpqr4yaGXgUbdzIIc3Qa8CtJuKl75ppJqsj+5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5XSNDIzY5KgKV/C4Qw5DT2TF9Y71PF3dVPpYBwc7h4=;
 b=OWiuQRjAC4Et73hKQqfNSeeIBp+c+gcPvnFssRvW1cmrlujmTBNRgLGm+nUaaXU1jvP2ysd8BJGpgvgflHUPLqFRo57Q+uJbKlzkPgeHIjYeGbCXeKjN5b1UV6txN+4FRKHNOHCD4YnkUFXkkD2gsjG+QdfOh8eegZ2LB6Gb/So=
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com (2603:1096:400:3d0::7)
 by TYWPR01MB8493.jpnprd01.prod.outlook.com (2603:1096:400:175::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Thu, 12 Mar
 2026 17:46:44 +0000
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de]) by TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de%4]) with mapi id 15.20.9700.015; Thu, 12 Mar 2026
 17:46:36 +0000
From: Biju Das <biju.das.jz@bp.renesas.com>
To: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>, Thomas Zimmermann
	<tzimmermann@suse.de>
CC: "boris.brezillon@collabora.com" <boris.brezillon@collabora.com>,
	"loic.molinari@collabora.com" <loic.molinari@collabora.com>,
	"willy@infradead.org" <willy@infradead.org>, "frank.binns@imgtec.com"
	<frank.binns@imgtec.com>, "matt.coster@imgtec.com" <matt.coster@imgtec.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>, "airlied@gmail.com"
	<airlied@gmail.com>, "simona@ffwll.ch" <simona@ffwll.ch>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>
Subject: RE: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Thread-Topic: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Thread-Index: AQHcp96eSUoAacjqcU2c+U96UWFVr7WrPdqAgAAB0YA=
Date: Thu, 12 Mar 2026 17:46:36 +0000
Message-ID:
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de> <abL5rcYIaFFO3GW2@tom-desktop>
In-Reply-To: <abL5rcYIaFFO3GW2@tom-desktop>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11346:EE_|TYWPR01MB8493:EE_
x-ms-office365-filtering-correlation-id: a615c6e6-013e-4294-301e-08de805f4ee3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 kbW3Og+wfWnEHkrIzlqU8te2xteegZYTlXbUPY3zg4BDfJ6muqWIB8Kh9M77vSJW4q2WN9/cdhiVBMxqWzXPX6CvY+fb6hFPomgOKFxSe0KRlf7eIh81l/TYaH7vetgj/xImvdzFmO+0ukYtZ2NIOsRJQwnslJ/Fem4Bfrr7Xhuv6GBCbiCufNr0KELrC7+p7OD9P8o/rlFwPa8rsCdWxfJKM0fEI2RFmrMsYBYMjoBhHc16FjwyuhXPg5qxFBs/6P2svYDSIQQsABoxVPoROBvwm3lbBPhYRhqUS96rcpMTqgvENF+rnXFrpvaSH4jClVZtGD9DfUaJm4vmVEqtaW0WgU3bKJtUjWt3EsAAVHgi7FlCI8vQXRUdBthgtBeOS8UwIZCvM9tOMj9KQbvhqyUsm7vzp+bnK/00/gZZEMs41C9guD8crkATDgTx2dWPWfQD69yjXg2uxiMRKilt6utx2br4Agi0gnrV434JCxqgDX+qEKCfDrrkGio7qsxU/W3nMLw5MhpOrK67paoTMbT7XD0jampZutql4/GZDkzhk2d7wOUI8VPKqzDs8UWeLdRJY5sjEaXHOBTT3C/VREXGdFKHrmk4CDxPg5pxxZL1fv8Q+aiYdT5CCw5HJCY8UY/rNbGvvQ+rHVr9YKMaEqM+2p+eaZtKQS2+0g6Uw1A3WaEcuqLQ9NVCUDctEJJYhp+K7nb/fc6q1H9UwmVA840iRYEn+Vi+XQdZoPWmXyF5n18+0oE3z8RMtzBgN5QoIIomASe8976B/muHNZpFSSwnnFfPfoj2f4B5MXQWbX0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11346.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ClnswjDtLB8IUGeA8iI8XoxQi9cpu+WbDz198swDXDU3roA1vMB7wu7vaZhT?=
 =?us-ascii?Q?bCUlfPfrdaD9i9J5lAgD4iph/5N5KR7UD1a8yvahl4/js++VYa9ie/yTwekU?=
 =?us-ascii?Q?TTjjkpqYr2MFextr6NPs7Aurlbxc8lQfT63AlNpbJ+FYqI4bHxcYnPerpLwy?=
 =?us-ascii?Q?oAGRlMlQQFrwsr/DeWkxWZDA75P/y830LiNfP5eyhAR0c5dtVUDmkRY6cjK8?=
 =?us-ascii?Q?PNPviIhZjcq11h7c8qTTgjw8R9Hd2LHYsto6P62HbFwYJCoat3MPhpIE9r59?=
 =?us-ascii?Q?Ve6W/8+/ye075D2KgJr1NM5kL7rpjz6L9erPJgn3Z+jI3qJdrauoSit0vfIr?=
 =?us-ascii?Q?pveOUT1gs4yBjWIuBUY502SRySvGpfPOmVxd4opEzAe9QwUOyA1fS9iyjOFA?=
 =?us-ascii?Q?1AZrE4Baht5unOLd7GSHs/xX++UF0+xhvHQjPHobokhLaeeZoAOe8dbL1IPx?=
 =?us-ascii?Q?gUgDo+vpl9HIy5lFKt7I1X8l9lgOTHWnngbqULW/KaCFGh2HeJWRZKck/35P?=
 =?us-ascii?Q?8KGYwVsNltxzigNduy1wry4PMd6OxrXfHcmZdjpv8oJUbGcspJHaoFcF1L4J?=
 =?us-ascii?Q?CElPnB7sdus5hfivE23OaG/Tbc8ivxSRPlEVA/kZSlFqqLKCA9g2A9U53kqY?=
 =?us-ascii?Q?UII+oJPyMKeeMnizvsuwRGhXX2K7MA6Zgq1zqbwBs8whVSY0Zkn5SZNLL43M?=
 =?us-ascii?Q?mBKd44nEtf8AOF5zv03g0+Y9GrYwHvkpAQnbaEAhQ/n6vUX3YufQi0/8TGmQ?=
 =?us-ascii?Q?ijp6S2VJXmoLqqXYNT40gt0FqxH6I6itamQFZ2XYQGmcnUK5GEXYD2OLXZFy?=
 =?us-ascii?Q?DmaQWSR2uEKmu+Tstekr96nzgaicCJqS6U1hB4p+x45WDa5b3OTCrMAwIdS3?=
 =?us-ascii?Q?zpiuxvj1vRCM9mke60XPFEWzNc0YTTm2N6eKqj5Vn//1bLBG026uXP3siZq2?=
 =?us-ascii?Q?cUsBCLmJKKw92qxUVmBARy4vO9muu8WI+oYiK/eElV1CfD0zLl9W2nlDgEuj?=
 =?us-ascii?Q?YJ0Ny+Uq4DnhJqRUt76fxR7iN6baSeNYmUf3f2sRrBb+9yHMqeSLkq7FWiHk?=
 =?us-ascii?Q?rJmiZXBkNdcmau43kThU9QyD18MKgRAObMYJEG16CEV32md0oi8L6iG+pmcB?=
 =?us-ascii?Q?guisOl+4/dzeRNGtd92o4Ok/7RrVzGfnfOU2D8WIrO5DzP1eXVcgM729LU+K?=
 =?us-ascii?Q?QR8dQl3ZZqsGOrpHnhR0iQ40sfW8htmA0z0Pz2gitOC5Vkx26W6Av4wt0emM?=
 =?us-ascii?Q?RZGapkiQeq7Ko6d7c+ODyijU55c6gGHZqgSVm9m/B2IUMBvahPSWiruQU5is?=
 =?us-ascii?Q?NBnnvR4SMYqnjzKY+nDctgGwumf77F1pJgfs+v36aEPIsHpXObcV+g3hb7T/?=
 =?us-ascii?Q?6G+iz9fk2SW3de86h0Ql6TYLC360hwi8fQCMt2OPHkgBZdMEZ6v9iryK/s0e?=
 =?us-ascii?Q?bFJXKmTqZpuS7PInOv3PnxTNUpUiumbq84bMlhjMycAgbjj6M9urdedECAE5?=
 =?us-ascii?Q?vvPN9t4FJwrqnXLzhbPzUuTTo9gylDY4Pl4Qbnh75eXsUq9Ek7R4sy7mdX3Z?=
 =?us-ascii?Q?xmvevY0Rc6ulSUq8GBPiK0vKbt8dIeFn2UCZ99DhNBgYqQ7Qi+iI4aIWQfcd?=
 =?us-ascii?Q?Jg06wWWafKw/dz90i/yIrIMdDE4v4RzbERb7gzUBpek3C8NckPruOw8rGnLn?=
 =?us-ascii?Q?Ln6UCuFn9UphOz05LL8Fef34m7t93DozYduFR1CaxADb84SL+fg906TCS2cS?=
 =?us-ascii?Q?/N6+CbYO2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11346.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a615c6e6-013e-4294-301e-08de805f4ee3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2026 17:46:36.6443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kVjW7gLmg9K01ziiZ2u7g+vwhxk4xkQzRFL3Jpt2mSMeZLyv1P9Ydv02KaZ48ubWspl+h5b5nZHqIpTs+7/ynIIfVXhe/2uoE7dY9l5d66M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8493
X-Rspamd-Queue-Id: 3AFE440013
X-Rspamd-Server: rspam07
X-Stat-Signature: ihd9i3c73awfqep5hp7ochsjwrhxfhss
X-Rspam-User: 
X-HE-Tag: 1773337609-897818
X-HE-Meta: U2FsdGVkX1+ruEByYSZNI0/gTn2esxthVsUZKuwdPM8xRBQ5TGAHfRtS6J5TybOzMu25pukCeDgKEp8bQwLd+t0h1FOXxaRLb4B5HY5Agq7skVvf5jVLkzFlaN/N2bHX9tk4XlSQZHBSiGJpKvB/XR3z0javfheDzjaMsd/jUTd2oLvCYqLMqyARtrgbB3N5IsSeZLGLvGU+FBsTFfJL8pLeY+KxbiYEaFgzaAuNl6UHgxOTFN6G/16VU35DnE2391rnmACnLEtXQclGi426bWCh6o4JBA/oLMCrreAwSpCHpA4PfmJuhVjGQwakZm/ZvqCCxq6yUUbuI1aGcZzdX9lKogC58+TmYUgVXmg3MksfwIEZPw7V3Mx/YqvRsoKOK79wFxu3wBpUBS0ATW5T1CeJnOXW01CdTKRRin0VKcMcWYuPm+UftdiiQMof+tD1DU6L5MtPOdG76yVmZ3rF/6qHk5gxMu3tgEnkJiSMJkVEsAKQfRCa+0TlErZxQwd2kXTJg4+bwSF25AohEKDyYxYLME8KTkMk3oZy8XwYqP0TluHuTsrQeZSXTXFxEZK/6sUUDgvRGkcwzWQf3mlRUXfr/OmSGz4ZuuRSWnUPODFS1l04dFplyrfEFAsPXKgUyz0Vx/1052tdhUa6/v18gT39xNGrEcF20+zbQ2KXajVnwpapX+sKTEQQgwmxZfPAg9cN7074eTPRYOTXe6JaoEr9j5YZP4f1x6e/VpytrugVqZBWlBB9AsYPITzjaWeOLcpiixEEOeF8BvW1KAMBL7H31EniX7Q1Lrl02+TWoqdghCR9kBWvH5mVpCUXHGie7zXRLy93GsrjbidygbBr1MDax6Zq1dVPdlejDxOhhtVMy1Qt3r3M3qmUhU3VdjQUu1H+Ec4SMqeD8x8rFugT5Qg9Zig4sgpySV44Ln50ADYc2YWUAn2X086Sr+yU0EFtVJskBCo5xHlGMMIgI6M
 4Wctb93K
 INe/v4zd9UH/3kDxeBZ1hYdAHHJrxF08xLcpy/QLRBcPWPF//w5XPwliGGzSDKbXN/QkOx9BwDWRDT5cbajWbUm1SK8XjyBugUfaQ8bKTvVFzrMx8eF8PvS8QwJfP+POetMKW7zS5hDJIAgB2YOYKg0WtGiHs0ElBUebstCViA6j5grDPVu6u658P/trP7OTK9fznQuh6OAtBk6xcHFX9BFITIUzJgWZ7oWlM1dA4eL15z1gbBvUPOKaiW6Iz1MywFpCWFM9K2Sa2BvBwFsYOkcpgXlmpXsBjgPey/ilkli7vXhZmf5M6ydlraCtVlODUBqF9ftpT446Rv7/xf9rHOV4XtVKsbsNu6c+/8ooxO32dqYfiC0Fm/L+NiUqb4OalOOnebzkqG8mscYgxoFbShDq0SWt/+YmsFx7z0qzHb4a8pO1P78sdtx5n3EqWTQE5qWavs7WzLzFVV3HNtB6AJPxFlDWex64150cVMn4EEu3TO8tPUTrPY1wd1n/GC3AWQUAhXqj6d4hBMOguO/eFx2Mww4zffwa2haFvhFm8U10Cye/KP21kqY4Cu8p973pj9GVfieH8hpyUmeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tommaso,

> -----Original Message-----
> From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
> Sent: 12 March 2026 17:37
> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty sta=
tus in mmap
>=20
> Hi Thomas,
> Thanks for your patch.
>=20
> I'm working on DSI support for RZ/G3E from this morning rebasing on top o=
f next-20260311 I'm seeing
> that weston hang on my side:
>=20
> Reverting this patch fix the issue.
> (git revert 28e3918179aa)
>=20
> I'm wondering if anyone encountered this issue?
> Thanks in advance.


I am also seeing same issue on RZ/G3L with weston.

Cheers,
Biju



>=20
> Kind Regards,
> Tommaso
>=20
> On Fri, Feb 27, 2026 at 12:42:10PM +0100, Thomas Zimmermann wrote:
> > Invoke folio_mark_accessed() in mmap page faults to add the folio to
> > the memory manager's LRU list. Userspace invokes mmap to get the
> > memory for software rendering. Compositors do the same when creating
> > the final on-screen image, so keeping the pages in LRU makes sense.
> > Avoids paging out graphics buffers when under memory pressure.
> >
> > In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
> > for writeback should the underlying file be paged out from system memor=
y.
> > This rarely happens in practice, yet it would corrupt the buffer conten=
t.
> >
> > This has little effect on a system's hardware-accelerated rendering,
> > which only mmaps for an initial setup of textures, meshes, shaders, etc=
.
> >
> > v4:
> > - test for VM_FAULT_NOPAGE before marking folio as accessed (Boris)
> > - test page-array bounds in mkwrite handler (Boris)
> > v3:
> > - rewrite for VM_PFNMAP
> > v2:
> > - adapt to changes in drm_gem_shmem_try_mmap_pmd()
> >
> > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> > ---
> >  drivers/gpu/drm/drm_gem_shmem_helper.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > index cefa50eaf7a4..1ab2bbd3860c 100644
> > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fau=
lt *vmf)
> >  	if (ret !=3D VM_FAULT_NOPAGE)
> >  		ret =3D vmf_insert_pfn(vma, vmf->address, pfn);
> >
> > +	if (ret =3D=3D VM_FAULT_NOPAGE)
> > +		folio_mark_accessed(folio);
> > +
> >  out:
> >  	dma_resv_unlock(obj->resv);
> >
> > @@ -638,10 +641,29 @@ static void drm_gem_shmem_vm_close(struct vm_area=
_struct *vma)
> >  	drm_gem_vm_close(vma);
> >  }
> >
> > +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf) {
> > +	struct vm_area_struct *vma =3D vmf->vma;
> > +	struct drm_gem_object *obj =3D vma->vm_private_data;
> > +	struct drm_gem_shmem_object *shmem =3D to_drm_gem_shmem_obj(obj);
> > +	loff_t num_pages =3D obj->size >> PAGE_SHIFT;
> > +	pgoff_t page_offset =3D vmf->pgoff - vma->vm_pgoff; /* page offset
> > +within VMA */
> > +
> > +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >=3D num_pages=
))
> > +		return VM_FAULT_SIGBUS;
> > +
> > +	file_update_time(vma->vm_file);
> > +
> > +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> > +
> > +	return 0;
> > +}
> > +
> >  const struct vm_operations_struct drm_gem_shmem_vm_ops =3D {
> >  	.fault =3D drm_gem_shmem_fault,
> >  	.open =3D drm_gem_shmem_vm_open,
> >  	.close =3D drm_gem_shmem_vm_close,
> > +	.pfn_mkwrite =3D drm_gem_shmem_pfn_mkwrite,
> >  };
> >  EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
> >
> > --
> > 2.52.0
> >

