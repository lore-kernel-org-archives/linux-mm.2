Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 271D61090233
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BF36B04D3; Thu, 19 Mar 2026 10:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D726B04D4; Thu, 19 Mar 2026 10:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714456B04D5; Thu, 19 Mar 2026 10:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4606B04D3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:17:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C0901B848D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:17:41 +0000 (UTC)
X-FDA: 84563015922.08.11862E4
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011044.outbound.protection.outlook.com [40.107.74.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 069C31C000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:17:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=wwWM3lsm;
	dmarc=pass (policy=none) header.from=renesas.com;
	spf=pass (imf21.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.44 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773929858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gw9qR3b5esJ554TQ+4PO3EuHLctK5EsgNWXliyMRLog=;
	b=SXMeuFMUTVTegmU0Bvai6OVR7m92ibQvnsNjoSRCESwRXjXs07rSuZLiN1i9NuVoJnn6f/
	8GOJbjPFuxuhM5gwRZ0BZeRFbX8VXAZ4dlFythTjrMqZcZMR5Mny08rWkZvjs205PlbdtN
	HQOMfUMfN1jinz6mQoOa288GjCZk1JM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773929858; a=rsa-sha256;
	cv=pass;
	b=lGe2NWc/i6FG55t+MN9ASSqsKQfRQdNRKYUm+2JuYbz/biSNA8XtrOUyaJVuqsVQDNgdZy
	Boo49jEcAnU6zMwQwv1xYyqpS66tGoFDnI5M2A+NMXOrIK/YVe3rLitk5HDhnxQ2QSnY5X
	51N0+yU6FE3AD9+tDgiv2ba0HhNcT/E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=wwWM3lsm;
	dmarc=pass (policy=none) header.from=renesas.com;
	spf=pass (imf21.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.44 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=utM8BVB8kTWKC/071mW1Nm01lJ+JqOB3bzB7I15ImFkmdz1EcSmXTeBByhJVgldOAJq4Jw5UP4KFvKT5nLvCgm9aFNsVLDEYICUiLEFkW71tV+Fl0Y89OPctHaTGxueTfPbRHG7UORZtP7gveRBbN4h3i3TWEPEQDYD2GUZu5zwSeQCbhHH1ZMgidpAoi+jOVehXdzKNNWL+tYPKyeM0qZkSPTbSYktPWHSjo+55AGwbNLz2LRhe9R1nzIY5iiwhgkOxqLvAkWPEby7ZUUMfAj+uWLYvrPg/u8yvJ3Y8yfwBq3o6E2Tb6pjtVq6TAMhVGajvbvnXtrH9KMGZYro9mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gw9qR3b5esJ554TQ+4PO3EuHLctK5EsgNWXliyMRLog=;
 b=hGHcc1f3Sj3yOhnp5dyM9v8jeY45pfHD4OU8lXiHHFLC5ky+ftxUh6BWtc6NFCNPydsMvAUf8FcV7iWQ7QFhilP+1HTIAnRcZoDCUxiqqzasNVlfhppzz7zsnqafDQnqrCrjOSgghkl8LEkgJj4aa+UljttfLqeaT1zHL/7NojO4LrN3Rx6L6DkCoo7A/gnhZJJ+dZlRrUUeI/wI3gIbWjezqlERZN8DefQ++2mzcgP9LlhlHKT0x+s22Et1Ho0GKNqV4DFqKM0uSv3pA7ZRnr9mJIKkT2FtcMBJyH1Ky3U89U66DVlinFsi8VKtS57XKoMPWi6AmHYyXw7npwBTBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gw9qR3b5esJ554TQ+4PO3EuHLctK5EsgNWXliyMRLog=;
 b=wwWM3lsmPyB2GBcTQudkXRNY3ZII1mDoMdPSblbUNYnjgI4nf/H3W8lVwqm2eT1Xj0aLlU3Q86cGcuwuekGIF+dd7XplrJ51gWx1rdisDL6+3i3wYYSWEqvsmkOQeMQDIpPYg/1quxmqIE2sSJvTaWs7JcbXXw2CBUQXE5dfc00=
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com (2603:1096:400:3d0::7)
 by TYRPR01MB13865.jpnprd01.prod.outlook.com (2603:1096:405:215::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 14:17:31 +0000
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de]) by TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de%4]) with mapi id 15.20.9723.019; Thu, 19 Mar 2026
 14:17:31 +0000
From: Biju Das <biju.das.jz@bp.renesas.com>
To: Boris Brezillon <boris.brezillon@collabora.com>
CC: Thomas Zimmermann <tzimmermann@suse.de>, Tommaso Merciai
	<tommaso.merciai.xr@bp.renesas.com>, "loic.molinari@collabora.com"
	<loic.molinari@collabora.com>, "willy@infradead.org" <willy@infradead.org>,
	"frank.binns@imgtec.com" <frank.binns@imgtec.com>, "matt.coster@imgtec.com"
	<matt.coster@imgtec.com>, "maarten.lankhorst@linux.intel.com"
	<maarten.lankhorst@linux.intel.com>, "mripard@kernel.org"
	<mripard@kernel.org>, "airlied@gmail.com" <airlied@gmail.com>,
	"simona@ffwll.ch" <simona@ffwll.ch>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>
Subject: RE: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Thread-Topic: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Thread-Index:
 AQHcp96eSUoAacjqcU2c+U96UWFVr7WrPdqAgAAB0YCAANfgAIAAPkuAgAADDoCAABhLAIAAAcHAgAAEWoCAAAbzAIAAA1KAgABRKICAAQkrQIAIKkpg
Date: Thu, 19 Mar 2026 14:17:31 +0000
Message-ID:
 <TY3PR01MB11346CEBB1B1A5FCB69D247EB864FA@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de> <abL5rcYIaFFO3GW2@tom-desktop>
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <20260313111851.4c1f89f3@fedora>
 <f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
 <20260313125644.65131b27@fedora>
 <TY3PR01MB1134662A395AA0A048CEE152E8645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <20260313131835.52c5c935@fedora> <20260313134328.3166c4d0@fedora>
 <20260313135521.07823792@fedora> <20260313184549.08656eed@fedora>
 <TY3PR01MB11346AEACA195A53E54101A4D8642A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
In-Reply-To:
 <TY3PR01MB11346AEACA195A53E54101A4D8642A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11346:EE_|TYRPR01MB13865:EE_
x-ms-office365-filtering-correlation-id: 78442970-9b43-4900-0ca2-08de85c2421a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 HSVYHOmvXxNNxYPHM3QS/nxHxWqaEEJ6j51yKce+r+zyUL+PNRu5KMXgc1XJzWWJP4s80nTseoNWOYoq47aHDzbifClFPC8ziv6uwe1XMLibu2f3tn/zVQnZ8Wyw+v1VksnlunBiPrw0049MJPoXNB8KmBGrNKHDJ+BhyXB3NmXV+YDI42KSJQLxg4ytypa2BQNqqKei9uDhMcOJJG9XEFabNnV6DQCz9faBDrBHZ02DmjrqvMwYqU6cD53ZAlGVVstXTEuwvdc0RT4LboUBULd0o0A9PVVtyFVVnGcz2DN8tCbTXSXFPFf0yTjYQPczr+Aco7/k57xQF3X0n+TX87Fuw4D6tdVA+rTE3IzI6B5PFQgMmn0ovB16n7Ra0uS+0GKsmaHQz1OVVsfu6UMnnyrniDm+h5e0lVpTu9s/EkAZJ9B1E05Y6FkJIiR/cV55dz3Rih9VV1u+BRM2tQVMHZUHfO+KsGSpbMXsCYsQWrZlBX4yWegROJCDhFVKWPWdZ9cu2nPRxRafjq3CJXkwwvmoPUo0dUdYS5BxnWQIyqJb/Gge5So1WIpi0E/uy3A5cOFCnvDe84tubbZhA7CZR8UUe7Sm3Bcp2skbA+rTrByCitG9BL2q6UTo2aDD86iQJ4iTdm87v3yCaHuJXAQZgI8Tyuk6J8mQU51nHi+zJeYq/i8FCkRLiOvqmQKpOxNJV8BIXpx9xA0xhw/b0sLYFIGVGnU8G8u2qrOXhRmZ1q04ThjCzDXagkWXVefgvaTL
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11346.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?u7OoRHjF+C9uzjueC+W8oFrHNaOrf2jhSp4JXAK+jG0XV+0HSIgWGUvmtgaS?=
 =?us-ascii?Q?J6QhePyUzE7lUbKnBNOMMRpwWQ04o9Ig7sHO2sC25hi7xzp2BrHspT9wQTn3?=
 =?us-ascii?Q?8HHb56BBmP9CT63qG/76i/++UTNKGWipeZg5495mxuc7SBXhMNbD74dwh97L?=
 =?us-ascii?Q?1o8mWjjblJEIrtlVtrj+MDQCBEh19q6F2CDjD1uEi54/sX7ryaF7j5a/abUj?=
 =?us-ascii?Q?jk3Q2W6aP+Yitzeao3ygJlVN2pLkiT3rucPGTdgN8KlSA3og6xVcr39XpKjz?=
 =?us-ascii?Q?hNmC8miUX9pJjv8ctmdcxpfPbQoH3h5t9mHVi1qqgJsES2+EIsSBYYYRSYli?=
 =?us-ascii?Q?aEaW4jx3FBOxR/Fyl+JmRuC04b9SvXv7n99G1IGO8kiQHzqKKDWR6mEA5wcN?=
 =?us-ascii?Q?N+/KsIrPY0j6x/YdF9qedwLMRCMqyIoRs4O5sxxW31zvpkcBxdh2XwoNxKUP?=
 =?us-ascii?Q?utXpO+KOjcpEOrjRR7d1JVEOOGS0DcBS/y433I8vafjIFtpolbnLGH3V3X/x?=
 =?us-ascii?Q?YScRbeP18nwp9OaWDupHYdBsPsgk9NXtKzfwJy8W8sfe4cV9TFWdVZ/ZvWLr?=
 =?us-ascii?Q?RVyabRKdHhCu9ACWNFBtxs4VHZ3/UvDW6wWYcKQ3ytvusx+t52sX61y5ap3U?=
 =?us-ascii?Q?PA1zeZTuHy+wi9YnA+xXuhtoiyPO4OwQounVMvAmAg/jY8GnDaCvzmsHUDzP?=
 =?us-ascii?Q?rh7SLJwEoYrRcusw8POAy9Uq9kiHz5Vfu4bLHI48bHc4KzwL4pmioUBGe9Bu?=
 =?us-ascii?Q?XDyZve6iwJyZM3cBKPh8s1s5yYMFmyjUIP1248l1sgi5saO/jyOvtGdD5TEY?=
 =?us-ascii?Q?89p2GH232y0Qu7IGFp1XOFO08RRB0YD3vxyNmBB1Ek8VY1HEdxTWbZeL5Fls?=
 =?us-ascii?Q?O9QNzbAd2bHOA6Dm5KynTICbok97G9UoNXr4eTJ7dPBTDZs21rOiGJoWWnNr?=
 =?us-ascii?Q?vOBCKL5mjVrjEeGYVuraSetOkW6KopZe6cF3vyB0Adx9Kvf5Jk4ME9m6tMbB?=
 =?us-ascii?Q?/A4n7hobs7Ftz9dYpF0njI7pW3MrfqoyHjTXtpPDYl+YdfmvfnzAYG8ZO/k9?=
 =?us-ascii?Q?+P2NOVw206E6wWMvm4pWiUQ2gR1/3w/zP3jSVec47/i1YnBDTZvSyWNWVlAM?=
 =?us-ascii?Q?w/M2prbKf2xmmZ9PAEbq8BEJPA2MJA7fpcpwnbnBH7pX89oE5fXqhisXdxrG?=
 =?us-ascii?Q?lMk5C7Okrpvmqv5D2++XrLsejgYbOmdSHNzgGJtMJhzzSXMxUVsR6OopO/yx?=
 =?us-ascii?Q?va6Ws8lp4lph3/lcwjZmAnCFA+DJnN+h8TqeU/INua1HQFxmPGJcVvW8bLGI?=
 =?us-ascii?Q?VYbF+r6rduda32dnldSSsRpiLQrQLOBcIHTJ++zwlxtNT1+/lFXoKkBwMw/4?=
 =?us-ascii?Q?4MkUbFaL5yP2WoNIlvnlaU5WVuQ2EQHb1bxgpWIwHI0W0NZMAFgwFpxl34q6?=
 =?us-ascii?Q?YkiV4+mhJ1VgaaOXocWWA5lpfoeeI/6/RsJdP+OisqZvjn8ergZNpQZ0W2kw?=
 =?us-ascii?Q?YUZbGxNoiy49y+yZ6VMZzK3+Ju6MrxAn8QNtlM0dxOPXpUhbMwWJZMhVC2oA?=
 =?us-ascii?Q?VhYuRYufOmgMeUl5/s+2ARX0T76peVYnKBUjsG5mKB2rDAAv+9eveulkP4E9?=
 =?us-ascii?Q?1Bhii5sY4RRCQlqBFQIFPaZssdLNHg4+YbDNoL/HKXaTcLz05U53q7hh7VU9?=
 =?us-ascii?Q?eBq9wYkSsj/bIGB3aJ7ifASkHmpOkFHRf+Aw+XMR2e6pcf9jmPZZYd8ucQWy?=
 =?us-ascii?Q?edk1lZnXNQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11346.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78442970-9b43-4900-0ca2-08de85c2421a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2026 14:17:31.1944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2HJIR86Q2W0qxGMT+OQqLM/VMGTiOOrH3x8XDi0xOZwuQQn+loe3BDQx1ZSg53FuZDxlbnlVoF4GO5X+Zh1/t2A/NgQQW+pmTKqi7vqGieI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB13865
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 069C31C000A
X-Stat-Signature: 9ha7wcef9t8angkpiu1d4kc4cxum76ty
X-Rspam-User: 
X-HE-Tag: 1773929856-531748
X-HE-Meta: U2FsdGVkX18LJ9yiHOW6wTZNaKT5Hd6t4ekFz3rApCM/tfVUC0ZZlHz4b9PPYX26Y6+AFzHeV02P2m9NhDMzj+y2qwO9/+ew7TLeMrhwdsRT5uG8/oXmaGZ/ETjOKAGiigjG5MgyBnl4mcBXdexNozg6oiJGYbj0uQqvn4sq7hU96wjQ1rOTlc7YsCH94C39+vEf1yGV8QOvGzpPi4mKciffANGf0WMApx02uK4zmGHPiADPhclcBrffkjTbirapuS6I1B3rsEkrFN0gmxo/G8IPJnDfMVwQqOlC9rwFQbnn3WTbv5np4z7Hvm9TjOpT9rouAWA+CRXKOfV56gzaQRlNZP/FQ52+7nbdqWc2ty3h4jZTfp3QAzQWM7yqa5Zk/Fra0kdLDJT6Cs3pLaNQW8FEebPvVRBMrTUk+1V5jIYhO3YCF1i1k7+AyopTmWXtMvdPfb8S0ynWKqqKr0aoYh2OTXW5J+unpXB4tRgUzMws+ksjjN69EJH5bmZq0UcCvX52nJ5c6GM2tsAspPmuaEMAgcR7Mge8VEdoLl+nwZLt/Lt7MXYK5zcNm347Th/hVLN6vcdwIW7CjMsLdeV8ofZds6HwI3m4XJK2Xgzw0YH8l9/wHa79qPWhoPzvw1DwEIiyUGGE/ZYVcLD0WDVCJZyfimI7K+ji4eKLUugYBUDld+n85QDoDqoQZ8mU7cpcst54wQPqBznvNbSH0pnavAMXpgGwcgB+syNCXnRrw2J6f1W1DBbkDA46ch//ISxhc6KOJb7rc0HgI+EvrFH9ZmparMzXlCiiZ7mb+l4dAK0yMU6T/SWB+ht96mEy7Gif2pMuZR64bE3dDGNCYVyE4LC9yKx8MPrJIXuHmLTuMxGSFjBlFgNAGUBJ8jJGjJqjnC5sNKtPo1fOlJej4e6peZauj7jpVXgapvNLP3nwuGT1G+r8Kf6SkK81+9g5AuLcmwRABCGyKEru0GtupMj
 TGLW9TVV
 o39c1MnsWIcRxHefZWdqd6PtJHw4meOzhG6JihTkz16l98VwPCPKD10Oo/ew1Sq8MZWFswSp9LzhmF3vSKEbhdKp0bPBZGZ6g7H64GGwozOoojjEnZlVlH1fvdYR7pl/Tb7TnkbwzmAH/9moeAS6NHm1KMlipdZo+uwjSR24fFUzT/gIcvcn7bodQYktqi57cJoYV/eU2RdriM4rv9U5z/2uUQNTjobn53sze6hiPCsGtMxEYtvvSCMH/bNpz4bI0x+8UTOPRAVDkTRNcPuGvnBaFgJUmUR4rlxEjW2zhbsz3z11QnoKsKC8ypOgkwFAiuX5JYr/Uj9Hz4hDcVA4X86IPgD3oX/nBmh+gQy6Z5i24vIAuHo6EK91Gl4LrWgkCoO9/C/xEcqEjfuALoFU0Pi5oKPaKynKYCxTPiXjgXCxlbSEF2DrfuBy/imJf+61ls+zpQALFHbMKM4gyMJfqz9j8SgNTt8Urby9SsPOofUqlmT4NSD+iTfkTa35FED9zw57wGtikeNsDm5wwpIH3pISKFD+svX1mWSw3G9M+oB4VkQ1jUEaaZhCFPkeipWJHV44zjkSmilYR6ppVV1XIS+vchgFLhDYSQpNZHa9SWZ7OkGr/SPfP5gnOR/rH5VmllMc4XGZWvRzeU0TErXSekecvMy9GiVDnmVEp97kHziZGkHfyKsfq5XWcohvamJzzTPbs+kPWWwlype5YwzQV7FErzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

> -----Original Message-----
> From: Biju Das
> Sent: 14 March 2026 09:43
> Subject: RE: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty sta=
tus in mmap
>=20
> Hi Boris Brezillon,
>=20
> > -----Original Message-----
> > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of
> > Boris Brezillon
> > Sent: 13 March 2026 17:46
> > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty
> > status in mmap
> >
> > On Fri, 13 Mar 2026 13:55:21 +0100
> > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> >
> > > On Fri, 13 Mar 2026 13:43:28 +0100
> > > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> > >
> > > > On Fri, 13 Mar 2026 13:18:35 +0100 Boris Brezillon
> > > > <boris.brezillon@collabora.com> wrote:
> > > >
> > > > > On Fri, 13 Mar 2026 12:04:25 +0000 Biju Das
> > > > > <biju.das.jz@bp.renesas.com> wrote:
> > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On
> > > > > > > Behalf Of Boris Brezillon
> > > > > > > Sent: 13 March 2026 11:57
> > > > > > > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio
> > > > > > > accessed/dirty status in mmap
> > > > > > >
> > > > > > > On Fri, 13 Mar 2026 11:29:47 +0100 Thomas Zimmermann
> > > > > > > <tzimmermann@suse.de> wrote:
> > > > > > >
> > > > > > > > Hi
> > > > > > > >
> > > > > > > > Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> > > > > > > > [...]
> > > > > > > > >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_off=
set >=3D num_pages))
> > > > > > > > >>>>> +		return VM_FAULT_SIGBUS;
> > > > > > > > >>>>> +
> > > > > > > > >>>>> +	file_update_time(vma->vm_file);
> > > > > > > > >>>>> +
> > > > > > > > >>>>> +
> > > > > > > > >>>>> +folio_mark_dirty(page_folio(shmem->pages[page_offse
> > > > > > > > >>>>> +t]));
> > > > > > > > > Do we need a folio_mark_dirty_lock() here?
> > > > > > > >
> > > > > > > > There is a helper for that with some documentation. [1]
> > > > > > >
> > > > > > > This [1] seems to solve the problem for me. Still unsure
> > > > > > > about the folio_mark_dirty_lock vs folio_mark_dirty though.
> > > > > > >
> > > > > > > [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-
> > > > > > > pedrodemargomes@gmail.com/
> > > > > >
> > > > > > FYI, I used folio_mark_dirty_lock() still it does not solve the=
 issue with weston hang.
> > > > >
> > > > > The patch I pointed to has nothing to do with
> > > > > folio_mark_dirty_lock(), It's a bug caused by huge page mapping c=
hanges.
> > > >
> > > > Scratch that. I had a bunch of other changes on top, and it hangs
> > > > again now that I dropped those.
> > >
> > > Seems like it's the combination of huge pages and mkwrite that's
> > > causing issues, if I disable huge pages, it doesn't hang...
> >
> > I managed to have it working with the following diff. I still need to
> > check why the "map-RO-split+RW- on-demand" approach doesn't work
> > (races between huge_fault and pfn_mkwrite?), but I think it's okay to
> > map the real thing writable on the first attempt anyway (we're not
> > trying to do CoW here, since we're always pointing to the same page,
> > it's just the permissions that change). Note that there's still the
> > race fixed by
> > https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargom
> > es@gmail.com/ in this diff, I just tried to keep the diffstat minimal.
>=20
> I confirm with this diff, weston is now coming up on RZ/V2L SMARC EVK.
>=20
> I am just using drm-misc-next + this diff + arm64 defconfig + Poky (Yocto=
 Project Reference Distro)
> 5.0.11 + Mesa
>=20
> Cheers,
> Biju
>=20
> >
> > --->8---
> > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > index 4500deef4127..4efdce5a60f0 100644
> > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > @@ -561,9 +561,8 @@ static vm_fault_t drm_gem_shmem_try_insert_pfn_pmd(=
struct vm_fault *vmf, unsigne
> >         bool aligned =3D (vmf->address & ~PMD_MASK) =3D=3D (paddr &
> > ~PMD_MASK);
> >
> >         if (aligned && pmd_none(*vmf->pmd)) {
> > -               /* Read-only mapping; split upon write fault */
> >                 pfn &=3D PMD_MASK >> PAGE_SHIFT;
> > -               return vmf_insert_pfn_pmd(vmf, pfn, false);
> > +               return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags &
> > + FAULT_FLAG_WRITE);
> >         }
> >  #endif
> >
> > @@ -597,8 +596,12 @@ static vm_fault_t drm_gem_shmem_fault(struct
> > vm_fault *vmf)
> >
> >         pfn =3D page_to_pfn(page);
> >
> > -       if (folio_test_pmd_mappable(folio))
> > +       if (folio_test_pmd_mappable(folio)) {
> >                 ret =3D drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
> > +               if (ret =3D=3D VM_FAULT_NOPAGE && vmf->flags & FAULT_FL=
AG_WRITE)
> > +                       folio_mark_dirty(folio);
> > +       }
> > +
> >         if (ret !=3D VM_FAULT_NOPAGE)
> >                 ret =3D vmf_insert_pfn(vma, vmf->address, pfn);
> >

Any patch available to fix the weston issue? Still the issue is present wit=
h drm-misc-next
Please let me know.

Cheers,
Biju

