Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02775606A334
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 05:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=EgsmJR/v
Received: by kanga.kvack.org (Postfix)
	id 2EC236B05B5; Thu, 29 Oct 2026 01:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D666B05B7; Thu, 29 Oct 2026 01:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13EE66B05B8; Thu, 29 Oct 2026 01:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D25FD6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:03:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54EFF12028C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:03:42 +0000 (UTC)
X-FDA: 85374471084.06.DA5850C
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azolkn19012023.outbound.protection.outlook.com [52.103.10.23])
	by imf02.hostedemail.com (Postfix) with ESMTP id 74B7180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:03:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b="EgsmJR/v";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of x-professor@outlook.com designates 52.103.10.23 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793250219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8igprn/UOyCqFPmOG8oAlfP8pOfRCS5h0pQlsfqphP0=;
	b=qD7WRYs+pMcW6CaQ9Do88+xiT4L6KncAR4JlICsGKu56scWMDIMP9WwTIQVmhLMK4/UQME
	xIueBR5mO1cC4BKQizpPnCRfesjoD8kmsumhhWKOSJVodVJT2P7ndcr1MRc6zevm8tPqpK
	xwxLE8XgD57WXdOM5CjGQNkqlT83hYM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b="EgsmJR/v";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of x-professor@outlook.com designates 52.103.10.23 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793250219;
	b=B4as3WciJ3ims0VPy5Taa1Jg4bfFgGutK3P7ag103hw+SkODfPwe6QIZtGJGfbHUwRdMWZ
	O+ZywjLz4Jbb0wnDIQ+tkoHb3gtDBryqtnpMbs4VPE56xhp467Ds3uMMrGxLNfnEA1eR2B
	HNkUZd1oE/HcNiokI4KuKRZYOM7y4/E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yAoEgHfSH0p/OfquS4/UmourAMT9bP8DjF9+77jq71ZOv6x/m2veW5ne/+EGoDuOJmHzWJFkP+rd7Fcmdgh7BrmGNez6AkfiHCyf9XCvPmAWqNotiFsjW455TwHF00AtuwaJyYo1RdWZZ6LEE/gn5PujC9YWVDur13hionlaSDnaEx03S7B0FPnAJboGiVTWTwD66wrUco0wa3qQjPsZA0OU5+PexgWstAHw5jmfL+N6yTQlWUoNnDLC9z8y73uToIvsY50l9aQRKuCNJMA1XpIul6MasbEB74IlIcHVQjmbAMEjJK6jmaCDS8p8xWnfoXO723AWFsGtIS9hhlPhXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=8igprn/UOyCqFPmOG8oAlfP8pOfRCS5h0pQlsfqphP0=;
 b=k1J3YRrCZWEIjepySrhIEGzzMYO3tkoQOl+VekhQ7BzAn29kSYdaKyxYP8kRmueSkRSsLhzIunHz2zc6nSa6iH57z3Ypxa+Ggyu3IDJ7Hm0QAk9ILmszG09hZ7Iroyd81WdFXzbDDT3w1q+rWlB8z0GBSASvKEOCSz3h5A2Fjy2aiKpROKvrUSADFR6PsijAAgqVH4Ch6O5yQwlO3Q/6Ovev4jHe766iuFmjRx/txbE4aSt6nQIdEcaDwmJ63m7P6rGKl5ltG9kISKyua9JNyLJezosooFMeelk/FdCKBXyS56zsJEqoQiBBlggHJQy45ScGqhVPZefNE589q6Zssw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8igprn/UOyCqFPmOG8oAlfP8pOfRCS5h0pQlsfqphP0=;
 b=EgsmJR/vTIzyddjdXEQNVoa+i8wHTnnoL1GPcG8Q0sGJQTr7t0siM7Mgq7ZZDqCJ4lmHhqv2fBTUE3d9pe9psTvlllMyg5cmKt/lRzl7bBAANP/oyMaUypc6bkUPe42qnHbTWJ6csE8WAbppUQzhwaNphBuEwnNi9uj+w8KncJGIbpeJIXZcGEuz/rdCS4xz70CLSNAAl0fSOzrqOWjrG/KzoxAlXkhCghz8W9fSdkcC8zPVSnweQbW2pJNZzwCFRXtc9jiObsgf9mGITZQ5eU6SziDOxkana4G1Mse4V+iDVdbIwEDbRm4e4BabUArDcF9cWiVLmEBSDV/Zi6KiIg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SJ0PR05MB8214.namprd05.prod.outlook.com
 (2603:10b6:a03:390::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Thu, 29 Oct
 2026 05:03:28 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 05:03:28 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?iso-8859-1?Q?Michal_Koutn=FD?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: [PATCH v5 3/3] ipc/sem: remove obsolete SEMOPM fragmentation warning
Thread-Topic: [PATCH v5 3/3] ipc/sem: remove obsolete SEMOPM fragmentation
 warning
Thread-Index: AQHdZ2LVhtHGdgs2WkKTOxYJnworMg==
Date: Thu, 29 Oct 2026 05:03:28 +0000
Message-ID:
 <6d795eecfd0beb666251e6bc03ef9fd135386362.1793250194.git.x-professor@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
In-Reply-To: <cover.1793250194.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SJ0PR05MB8214:EE_
x-ms-office365-filtering-correlation-id: e5fca09b-811f-40d5-355a-08df3579f872
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|16051099003|38102599003|24021099003|4140399003|15080799012|19110799012|8062599012|8060799015|25010399006|2604032031799003|22091999003|24121999003|52005399003|40105399003|26121999007|102099032|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?wgVT+0UnyHEV9mA3OalL/EcN1bDuNqMw4YYnHYGNN1xwVX1e2wCB8rgsZi?=
 =?iso-8859-1?Q?hnkCz4iKt4nxAJxysGu+ppdRiB59wrQjiKaxbKAG25oznY981Ey+B78Q6r?=
 =?iso-8859-1?Q?ZZMBFkdwYuppczPP6ElVz2LMYDskzmvpLl15WfBupTUZgfXpVIZ8r4g7YU?=
 =?iso-8859-1?Q?lM/8YNQu5n+obPz1LnhI6uEgfeA2Qz8dtWFntgXQeUBT5O8f1RZOzAHUqC?=
 =?iso-8859-1?Q?A2v4lvJCnnqcbbNOqXwC2nEaRUG4zH7ppBw82q/ob7B8qocrg/Lu0e+Vct?=
 =?iso-8859-1?Q?AyskljYUKUAyetYrS3CzgireD8moD+ziH4TZ+OewaHYH6oiMHJz1WFSsw0?=
 =?iso-8859-1?Q?AJHpK6wObWxUHTrZRT7KOpwsSBJsnSD9shSTx3RpUzxY2gwX++gsZqyIrX?=
 =?iso-8859-1?Q?PVqQoELcV7Unvf+gM6YTXzKKdnFo/bscjTqMDFOBGE1K+5FwMrd3bpZRsQ?=
 =?iso-8859-1?Q?Ob6L7uYqR2yMLaYvNTL83xjvb9mriZj4vGzhNjTCsNV+GFJovQ4R98+5YR?=
 =?iso-8859-1?Q?HsCQjclzvb/tZiFcDaEvYnYrfzJyE/19C8mDT5hU1KcunZp4Rdc3sZjeLN?=
 =?iso-8859-1?Q?aF4mYEq7nX1MBBcBHVNM/33JA1Uptm6rk09DLyngzGisME6wyyMsp5tVvl?=
 =?iso-8859-1?Q?nGc9hNJeZd25fVJH75YUyjRxLk3wUO8cWWZPuII4HXn5RdkeqvrfRA5fTH?=
 =?iso-8859-1?Q?c3saMIpRR8slFR+LFSFVGtoBfBIupyZyysGbpRjlNhE9fyC4Qraw6OsMfm?=
 =?iso-8859-1?Q?Xx2wDsDx/7Q06Fd8j3nO2HTrYD1igL/QkgIQQTcYwFNmUWJI+4KW1qlvk/?=
 =?iso-8859-1?Q?SA6smw85Bc8RcM5V17HEop1EBYZDVHijrj6RR2sDf05enlAAh/dEs9k8/Z?=
 =?iso-8859-1?Q?tQWwYx4Zcx4MjhB2KVO+XeWNDdjaorTKl/LqbeCvNREUxf7dwijMU7hSmz?=
 =?iso-8859-1?Q?yjvQhU7CUMguqa/I8whkmJpfeMrv2q3k+oj/kGXdlLz8awptmzqfACkeyh?=
 =?iso-8859-1?Q?Az4ehB/UGjUVi2FUQq4tlNjjHm6L3a0OVkB6WIkNEuquj4fwe3GryZH4qY?=
 =?iso-8859-1?Q?8lsG+slYyxRRITg9xTBih3yZDGJCHtxMU7ndnt7PHmelrfFhUbFeDuBR4h?=
 =?iso-8859-1?Q?QRevOtjJ356Z7VGFyk2YQN2j9gnA9LfB+JlEcQmjlMzpEvZssnY2bdVt00?=
 =?iso-8859-1?Q?yXPGUk4TsfttpwsN6Aq5UB1ruJyf9ndFgiw=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?7XCZOWf71f4wvg0XBBgJz1bol5qmHE2ZshaPbX9B0priYZggJMJxIYrO0R?=
 =?iso-8859-1?Q?r3bvHFgt2tprMcNpo9KpOlbqiIg//4ZmQ808FWIzDzEaD30tD/oaL3/f1q?=
 =?iso-8859-1?Q?IbYHsbUOvoMV2EBTbCYXl9PKq6L0QN7CmED2X4F50oaY8+cE3ay9IXzPbU?=
 =?iso-8859-1?Q?DK8tc49vsl1MMu0MgxFQMHDCrNWFzBfubuADjnm6m/TGWlovVUXpfmocHi?=
 =?iso-8859-1?Q?3dd1nef14PClx8sAd7G3xmLw7HPaZ19gjpGOiZbRsUfkKp1GjMO8EMplg8?=
 =?iso-8859-1?Q?cHrUDm+8IhYDc/1tKICpmnCSlUyj10xoR2D7tughIIf9btUfpiYWecZoTy?=
 =?iso-8859-1?Q?meomkvotWiPk1BZj06L+Cikg+9yeebFfYef+Hij5ewEYGelRWVf95dJyg3?=
 =?iso-8859-1?Q?1i+S9jtczHRppb3AyLFi3C41+tQthThMcwuv3tcOUT6FkrZlreHvuZqJUE?=
 =?iso-8859-1?Q?geaMVi5Vo1LO6w3vmttw4UbOxyXOKpLimuwRnN1OB/UPTnv+58Ta2qPs0f?=
 =?iso-8859-1?Q?oxrRuNmVi8TXRC0P1EO7G2b/5/hx/EVY75KJIhmJe+uqPDvFRHD+lG4nUX?=
 =?iso-8859-1?Q?tVoMpbxKnSNbWqfxOyXm5o+3azM7xptAB7HEAtQmUtmgAa8hUGjsy26dQQ?=
 =?iso-8859-1?Q?MWIAiSC36TGtCwwPZfXDqjk1j6fag4AemI1aDcc6CVQpQ3NefgQb1Los1g?=
 =?iso-8859-1?Q?p05AlFqEL+nbYR050Z8rmsuosRd5ohRBMfLxS92GijI5BJcoYlQL8jOT2z?=
 =?iso-8859-1?Q?MVXwD+meTg1lWrAPD6BIO38NwxRndPs3bg0ivdxE2h309NGVFQJE2NbHyf?=
 =?iso-8859-1?Q?0VWkjuGTJZRAq1ZJKBfVJSWR+EHcV6EyCTNTWEsI3LprhTRkW3TOCbkMcL?=
 =?iso-8859-1?Q?p61/TyGXp2xexQcoQLKGWdF1FruFSNZncnpk9VWpqUcXl/3AVHOSdcZuSq?=
 =?iso-8859-1?Q?+maAv61MWwfonDnSZMaVQC5Mjfhrg8dzifYBwGpI6WuCETNsGydQq9Ej2z?=
 =?iso-8859-1?Q?4DhlKTrnlvm7k+OAlNcjP2T0Yv2le6btaJauhG5ZB/Io1Q3ttgPssF7k7u?=
 =?iso-8859-1?Q?UzC8FvfmCh0s3+hgGO1bFxln8Xz0yyiQTou1aqtb39nOIEtOksLVQFZ/QG?=
 =?iso-8859-1?Q?qa9UCrOL4ZYoiCsX+5E/ixsIT0/RG/4T24hAtBjvs9XY6No66zzHrkk218?=
 =?iso-8859-1?Q?4JTROwyVCjReUI1OKRove4Z4+oO0E8MYglFkSzF/uqv42LfVxnx1jf9rF8?=
 =?iso-8859-1?Q?WtHeo+QBOAM1i3ezcxrXUIx39tKTQHNPbStYk2w1GQRtX41ugPh6fZN7Ey?=
 =?iso-8859-1?Q?uThfBqugz+laYWfJGxHYtX5Dmv2kw6NF/4Ss0BzwigxRKS6pNVNZqly2kx?=
 =?iso-8859-1?Q?TmwK7jT6DzlUIFTTErvQjoyuHXBYsfuJzi9PafIp5QnYRi7L531w/zoF55?=
 =?iso-8859-1?Q?oQcj2dRL2/0w5+lG?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e5fca09b-811f-40d5-355a-08df3579f872
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2026 05:03:28.5197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB8214
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74B7180003
X-Stat-Signature: 9948e1h5w4myoyhmro5r4bes7m316cob
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793250219-634023
X-HE-Meta: U2FsdGVkX19n/GtT1RlRP5OnNQtmA4hkGF64bsnfKt1XTp/97v6tA5jFn0WWTzkLltrdolzQISkc/bPAZ96AOWjCjCSgSs4fIBqRqjEahEgTNodRhyskPWfx0oqU58mFgDNi/OmZHvwnN8DC6fnaCmgqdD/GnXZEmHQuxp1pqE3ip0N7earOd0OuaFSnnaRUu3a+2W74GzCakZE5eTao2izdPxK0wPmOAESHAuXs3WVrZf1YIX3BzjedBLzARI1XAXJmVW2ogGdtfEJcTibW3XDqKmIRjsX5SZBjgqJyJiV2XXMTCyUR75Zj+zLUD/hB/z5xOsIe4F7IGark3XrJQ/kkj6WRA7hl82XoTVI0fzAhu79sQeAQAuB0WSe24paYqrnjfqyL5uCi4cWCblQWFw2olobJJ5r+NXWBpjk3MBlqAjnVPBpyoqJLzIn5CfaEHkafNREaiUAm1Rhzb5PAM2r+oMz1tpeYp8hYoI9WmWtKF5Ebm9k1jmuHLBgAf0pll5oUvw2mwcDr2vyDjzxHXaJYQbSd4GsHmtRmbgRWL3b01IlBapYfT2CLD+KE1eMMWQypwUoB8saBAdF65+upyCKlSIVjPRS6IZn/PlCz/Q//CzZ00h0i6pGW4ruqATd5v3kADoVIlXtRWjic3duLSjQT1fOh8DJzUEZjV9HmU1sIccfXIA97X6MUoHCsvpqI1ZcgNExTwLzCVpOYCULXjNQ9mKwMu357blvl9ImVCpIsVO37zy3gLQ7awgA+eY5QfxFeR+vxqlFMQ5+NpFpJcZgW1tiIpew45H2wN1N6U7M5IbwKQa861CFvBcq/g6Y4M4negsRtSaWX2tlXubxKRg8La+mLNjbgavEPtMEAqNrg9FaNIUezbs8B/8gNauIVJAk9bZ75QCjvdmNQbnHGjx6QPGXCpcmbrb0Ci3QzzN/ad8VZxD6ikE0090aYfrSqI/PcpqnNf30+BFsx7sB
 3EJDw1vA
 Rua9gUV8hsWV0TChoC0ytNePc6fMQ9ONpKOyHsPDV6dNRPCjWn0xMhdn+Ri0SXik7NkezVFZ6NpL7/i5XKXyxo+0Gf2s28BYNRzU1gCTVVo/tzrTiiOig5Fr+W19eDrb239wf/x8b2436fXaCPJGBaueCf8U6Kg2Jub00ajcEaqxxDp6pHUfQ5H+QQDrzfeQPLTlQ7Yn7vhsqmwGVrIhTAv/b3BOgP8L3y1qllUfkaVfX4692DlfquhgD5wgvg+eDjqXh69Mfy1fdEbdwMTgWAjd2+LVyjyIUkrFC+Hl7dBqBCHJ3A+9JfGq7S+POoFjCjfJUYjX/tm/8MvbHtGOHPBxnlbBPkTSqr2+hOlN4vSau3d8ZuGYvGgCB9UcnhAKYqKfoJKoYIeLlrz0TmAide/iM6AZzRnW77sURBmGqg6bSwEMgYSMSMMyalDZwlGkS36abAQLDtgKA8YcLGuHEYCQeRXNWe1BwhAgTsWvste90p6apWyRSiq2vjX4ZVOUObn93FNjv9ef5+pA/8+Bkr5TblIx0kW/iMlMngTCwev1wrcFVnW1opLJp+QrszKXsCXCdrfXalKt1ZvYbbRMRIrKetIrBj26Szsb1HfDhbfgSO2m/KOcZz2WyeipQ6u1mkIL5qyyQhad5Z80Mqu2zK59Z107cCrVnsTlUmALuUC7/59AoN8P2e90W7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The UAPI comment advises keeping SEMOPM at or below 1000 because a larger=
=0A=
operation array may fail due to physical memory fragmentation.=0A=
=0A=
Commit e4243b8062c1 ("ipc/sem: play nicer with large nsops allocations")=0A=
changed the operation array to kvmalloc() specifically to support larger=0A=
configured limits, with vmalloc fallback when a physically contiguous=0A=
allocation is unavailable.=0A=
=0A=
Replace the obsolete warning with a description of the compiled-in=0A=
default and the runtime sysctl.=0A=
=0A=
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 include/uapi/linux/sem.h | 7 +++----=0A=
 1 file changed, 3 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h=0A=
index 75aa3b273cd99..d9f961a1592c7 100644=0A=
--- a/include/uapi/linux/sem.h=0A=
+++ b/include/uapi/linux/sem.h=0A=
@@ -71,16 +71,15 @@ struct  seminfo {=0A=
  * The values has been chosen to be larger than necessary for any=0A=
  * known configuration.=0A=
  *=0A=
- * SEMOPM should not be increased beyond 1000, otherwise there is the=0A=
- * risk that semop()/semtimedop() fails due to kernel memory fragmentation=
 when=0A=
- * allocating the sop array.=0A=
+ * SEMOPM is the default maximum number of operations per semop() call. Th=
e=0A=
+ * runtime limit can be changed through /proc/sys/kernel/sem.=0A=
  */=0A=
 =0A=
 =0A=
 #define SEMMNI  32000           /* <=3D IPCMNI  max # of semaphore identif=
iers */=0A=
 #define SEMMSL  32000           /* <=3D INT_MAX max num of semaphores per =
id */=0A=
 #define SEMMNS  (SEMMNI*SEMMSL) /* <=3D INT_MAX max # of semaphores in sys=
tem */=0A=
-#define SEMOPM  500	        /* <=3D 1 000 max num of ops per semop call */=
=0A=
+#define SEMOPM  500	        /* <=3D INT_MAX max num of ops per semop call =
*/=0A=
 #define SEMVMX  32767           /* <=3D 32767 semaphore maximum value */=
=0A=
 #define SEMAEM  SEMVMX          /* adjust on exit max value */=0A=
 =0A=
-- =0A=
2.43.0=0A=
=0A=

