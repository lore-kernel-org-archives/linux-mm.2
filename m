Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7BBCCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B426B00AC; Fri, 26 Jun 2026 04:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C0E6B00B7; Fri, 26 Jun 2026 04:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD426B00B8; Fri, 26 Jun 2026 04:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21D016B00AC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:46:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BBD5A03A3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:46:06 +0000 (UTC)
X-FDA: 84921431532.27.D805A06
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013002.outbound.protection.outlook.com [40.107.162.2])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7381140003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:46:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=phDc045v;
	spf=pass (imf04.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 40.107.162.2 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com;
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782463563;
	b=qcImkDRip9zVcQ1wEwb0vOPFLBtvtyJneVUZBmE/CbV7KmaUYwwgRLhHtqtaQT0kwVyiGQ
	8TocpG34eO+RKwMNT0Dv2a6h5bP2OCyvB1GiH3nothi3CA3rQhBsvj17Ex7HCQxu0QRpJe
	DZdy0ctC/hOPUNUhutePiU2a+wGlv1Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782463563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59O+22IULRzY0yBIvDWfmm4h/UKmGrmzKU49aFFF0vo=;
	b=7dLhGOD7vtUpQZL44CJh9X5N7U7o+X9ChQz5wYuJJxPzzPPTHoLCEJsXWPyEhzMTgTaCRf
	taVVNGtPws1eUN8dwd5CrHtR1PQF8RIXo7cSkam82Fpp8wY04OAc9HyzVNTJlLOEnzELrO
	2MZ8uRy/9n1VvYj+vqQFNtHmMvdy8zw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=phDc045v;
	spf=pass (imf04.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 40.107.162.2 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com;
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXq2Je1WSDo8oxScQQ3ZCW4bBBAJ2OZZvWONaPDabhaZAwbDs4aGUGJR5Od8DzPJfxB/IbTblrNgS7BZ23DJwCiEnL8GvQPOxvAmu0VGCqz+PKxDCNGlj+f0p6wiJqTqCJFLPyEEeAzZI4hBvUr5jHQA7KiDNH0Tn19FMOD7oDpZmPmqOTgt1xZ9IyXZ/dGRwxb2GYCdkRhCTvMSttm/L1uNdWSuHeZZQDKmVWFgLl9FP9QGFJGobG41hM02DlPXWllD9jC1nfn/jXrByglvfANxBZgQrLIYWwMNKBfKht3NpeyRmttD3TmYxLsa+Pk9uMYruuyEaCEHarAlKkniRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59O+22IULRzY0yBIvDWfmm4h/UKmGrmzKU49aFFF0vo=;
 b=mr0de/jGkc0GtzkoV1BjbYHN0FgUxa/d1uAgMt000HtDU4J8+Bp05UrRMbk2OApsQFTaYTBx3XFHS3fluycPRpypXa90wPyFbmTEm0ZIiQlH15BhcwH2tnk9IrMQ/vj5vCh8C1ksoCasJ/gEofzsg8IgOWGp8FYTKJlpY9x9CYxzmGEMkIEpELd78Y4UIfldVI0NW6NShoJbL3ueVtyKSisX3rT8pcvUEzGWARsCtApY7sPiIgZLxiNcMjByCCtlO9aj9qImjPtogbso3wuIVeHAQoXNu2tatQR5tbfIyCq9ZZM2e1aIlHHH07ylaMBQBf4rQSAlqJ54SHiUDUk5Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuka.com; dmarc=pass action=none header.from=kuka.com;
 dkim=pass header.d=kuka.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuka.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59O+22IULRzY0yBIvDWfmm4h/UKmGrmzKU49aFFF0vo=;
 b=phDc045vepiAwWMPAJ9M9mRSlhsEL1uMoKQZQfKGNnEOabwNrSZAw0UHKHat/iOGAt4mrYLhtuEwDohpFGdZQ1oNUA+Lwl5yTz508/p+oJDltJ5jFvk/g/+QhGzot14tJ1wRmBDCWdNjoR3VA6DAJhoXl1ZxYIqofPzUvf+LT7gdS0QqejduHkWkRIBwLZt8kuZmy+zjITr7IRzirkcrVJ6txOSHcRmNNRsUUqMP4kMKOzGBiMJVXYtoZ10w3RwymTfdaMXR1L7TVrxW9m4WY9wICacxHUzAmnGjEEqHUrZ0EEK9gSV5acPFuu/NIo6IJ53uDHf8fUWLRLb1YO+Kfw==
Received: from PR3PR01MB6666.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:63::22) by VI1PR01MB6590.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:18b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Fri, 26 Jun
 2026 08:45:56 +0000
Received: from PR3PR01MB6666.eurprd01.prod.exchangelabs.com
 ([fe80::7c4:3143:57b7:cc04]) by PR3PR01MB6666.eurprd01.prod.exchangelabs.com
 ([fe80::7c4:3143:57b7:cc04%6]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 08:45:56 +0000
From: Alexander Krabler <Alexander.Krabler@kuka.com>
To: Wandun <chenwandun1@gmail.com>, "Vlastimil Babka (SUSE)"
	<vbabka@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-rt-devel@lists.linux.dev" <linux-rt-devel@lists.linux.dev>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"jackmanb@google.com" <jackmanb@google.com>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "mhiramat@kernel.org"
	<mhiramat@kernel.org>, "mathieu.desnoyers@efficios.com"
	<mathieu.desnoyers@efficios.com>, "david@kernel.org" <david@kernel.org>,
	"ljs@kernel.org" <ljs@kernel.org>, "liam@infradead.org" <liam@infradead.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "bigeasy@linutronix.de"
	<bigeasy@linutronix.de>, "clrkwllms@kernel.org" <clrkwllms@kernel.org>, Hugh
 Dickins <hughd@google.com>
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
Thread-Topic: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
Thread-Index: AQHc88tI1dDVY1j8J02KOQzrNPN747ZDLUoAgAEaZICABitEAIADOO4AgAL622k=
Date: Fri, 26 Jun 2026 08:45:56 +0000
Message-ID:
 <PR3PR01MB6666C11E08516555C153D4FD82EB2@PR3PR01MB6666.eurprd01.prod.exchangelabs.com>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <20260604023812.3700316-2-chenwandun1@gmail.com>
 <969cb14b-5b8b-48e6-add6-4dd13101dd89@kernel.org>
 <040788a9-e0d5-478e-bb48-3d22b8b41020@gmail.com>
 <c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org>
 <ca1115c0-1509-453a-8235-08e381a3da6f@gmail.com>
In-Reply-To: <ca1115c0-1509-453a-8235-08e381a3da6f@gmail.com>
Accept-Language: de-DE, en-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Enabled=True;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SiteId=5a5c4bcf-d285-44af-8f19-ca72d454f6f7;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SetDate=2026-06-26T08:45:55.716Z;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Name=Public;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_ContentBits=1;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Method=Standard;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PR3PR01MB6666:EE_|VI1PR01MB6590:EE_
x-ms-office365-filtering-correlation-id: f76abb42-283b-4371-c6cf-08ded35f56ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|38070700021|6133799003|11063799006|4143699003|56012099006|22082099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 sz1Tl+1NKE1JBvhDFMHAdzJQabaN6wwYPrs3KO+sM2c0E/0eFnthqOAEqVRbC9M3tYt8Ym5uHyDoolHSbYpoL+oCrNghK9CIYtlpq8QjMXlt5PXIiovdXEJZBl/9JKCeaqP8F9BJLt1i5gnMcyXjU2p7Of/pYqJKV9ACmcq82RomGkfS5XFBECIgBiC/XbfTHvZMXBhG7RXQ5KkN878Xy3+4cgsEuIHhUXA7MuDI3zk1nri+NyrlDZPFUfWOAJhT/ua5Rl+3FVr8bIW6IbHlik42+nLXis5rjLrvvughWbXrhVnYpphW8FuNCOMyk/lz3DZtnq0V0Rv2Hh3iSz+RtJh7Q5/aNDFUyegVSHM+meq79Q9Srxgj2tM2rzxJL34oqh5HnIifDCaF6986uQ/aw7I5f43QVRkicjSIlGwUU/M8QHYe8vQO73jyYfHQyqCAHXVRBw/DkoVNn9tCkLO9/lFXtkx4cD3KhXVAJA/15y9UoK7I2MGq8jAFX75zdpzNVwR3Sf+8VAowLwIq2+t9cZNhuxFIfqsKAi6ghReOf5OXbb5gHodlGOhyET448OB7U/zakIlvq7rswRdR78hz0n6rtAnPjvAT7twfgaojVO6TaT0Y2UMvj2duUKZuv9O/MKI80AdR58MO7TAQ4tCwN2HSs3AvW+hL7fvx2/uXFKFhbLj4tTr0qstzH7RYNFa64rli4WbhrSdG7jFU6yHEjId52HjDu+eCEAyDoTND1vs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR01MB6666.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(38070700021)(6133799003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?QE0oP3jQ4fltcpCIXEw+KgBly+QXYpmkK/GUQJpmphPBbW32jPAYoMsld6?=
 =?iso-8859-1?Q?tPKZr3CtW0Wvi41457REJy1/rv3L+CzhEHAd89iFRqs2kivImJO5kXh08x?=
 =?iso-8859-1?Q?eIWBP7iEuIsAP40n0Eg4bQ3Do40dCAk0s64xZnw0pxPxDZy4WpA4vyp6uz?=
 =?iso-8859-1?Q?otqxYwYI+JiOV3mQvhiqfUSc+iAKkPrAvsJ3CIO/VP+QogeDclRtSC408f?=
 =?iso-8859-1?Q?6NV9RkP04h7XzLA/VFQ17cf3xk82s+twe+nyYCx24pdMPOAg3/4x5gQqOF?=
 =?iso-8859-1?Q?Kl7p5oTKtWOPl3LliVqqR98/l4JKvHkC+IfumrnMPZtNC7Ioxv94dVoqXZ?=
 =?iso-8859-1?Q?jl7cAjy/HJ1OWesjX1xyYRTgOa8Xvr1IC447mvraXavXjtcftW3FG3pK8i?=
 =?iso-8859-1?Q?KNxKqnSKOETjpH06ii0bQdWZyKYCGKkbvJbH7HH3Yo9e5zhN4/TzDkdiJc?=
 =?iso-8859-1?Q?TyVV68DF29dLxaKzoPArWXWLHTxPJQDIwP2SdbDh1y/WWlNv1eLELKSR8H?=
 =?iso-8859-1?Q?OwSvdogJ3uAJjuz0qbCkhWWblrbKIZTAn9aJDm1yXnscLsXeFfGGCxz3px?=
 =?iso-8859-1?Q?RlcG86oNu8pLSufuSIvhlhoDnPdE/Y4J/WMGA3hIWL/nk2btNWFMxufJ3G?=
 =?iso-8859-1?Q?g1UlQjWGgQ5utc9FrJAaqIh5XK862g+3rizgIbA0X8x41/yJdTHhHPRKJD?=
 =?iso-8859-1?Q?In6GQsuJZSUDLcNJTJQA3Fe6khp8dOCEyQWDxcDhbc5Jjd9sHTeeMfhQTX?=
 =?iso-8859-1?Q?ZUyWi+hEC6kv9RL7PV8WR6a1qHb/9qh4o8UIfO1Rx/8HzTmfw3hSmOw1px?=
 =?iso-8859-1?Q?7ypKLbOvdwjsZvd0W+YBQ+BcqCfUwlz/XFqmsWSgCsAYW/OriqNetqusre?=
 =?iso-8859-1?Q?Jr1EmlvjvGj3Zhg6bqibLAKYb2MRyBT3tFMvuERr314eNeKkh0L7BGv6ih?=
 =?iso-8859-1?Q?unxhoVi2dpzflWYFTUh1c00/Fs/5sTfZr/mDMn2ozUOPjlQXbo7bKM1RZ4?=
 =?iso-8859-1?Q?fR2HHK7R3ZEaKM820C1+5l15HYUCUWpE6ymDkiU7e9wAKviL8iK1WzUvk/?=
 =?iso-8859-1?Q?uW6SAZlTuY+C9F6c1/CaYtURjq5dshM04cxE4Q/j91mqc6FYrKzVTMQKMV?=
 =?iso-8859-1?Q?ZHrBII7nLMkkShVGF9z+5tQv39pJX6e/3q4VDVMCWPyUPL984lTW9Px0RB?=
 =?iso-8859-1?Q?695fAbqc7bXWPy4q5ZQOSl/drekBFkvIHr+Kh5sLZT8gr3vdOICrzxVq44?=
 =?iso-8859-1?Q?LnP3S8y5rnWfTtRlhgbeUVMa/iC60hPYcNnwoZutX+pTY430RbMFnbbKtY?=
 =?iso-8859-1?Q?RsRGHUMuQ4Llcj04otBqIOlU4haoE3nAh1Z0nQGbu1btrqaxakiJ4XaJyd?=
 =?iso-8859-1?Q?MWAvsWg0rWbzD/1dWIVxhA+4/4GbVp+B4hDH6ID6Hln+gwFBbUtF7G1Wp4?=
 =?iso-8859-1?Q?T7I3K0yarGIkGi1cZNqwybaGhQNbpzhmZGb2OkW7mmxT2C1NN3PckavxQk?=
 =?iso-8859-1?Q?I4MDQT+ze3JWMkiFDNGBSA4um5Ck307Zl6qo+QlQiwBj3TZl71h93/4KAa?=
 =?iso-8859-1?Q?xoatI4IFsYu7l3TjhYRH9TnCKXTdTTU+Ool0Wy1T3bChXaN2NfucHcdqKV?=
 =?iso-8859-1?Q?a22HmjnY3TzdglUxuZDiW9dmFop2MVGamviblSUW3inNo+sNGaRCh/zfeo?=
 =?iso-8859-1?Q?XB4gP+qJMYtmNYBJan25f0Ovfjjnqfq9I3Nq239YEojyV9j836UbyxZBqq?=
 =?iso-8859-1?Q?12W8zSg+bf0MolwMagFL8V5MZ42QT80BLpX70h6EJ6PBkfyabtDlcMSISl?=
 =?iso-8859-1?Q?Ile/bchNGQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: kuka.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR01MB6666.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76abb42-283b-4371-c6cf-08ded35f56ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2026 08:45:56.2446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a5c4bcf-d285-44af-8f19-ca72d454f6f7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o1krwAm/D7mGPCL8iqh4uJZeF/scgxATOf26IulNZtTRDgSSeRGdsOCUmywj8cc90HeXpPB+Rk934EEQkuLWVaODAqri+PQ3Jh5WJAMMPnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR01MB6590
X-Rspam-User: 
X-Stat-Signature: 4kzheauo7cwwcrmc3rrbc7aufq8g4sob
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7381140003
X-HE-Tag: 1782463563-295308
X-HE-Meta: U2FsdGVkX1+mNVpf0gCworz09I2H7d7VciLOweQnTVJfbASe/jEjyAIcZyQLL9tXFPb+DsuYze/sHc4tXvEt/sWZbwONDXCS75vEbYIzfzDLE1AKWdJbOMAGYaP2PbcFhG4eMWZebRcQFd2nXHH6WC2J3PDgCmwEQ0aKaHj5CYY6100hEVBkBf4Kg4Y52aDK0yrIWQ/JBxa+waMCdCmuaQd+thRfxDGUwd43TMKkDyvlehAv74hdaMf2g9557thc7PG6hRoJ98pAAg04WvPQ34HdmPFfKzXIjB8u3cEQs24aWlIXZSNSvAqBycsXPb1rXi5sXoS99BOBpX+QKw62Zj1dY7ck6vmHE+6vcPW3BzXnR0Hve1vKnwYxkg1OhhPwnrv4xhsC29XUaphpT8E4Rp2jqMeCFPnPVPmsWd/+zbk/rBjQIk7Pfy/hMXt0oSNs6ocp7P5Oz3UTbz9JXnBAlrEpYFlmEHXRfDCgBGA8g3ANHJspb5fgUhmL9Wu0r74FXCzxFthOUD06jmEaKSbU4nCt/PkTbGjszveVtA0ZEDBEbG6AlP4ZRaIQnja+BLPo6IO5bLxNKsxGrAFcaQU8gcTbxzEpsqo7Gkz2rm7XrAUyGfua0BBvTTphFzPApi9CNdA1dXzy9/T+/x0yeEzth3lLBdvwNBRqT14S6b7A39uxezALgo+E1Np1yrjR42aEuiBdEt0nkEojYGaeLgioEl2/jGKTkSXhWhmoJ4MfM8JrVD0GPdw7daQrgwbSarYv9FRCrnTr+seI71WcbTLPvWotLQ8NPUVRhr4cwKVdoZ+Z5vpYMTFzeY990ZB6o9EmWqX6e5EG4wZcFP47f4AO0jlDjhlgGDVfM9T2Ey0yCLH0Bg9uMYJzZHHpcTBgBFxOvUyn5bxC1YdzAipJv9JmPhLhRdtutGxmMP/MuCRRzoRCgtyWG5vuB3sxB0dzCcN8dHxVDmc67h1G8WMnVRw
 MdSeoAHQ
 jfK43MctYI78YWr0+ybT9hM8iQz300H+WI1Oj5k/g9oAq0Q8YZZxbyiVzXGdM8V59WUXSykKjFaZS8dC0bUS7xLywx8JogeDAnQZhgYorqUDuulrkfR+BpFEU1fnseNEpyIGe+iTVy+Q+t9hGy0ZZXXZoO2FiEDKlEVtEiQpQPR3muF38UQ1tpcWSLh0yO6/i8fde7G6sg8vXOkRkMygpMttBTeiuuOJ5Rh9DJEDRrem50YR8hyv4p5KnhmQnUw2KsMj64QVz8sPFdeDJNryEArGpMjfPeQJ42E6dGQ3u9DM9FQvQDXP72RoRDF3RyIp/Y+tI73h32Q1l6vbEII6ssjE+GoONzt3bkR5HZMyvZx2J2wkajhZ8L8vxiFeuN/Ih3/5HgOXeRziQVfKQ4IeIuU7nmRPvUJ3vOehy7yK+Ss+85KEvuw+VpH4Vvy+SSm4xAjYvvXWol770eLVUFUBfLXR3totZ6a0eb3ruCiGJIiPmBMRtznyPKVjZRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 13:08, Wandun wrote:
> On 6/22/26 17:55, Vlastimil Babka (SUSE) wrote:
>> On 6/18/26 13:43, Wandun wrote:
>>> Yes, I wrote a test case that can reproduce it in a few second.
>>>
>>> The test case contains 3 steps:
>>> 1. mlockall
>>> 2. mmap file(2GB) + trigger file write page fault;
>>> 3. during step 1, trigger compact via /proc/sys/vm/compact_memory
>>>
>>>
>>> My reproduction environment is qemu with 4GB ram, 8 core, aarch64,
>>> preempt_rt and includes the tracepoint in patch 02.
>>> After running the reproduction program for a few seconds, the
>>> following output appears.
>>>
>>> repro-403     [004] ....1   101.270505: mm_compaction_isolate_folio: pf=
n=3D0x71e3a mode=3D0x0
> flags=3Dreferenced|uptodate|mlocked
>>> repro-403     [004] ....1   101.270507: mm_compaction_isolate_folio: pf=
n=3D0x71e3b mode=3D0x0
> flags=3Dreferenced|uptodate|mlocked
>>> repro-403     [004] ....1   101.270513: mm_compaction_isolate_folio: pf=
n=3D0x71e3c mode=3D0x0
> flags=3Dreferenced|uptodate|mlocked
>>> repro-403     [004] ....1   101.270515: mm_compaction_isolate_folio: pf=
n=3D0x71e3d mode=3D0x0
> flags=3Duptodate|mlocked
>>> repro-403     [004] ....1   101.270517: mm_compaction_isolate_folio: pf=
n=3D0x71e3e mode=3D0x0
> flags=3Duptodate|mlocked
>>> repro-403     [004] ....1   101.270520: mm_compaction_isolate_folio: pf=
n=3D0x71e3f mode=3D0x0
> flags=3Duptodate|mlocked

I applied your PATCH 2/3 to our kernel and checked with your reproducer,
I get similar output, e.g.
t_compact-2148    [005] ....1   515.320221: mm_compaction_isolate_folio: pf=
n=3D0xe66c2 mode=3D0x0
                                            flags=3Dreferenced|uptodate|act=
ive|swapbacked|mlocked

With your first patch applied, the amount of these messages decrease.
I was not able to apply your third patch to our (older) kernel.

However, we were not able to reproduce the actual race
(mlockall() process waiting on a migration PTE),
not in the past, not now. Might be hard to trigger that race.

> IIUC, more accurately, the migration entry in the page talbe is real a ba=
d for
> RT process, because isolate page doesn't modify the page table, so memory
> access continues as usual, therefore a new idea occur.
>
> S1. In the mlock[all] syscall, if mlock_vma_pages_range hit a migration e=
ntry,
>     then, it should wait for the migration to complete.
>
> S2. During the unmap phase of memory migration, prevent a page from being=
 unmapped
>     if the page's associated vma is markd with VM_LOCKED, similar to how =
reclaim is
>     disabled for pages in a VM_LOCKED vma(try_to_unmap_one).
>
>
> For a page handled during the mlock[all] syscall:
>   - if migration has been already finished, there is noting to do;
>   - if migration is in progress and the migration etnry is already filled=
, we
>     wait (S1)
>   - if the page is in-fight, going to be isolated/migrated, S2 prevents t=
he unmap.
>
> For a page handled during a page fault: VM_LOCKED is already set on the v=
ma,
> so S2 guarantees it will not be unmapped, hence no migration entry.

I do not understand all details of this, but it looks good,
especially the S1 case makes a lot of sense for me.

Nitpick: I suggest to switch order of PATCH 1 and 2 for the next iteration,
introducing the tracepoint first and then improve the situation.

Thanks a lot for looking into this issue!

Best regards,
Alexander

--

KUKA Deutschland GmbH   Board of Directors: Michael J=FCrgens (Chairman), J=
ohan Naten, Hui Zhang   Registered Office: Augsburg HRB 14914

This e-mail may contain confidential and/or privileged information. If you =
are not the intended recipient (or have received this e-mail in error) plea=
se notify the sender immediately and destroy this e-mail. Any unauthorized =
copying, disclosure or distribution of contents of this e-mail is strictly =
forbidden.

Please consider the environment before printing this e-mail.

