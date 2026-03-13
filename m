Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0464E106FD91
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 06:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123F36B0005; Fri, 13 Mar 2026 02:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7626B0088; Fri, 13 Mar 2026 02:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1296B0089; Fri, 13 Mar 2026 02:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D65D36B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:44:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87E51160806
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:44:45 +0000 (UTC)
X-FDA: 84540101730.03.C017CF0
Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazon11010027.outbound.protection.outlook.com [52.101.228.27])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9295A80012
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:44:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=WkPyAkfI;
	spf=pass (imf02.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 52.101.228.27 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773384282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mvoju5M46wfoKngitNLfxvZtC6FSm/xOPccn7xY6QY=;
	b=TV1PTi0mIlDklB4CERnMrUJEb4AwzBwD6Zhq60vi7UtLuvQrArYeeM8t2Uko3uWfWA74O7
	w+MynupsJV825VFjQDsE2SacjRIA3xolK50+LF0+NFUQVAzegNti3/asDMk5iztDI436QS
	mZN+uu0vxc54k+hpNy8z8MM5JQ2Oxaw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=WkPyAkfI;
	spf=pass (imf02.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 52.101.228.27 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773384282; a=rsa-sha256;
	cv=pass;
	b=1zZwmmBsjSR9Wu0TxLtBpFfaEoVEdsQKBJemr8TGXcU30gxXAl/ibLjaw9OptE4KMwxgYF
	LDdnzSlMw3Hk0iiB9uAvPLGvPVmnJ/rMnDKSkn8EkF1xyRLIocL7r00Sz/zGCaz7QWx+rh
	8aJ4gcyEGurgy/d7i1hJIIzyRY1Y1u4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZN5R9ZJTakWd7iVhqm6EHEZxDsU0tRkkW7pRLZNGq6JB3ciEcRuz5RztkTH2JLv4LEfctI7hWR4WDFkOd1vUZ7MBrYUFkCOHL/fIfYKL5EXM5+m0qYPas4W4n/IgJLPDS2/CWpGPcNtqp4i+Sx4kjFCersxlo8bAXmcszIWm/12KWeqbpzVJMBzGSazi/i5gLcAvED7ce61zrqI/eSJtnnkMHG52qliS7GvCplR1EtqoII/gKQ2p3ZX9Dw2/AzaXfi2kgh/N/OgOWLVqsCMyuF3KcqmOv9aecyuwZ5/G3dEnFiVqYJUxGjjWA0ngOxgWQhXlf5Wh0Lnx7QBaQhps+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mvoju5M46wfoKngitNLfxvZtC6FSm/xOPccn7xY6QY=;
 b=STurJ/LspqK11MSLJ3v2q4m5H238Vxm6JLJvf6/Oy+lRHr2cdVgCoX/FAVAozefzSEZvhQeO9TpO6/xehOOiWQDKnFncYDkillZEi+ySaE2JpZtpw6j2670YQw7AxM2xL9VJFFFvCTnxmgVtIT+HbamEKZV+DUYwibqNAxzYIjPtrzpqbPki8EACisek8i+K5ZOyY57Lx9etTVklU+ff0BYJ4qavjOu1cb5v8rgfWpQjo8XoxFCVIfUPiOWNWwAXKWOx1iXdg4VBFAc7sINsRsOD0lMR7XTzfRw4AfLIUG62aKObCuAFmGtQg1jTjRI8sIVgScJf7npLTMOAKHk6Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mvoju5M46wfoKngitNLfxvZtC6FSm/xOPccn7xY6QY=;
 b=WkPyAkfI4Zc+7Us71TUyO9QAvqTgc/d1pWjX0VgnCcbnlrBtIcaE1JQ0HRbNM40Ysu1RbkFAA8ITByKrkIJ1wf9ZsMBwAdQRSlUdcf20qIUATPZnhFYndKwnCZhI/OArdBM+j9HDPmAP2luH0+ZYG2dgfgfgW1E9mouyuc+U324=
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com (2603:1096:400:3d0::7)
 by TYWPR01MB8394.jpnprd01.prod.outlook.com (2603:1096:400:161::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Fri, 13 Mar
 2026 06:44:33 +0000
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de]) by TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de%4]) with mapi id 15.20.9700.015; Fri, 13 Mar 2026
 06:44:25 +0000
From: Biju Das <biju.das.jz@bp.renesas.com>
To: Biju Das <biju.das.jz@bp.renesas.com>, Tommaso Merciai
	<tommaso.merciai.xr@bp.renesas.com>, Thomas Zimmermann <tzimmermann@suse.de>
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
Thread-Index: AQHcp96eSUoAacjqcU2c+U96UWFVr7WrPdqAgAAB0YCAANfgAA==
Date: Fri, 13 Mar 2026 06:44:25 +0000
Message-ID:
 <TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de> <abL5rcYIaFFO3GW2@tom-desktop>
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
In-Reply-To:
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11346:EE_|TYWPR01MB8394:EE_
x-ms-office365-filtering-correlation-id: 0e8117f4-8ac0-4ad1-d06f-08de80cbf7df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 873boxpDcpBkytSGHvoZ/Gnnt0TwYQObivfFQXDXcaPNtL5qKGj3Rj4kUOU6eWEmPwv72948RsLoho074+u/kLLjLi37vmtycyhxVPiGBYgbePpopO/uraxOnuoRn7OzT3YbbFObd+Y6GEYPFionjtevsEWUDnh4D2/JQP87TjEbXINVsF8rvTfKkfqDnefUNXeeYbksA3i2dEUvELe4cQdst17Q0mC3mXwe5cnoMaxW70E+xaU/+lPddjJ5K5UMIHsenGd/UyueMbquFZCmwhdTi8IsaU4bdvOyvpdR11AAsI7yy3MMbgSuztlSP3sRNC+qgdE34dwnSUSCOKNvCBv/jIZukLGnnXZw6BBXbw4LEB4m4kZgesF3zs4WoTczIUqPEzqZ8lKaMBeRSiou3Ou5GpN9ginu8l6tbj5eK4cnZ7PUw3fLUgvcRtq2YV/de1KnGDcd7J/8jbLxRdSlUT5P0vSZjspsR8l1Ju+ksXG/JuH3vrQ0oSC3hxMHdBGZQQnwePrEafRl75dlfC0sqTKazCGBFEcjBx9EEMY9DaCCOCSKnci00v71tFh1asY1Zk4+DZ1pqCw4ZetYO/3bH7Rc8/wCMrpczLzuirkDlWm6pvXjDAAoperN6/5W0UM4otoUAKoU5jK3myqh06W4A+Ogf1Nmw51zgM4Il8tHTKUrW2neSaMaY+YQgQda507uFYkNB2Bnl3XtaTh/XWXILjrtw5P6x678xakXXqyqt0a3tm4gl7VQnh2t0MiQQkaTbEOR4UxUWvhDU2cqTzrdCzRNw0ivRE46HSVlCH6sNpk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11346.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FlKzWVO8D00jo9E8YhCXDdVl3WYdy+vtTCk2xzjoq2x62Ak/OVxVZesPGRmp?=
 =?us-ascii?Q?4OOyrY/H4Y+9TwFjZb/bznD5VU5DUlwC+brq2rRF1CH4baWDkT1pMnm/5IQJ?=
 =?us-ascii?Q?BxcHgT9FXVmcUuNBYqiGJ3jV3Gdq8ROL0Nt1QB1s6o6ZWzGZthgo4n7afxC1?=
 =?us-ascii?Q?c4NZa9tVyuraePERwQNA/Ar0LMkXuC6J86jv50mHlCS/IpjgcmnLxCk0QxvJ?=
 =?us-ascii?Q?KV3mtUDHCNNZlJ2k0AwP+fhuJ0YnF2stqW//YgQHPILNBRaDNLbVXoOVZsD4?=
 =?us-ascii?Q?KqB2Z/wEq0eRAhILJXjNbsklv27lRHnkKqQcPLiwMXVNkvAAN4NtVY2YibT8?=
 =?us-ascii?Q?9+w1CuUX91MDL32f80RKkD3utKVKZK/Paq30B6Fj4U5dyLP7zRztnVpf9oCR?=
 =?us-ascii?Q?4J/wxAK+3Bs4/M7GDaosnDgQc56NcLeI6aXRTsjWIdqsDvgcoxNdsXqX0A6E?=
 =?us-ascii?Q?5f30Xm2cVK8jFvAtCYi0WzDORY2JBGzR8q8Ra/GmT9nCFiVfxMw9lesVn3qX?=
 =?us-ascii?Q?bE7tw7uPf58cddJbBq30xcMOBzNGXGuuuDiVdQEcgz0QDS83w5t/DddMroA2?=
 =?us-ascii?Q?ZcNYYeKf2YIIu/Yje8oMBCSHDdzyz9G+mcFlVMzdKGXXTzkdeStWRmCUzm6n?=
 =?us-ascii?Q?HpPusTbbzoAX0+AWba3SgzbL737OINpeYAHCUrxNbDx6eO5wIwGoVc6T/xOp?=
 =?us-ascii?Q?bzcum+RP99edDxQoROr3WRSmzLnmOPDsmgbEoXEpZLJsjki8K9NN/nuyY/hj?=
 =?us-ascii?Q?ASsp1QG0GA8HgAyNK7Sp2qRi7VYvTvub+MQCGjpqwYa65yOvdJoJqMeg1qpL?=
 =?us-ascii?Q?ihbxc+7ljjimlE9Z6ppTBOJYnu3EPxQuM6g/DWwvMWTYBpv631luawvWdurJ?=
 =?us-ascii?Q?HoLvUgVEi0jR0HVddNBYs/T8PJ8L3p0g7hI7GbeWwdFihQhqJ56j902Cr1bE?=
 =?us-ascii?Q?VYKoA4owxrFdhm3UolPwsr6D89sBgT9burq2ez9lE8R8M2txhjUFOrD4h8TB?=
 =?us-ascii?Q?5dSx9GOSwh3bFz1oN5FOFkh66Rqz+xT58r8WIKSpBXTczuRs066RyMxPBh4f?=
 =?us-ascii?Q?0elXaPs0XA2CHqsa9X7XhdSx12yzHC8uEYpJpdZJlaDE9HDIgCpSYsAi7Gej?=
 =?us-ascii?Q?Xn2PkblR/G12CnVkDXdHsCo43z9FBKD53Cy0wH4Hnvf5gzinr76/TwP+TSTm?=
 =?us-ascii?Q?kdQJBoRbPutPVWwtM9OPW2UKuWA8S2lnhZJIJ3LYjfN2vCJc60/oxtHyMVD1?=
 =?us-ascii?Q?W2bKJAH0M2zuoUINr/FTZa9ZfwJMdWadT0H2rSAAImhxPLZBzaxoHpI1X6Bt?=
 =?us-ascii?Q?hhHfFg/WFDPvU6HQF4QK4vog3WFjRej5cr1UEJmFSINDXYRYBrj+TcsenBLe?=
 =?us-ascii?Q?ppggsm4ExQPpLduAU7oSGTy7wHFmhOevNqSqBuuMtGoAWrdjCk9muLV/Wa7z?=
 =?us-ascii?Q?laChXULsfQK1hrr5N2j/giw77l0dMx/vy4OZ+1rtkY05yWcyoQVJ7jGvkrth?=
 =?us-ascii?Q?LqNkfb2xhePYkccyncbPISzESFZgQXbBvqbn/mp9oA4HwPV3qkD0MfUr1S1b?=
 =?us-ascii?Q?p3lWVX+cn27FubWoqJ/M3XQPovmCjL5U3S9bcLg3KLJQlBO92d8hMJPZXGxp?=
 =?us-ascii?Q?PHS8IKvYSLUOJNa60KCH0f1KqJtxrbQT9oprrujxD0wAxw1LGyYUEMD5eTAl?=
 =?us-ascii?Q?Q9AWX52VKFqH9JbYPUsaLy3fsL7D0PqUllOFbAFZHYTRGyfrC9OIRX0tVQlt?=
 =?us-ascii?Q?lhuli9osWg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11346.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8117f4-8ac0-4ad1-d06f-08de80cbf7df
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2026 06:44:25.7929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBIdeG87S2iTlN1cAx4ws3Sa9qVp7haR7O9nxD02EcfthPqrM+ABRX2Ykh4Yf57B1vRtEehY/XqSCmhP2wpNCk7/wDu5fBdwD46SMEVbRK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8394
X-Stat-Signature: 1pqkna4iwrtjoi1rnrod5o7yrmd53q3g
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9295A80012
X-HE-Tag: 1773384281-825989
X-HE-Meta: U2FsdGVkX1/1dYwGTzqiEEOp5jT4SSGsEoVOppq7rQMzh9YcnFNvIv8/cKoQzFTd5nmBV5bQPzlo9KzfNKMYtFogf76nBHQwAPWGJmX9EauM/KDrF+aqBrpFXwJ56FxgAMJyFCQoOkqWLAZbmVA9JMjUG2iTw7YcoclaDeJKKsIkrPTE+DF9qVh2WoNLZ59cYGQ8iMyBeL2kR7CwLRxmIqlHWW67b+W6UZIk/xoB35z2HcQ3ns8oQrpAS8kxLX2yZV0KOwfvThU+noPiy8eSoiAsFmr+n0M5eL8D1w2P4+n0vjqH87kAogd5ItRkHAcq90oScZ7gXxkvYPWqXy07iUMQ2xN30GrsONXaDRgnIoh+I6qT6RZmRiAMdgBZRIK2wxXv9szz/AFwabrWTRhUvJCdnET3xRVKpXMcE+ZtFffevqP8p27zmQ887Zmm3Jx5HCUh+A4qvZRHpg+z0bq7O0mPboe2eI82v+UMj8h7+fo86KL3284hgWjqw2hhuzqHTF0DgEJs/bnCMMzF9/CxTe9CEcEVrTC0DHLI4ZylqeCEtAibB7oVQQ/lwMa9vDTsMYOzEI+/fRCL0llN0UuUJqY3ilPUTRJrrakx26NoH/2Vx1LQQqhsgHmMgg2AVgSLa8VJ7yF/wU25lIWHwf3LmYJt5vsVVwYbAXLvcKlnqPyZAvXqJnapB5xVYVOgtVLW5LPDgTJSICsg4NyCHRBnYqHu+FXJqA/a78cI4A2MdGxYWhhGzYL/LkAC9/D8vOgL6DXJE8uQ0Qnmlnm0bRzKH1WcA19ydlsYFfcf5zerabByVr/tsHnNpFaPAMKzHto451xp+GuZeNk1V3ZZjy1LZPGmjkawhHzmelb5coRqbkN2lNMcTbx9A4RNiJQ+NjSddFf5Yx4zHxJFv7o185JxMhzFtN8Ffku7jTrZCVSXNNlhVh9rJkqW6Rj2cZA4Stzdo14n8GKdsmOmn/RplVR
 3aBU5n8K
 dDHXxJvmUJ1B/JdbApvU+FpXTja7iNcwh+YesdJmQ0HZX93RSs9nW5LzfEozAATkVifS4PAt+pitYXjT5r5HWVLb1xasxjTlgoO695L1EuG6HWrt5bviAwrI7b24mN9jP6AGeQ81wTsxb6tGOSmek7EsOhYg4emVhOw9fBMlH4ku1h6kc2L9GHcKvFGTDZZL1UHyo4yd6wxUwGCi24is2EYRclJ/46hTjxZ58om2aulQKpBd2emDcvvrWod97iSPwO7kPwi2QobtL4Lc0LmPPoQEoHImz3Yf1XeYy/0c3ZWWaF6RX0AGV7vDKzYTyPrK3Mhbal/UKxxStEpemvP03mkIo89CAWhbQMtsIOameSQN3ZCOqJAPmdVuhTcICwrrXR7aKOoMu9Y7hYcumzNIicAH1DPbxX/GFwhp8obmIXOm3CkSEhouFFSpUfxVHNfsRn7vJBxHZn2cAYrgvClP4vGPLTkZAJ9mRoDxfdCYCAhpboF+HmbBpSEKHoCP2TdPdgsRuIuN5D0Zqbh7+YyQEnCOmnxhZ/GIU6ouuTypn9yZAQqr1KesiI2KQdjf51hqs4eXHrESn91rDj8NFVJXZSCvGGRcj0Y1w2jXSU5V/gZmLrablqLuB8VlZPOUp57Q62oIv1alM1dGtmeZCla3S/O7oLUe5CiHM/adkIrIzsaj1EewmGDm7bV5GPA6mMHUFT6EkW810+p1GALWJvMUpztNtNwFQjEIo6rZZBNe7PLaStH1enoeOiVRxqeXpY6B0cy4Pyx39CUv2S+RDpj0i+bjl85XA277lwqSBB//WuX/wykMRJ+ALfraV8/Hp575Vgdr4XQoIJZc2WbEcyBwG4gfWSIMO3yaDFlUg1hHICKy6rv8XNfy0yJC2MBMgT4wewifd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Bi=
ju Das
> Sent: 12 March 2026 17:47
> To: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>; Thomas Zimmerman=
n <tzimmermann@suse.de>
> Cc: boris.brezillon@collabora.com; loic.molinari@collabora.com; willy@inf=
radead.org;
> frank.binns@imgtec.com; matt.coster@imgtec.com; maarten.lankhorst@linux.i=
ntel.com; mripard@kernel.org;
> airlied@gmail.com; simona@ffwll.ch; linux-mm@kvack.org; dri-devel@lists.f=
reedesktop.org
> Subject: RE: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty sta=
tus in mmap
>=20
> Hi Tommaso,
>=20
> > -----Original Message-----
> > From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
> > Sent: 12 March 2026 17:37
> > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty
> > status in mmap
> >
> > Hi Thomas,
> > Thanks for your patch.
> >
> > I'm working on DSI support for RZ/G3E from this morning rebasing on
> > top of next-20260311 I'm seeing that weston hang on my side:
> >
> > Reverting this patch fix the issue.
> > (git revert 28e3918179aa)
> >
> > I'm wondering if anyone encountered this issue?
> > Thanks in advance.
>=20
>=20
> I am also seeing same issue on RZ/G3L with weston.

Just add I am using mesa with panfrost(Mali-G31) on RZ/G3L.

Disabling Mali-G31 renders weston desktop during boot.

Looks like this patch is creating some hang in panfrost driver
during weston launch.

Cheers,
Biju



>=20
> Cheers,
> Biju
>=20
>=20
>=20
> >
> > Kind Regards,
> > Tommaso
> >
> > On Fri, Feb 27, 2026 at 12:42:10PM +0100, Thomas Zimmermann wrote:
> > > Invoke folio_mark_accessed() in mmap page faults to add the folio to
> > > the memory manager's LRU list. Userspace invokes mmap to get the
> > > memory for software rendering. Compositors do the same when creating
> > > the final on-screen image, so keeping the pages in LRU makes sense.
> > > Avoids paging out graphics buffers when under memory pressure.
> > >
> > > In pfn_mkwrite, further invoke the folio_mark_dirty() to add the
> > > folio for writeback should the underlying file be paged out from syst=
em memory.
> > > This rarely happens in practice, yet it would corrupt the buffer cont=
ent.
> > >
> > > This has little effect on a system's hardware-accelerated rendering,
> > > which only mmaps for an initial setup of textures, meshes, shaders, e=
tc.
> > >
> > > v4:
> > > - test for VM_FAULT_NOPAGE before marking folio as accessed (Boris)
> > > - test page-array bounds in mkwrite handler (Boris)
> > > v3:
> > > - rewrite for VM_PFNMAP
> > > v2:
> > > - adapt to changes in drm_gem_shmem_try_mmap_pmd()
> > >
> > > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > > Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> > > ---
> > >  drivers/gpu/drm/drm_gem_shmem_helper.c | 22 ++++++++++++++++++++++
> > >  1 file changed, 22 insertions(+)
> > >
> > > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > index cefa50eaf7a4..1ab2bbd3860c 100644
> > > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_f=
ault *vmf)
> > >  	if (ret !=3D VM_FAULT_NOPAGE)
> > >  		ret =3D vmf_insert_pfn(vma, vmf->address, pfn);
> > >
> > > +	if (ret =3D=3D VM_FAULT_NOPAGE)
> > > +		folio_mark_accessed(folio);
> > > +
> > >  out:
> > >  	dma_resv_unlock(obj->resv);
> > >
> > > @@ -638,10 +641,29 @@ static void drm_gem_shmem_vm_close(struct vm_ar=
ea_struct *vma)
> > >  	drm_gem_vm_close(vma);
> > >  }
> > >
> > > +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf) {
> > > +	struct vm_area_struct *vma =3D vmf->vma;
> > > +	struct drm_gem_object *obj =3D vma->vm_private_data;
> > > +	struct drm_gem_shmem_object *shmem =3D to_drm_gem_shmem_obj(obj);
> > > +	loff_t num_pages =3D obj->size >> PAGE_SHIFT;
> > > +	pgoff_t page_offset =3D vmf->pgoff - vma->vm_pgoff; /* page offset
> > > +within VMA */
> > > +
> > > +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >=3D num_pag=
es))
> > > +		return VM_FAULT_SIGBUS;
> > > +
> > > +	file_update_time(vma->vm_file);
> > > +
> > > +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  const struct vm_operations_struct drm_gem_shmem_vm_ops =3D {
> > >  	.fault =3D drm_gem_shmem_fault,
> > >  	.open =3D drm_gem_shmem_vm_open,
> > >  	.close =3D drm_gem_shmem_vm_close,
> > > +	.pfn_mkwrite =3D drm_gem_shmem_pfn_mkwrite,
> > >  };
> > >  EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
> > >
> > > --
> > > 2.52.0
> > >

