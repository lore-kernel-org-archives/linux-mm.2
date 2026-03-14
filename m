Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6135A106FD9E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2036B0088; Sat, 14 Mar 2026 05:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989256B0089; Sat, 14 Mar 2026 05:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833756B008A; Sat, 14 Mar 2026 05:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8946B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:42:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E63F81608E8
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:42:57 +0000 (UTC)
X-FDA: 84544179594.05.E0BB1C5
Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010002.outbound.protection.outlook.com [52.101.229.2])
	by imf29.hostedemail.com (Postfix) with ESMTP id EF4E4120003
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:42:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b="mxh/GQzD";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=renesas.com;
	spf=pass (imf29.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 52.101.229.2 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773481375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UMD/c/eVhpVbdpBCGmZK2kh0f563ZLHrld53Gal/lU=;
	b=1kSXG4OhnAn2LWNUwRkbFajh+17yu5HTxcnzYtYR9xXPIybph6BibB0JtW+1dm845unnDl
	xKGS7urXzweKGkwMeTSF3dhE9mCkA/ZWmlCk+LRJ303JnJDJT1JEd3Ed4VuuNEILbm9L2i
	LwHyZwferKcbZWLH2rYNPlt6qKL+IsM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b="mxh/GQzD";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=renesas.com;
	spf=pass (imf29.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 52.101.229.2 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773481375; a=rsa-sha256;
	cv=pass;
	b=wtQvalTmnUFj/1WrodgWUltH+MZkiWayGGgWtsgxx3UTEpbNkn5+f7Rc0ecEcd4a87GP/t
	8cHEyn+Ir4jfjTrh1gqHPBxuwjUGOvnVhqyFPVLQabjbIcTquHCaABZm56I3zRpBhpnEX8
	J3Dxn3179tNYoEnkvfLQP34ASkEWiyg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AxxOzWOwOc7gpx6TQxU7PQEO2bLbmrIryBGEL2oTGZLQ6rZ+VXgE3sgcBvvx9gaTnxyzkEIsyGPbAw74WGIVwqrvcBC1cQv1xydX3l5rjUuwTXaOZ/d92T0UAsonUXGNTsgs6tbU5RBLzdj5fG/l8J77abi2f5jNpXlBLB9P0rf672rj/pO3KhErdMtmXdxtBGKg+N7VB536Lrn/zsY6oiB59Zty2821fcxmooG7kOhv0rWeW+27RBspUtub/MHc7P62JBk5JFvKqQibl4af2keiLYPgc0grCxCnavLUV9a/OBYDEP7pEFdgUnrs+rFljncG88RUExDz/Brsv6hpnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UMD/c/eVhpVbdpBCGmZK2kh0f563ZLHrld53Gal/lU=;
 b=Gt5LxsVjqJyki8UHRPGWGqUktka29U2v7c8BEUbQJBsXHHP1hcnRZVNLHvrbd+9Va9W0qWHU+BTuIk0NTKvEBBWq5z1F4SHzrwuBxmuV+pA9HQjBBrifJ97Fa/M29Q3/C5l5psn5kyy9WqBkxwQ5wCJtMg+lfxg9iyqK6WUUDFuOHXilNLOLnwSw/seqRRbNFPbF/bMDOhxsd/3nYVgk44VKR/sybxUXEPrMubzA1EaqXhPOmksuLbenc8Qh8A+TpGQac6sxAgaDGylmxypdmKyYs+CKg9NrdHtTfU9IHM/AiF8CvUpT3yIXKQ15eSg0QACL2qobVMMeMIcxbgt2zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UMD/c/eVhpVbdpBCGmZK2kh0f563ZLHrld53Gal/lU=;
 b=mxh/GQzDSbhX0KcN5sN/kyyvpcLFGBrj/0r0fk0yIyZPRTUSbFFwl+wgL4SA5cQeg1OMj7HxmzStIZ0DsWnlyAJUxU8ju42mlXBGT2jN0j8fh8gVHvKF+lIBJHbgJnxlDdrwu/rLWzmtT1FFaRuKqp+Al4UsFdEpn3w2UM1/BFQ=
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com (2603:1096:400:3d0::7)
 by OS7PR01MB14747.jpnprd01.prod.outlook.com (2603:1096:604:394::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.19; Sat, 14 Mar
 2026 09:42:36 +0000
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de]) by TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de%4]) with mapi id 15.20.9700.018; Sat, 14 Mar 2026
 09:42:38 +0000
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
 AQHcp96eSUoAacjqcU2c+U96UWFVr7WrPdqAgAAB0YCAANfgAIAAPkuAgAADDoCAABhLAIAAAcHAgAAEWoCAAAbzAIAAA1KAgABRKICAAQkrQA==
Date: Sat, 14 Mar 2026 09:42:38 +0000
Message-ID:
 <TY3PR01MB11346AEACA195A53E54101A4D8642A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
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
In-Reply-To: <20260313184549.08656eed@fedora>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11346:EE_|OS7PR01MB14747:EE_
x-ms-office365-filtering-correlation-id: 9d79b5e6-b79e-4fdd-04a0-08de81ae07de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|13003099007|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info:
 H/WDU3dFUcXRlNRnj57lJzg9pV7MUgo7t0BL8LRxUGuMTRiiAat+tmvneIcARwQVAfwy6+wZhGExkUXPldaweQ2/LR45XbA1hH0aRPf18+0BfZWpfD9xj1guByBGb+QuoKSSar4vKwvJqGBmZ/wlRGA3UMY06Z9uHNNMsgHbNusTzguAs9uUCiBdtvV3kJYoM639C1oNM+jFpKN7rYQQfQZ/1S1jK3GqhENr6iOcVT893Ru7tP/5p2uWNstUO1GqBADCW1cdQLVr9VvyLRj1W5Wb7eNHY1xU9gnV4gJnMZ9jEsVMMEErYMaBMkU7551Q4qvyRUOm6nCZnzUwoqju+YSAMHueD6YWZITgZBSTdb59tuaIJBct8Nxhub5BEeTXYo9WhqQY9UaR3Gh75xpaMMpaDxj1rdH5ifSJYhkgtNIkKUP7r7K9lUUC4ltC8ZP2UY7aCR5pd7cDSMRGFwEtN+4I/IXaDT414UiJYlIoZg7mbLhei1AS6ki1CvGxAn4tCZ/GLDMF+OqfhuPsAnLiIkeOncFDgMGc0g4sBgV7QkyRd5oSpybDat7wwuCUg5MGw0lMkRUHSG6TLphyt2IOI41w2J181SC/yOIpbNf14ELAdNlPFzhetKE9fNmQ5aXTm69M/VIs+/h1wKyWpEAdFd0I/ok1WXIKwE8Xek1I65MwIAb5Wo6HttnUJDFXbCS/QYHkO87TP/gLaGm3v33Nb7YduHLKDiMaBU2iqlOrHrW6JVc1zzG1P0FsIFc9xfnd
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11346.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(13003099007)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0M2n2cnf6nw3Fs5yVjsBG/0jU3wKsfWJ1toIOVC6F8od+MC9fDXhSH7g872Z?=
 =?us-ascii?Q?uRwgrPxXhZCOtukJsQV8IQozK6MzlRrOnABKlpXwdSJ01yjapQt/EBWYmH9F?=
 =?us-ascii?Q?Qtjxdigsc0qUvUmPaaufBNsbeCLc87CWTkSINf1VIIIH8c7wcDXnbzZtbdGw?=
 =?us-ascii?Q?lf8Efr9F/XhsVrSzEJJikKON1ATKj+shmcNxRu63MnkZx/5Cj2Hxg0QiL8+Z?=
 =?us-ascii?Q?sO+rlXE4sFFbEglU6gW80BlEwsfQmnY5w7m/+TofSHO7uu8m0YBu0bCW8IZQ?=
 =?us-ascii?Q?xA8sIz7T/0BYu0vGCFydjysMxxFf0UQH9z3xugWUfN+wmm6sW/vZF+jehbil?=
 =?us-ascii?Q?cqSrMfvIMcu/qUfJYL6ydxFlBCf2765JwPdAGt2qjVnNTASd8vZMEBnoO9J8?=
 =?us-ascii?Q?y++iruGVG5h68JikGSopabjtdim6FGjamsYa4atzfSdsjvEbcmLi4HEK3zNy?=
 =?us-ascii?Q?iLg3mfQSwn4DHnnYFN+c303xztPL+GT47klLeAUZUkGACj0qEI7iUry8o8Mm?=
 =?us-ascii?Q?yS34W0eDaIs1R2M1awmlHEQf+2jn1MDX9asA4xcIErFc6ihfk88g3b5xgegd?=
 =?us-ascii?Q?54DTA6YrAM6TdPetKKXrdj21O4vg3NcOrhMU8hnMTM6jz5pHa0OUI3vmxLgu?=
 =?us-ascii?Q?P6DqJnfP/YYKICFO8LjdP5U/kTdZVe5P9Q2FuelLdP9TQvWoJdwbq3dChB3x?=
 =?us-ascii?Q?VnlOx2QjzsyTBTVQ1PYU8LBEW+h9LYUmjHzZfkozDHK0zwuWcuyFQ2Y3LQt1?=
 =?us-ascii?Q?YRAeicgVJ7TnoQIMorgd74O5kwwg2eGnO2fuF8wwxdNihN2U29jLYPaW9Qw5?=
 =?us-ascii?Q?x15dZaEOlk6SK4Cxr1TuOYfMAw2yuXEAG0TbYSPuEQo/mUYRr5ezI2MTgNI2?=
 =?us-ascii?Q?zmxP3KGYHJftht7M1z7OdlHsyHAqD0MACgeyC29I5f5VujvQWtj2PXmVUk8G?=
 =?us-ascii?Q?ntex+v7wDwk22EhFGtDqgUiAA6BOX0zhkvYUyISXqa9hdVqxYg3Qh0PI/yr1?=
 =?us-ascii?Q?rL16fKhPTMDrwyc1BufY03hx9WwaQsW+aqLPF45ksVft2MZU4n1wpOq3uO6f?=
 =?us-ascii?Q?p8fcbTWYmT2mAQ8kOT+Tryhn5MrqbM7hBP79Cwq1IqOfRbRkqkSBNZCkI55x?=
 =?us-ascii?Q?6OzJ1xE0hDGmWkf564g2GX9rYLyL/tN3WSgFUtHxVhk4jVuWi/VbrAGYRP9x?=
 =?us-ascii?Q?RhqsyXneueAcZ+5X4+E83Km76V1X9FWYkluOAicWMvo3KXokQXLjLwZMRviC?=
 =?us-ascii?Q?volSs6oib441KNnR36e9cExKbo5sd6mo3j4Z0MPLKVk4Jq/9GSf6mU4n2kjU?=
 =?us-ascii?Q?g7cSgWKgH9PfgiphSsRx2ouk/oflAI5cGNFFu4Cd40r3mSIVY33lRUcDQIW0?=
 =?us-ascii?Q?KSbG7GhRzltSvoYZCbxYippFFKiul3YNiiMNQROdRz7F3Y3VayK8r7nVmW8I?=
 =?us-ascii?Q?T7WzxSa8WJB6AvjhvIZqdhlHtiOdHNjJ+MEpMwhuYRhjJR2STX1rgA73Am12?=
 =?us-ascii?Q?h0A68onaTVbudVTsCTbxDfHuBOWq0hjWhCXsVU82Roaobz4dvz9mK1C+ddUW?=
 =?us-ascii?Q?FMY1xppeZGki/dsKGP+Cn6D1Mn0xxY02rlmrQ3N2dqOvhCPw+MYDjTE0NtkE?=
 =?us-ascii?Q?MwfdJrQ1tjBtmC1C126FJgCqNgayuZSJJ/Y+0BrqXLPFBOu63vNpWtVj/kK8?=
 =?us-ascii?Q?lNlEu9T8hjx8lDeF0TuGEU+Co0oyFLCJvbBiKpwcbqa+mximArtUZtJLdeU0?=
 =?us-ascii?Q?rY649C8a+g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11346.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d79b5e6-b79e-4fdd-04a0-08de81ae07de
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2026 09:42:38.8936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZdJj9CAk5AO5JSmK8Phc7y/fyByYU9ozs2PE1obhk1qpTBxIxfo05EuJjjhwQTfH4cPp9KN2atiBedyyMx1YKWbOD/9OEQZOcGCoYvyQcBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB14747
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF4E4120003
X-Stat-Signature: z5o51qnnx18ctidpw1bbmhs1gppn1nao
X-Rspam-User: 
X-HE-Tag: 1773481373-846316
X-HE-Meta: U2FsdGVkX1+h6n6pHSBRZp1WdGVsfZn+EalmiUWltoU7d+mw9o60cnOSjbN69DRYKV3EGO2a5IlWBWI7TRW2MX0Zc3vYwxjv91jM/yGkpebGNICV9AM8Gp7fl3xOQ+L6YfCdGcss4GpxiO/HivSmxZi7T5evEzxH1Q6fCXcKq6n9kOqEMdVNEQGV/g0MkxP/Koe1XeoR6b89nYlsR99ZDG3zku1ztSc1vJ7AmgcZK4xGNL+QFW5h2OS8bne6DeGJLts0CrVwcRzJorztuO2MtPIdjZ2/SUH6/ttPWj0WaEfA8UxnFfofwmKs59b5+vIVAkzJkz3YXZuxUEgX4GnwrqkpHTkp/3qQkFSwGvbtenUOlnXDu43DMxAJD94obPI01neyor8UEVDNPaPc/Sy4ozxznfTKbV3hL3s+q6K4Cd+TDCOgIx86bYiX8ibL/FvFmfo5IiH1OBb91omm0H88QWWiqXbQXzm2Kll0Gy8y+C/dqlnY4OdI/nnMlxDBQiZR5aWB35iit2wD5EBpRo4PpVxOVcr3179uyyp45IVLLJycGWSWp/Bd6KST9u/zxq2tzvzt88aoMuLnqheuVWMqmzj2E5H4BqYG/jHwNzKFHvxBMRY1F8kQT6n2vWOazCZSI9Tgl++HDy/fosLIhmGVqJSlj6GTaIE6wPtyWzyAWeyGbbaGD4debRTrbFxnZQBAb0vD4E9BDNy4PyKyzu2WnHQQBBlTBmyyTGVWrtMXz6J9CmbWhRadIb+Dqreng6GpS6eouR4oHHDN7WKV0pn+zUsZznicjgjbfGSysvub81Z591Q+4pIoT1yeVUbN86qsThUUTk66LEx+p+nn8sJvBzqGjH335MAVoH0vqN3rIjaZoBXcLcG87kzA24Fh4+tNkEHP3RQw2ENuwjJEGHVH/xbvtLei2N40II6AY0Tbw7KBQMNoApz7QDqy2gsHsnIS0YCnWMML9y5VuTyZ9hl
 mxzpj5X4
 VrGIWRbov8gG67hyQSoOfsBbzmeRskyt2z3tr2o9U1jzJbKVvs+sheTRcoUD6pf8LIh1alTRKdbvdTSNXPibf6jIx/1+v+Mv0TniHF8KytGUi1p9aACIGWrE2KpmpMii4LWfWlrhNiZisuTuW5/pqN2Nf7ImNTkLYq3ePfXYZyVVlPzmDv/AgSKOwXioExzOhGnjXxoGH1uIAl4rf5CPMmVV6WsTDlInK22L5sraAez5sIYx3sBdDWiSX9Ab/aWe6+DU+w8CRpQ8HjLdkr2StZRG6xe3P2oFN8NkdQYDrMBiszM8M7acVL2KYqPbTwpB2b23R6PlkGZ4y4S/bMom4iwoeLinTjnBHGXQEpv+7ZZ7nmUWsfI09Kf4vV5uw7ui3PjLTFywilFBXKHNk7iBDB19ntxrYTaikKQbS3SNtOEu2UfC6EHCxvyVIRjPk/rk0KO3z1maypJDNfOqEtSG/5TBNGMWYRKVrEiZPZ2k/8GsWkJ4zb/4nsgE3ZlgiiZBrUb/5y2vH969jYTvJ8cnkgdUYTBAEq9DFW5cb7m39AxpMCuoOhIsW07F/IzExY6Pi8WD/9l20ExTuwRts7Uhk6jSkjYtQuFYoP4jpqcAZukslw6PHocOgRsI+Kft9gsL0boOB5JDAcna6rFk9NwcAByZ7I2JzHn+R96r8zeqmf445jjRloLb4nYOZvXEJNYVDJrKXwGBVsgRFXcbl/fmWVyh+Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris Brezillon,

> -----Original Message-----
> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Bo=
ris Brezillon
> Sent: 13 March 2026 17:46
> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty sta=
tus in mmap
>=20
> On Fri, 13 Mar 2026 13:55:21 +0100
> Boris Brezillon <boris.brezillon@collabora.com> wrote:
>=20
> > On Fri, 13 Mar 2026 13:43:28 +0100
> > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> >
> > > On Fri, 13 Mar 2026 13:18:35 +0100
> > > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> > >
> > > > On Fri, 13 Mar 2026 12:04:25 +0000 Biju Das
> > > > <biju.das.jz@bp.renesas.com> wrote:
> > > >
> > > > > > -----Original Message-----
> > > > > > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On
> > > > > > Behalf Of Boris Brezillon
> > > > > > Sent: 13 March 2026 11:57
> > > > > > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio
> > > > > > accessed/dirty status in mmap
> > > > > >
> > > > > > On Fri, 13 Mar 2026 11:29:47 +0100 Thomas Zimmermann
> > > > > > <tzimmermann@suse.de> wrote:
> > > > > >
> > > > > > > Hi
> > > > > > >
> > > > > > > Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> > > > > > > [...]
> > > > > > > >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offse=
t >=3D num_pages))
> > > > > > > >>>>> +		return VM_FAULT_SIGBUS;
> > > > > > > >>>>> +
> > > > > > > >>>>> +	file_update_time(vma->vm_file);
> > > > > > > >>>>> +
> > > > > > > >>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]=
));
> > > > > > > > Do we need a folio_mark_dirty_lock() here?
> > > > > > >
> > > > > > > There is a helper for that with some documentation. [1]
> > > > > >
> > > > > > This [1] seems to solve the problem for me. Still unsure about
> > > > > > the folio_mark_dirty_lock vs folio_mark_dirty though.
> > > > > >
> > > > > > [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-ped=
rodemargomes@gmail.com/
> > > > >
> > > > > FYI, I used folio_mark_dirty_lock() still it does not solve the i=
ssue with weston hang.
> > > >
> > > > The patch I pointed to has nothing to do with folio_mark_dirty_lock=
(),
> > > > It's a bug caused by huge page mapping changes.
> > >
> > > Scratch that. I had a bunch of other changes on top, and it hangs
> > > again now that I dropped those.
> >
> > Seems like it's the combination of huge pages and mkwrite that's
> > causing issues, if I disable huge pages, it doesn't hang...
>=20
> I managed to have it working with the following diff. I still need to che=
ck why the "map-RO-split+RW-
> on-demand" approach doesn't work (races between huge_fault and pfn_mkwrit=
e?), but I think it's okay to
> map the real thing writable on the first attempt anyway (we're not trying=
 to do CoW here, since we're
> always pointing to the same page, it's just the permissions that change).=
 Note that there's still the
> race fixed by https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pe=
drodemargomes@gmail.com/
> in this diff, I just tried to keep the diffstat minimal.

I confirm with this diff, weston is now coming up on RZ/V2L SMARC EVK.=20

I am just using drm-misc-next + this diff + arm64 defconfig + Poky (Yocto P=
roject Reference Distro) 5.0.11 + Mesa

Cheers,
Biju

>=20
> --->8---
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm=
_gem_shmem_helper.c
> index 4500deef4127..4efdce5a60f0 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -561,9 +561,8 @@ static vm_fault_t drm_gem_shmem_try_insert_pfn_pmd(st=
ruct vm_fault *vmf, unsigne
>         bool aligned =3D (vmf->address & ~PMD_MASK) =3D=3D (paddr & ~PMD_=
MASK);
>=20
>         if (aligned && pmd_none(*vmf->pmd)) {
> -               /* Read-only mapping; split upon write fault */
>                 pfn &=3D PMD_MASK >> PAGE_SHIFT;
> -               return vmf_insert_pfn_pmd(vmf, pfn, false);
> +               return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags &
> + FAULT_FLAG_WRITE);
>         }
>  #endif
>=20
> @@ -597,8 +596,12 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_faul=
t *vmf)
>=20
>         pfn =3D page_to_pfn(page);
>=20
> -       if (folio_test_pmd_mappable(folio))
> +       if (folio_test_pmd_mappable(folio)) {
>                 ret =3D drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
> +               if (ret =3D=3D VM_FAULT_NOPAGE && vmf->flags & FAULT_FLAG=
_WRITE)
> +                       folio_mark_dirty(folio);
> +       }
> +
>         if (ret !=3D VM_FAULT_NOPAGE)
>                 ret =3D vmf_insert_pfn(vma, vmf->address, pfn);
>=20

