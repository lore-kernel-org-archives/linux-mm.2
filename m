Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1698105F79F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 12:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301036B0088; Fri, 13 Mar 2026 08:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEDF6B008A; Fri, 13 Mar 2026 08:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C4C6B008C; Fri, 13 Mar 2026 08:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01BA46B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:04:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96CC9160114
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:04:40 +0000 (UTC)
X-FDA: 84540907920.19.6BD47DC
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011058.outbound.protection.outlook.com [40.107.74.58])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77DF6C0013
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:04:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b="eJ/tQg9z";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.58 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773403477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfOC/VHGg+VHEDY6OwhbzpgpXKsOaz0IWHk+ZqoM8MM=;
	b=zFPdM6JQ08UGitQadADRouTCW59WKSMs3PBml0Uqf1EAB9xjhwFubxHahEisoXCKe6eES3
	Xib6UeQyicz3g83jStZ9zE9hLF5CQdr6JoUK4KbdAAIbWXGuKhszKBVOplr3oAIK5RtJIh
	SDS2O99bl9ggyjHfS932dGiCypGKPpA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773403477; a=rsa-sha256;
	cv=pass;
	b=w5rxc6DH33x/4eHJRbASsNHEY8ez025BN9VBFivslBEXd7j5IGxabgMuV2t6SO+jphH+WD
	MoEvYDL+MEgzytwJJcuvLJvJC92B6dUoh2AD5fZZRHifcDirjpZ/aaUaUYi5Fz9UtAD9Et
	oWrY9dYfD7dPmrdjpHMpu2zkHvOAN5o=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b="eJ/tQg9z";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.58 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCB6aPBE+YcGkEvtEG6MuUbGbVnNxVDDv8jT/RT84xx8iubLdqMLMtN6qOhw6nt8dTObVr5wlsuImTrtAHA0RCfGgGJaXVPeji/AJw+1/RG7HuouDzQ61xSD163UbWnpJ73geEv2I7NFbbf5N80hBXVzMiRULevQNKunOGemBiqWS2d1Ad1/YyTv6zIGfiShir05pf2CxbS8tICdd0dx/ZkphdQnZRO6tEaD7qoAUfWYEfKSKsEKm9qu3utcAwtUMePmMqsRETi+wKv4Iyfr06p4KCj+DPHWrA3CXEWZmBVO8u9BEF2alnQ/3P9r1MWS1+TaCHOjGFnFtjG/+BVoPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfOC/VHGg+VHEDY6OwhbzpgpXKsOaz0IWHk+ZqoM8MM=;
 b=IynnczFB693sF8f8frcNFPnBdgEBy+kcWy+6GpTqElw77AYCx1o7VZjix2avkP4MvarTrsfc8vUO8x8d7dySr2aCUNt33UNEWobzwuvwmwnzWSfsWS6yJ6R9B4im1nYMFONOPW97Ub2A42nMVTK4HjKXSEFyhA+0G1cm4h+pxZFSSBgVPlxyFOWlrcCg1XRfdQajNqlLBx0xAqkF8FbmGU2ODchZHFTRels5YwZTfi5xIxH2Mxam7U8leAl6ZgEYC8wpFwOx2Nvf6Hp5wlE1kQ/NY7mGwPDwlLxFRg1EGmSVpHTLQJXqRsPRBX7chxe4YOOxsTspvJ9OwqmjSLO9ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfOC/VHGg+VHEDY6OwhbzpgpXKsOaz0IWHk+ZqoM8MM=;
 b=eJ/tQg9zeh88N4Uz2Vn8yLj1T9ATy5LLcNgD+r5dJZZsfAoHgBPxFV90R/SdZo+/SZyk26bZrlOfj11pyRbnfm8wt+IEpOAzqP2Qh6BULAgzmqKup4F4uC4Gp0yJGKOLj7NtxAGk+CDkOzrgD3SdxInwDx/1S0hOpIWFlVe6auU=
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com (2603:1096:400:3d0::7)
 by TY1PR01MB10738.jpnprd01.prod.outlook.com (2603:1096:400:31c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Fri, 13 Mar
 2026 12:04:26 +0000
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de]) by TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de%4]) with mapi id 15.20.9700.015; Fri, 13 Mar 2026
 12:04:25 +0000
From: Biju Das <biju.das.jz@bp.renesas.com>
To: Boris Brezillon <boris.brezillon@collabora.com>, Thomas Zimmermann
	<tzimmermann@suse.de>
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
 AQHcp96eSUoAacjqcU2c+U96UWFVr7WrPdqAgAAB0YCAANfgAIAAPkuAgAADDoCAABhLAIAAAcHA
Date: Fri, 13 Mar 2026 12:04:25 +0000
Message-ID:
 <TY3PR01MB1134662A395AA0A048CEE152E8645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de> <abL5rcYIaFFO3GW2@tom-desktop>
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <20260313111851.4c1f89f3@fedora>
 <f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
 <20260313125644.65131b27@fedora>
In-Reply-To: <20260313125644.65131b27@fedora>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11346:EE_|TY1PR01MB10738:EE_
x-ms-office365-filtering-correlation-id: 3b8b3ae6-341c-4474-5bba-08de80f8abd9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 iI1Nocz0PbqK6NgV8N3EojkSWN8D/K2E6qw1AIZhK5MOlYOhkPrkS+dGR/9Nd01lEqnBTRrqHq8nuWea3+5aICZNXgmdipXTiV9WCE6zTEq1A9Ffa8TW8rgtOlY0osR46KUD/82/2R/VIiISc0EO7HB1aabD0JHPHJgqSFxAf2SaIpj1orVWJ6Ag21ZDaBcb8b9sD2I3ynrUEQkONUV1JscHYoXH4zyGHHreJNXuTnCivCl35prtVH7bxPZb/MO2YJt5PQEtQVlQUjeau7RSNkMLkAuBslbZUc38luQh3nub9oFYGogHg21zb+sD4Busxp++vZciSXMjpcbAH8hx9jNdAOblf9JOS4bVtayEQG9Bwv1PHZyZ5mjtxUgMWi4Rs8Vs1IvZse4P2QQWVGVvQxUaKOLW5TbFEqlhFHfqLTipPT0Yn9XpnSO9Ipc8xzs2cJgXhq7cnDnZ+ehZ0Jhm3ezXzn4U/eQQmd5xlAbFKCM9y4Khq03V8JWd5Zf0EcwT9F9GYTFgbu3mDVoazdUwYJIoGeNjkhrWvL7epGgG4poGM6qHyVGm/ZFcjXwtB6t0pLYU1Kw8h/WkghE7OD7tPCkvghW1nYowlaRVLAJ0gaYl1dlRqB41KGfxafUZ9AjqzQiXx8HY44A8gMNEc+/58oPndjaYpsdSgjl3BtwYkh2a4sZqXnkOFieyOkbfAausmog2fpsg3Yg8I7AN//2odnMQ7p5E0lOJ6YoqfXvlr+R9/ZwLkQ+7ktFf8zWXZ4+R
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11346.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?tuRxvjUmRc+6121Aak+uk7mFfzI4whRa5ei+Z57MjF5wmDckZrrvffX1TOu2?=
 =?us-ascii?Q?Dqn5fY6W2B9HymdUzTnXYOY6J9qB+p+HmVux0iB05xqL2O75JQKBmW2HJoTr?=
 =?us-ascii?Q?b0vwPDRKVwemlEqiTEi+oa5/g8NpM9FsHehenQJSbOCevvkLJnBGtxWGAKY4?=
 =?us-ascii?Q?tf2wefHKmM15QdiyaImCIUQCZt33E7kzJXvALAi0fb+S17K3/OnU9T8QH5u0?=
 =?us-ascii?Q?W/aFZmCOtCHPK8QnHfp7m8mfS4TOxRowDEhFxmV+I2yTWRz1CGtOyCr6b1Be?=
 =?us-ascii?Q?wmo6kYVxezO5Lp3HT3DnAv9UEgYk0LAcYMCvBnip4bjiNaNRnu0eqv024nl9?=
 =?us-ascii?Q?NppPZloNwHAyqLq8NKI/5qTV82aHHPPkZ+hqLSnHBwiESFbB+tItoTWEfLlz?=
 =?us-ascii?Q?QMJMwH6uCVMfFZ2khE32jR6BQaaITKNIPQN4SZyKZy9LHJwX0zmioUtve2HM?=
 =?us-ascii?Q?pEf5fixgQHrH8p6SLeZLpIwl1fG3la692dZr/xXLcEqrNxmZ+f0Etqj3kxt4?=
 =?us-ascii?Q?wSeWx+fmEpUVOVucHhFgMkagKlMK8R6fZMTf47Jyl6hw480/v9X3+X6qVT6B?=
 =?us-ascii?Q?gAfzu0JHN3PqM4qO3NOZRIL8deCQOuf9Xg5Kfl3rVq67oh59NNsXzasI6K9F?=
 =?us-ascii?Q?1/tE1KCjfNHdIR1hGP+U31pDKXPYa+uxP/nDTJY69hRobM6vtTBQxtackTIg?=
 =?us-ascii?Q?ERtkX87C2NcP6jDkqSMmrDsfPVYEKUEVbWzKg1/BqTt65tyaIxLt1kdN6slq?=
 =?us-ascii?Q?+brVywS3wmi8PKHl64C3cWHSCxxico0KGKlED7aIWKbnjuN6lNsmYAntcHNY?=
 =?us-ascii?Q?U7bv1Z6zgke7sge3nhXfQoWDCru+Ym37wnb/4y5TFFPdi3JcbUBes0OrGlTZ?=
 =?us-ascii?Q?i7vAgrimadLhJM0Z41AKbDGzMGNTxIJNYAfq9F28K9mdEIqKy/zcsHjd43eI?=
 =?us-ascii?Q?EsJSSRtr+X/RBrqJD+ri/W9z89NaoAiCVQHJvAgAJtrPX4eIwjTROScQpbEV?=
 =?us-ascii?Q?Jk8BQ8ykM16cJcTW7WFWT7S+609shsAGDBYlkBcy8VEeAhb3cFKrPqOuEb8+?=
 =?us-ascii?Q?tmuPJzaW4kv7v+cungGZnx033Gcxa15IViKA6GVUstGfav6Ztl+wzdZSBeSg?=
 =?us-ascii?Q?T3uhEROu1qNPE+KSQgn1W4xl4GOCnP/Gaip+Y/EaRHFNuUKQM5gYKH+m2jv9?=
 =?us-ascii?Q?gzk6NSHo2t5srYWPG0jjP17FJvjMhn9Pa46GZA1IqRP43FmkIaPPiLb7BfA0?=
 =?us-ascii?Q?vQu31AUQGffDmsZS1fKzK5J1Qr6uTuxmfSUSkxjWHyYkaq6DHq4XM8qmSGa/?=
 =?us-ascii?Q?RSzNU5+UYk0n6F9VbUosY770XiDeJCjbiJxxK70ZkNcJqcuLPFCM6efTdFut?=
 =?us-ascii?Q?I2fc8QSceDLcCCSXaulJr99JDNzw4potvglWiq1ED8tD91GD5SiIf+NyYDzE?=
 =?us-ascii?Q?ZBWNL57Xpg4nl08ztfN/RfWEQ46Y/ODxgGFuCXHKNQZT2VB7hxKLrhilef+4?=
 =?us-ascii?Q?+JWa6FP/kzw6Wh0uvYrLc/sV5HxW9i5LSzfiKELrA2nms0GwQcMPkSMriO/S?=
 =?us-ascii?Q?mSkhwbLc/43r6mWMaDqkZumYfcCF2weGr7I/9N6Ax7wqaaL8FO/2EfES2yHP?=
 =?us-ascii?Q?rH7WiZiA3uwgK/0m18ZlKPRuDKRxPLDBzjHEIWO9zCkfq3Z+AQ9KMpeSNtwc?=
 =?us-ascii?Q?TVztNBzQ15INnma1O8UoC+fdYi4cUnsokN8evyw0D0N29a8uCHc5jI/wQrUe?=
 =?us-ascii?Q?+6K5kGg+Nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11346.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8b3ae6-341c-4474-5bba-08de80f8abd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2026 12:04:25.6412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MRS82Eq9WEVT7zrNkN7Poa+ZRXlD+nVfv/d2TKupliBM/Ul0usbcjpR8LSQu0ALSlfmejGs4kzDQC4WHYnJRpwVDeQFKBDInCU3Pd4uM1jM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB10738
X-Rspam-User: 
X-Stat-Signature: oik6p4aowqwt4tdk3k1w8m4sf9nnwpsu
X-Rspamd-Queue-Id: 77DF6C0013
X-Rspamd-Server: rspam03
X-HE-Tag: 1773403476-919082
X-HE-Meta: U2FsdGVkX1/9/J0GgveLGCSoSnGGVrh1be9XG0hCDmiC1sVHCbWzAJm7oHztxByHxEOSown1Nkx6+xMLM0h35MFtorTMUfApAvnL7+cFgzvQAS0O7zCfO333fMRo8aA5fMLF47eQ0I7cQ47hXvdeIeseA4nKeKsOUtYiaplaWuLNcQmYGUme2cBS4sd7brhcAQ+DZkrkrHniclQsrjBKGRubHLkz8lhyfcSYw4L1R58mO4O/kZ+TpZKfKOqzBUAEvtXAhDbXlNcbr8tuBciKlHxO/v/BXx5L8pa5VyDdQjUjAE7vPNeHYM2Gp9o5JSKjdaoMzwFAvSnBQofyzvvwj0f5qzvG7xOk57ALkCFKj3BeFyDqws8l+xxnkigm9DVxQm8PI0tH7I9EGPY3QC7N5MiV6HSeK6NPzi5L+N1E+cTyAxJr8jSo3DZpYH4mk7Q2vdwGlSSbanyWggYjiy9wExGOdA+qOTn9XoJPck6AHa4V6cPB5FdnD551h8RPViGierQIcOJ8iko2KhlQRR/WuYjxgN/7s/1CZMYNwdYLRPi+R2lmrerQllBb9uRx8ePuUb9EfYvt8KngMDSTa42ppt+BtWGqFn/VjO1IBhg6dDPyz5wePZYskbaL/An6MwreEhoJK7LPkilBOMTlQx3mqyxTigwSGnbzwtYDzf+gNpFDBuOmoJqa05xCwLr0Bc3Eayh4PB9Ff53EvZb/4XdQeF2kIXA58NfxYzF/Z1IGXdFsyIEgAMSIqlyz2EhvkWb28x8adilA+npz6M98i/OQbkmdR7gX3KlR5fQcVDf1qot8vUw1xX+NOzWwoaPuRsYfKetzJwwI1QrsB8MHzTeRBjt02bDVcJ3OKz66Cr9QwDrTfYfBO+fLs/biyauydPVqW/YUODtyGDJvWnay7Mu2lTrpW42HcDSdwY39T8RD8rwX6OLjyHiDJSFk66xei+wKai4jYH70aPizr2gJ1uM
 ypMcle4Q
 zTY7So/vwULO1V5rxy+CjtQletVy+1yXpk/htjy9RUKYxSM8dircq8VvaZ26e/0Xf9XjOtv4UwF2J5IqjDzuhLNNaTrOuz7dr+cBl6aKr4oc/AqxecxDMHE1yPwXkoerwV7A0uWDehh26k9LWnM0QFgTOXoctB8vcvVabf1KyZAS51AuwfCWWku9cH4GegbhumNiKmUtjTGem3WzS8EBq1VTbg0XUlNg6O9NBMJE+cVfZj9s5yEziTnAJCC64pQd61OiEvjPH6LahEqsGoKLH0ICwC+vXUcCM4GSJCt9UTl3Om8vk+s8sGUht4EHgFUlQomW7RI2/DnJ9DeWOY0AncnwJaG+zzW7gMRVGh4I3LAYBdySxzQFxwR3nieDzl6owmreU2E/AUu28qWA4LXYhbEuOWP/xE5ONA2+iySNr5HOemRDCocBB45aEV+v4KWIH9+nqTvup7Rhe5SRGebqqsvt6bbptq/iHUISXUj/xf+nD++4SauFaYxcVdWPQD/yNdcek3WNLrMhmFTC3nEoXj9xib17+fJBP6jE2NFd9e2raRPwtSnvl3JXxbLnwSsjJ2U+Ypi6Wm8JchwlHent5/8pQp0mvaxxsoMSOtEvTUSKayXHW27V78Tbal1GCw3gnAWH2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Bo=
ris Brezillon
> Sent: 13 March 2026 11:57
> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty sta=
tus in mmap
>=20
> On Fri, 13 Mar 2026 11:29:47 +0100
> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>=20
> > Hi
> >
> > Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> > [...]
> > >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >=3D num=
_pages))
> > >>>>> +		return VM_FAULT_SIGBUS;
> > >>>>> +
> > >>>>> +	file_update_time(vma->vm_file);
> > >>>>> +
> > >>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> > > Do we need a folio_mark_dirty_lock() here?
> >
> > There is a helper for that with some documentation. [1]
>=20
> This [1] seems to solve the problem for me. Still unsure about the folio_=
mark_dirty_lock vs
> folio_mark_dirty though.
>=20
> [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargom=
es@gmail.com/

FYI, I used folio_mark_dirty_lock() still it does not solve the issue with =
weston hang.

Cheers,
Biju

