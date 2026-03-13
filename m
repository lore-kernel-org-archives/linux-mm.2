Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD78105F795
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 10:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A54C6B0088; Fri, 13 Mar 2026 06:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752EC6B0089; Fri, 13 Mar 2026 06:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609C36B008A; Fri, 13 Mar 2026 06:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD416B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:33:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E165114090D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:33:17 +0000 (UTC)
X-FDA: 84540677634.05.F598F38
Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11011036.outbound.protection.outlook.com [52.101.125.36])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCAA2A0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:33:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=Pya9eUhz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=renesas.com;
	spf=pass (imf15.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 52.101.125.36 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773397995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTH0lh7qzQedv+4ocinL1aDJwpDGVnOinQlnCNsHw2c=;
	b=fN+fJ1yWkzuebbDrIvhEs6ILtR1Cln5O1w6w6W6NzgPzjijpmA5a8rxHzfsyoiD9gileGT
	3qynLPvrZxoKf00zjxLbGijqkibEGclHyos3f3VEApd3qKev8MvE7lm+w+5ibAG41JaQWQ
	TUuEBuOW0lnnCV/+ETvnU1fN6O8mWLs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=Pya9eUhz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=renesas.com;
	spf=pass (imf15.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 52.101.125.36 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773397995; a=rsa-sha256;
	cv=pass;
	b=57vBaNADttXBKKqa+zTLlbhVSbeAcpEKOtthsnGUg273oaLH0ar0HVDPbObVZIIhhxgZcg
	LvPn0FkdtZZ/NTuagEQgKLkMBtDu6fqbTlRQYKjlCcaHTWRTygoPEnQqFSP+mHrFt+gING
	fm3iHsnR4+3WyT2EmlUuWlRapeDh2lU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lPapeSv/DuDv9X1P+6mprd6zbX7L/5K/lJfzUSykDi7FUH1yTn/+CKEGsIV5Wo4ebtzaXQKE4t26fDp4+BZtzU0FWkkbN84tE3lEa2/jCZu6kzSm8rA8GRlSq3Hx0Rme9I1CSpnzQCpgH0xlJxhkERzWPTT8lJMd9DJA9PO1ghhvHTvA4sok24z8CYFe6ZT+M7ifSvlcTalvVuL5XoFEZUbZn6ql7lFkWEqXgeB2xMHvG5zWhtbhtRNfgCrscRStSOJREIybDnNw7AKMsO7hCML6OBTwkz+az4NG01L1k1SBKP3g1FNC7DszXFCFFe9SL0cYk9dD67DW3zxNu7cCVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTH0lh7qzQedv+4ocinL1aDJwpDGVnOinQlnCNsHw2c=;
 b=PqjgvdbSPqDz/hQzIAZo/lPeypGe95kW/7d8mdCywhExb9ObPxiRVGj/A7PCxqHjurS/eaVuqDBNoOvdqTt6BWPiB2Hy2hwjj5d+IyqZ8jdsJ0XixRWttkjUuhi+5C+kR3q2yfnBneu2Tjb4Uv2U44vdXdO8ik7tOPKriNTZ2+V2MEs8jnzQzMh/CBLHemjGzV2v5BydzFAti3e49cuXSHq+PzaY267J4Oh84IK2siTaOdfzYBP9Cyi0yS20wDDCxOA9Kcw8Bs6AfY8L/2044pygbeDT3I6PXwwIGQcsnDk+s6uT5ZrNr55EsjrxUvTw0wIoIfj9ZVuHwm06LQlnVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTH0lh7qzQedv+4ocinL1aDJwpDGVnOinQlnCNsHw2c=;
 b=Pya9eUhzURcs2TsLD2YId1xTTVHfHcOglLow+ixFtmYEiWBQjN3roqdwEDrGMdf8uQbOO5xs3jFOXhY376LQlV6FY8DuXBZHJ5BZHnTFhswMokeIJkeufjqo2F24m6C196AFAWOx9HDuCeHzACeFSVJkRXQiKl6WqwNP6dEi83c=
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com (2603:1096:400:3d0::7)
 by OS7PR01MB14430.jpnprd01.prod.outlook.com (2603:1096:604:38e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Fri, 13 Mar
 2026 10:33:02 +0000
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de]) by TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de%4]) with mapi id 15.20.9700.015; Fri, 13 Mar 2026
 10:33:02 +0000
From: Biju Das <biju.das.jz@bp.renesas.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, Boris Brezillon
	<boris.brezillon@collabora.com>
CC: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
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
Thread-Index:
 AQHcp96eSUoAacjqcU2c+U96UWFVr7WrPdqAgAAB0YCAANfgAIAAPkuAgAADDoCAAABiYA==
Date: Fri, 13 Mar 2026 10:33:02 +0000
Message-ID:
 <TY3PR01MB11346A730D0228580DBA8EAF48645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de> <abL5rcYIaFFO3GW2@tom-desktop>
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <20260313111851.4c1f89f3@fedora>
 <f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
In-Reply-To: <f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11346:EE_|OS7PR01MB14430:EE_
x-ms-office365-filtering-correlation-id: e52369e8-0bae-4245-1df2-08de80ebe79b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info:
 MXt/Ja+L0ONXcAMreo0CPsDlRS4Wb3Gr4pOzOzGVBdg98ykCJqaGPiGjrVKKzmYghZpbBmBgXdH7NYglKuL27+SIFdA7Ywp69G6UQLN+Th805LeCIHhwysI6PiIGuZLYEH3QFBTKQl/aCnNkVYLGfgDhsnbqqxiqDbw0xurFPQDTO3FdVO82KzEOu4Y7RvYakQIpi57+BVRMvqAwO5etPUaA1/xBJXAGT4ANfho+l/nlUHN6uvIqLWHH3iuPEPK7e2wRVopM9OqRedZRFrT6DPThkztZ7h53oq/LGFzGsnwoyfR6CYK37T03iHF6HyHxwMdpqIam/riSte4jIvBlidF4rliAg1QRweGBqV1tKiNqp9B9jxFG1og6UBliTEJoBFfOwRc6bguIMLxj5is9jpWyDKQ9zJW5NMYelV4/pPz7ZJBVURmeAJSE8boJA3eqN/6ue2fgPe7RADrlyxPiOlBu4r7CFmx4Sj928mSok2Joi4Y1r7MK1Ktj8NJmc8Pa9rXf6kgnoTeQ50spiiQDZa3rUJ70pA4XeMwxkzFExzEN3IaYYV2l1RXuTXf6GM2s3Q0SGXqDuH5iaa1V8y0fe9hBGjuD73SH9goMrTPtw4ixxgO+a1KXWX4nKFKPFFR6fn6yGPtk/v80fl4rABXZ9dzadfMFuM/1AuJCWw/Ol/xdg7/MFMl3wxlhuVcCL53I26QB8SgiE7kDykFqoGadKET5qKWRVgtfYdpgsFO7X4k=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11346.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YUFSK0gxcWczclFRSnlTMWF5enU3QkxoTmN4VlRiMGtJMWJLb2FsTFVHREQz?=
 =?utf-8?B?d2Y4UTFock52MjNHdUNvbFRYc1JEdU9LclY2T2xFTU9vOFhncmkwbGtpQTJn?=
 =?utf-8?B?OUdXWEJHS094N0RucEM0bUpTUFJZSFVKSkEvcjdGMGVuTHlOM283SVJjejBU?=
 =?utf-8?B?Y1pmeFlTbUVqOHA4aGFNdk8xdUVRNDk4dnkzZnVJczEyMmZqVUhYZm82VUpx?=
 =?utf-8?B?S0FUNWl6ZlUxZWVCaXpjdkNoZ0p3RW1lUFZFN2ZMaTJzaThCaE4ydlVneEVT?=
 =?utf-8?B?UGpBbDVDaGRCNXh3cG5ObnZNbW5qaXNsM1FZZ2hzYklWRGEwYkw1d2hOTWU2?=
 =?utf-8?B?SzhkSkVjZGhDZjZwNkw0cFJrSmdmL0lSVkVYeGdiQk9ZcVdDeHM2L2NHYllN?=
 =?utf-8?B?NmZpbWR2Q0daMFpBcEZXb1FHSzJlU09EUFEyams2b0RYVXlmNzU5WmdZTTEv?=
 =?utf-8?B?UCs0c29PRWY3MXYreGd6cUsrMXF3Qnhkd3hoS3lHRWY4TU9tTnBCaVVYNDNk?=
 =?utf-8?B?eVJtR3ZHMitKN05CVDMwZ1BFQVZidDE4a2NwVzRhbHFudHlici9SM2hrSjRx?=
 =?utf-8?B?blZsWTRyNEtFTC9HNDZwcGZWc245cVhuVG9XSElaOStzZGNaOE9vWjVmNndZ?=
 =?utf-8?B?NHZWVjIwc0xBRW1IQ0VJemhuaGxYWkVHZ3hZL1ZqSlhXTDJWT0hXTUR4TWZn?=
 =?utf-8?B?RXVzenBMSUk0YW02WlpKakFLMlhoMVlVdnY1NDJibGt5ZEtER0x2MWNqRXFU?=
 =?utf-8?B?TmRQUEZKQ0xTYzlnVHJnRHJaSG5UbGJ6eTBaMkd2R01tRDVwTmlhOGZqQU0z?=
 =?utf-8?B?SDAyaFZGWVFha2U5Qmx3cThjdU1TS1owNkJtbXZTQkh1dWpLaSs4eGgzV1lK?=
 =?utf-8?B?ZXBYdFJWdHFGejNBVm93aDlpQk9MWEhNVEdSSnJMcXVYL3ptcjlZY3gzYVdk?=
 =?utf-8?B?Y1ViUGF6cmMzTFI2YWdVNHVZbVFaZUpiQzI4R3JGM2FQcWdkb212UHZRN2Uw?=
 =?utf-8?B?MjBWOUFCUmIxbHE1ZXZ1UzYzcXVERVhBUTRpR1J6dndFT3dvVVdMUnhKNEp0?=
 =?utf-8?B?UERtVFNDRnRtZS9wZ0ZDM3BTRitOQVB4MDdacjBocjRkKzhWSFNNYjJaeHdZ?=
 =?utf-8?B?a0YzQlBXc2JnRHlkc1I1U0Mxak9hUUhiS0t5K3d5dnozRWRhZit2bUl0b3Ex?=
 =?utf-8?B?SWQvN1BPVURlV1VVTjhtYlpYY1NGOVc5RDlVZUJsSW5Nakx2OW1qMU9QeWFV?=
 =?utf-8?B?d29GcjZpTnhCUzdiTlJGZ0VZYittaXZIUVhrd1RvMEFZQm9QTjZqUUdsc0Rh?=
 =?utf-8?B?VEkyQm50T3dyS2dERzVDd28rWFhpRlJudlhEZUlwUi9uZTJSa05qa1llNnpR?=
 =?utf-8?B?SDgrSjV5NnhUOTMvaG0wQ0Y4R2xqeWphckJrRXpINFJBNDdxKytpdjlYMTlX?=
 =?utf-8?B?OVo1TmpuaVV3V2NESkM3NEZwdU55VjBVOUQ1NllaZm5nekZQcDJXb01abXF2?=
 =?utf-8?B?Q0o3dlFBbVozZFJCWVI3UDJ5ZkVGZ1NhV1pmUEhrSStReUZvTnhiOVVCM2Vo?=
 =?utf-8?B?ZWRsSWNCUHFWajRWUFlUajRVRzVhZVlXakc4M1VZYVhnU0ppRkpLTFQ2U1Rt?=
 =?utf-8?B?eFkvUEF3TVNkT1ZISXlkNXY5WTFRR0VkYU4zd0lPYUwyK2xmRHRycGQ4VmU0?=
 =?utf-8?B?SVVHTXZRbGpEazc3cVRBbkhDQW5wUkwxVTc3UU90ZTh0VVFYS1UrQkF2V0Z5?=
 =?utf-8?B?MjFSL24yUSsxYjloNC9GZ1R6a3g5RW1NQlNQUk9aWGlYeUVXMTcvRk1jcjdH?=
 =?utf-8?B?b1YwQ0hrWGt3em4wc201Y00vUlJSSHUydEZEN0NtMkxNWUZqVjVKa1I3aVdQ?=
 =?utf-8?B?aGI0SUw4UU1zNUoyL2wxUFRmakpHL0hBMEZ4NFNMYUd0cVhaSWFkSFRrUFNz?=
 =?utf-8?B?YnNrODFVVkovRmdaWFJPY3RrOVg3Wnd6akRRTXlja254VG5sQlB2RGxpcmlV?=
 =?utf-8?B?NFN6bGtLWWFCVGhESlVpUVFqVUpXVXdqcjI1VHFpSHJaTXlybHdKZ3JxSmh1?=
 =?utf-8?B?VFFKdllwTjgvZDNMQWRza0QyaW9zZlBrMElSUUFRYWJBY1U4SVB4RG1lV2xW?=
 =?utf-8?B?NnEwTWJHN3NrMjU4UzQraWIzdTZmdGRtanRqZzNGR2xaVWl3Mm1pdEdxMlp6?=
 =?utf-8?B?OFRRN3NNRkVYU3JZTWlrQUVsTWU1ck4wMmhjMHR3YzNZMXUzeVNDRHk0U0sx?=
 =?utf-8?B?bWw5TzRiQXVEOTllQmV2MFYvaDQ3VEtycEJGSkVZQmo0WUVPOHk3d24xeGhV?=
 =?utf-8?B?L3B1Q0xBZTNBMUhhcU5PRE84a3JqOXJKKzlLdTZFSW91QlZEa0NGUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11346.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e52369e8-0bae-4245-1df2-08de80ebe79b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2026 10:33:02.4271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s6WtAyknzOSCC1Q3F0RtRHsYir5lzBXhJIEymxDtgjRg8Prq9T1Ovc9Yk9vbhueAE+kcXvHZpwoA6NmrzI6mFSZCyhOAvA3Rkil/EMBocDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB14430
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CCAA2A0005
X-Stat-Signature: nwqtiujq6jbmkgb4e8656tux1unk74ba
X-Rspam-User: 
X-HE-Tag: 1773397993-406138
X-HE-Meta: U2FsdGVkX18mn4kwwYQ52c47rZYUJMPTx6l2jvAFCPjQWRqSWII5yOEo74wjY/xUjMT2wdnTXGO8M/SkXrLBz3pz/HAe3UCxh8LZA7EcsBpAFO5/Q/ZPIwknCwvTi/KzfW/Uez4lf4MGgaTnlW9ZTTgLPWPjARQV/Be/ckff2ZCDObe3MnJYWnIGWHxXZ6PBVLBkKeJYI97mCAchdxHym/C8SWrbPm8sSf4VZYkRV+QWBVRDOICThNx1yWH99NteKW10I1tJitajCyryVlUVHoUWNGAbURliOWaZK6WkNSl6QgXzEvk0PkQXfbxvQMUyeiapUB2ChHENEZdcTa9YtA/gr/PFW36S2Ap0a8Dx/028aPzybNG1goLz7RXcB9MGQyeciLyzX7Ww8XWfQDEV/I8wfiVgaD9zZQnqXg8VgouumdxeefUxhzpsdSHOR9+BQP7/uYJo5gaQD5mqs4RxO8t/HXJx9iD741VJMZond+Yh0JGy66Y9K+b385QWfnmBFxepZpGAPXnwbnCMCEoY8bM6Q68XUOZIe/BUy08U4G7QFY7YgM/47Askf6l+rWcBRGcCx2/N4/nQnM4xPtdTQNy7f9yP8Tr+d29zUw7jI6KVKLooZs7Ynn0RebgYsIGpnYHKe10UEYZuvgoWmcLevHzZBM5MWmUhxD/mcDfK+exSZxTNEQSBiaX8bTEW3feUQrU2BdnmlzQ/+9R/LsnxKfPgJsoqfeSdWKxzuopIcKSpdqy2Ic5SK5s5jWsC0hoLOZ49E1kpUcIREFkBMFVFOdBsI/+YmISsO7FPxtbdDp3FiFmmvGIVvsVBbszsvwodezfVU+feViicuLAJ8fo3c/tIGgZeJizACEw9gqZ7kZMnflqXghmTf9YGmJ6BOWd0IvtT3toV9R606FXIe9XdanyRuIXdNqUeyNP8lXI0jJwia+9KctO35nCZ3wp1vsDt5bFJFgn6x01RDbi+AXY
 8l7KRGjT
 /vtyWNSM5xI8fsaB9RzuTHRBb8JM8TVvwofRtYD7DobT5l/jgUQJRCP9dQqJ5LaEAPoSQrlBgZUQFNGQcGjXyWk0+PWzMh7JMWYbMyhj3QH20FDTQ8VtZGZ8cRtB8gcqPEQcxiTJnSuWbIFhNU41kg5PZdspbJiUNsV1j9WdvtYtzz3jqqGXG1pGhmCpNwz8+z5Bau5UyhqsZC63mb0AULwDQLXqGtSnSvZLFrLGhq0BaLNKOj4bAh9XDQ0GbAyfUIGvjY4D8d7OvO1AvnipklWuvOEd7+EW+DketJ0T/zfs6e7/c7pEOO+KKhBB/QFgyeI6+1BIYDGz7JA6Gsy+z8Jq/DMOxyC1+/G+ZvMwf3HjJSaFYGjC3k5wD19qOfCQ/8wilG6RuOVENoVsarfUncf2RrHsp4pB0AwaKvPhFckDyFnA+gG8KBApQd7EY55ZkMEAE3nFu+ku3ZDIo+C0J2pVvl2N1rnXVhpNRVU1J3TQNpAO2lSDyJqFIGltHudJdg3lXkqrq2QWja6C59F1F3MwpqLNLkLMyZgJpIPkREySsumOh5iAQYIw+UUkL6kaosbiYWVvLh9MTx/Akhk/r2yCe620UEJCHHlAFxVnkfPQMdGw6GzuI5EsdBi/1mHJCNWMCHycPwI6mDHrJvZqMqmB9fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgVGhvbWFzLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRob21h
cyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPg0KPiBTZW50OiAxMyBNYXJjaCAyMDI2
IDEwOjMwDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjQgNS82XSBkcm0vZ2VtLXNobWVtOiBUcmFj
ayBmb2xpbyBhY2Nlc3NlZC9kaXJ0eSBzdGF0dXMgaW4gbW1hcA0KPiANCj4gSGkNCj4gDQo+IEFt
IDEzLjAzLjI2IHVtIDExOjE4IHNjaHJpZWIgQm9yaXMgQnJlemlsbG9uOg0KPiBbLi4uXQ0KPiA+
Pj4+PiArCWlmIChkcm1fV0FSTl9PTihvYmotPmRldiwgIXNobWVtLT5wYWdlcyB8fCBwYWdlX29m
ZnNldCA+PSBudW1fcGFnZXMpKQ0KPiA+Pj4+PiArCQlyZXR1cm4gVk1fRkFVTFRfU0lHQlVTOw0K
PiA+Pj4+PiArDQo+ID4+Pj4+ICsJZmlsZV91cGRhdGVfdGltZSh2bWEtPnZtX2ZpbGUpOw0KPiA+
Pj4+PiArDQo+ID4+Pj4+ICsJZm9saW9fbWFya19kaXJ0eShwYWdlX2ZvbGlvKHNobWVtLT5wYWdl
c1twYWdlX29mZnNldF0pKTsNCj4gPiBEbyB3ZSBuZWVkIGEgZm9saW9fbWFya19kaXJ0eV9sb2Nr
KCkgaGVyZT8NCj4gDQo+IFRoZXJlIGlzIGEgaGVscGVyIGZvciB0aGF0IHdpdGggc29tZSBkb2N1
bWVudGF0aW9uLiBbMV0NCj4gDQo+IFsxXQ0KPiBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9s
aW51eC92Ni4xOS43L3NvdXJjZS9tbS9wYWdlLXdyaXRlYmFjay5jI0wyODI2DQoNCkZZSSwgSSBj
b21tZW50ZWQgYWxsIHRoZSBjYWxscyBpbiB0aGUgcGF0Y2gsIGl0IGRvZXMgbm90IHNvbHZlIHRo
ZSBpc3N1ZS4NCg0KQ29tbWVudGluZyB0aGUgY2FsbGJhY2sgYmVsb3cgZml4ZWQgdGhlIGlzc3Vl
Lg0KDQoJLy8ucGZuX21rd3JpdGUgPSBkcm1fZ2VtX3NobWVtX3Bmbl9ta3dyaXRlLA0KDQpDaGVl
cnMsDQpCaWp1DQoNCj4gPg0KPiA+Pj4+PiArDQo+ID4+Pj4+ICsJcmV0dXJuIDA7DQo+ID4+Pj4+
ICt9DQo+ID4+Pj4+ICsNCj4gPj4+Pj4gICBjb25zdCBzdHJ1Y3Qgdm1fb3BlcmF0aW9uc19zdHJ1
Y3QgZHJtX2dlbV9zaG1lbV92bV9vcHMgPSB7DQo+ID4+Pj4+ICAgCS5mYXVsdCA9IGRybV9nZW1f
c2htZW1fZmF1bHQsDQo+ID4+Pj4+ICAgCS5vcGVuID0gZHJtX2dlbV9zaG1lbV92bV9vcGVuLA0K
PiA+Pj4+PiAgIAkuY2xvc2UgPSBkcm1fZ2VtX3NobWVtX3ZtX2Nsb3NlLA0KPiA+Pj4+PiArCS5w
Zm5fbWt3cml0ZSA9IGRybV9nZW1fc2htZW1fcGZuX21rd3JpdGUsDQo+ID4+Pj4+ICAgfTsNCj4g
Pj4+Pj4gICBFWFBPUlRfU1lNQk9MX0dQTChkcm1fZ2VtX3NobWVtX3ZtX29wcyk7DQo+ID4+Pj4+
DQo+ID4+Pj4+IC0tDQo+ID4+Pj4+IDIuNTIuMA0KPiA+Pj4+Pg0KPiANCj4gLS0NCj4gLS0NCj4g
VGhvbWFzIFppbW1lcm1hbm4NCj4gR3JhcGhpY3MgRHJpdmVyIERldmVsb3Blcg0KPiBTVVNFIFNv
ZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgNCj4gRnJhbmtlbnN0ci4gMTQ2LCA5MDQ2MSBO
w7xybmJlcmcsIEdlcm1hbnksIHd3dy5zdXNlLmNvbQ0KPiBHRjogSm9jaGVuIEphc2VyLCBBbmRy
ZXcgTWNEb25hbGQsIFdlcm5lciBLbm9ibGljaCwgKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0K
PiANCg0K

