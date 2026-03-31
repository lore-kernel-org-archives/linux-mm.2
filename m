Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA35109B491
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8006B008C; Tue, 31 Mar 2026 11:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF276B0095; Tue, 31 Mar 2026 11:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9246B0096; Tue, 31 Mar 2026 11:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D867C6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:33:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8528613A373
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:33:55 +0000 (UTC)
X-FDA: 84606753630.29.64449B8
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011061.outbound.protection.outlook.com [40.107.74.61])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB3D2160007
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:33:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b="IWDZi5/3";
	spf=pass (imf08.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.61 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774971232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDzaFbP6AN9JUup7nUQ4+5gPf8sGGyojy6+WaLJoIoo=;
	b=LfTzmuexihaBPu8u4vfUGACHPdlRlMqK7NjOUmn02T41Ad3MQ2VOVA8KXpnkRHh6XYqled
	xhVfYqkVwZLUb+vjiGlXG2/CHbC5yz5KHIa1kF9TDGI+0j9ksUmkEU+2QTKz/sAUhG7lpR
	rJTaqXdOhbBIB52q/hUVRQ2P+XL86DU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b="IWDZi5/3";
	spf=pass (imf08.hostedemail.com: domain of biju.das.jz@bp.renesas.com designates 40.107.74.61 as permitted sender) smtp.mailfrom=biju.das.jz@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774971232; a=rsa-sha256;
	cv=pass;
	b=JE/S6W0iKYrVRjP8zJCuvTAfVup2w8GoJu0rONB8gax1NNGCFg/1TRw8zo6z9Nlu2elowu
	ZofQB1if6/7Wuds2zJkcAko16Gj5bH147BRe3+DNWL3ZqjwSypTrovXxKXWd79oYXx4zhU
	jS0DEGSRPGsudQ0iNt+zErd5e4yAboM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vwHqNpodn+1dKWHlhMBTGHGcnyrqUennNBAr0lcum/bHm0xYWK2oDLOfwg/2T+oYAHXHWgIosrwsaxqE+9PQ6DyiLTXAyor6qA2Z7xeYRAxruG44WH/JkyNrl4PUANGmLXHSZRj3xSVIC8G+YEDyIC6K1mG37O+rDy3JxwHhY4SxA8G9E9MyCp6hZF11VR4KXh/d0OTHWMTB1psVYC/JhSQLtMcKHVSkGqodFbQGryeIxpRFVD7RCXYV/wXAaAoMe6w69iQnJbfH9r0waqeEEIxE9JJIKXh5liwN1XlpWfAhQpH5dB34m3HM/qwOyFHkJGtHtTCzMH2IAM7V2Vb0sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDzaFbP6AN9JUup7nUQ4+5gPf8sGGyojy6+WaLJoIoo=;
 b=BiH/vAXB+R7TiJbsTbT6h+66Q6sMS2tTf7V4x4btTycUCttWmobsWSWEtj+h8A8uv1Zm3Sr/VDYJpsBpS5If7B4d72s22VzAu1epCqC0qtOiBCBYzjg13bsduJlssKLJOekDoxoTRnCqs35fwf7K1O7+loUd+wNURebJ6p867gOpiJC+betValNRRvZmuaShcMdbHU+7MAyYTT4s5wAUxER9PSXLzEVxYZ5EFllIRmGAT5avJzjy5ryZybbdhgKf7KRDr5oq6zNTrPH4EH08MGNjeXpbxrA8QkcJ/95nkJafeGiO0yNtM3w02KC/KkLPZ+bFJ2zNhlQ1ETL/PWLKcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDzaFbP6AN9JUup7nUQ4+5gPf8sGGyojy6+WaLJoIoo=;
 b=IWDZi5/3c4VF43EURCbbiCr1RZ6bFue/qckGHmp4pdaO2bvMGdPXFHTNfTfk7rAA00yINxBbOYpkiNlM1HQ7wajAVauLtxX3JB718AhRHM1pvS3ucX8BCJSvZRpI8cnZRXS2aVjQKmII/U1p8eFuVJcQ+BrcKohzUlbNkSeKSa4=
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com (2603:1096:400:3d0::7)
 by OSCPR01MB13408.jpnprd01.prod.outlook.com (2603:1096:604:336::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Tue, 31 Mar
 2026 15:33:45 +0000
Received: from TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de]) by TY3PR01MB11346.jpnprd01.prod.outlook.com
 ([fe80::87d1:4928:d55:97de%4]) with mapi id 15.20.9769.015; Tue, 31 Mar 2026
 15:33:41 +0000
From: Biju Das <biju.das.jz@bp.renesas.com>
To: Boris Brezillon <boris.brezillon@collabora.com>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>
CC: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kernel@collabora.com" <kernel@collabora.com>, Tommaso Merciai
	<tommaso.merciai.xr@bp.renesas.com>
Subject: RE: [PATCH] drm/shmem_helper: Make sure PMD entries get the writeable
 upgrade
Thread-Topic: [PATCH] drm/shmem_helper: Make sure PMD entries get the
 writeable upgrade
Thread-Index: AQHcuHzyAwQHwn7Eak6JBM/l6bq/JLXI1hEQ
Date: Tue, 31 Mar 2026 15:33:40 +0000
Message-ID:
 <TY3PR01MB11346066DEA6D30785AB2E2388653A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260320151914.586945-1-boris.brezillon@collabora.com>
In-Reply-To: <20260320151914.586945-1-boris.brezillon@collabora.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11346:EE_|OSCPR01MB13408:EE_
x-ms-office365-filtering-correlation-id: 6c7dc3a1-e8a0-4e86-fcdb-08de8f3ae2dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 7prs6+BFW6YWa7qykjFNU35CkuzyXAjudz7tsgps7EX25HFLJnathcoJLX+vDt3yjBGucIfzdacynHahcUVmG/7/cfAPGaz94sHxtfyL0iPXPDs37/QUPB5r2d4AawuTo1TuqH1ohcHKit3R8FGIqqCAUhfMuAZj376NxTx8WBgKVhhHFZ8wWKvUbOUftN1w233O/sC6NONDkVqCkR/XH4BNomEhQHABU8Jywr6awlxBdRo7634r/BuPWjpH4f88R3p2Xic4zN1C7VnWe0tv25/lHvOofPDtGZWBgLFALbqKtuLUHt/UywJT0wlYAsT3wlm491eg1HrVKXQxY1nb5Vb/K9m7AHRvfNLWOJWzadTVK/hopFPAVPNPL7518QjqAqHseuqUMLcM6Thgh+/3/RN26lppoC11OJ5GSQMs0Zg8EQu0s/+ncM9kVdUppVW6oNAAk3hltR8icoqFzqOEodOhZpwWz606WrA8sEn2t5hZ2AcEItptPgWBug6SwfvHmXpemrSFzKUYywf+ZBXUMackLgDEprOrTmqZcmyH7m8Yf686SwJPhlluGHXQotC45llXGdWoVGbhjLecBOxK/QJqYb2hVRGpH2Y0pEgTYu10Bz6xOJxWBf72jej/Oe9xzEnSvtMGJO0d+yjlOL6cVZ/PZfzP3+WYO27n3mo05ggxGv7ldVfPjOXQsEJYk2Lmh3r/Rw1MRUYjRyjW8p7i0AuQbAgTN6e34wiDqoBTM2zdkekqwVs0m+O7mZnDSBEt
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11346.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?mhGjcabHAWDEZT7hzxUVdk2z2rGPQitWYmk3L1uJXDnwsbQ+dpYw7U0iVEl3?=
 =?us-ascii?Q?1wMecZeyjnwJLYMZD6XrgRdzERprGyTijNrcE3eq8cvv5iUVj3eCjXDg2K50?=
 =?us-ascii?Q?XA0Df0tRlXLNgWI6jpuhwKnsUOVQGdUkASdeTcdTCK48kTaRi80LGgyo18Lx?=
 =?us-ascii?Q?Ngl0Lo8T674wR/iQ3BWA3oQ4KYlEj+HWcs0gvGJFWLbKkpAUaIe058VZg+8x?=
 =?us-ascii?Q?jdtnmA3+ywZPB3NdDY+NZqsJZdvkff459XMTVLltBivUF8TGNT7UflkJxT8W?=
 =?us-ascii?Q?fxMEydwvwRq0XAxjOrZoVe38u3wWXw+/zELneBnK1gd/SPivV9h219Qc5+Yp?=
 =?us-ascii?Q?J8igbLP/r7+YwlJxvn8qKt0pE34QmW4Xxp9ev9gifRcD25xTxGrA/Ef5v7uZ?=
 =?us-ascii?Q?huK0btsxv+7sLKN/xtzLDAs8GxEZNcuqorxT6zrqiRmUgAhUXsJ5j12Koy3e?=
 =?us-ascii?Q?NHYm15r+2F/7ugxwHVQilxHS8XEYN09hkZYCOLk8N1Yl8UW76VHETpB5NV+U?=
 =?us-ascii?Q?5LjKo7SDWorSEaRQbQJWplSRQyb62FPSoVXFcBPKSj/V2zZYPYQdTcL4lAps?=
 =?us-ascii?Q?gfSwCJMMGv1FXsj2+GHjru7FVqoom6n1DKKgdLrlbq++qWYN5djwLm6R0AjM?=
 =?us-ascii?Q?Wl5EsHkLhzWbCUCygSF4uc20SovkaTTAqX/FuH1QvxlBtxrvB80EMeZmTe6V?=
 =?us-ascii?Q?o1d6i+GdDCt2+ySiht3edGzhfDPfjKbdM7QP9B5rszcR1BlqxTBGwd4efEb6?=
 =?us-ascii?Q?yTxq9zbC59bxdqqEqSAGwu9KbmZ5IwWl7fm7W8QD7QNDHYe7Nqrc2IEVTvGu?=
 =?us-ascii?Q?JVInZsy4dW2AWvJLM0e6H4xo+9gfohaOTXfrSYjLKK4vGKoFhnt8y97G3bS1?=
 =?us-ascii?Q?+cY7NCLlvexZLR/B+C0A+XxisM6kT9Rnk51Znxa93+HQtvTW0Qof4EsGkmlw?=
 =?us-ascii?Q?5kQWmAagZFBlsikOXksp/ewrRe8UmD/WelVyMHuR8tcy4zeLfINSHAT+FWIn?=
 =?us-ascii?Q?U+qmLKBbU1YuWxRKYSmW12tUxnL8zQReTRsIJsFPaO7dkzmrt6WYqM1APhAS?=
 =?us-ascii?Q?YYmVNOzfejwe263V8I9xN3m1R5IpmeMGSFmITRzTs17E6uRt0KPxlYoOCW/R?=
 =?us-ascii?Q?JHCQR43VG3MjmOLHrE3xbDW5WI5of++CyFQvrB17e9uOeNWsSu2EvgeYPvwq?=
 =?us-ascii?Q?DvmOOSNGrHnGEMc8YzysSvLtFj+EgmobjZx85njpJAWTf0V4MWYKHBJcL9ox?=
 =?us-ascii?Q?jtwKNtPvGJbKdouEVGjwuRdCCGzC/apYT6dAiGADMRkOHMQdm+4jK5PVQaa1?=
 =?us-ascii?Q?Y8ZPZweAaCV5RJynT/lxEyN7RiqXZv+/QJty1+wkDgRM0uCTzd3/7DdSpRav?=
 =?us-ascii?Q?V6Iw8LC1kLEmpBYCNWiSGUHNyFBNesQy55bBdcRQgW2C0CsW0I55Zkp7CTSv?=
 =?us-ascii?Q?L1CJ4WK168fhFluA8bSrfw+jI2CK762aWkBwnuqr0bO2K4a6Ed/Klp9O0xuE?=
 =?us-ascii?Q?A031YMaoXXuSIqTr0OFwtr8OazbV8bo9JU+L2/OV9gP2sDGyvkxX8qIlrxO6?=
 =?us-ascii?Q?a43Sqy29VFCbYDXem7O7zVXfQ+8Fa+fntfDbdQ6pwYwVsQtrychcKsfkw1C5?=
 =?us-ascii?Q?bYIhB42asnFj0H+KuuafGRGFyWYmVWdv/V3LB7yJ72BGigbprrgAvflXfSoW?=
 =?us-ascii?Q?nf/9kf4rp3wDHjGWfw5TqDm5iuiimuUhsOr395Lz6CpMCAwF7lkRRQwFuKGF?=
 =?us-ascii?Q?IRS5tleJeQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11346.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c7dc3a1-e8a0-4e86-fcdb-08de8f3ae2dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 15:33:40.9909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RktCGZUL34boWpnq261fO5R7nVL1rT+7b1QKmVVaGJZpD3MwjvOcR5Y57dSu/rn3PIUvuP9SPAiZ+70khgPKInUWpzkAYpvC2lWXYjhWR94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSCPR01MB13408
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB3D2160007
X-Stat-Signature: j9sgadyujnkzg1smd7mfozrkwnecf6pm
X-Rspam-User: 
X-HE-Tag: 1774971231-960163
X-HE-Meta: U2FsdGVkX1/Q20in1mu1NGymKjPhmnBWCso6757B1yGDnKMqp1cJxl8o7dWqL4+dCx+5lX3deTmT3Bs6rvS+6r/PFv1pHz2FXOkU3LtODsAUaFYg0+OTDBmZQxxXiJhz6R0FR3ZTSx8xDIR82cVrHFJVpNofbP3cC3zx+Ub1X3vf5cwPJN6ZhZ4taFRZPiLGUKccEXHAWiuGvwMP826V7YBa8EgXOWc+mHd+qAsOfa8yaXzC5ur5zuqjY0p8wQAYbgVgql5I25zxcZBdeCa5hYO+ZMuY8j0k683CCW3IaTkqLYEabaYsF8TnM2Bs4m7g7PHZ/njMzSDc40jn0fkjeAYKMfLj5PBR+BPKgGZHsIUZkjPNBMTgTrmatZ9zh1vskAjDThGqaeAxXWcQ8D43lFh9cKwK8Zn3nJVl01Y9QZzD4iVJbeyqZqpNc/zoYJyMGPoVzN9kLG8kqF5jLWDtZXprRG/O+lyhWkdyOS+y9lJhvQBuywjDr6+lK2DtqqB+MeeLSnXmZFQVCZxuLQccZahto503dbnOwW5TzeWuw4i6s66iyfaCHLz5hKFrZcVv259ep6ArOQhxjtRRtU8h5ELr8LJh1KkU5MKMd1uxrYcZr0qREDSa98fCxxa3/Fhxx6S60pDLKRpiZHQ1YznkDUb6sLqk2wmJl6K0QfqdfcDWMKF4aNi+AmG0Wtp8hzrEB430OEvkKHR+vEBp2MOqOP4NNiNAn/eo9qp1duj8jogLOafO4DJSNy1fRmWnCDwd4JHG5T1vVg4KCwE6/FW2R50r05yojNgt0PHb7vYLSCAPIZz/k+WyXEwr8dVRt1cLKFWNwdz4NEYq5ESiPCC4tNHLlNZ+zTfMTDzUPu/iJDssxEFHshyfnIrzTDZIsG7ts4xXu4DxpXoFIhdMKTvmTJ3vu8SUejBz64PNXjubODm43fi9sdWUxJMBfrnpqNc/vfmL2L1Rum/nH4SCTLo
 2ceARE4w
 2iTaN/GjkUtOpcwXpRWm03Uf9YwgBWQFE+UUdL7Y+hO+6ogj3/ntuK+GI1bN3sZMLXvKfg2KZvGd11D+V5AjX/EeVCsd0+khEM+vpce5F+EB34cldXdHr5PH0czwxYi+J2CTjy0yaZDrMDrWYretu6jzsKvWC0GyALEjj+vl/bnI/qefOXJQhp7KR7t5EzwF9kM5GqBguAQDDqDObq8sYOKEKk7MZj5bMLQIjIYE5d2vwc4MUBnZIr159R8mgNbkiV6I2/uG7Abtbk4FDw+Y1f6VJF0el4IdVbW/Ou0GgtG5E1AdR4lWaidbm4oq8/sEHKQ4wNDBloOYDhmFxFkwaqhjd2irvHAV5hJriLAO6gFpHXGU+k5SEFGCH1Myr32Aywwqxpyr53pQ55H+VPiOmpjBaBfE9LmZQp5PIq3rBuzc9QttoMNm2Wr0kMEFG36WAe69/ZYCQAl2KWUMvpSd6wOWJvTkRLXnz6cFA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris Brezillon,

> -----Original Message-----
> From: Boris Brezillon <boris.brezillon@collabora.com>
> Sent: 20 March 2026 15:19
> Subject: [PATCH] drm/shmem_helper: Make sure PMD entries get the writeabl=
e upgrade
>=20
> Unlike PTEs which are automatically upgraded to writeable entries if
> .pfn_mkwrite() returns 0, the PMD upgrades go through .huge_fault(), and =
we currently pretend to have
> handled the make-writeable request even though we only ever map things re=
ad-only. Make sure we pass
> the proper "write" info to vmf_insert_pfn_pmd() in that case.
>=20
> This also means we have to record the mkwrite event in the .huge_fault() =
path now. Move the dirty
> tracking logic to a
> drm_gem_shmem_record_mkwrite() helper so it can also be called from drm_g=
em_shmem_pfn_mkwrite().
>=20
> Note that this wasn't a problem before commit 28e3918179aa
> ("drm/gem-shmem: Track folio accessed/dirty status in mmap"), because the=
 pgprot were not lowered to
> read-only before this commit (see the
> vma_wants_writenotify() in vma_set_page_prot()).
>=20
> Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in=
 mmap")
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>


Thanks, weston is now back on RZ/G3L SMARC EVK with mesa 24.0.7 Panfrost

Tested-by: Biju Das <biju.das.jz@bp.renesas.com>

Cheers,
Biju


> ---
>=20
> This patch is based on drm-tip [2], because that's the only branch that h=
as both [1] and the dirty
> tracking changes that live in drm-misc-next.
>=20
> Also added the THP maintainers in Cc, so I can hopefully get some feedbac=
k on the fix. For instance,
> I'm still unsure
> drm_gem_shmem_pfn_mkwrite() is race-free (do we need some locking there? =
should we call
> folio_mark_dirty_lock()? should we call the fault handler directly from t=
here and have all the dirty
> tracking in this .[huge_]fault path?).
>=20
> [1]https://yhbt.net/lore/dri-devel/20260319015224.46896-1-pedrodemargomes=
@gmail.com/
> [2]https://gitlab.freedesktop.org/drm/tip
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 46 ++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm=
_gem_shmem_helper.c
> index 2062ca607833..545933c7f712 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -554,6 +554,21 @@ int drm_gem_shmem_dumb_create(struct drm_file *file,=
 struct drm_device *dev,  }
> EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>=20
> +static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf) {
> +	struct vm_area_struct *vma =3D vmf->vma;
> +	struct drm_gem_object *obj =3D vma->vm_private_data;
> +	struct drm_gem_shmem_object *shmem =3D to_drm_gem_shmem_obj(obj);
> +	loff_t num_pages =3D obj->size >> PAGE_SHIFT;
> +	pgoff_t page_offset =3D vmf->pgoff - vma->vm_pgoff; /* page offset
> +within VMA */
> +
> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >=3D num_pages))
> +		return;
> +
> +	file_update_time(vma->vm_file);
> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> +}
> +
>  static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int orde=
r,
>  				 unsigned long pfn)
>  {
> @@ -566,8 +581,23 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vm=
f, unsigned int order,
>=20
>  		if (aligned &&
>  		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
> +			vm_fault_t ret;
> +
>  			pfn &=3D PMD_MASK >> PAGE_SHIFT;
> -			return vmf_insert_pfn_pmd(vmf, pfn, false);
> +
> +			/* Unlike PTEs which are automatically upgraded to
> +			 * writeable entries, the PMD upgrades go through
> +			 * .huge_fault(). Make sure we pass the "write" info
> +			 * along in that case.
> +			 * This also means we have to record the write fault
> +			 * here, instead of in .pfn_mkwrite().
> +			 */
> +			ret =3D vmf_insert_pfn_pmd(vmf, pfn,
> +						 vmf->flags & FAULT_FLAG_WRITE);
> +			if (ret =3D=3D VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> +				drm_gem_shmem_record_mkwrite(vmf);
> +
> +			return ret;
>  		}
>  #endif
>  	}
> @@ -655,19 +685,7 @@ static void drm_gem_shmem_vm_close(struct vm_area_st=
ruct *vma)
>=20
>  static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)  {
> -	struct vm_area_struct *vma =3D vmf->vma;
> -	struct drm_gem_object *obj =3D vma->vm_private_data;
> -	struct drm_gem_shmem_object *shmem =3D to_drm_gem_shmem_obj(obj);
> -	loff_t num_pages =3D obj->size >> PAGE_SHIFT;
> -	pgoff_t page_offset =3D vmf->pgoff - vma->vm_pgoff; /* page offset with=
in VMA */
> -
> -	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >=3D num_pages))
> -		return VM_FAULT_SIGBUS;
> -
> -	file_update_time(vma->vm_file);
> -
> -	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> -
> +	drm_gem_shmem_record_mkwrite(vmf);
>  	return 0;
>  }
>=20
> --
> 2.53.0


