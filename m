Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F6EE91299
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E546B00B8; Thu,  5 Feb 2026 04:21:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBFD6B00B9; Thu,  5 Feb 2026 04:21:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0D96B00BA; Thu,  5 Feb 2026 04:21:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32DD26B00B8
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:21:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E13AA13ADC9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:21:23 +0000 (UTC)
X-FDA: 84409859646.24.A5810F4
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazolkn19011030.outbound.protection.outlook.com [52.103.39.30])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F8CC40012
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:21:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=p87DPeUz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of dcb314@hotmail.com designates 52.103.39.30 as permitted sender) smtp.mailfrom=dcb314@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770283281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=On/GZKkBXZFFCIx/x2U/paoXXhkuYJlLJQutLOn9SK4=;
	b=8haZEd//WG8VQQ/uQOwKgi+8CIwC66lj7uMr6ZmbtDF0+MMt3lGiR5SCgG4G9FotvFhwjZ
	a/VdAJ30unGfCisVCC8ajOLAba8cuLpS0jU1FiNmrGsJ4UEtqCYzuKdnwQxmJZvGl5n1JA
	lQTR2hd4SkLeD037U5zbnxcffwpcJoA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770283281; a=rsa-sha256;
	cv=pass;
	b=JabMljNZeSnl7Jv+Hri4vVQzmg7a6mS6pWcjXOcnc/LNFKqnBxgvYRyxVSHNKAOXjKFqjt
	wa8HwWXgWVb2N3nwcaqbIJ9zF16JaZNZxKE8m9KLlDyQ9bkZ48SXlnWNqDPr3Ptb6cW53e
	rH2M9zuMRaz0gS4G4Xe/VdMJw992l/Y=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=p87DPeUz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of dcb314@hotmail.com designates 52.103.39.30 as permitted sender) smtp.mailfrom=dcb314@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+8d8cZZ+1SsBjX6VdKUsa8MVKrfDaDjlASf60qpVcGiIJw78cUBCZb8oyU5KhdcExr3FIPXJAW6WgKKxrfIMnEBAuvm36Hg9Jvy6ZU2Lsyqh2JFfweKXVdF9DGXc0QCJZTkA8UjYb7b0tBlrtcJtIYIqrzpeH5ffj0mRXX/jCiMjEzAk8T6LofeLmboavhp8bOfFfemTFUSu/WlL4Wmmzsh5MK9LaswFZXBKNPvBmcYQpPOnfZ2rVvulj3FkZ1lBSCSLvCIqQ2pr05eikkUtFpcDFb9uIMOHPv30zoLyZm34mVaM3R18U6GktddyNdJOrkXUePldlAHJJquHLpXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=On/GZKkBXZFFCIx/x2U/paoXXhkuYJlLJQutLOn9SK4=;
 b=Mk5kh8oN+q9GWYJNRqHF+OAnpaLzfNjCdMjwckQnE7IzEXIg0uphf8jcEKYJ2nZ8/vDp3v+Cj7mHn4zUNaOeGUYP1Taoo+27RDZ8KoNVFGd/79rOkn8PTrL+sMPNesReac935nj/H2f4Hf53pzwRRIs0QU9sk1795lIqfp9ZcxvGVSjYEim2xsPFz9mSSywFqur1Z8ctQ9eIEKAxHDZNZ+BoCru5/UEKznBWiIcuWhePWiEnLKT/5ztZmj36mVj3vPx29mzP6qQlHju/XeFyJKsQT6atAX3yWWIBASq33WFs1Iwt/cMVttAInjECJtEmMq1vmKSVexzh3Jl2hsaxRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=On/GZKkBXZFFCIx/x2U/paoXXhkuYJlLJQutLOn9SK4=;
 b=p87DPeUzabgBqxXeIkSBWC/aPlBB10hjp3Ha/3WABDueFv+IkgCs72mpXLwWI+GksfbRI3bolA4xFWjJRKHICyowc62ntttEce9XB7t/Rffl/ZiB8Ym5ysQ93RXu1VMk1khdvJ2Q6r1Uihyom2d8HS45cHiR9tbvUUBOgCp22UsABjD+PTEF5EHXRAwtG1ZdKwFcddMvY4VGp2H2MTdVT1Pe2ri/+PGtSyS7UPhVSCbognaW8UVG0oagk7h9s6GEULZGHObb3gdVdP3UOJ4mbJLXTiyLPhh80z2u4Q9F751Zyvp+J/+VSm5OZdfOyhkOO8WPm0Yc3OI7TQw5E/4rSg==
Received: from VI1PR02MB3952.eurprd02.prod.outlook.com (2603:10a6:803:85::14)
 by VI1PR02MB5838.eurprd02.prod.outlook.com (2603:10a6:803:130::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 09:21:17 +0000
Received: from VI1PR02MB3952.eurprd02.prod.outlook.com
 ([fe80::7280:4925:465e:c1d2]) by VI1PR02MB3952.eurprd02.prod.outlook.com
 ([fe80::7280:4925:465e:c1d2%3]) with mapi id 15.20.9564.016; Thu, 5 Feb 2026
 09:21:17 +0000
From: David Binderman <dcb314@hotmail.com>
To: "graf@amazon.com" <graf@amazon.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
	"pratyush@kernel.org" <pratyush@kernel.org>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML
	<linux-kernel@vger.kernel.org>
Subject: linux-6.19-rc8/kernel/liveupdate/kexec_handover.c:1089: Possible
 32/64 bit mixup ?
Thread-Topic: linux-6.19-rc8/kernel/liveupdate/kexec_handover.c:1089: Possible
 32/64 bit mixup ?
Thread-Index: AQHcln/yvhRC8XsY60+2Xue/ZW7Yfg==
Date: Thu, 5 Feb 2026 09:21:17 +0000
Message-ID:
 <VI1PR02MB3952964EF347629B2686A36E9C99A@VI1PR02MB3952.eurprd02.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR02MB3952:EE_|VI1PR02MB5838:EE_
x-ms-office365-filtering-correlation-id: d5069706-6f43-4f66-8fe6-08de6497eaf0
x-ms-exchange-slblob-mailprops:
 7qh87CJt6y2KqegnoS4V+KljWAyhwvUzsmGSdUg8ignxq5//TS5BfUBHb+D/JEpaLxPMNfaJiLQdcxn14R4Eckk+/lVVApA5jI4k0yDcSN3J8JoaFIwp1PNHAlUF19kx5TEjO6WHA0EfwXVe7RYJLEqP+otWdKoUtCjlaWnmodi3imnvu6yUM6fh2PggEjSpuZvpZbz8coBkArUK2KxbOgwRDfAMtSS2d/X6OvZf0AJGk7YSO3spAdpSe2Rv867AbQvheZsXlbte0KViczWvja9mP9SKxDEcyBPnWrsAV8COapxAt4o+2r5TjFxOOxLYvdN7oZcU2KkNzAvMep00SJq0uS9uSvMC10OyhNsJFUbY7ltCeR10EyLG8OgS3IIMKD4b2jPJ4oDA8ViIw6qedh0zeT9Edgi9pZJtFW0VtApKXDRqhPMdaGAc7MktWS9bKXWQUZIs1ksXvNCrd8memmcWyuSnQnquvPp31PLEG9dV0r8aaaIQtAaWPmkBgLsAJwq8a3bKXXP1dHDcIke7HS0A26ehX2ohX0ABWGa9OmNECj5L6s2MsOUKGKGsP0BA6v5qEEpx8KpxWu2zZr+Cj/HmrLFFzLRQ78jUEjIekQCjRwFTu8t7+gT/HoRVPFcADmV0l6ahE6uwS3FlfADhoKNxT/2Rwoz8Mi5GwpMnO7wxtUR899mSEviCqUEYsnm8QgwnTBqK7Q+wzTnDaHbPXzY2iw8/GKmgp2DZm3p/QhyfAdzgnqgDeqqpWhs1w27z
x-microsoft-antispam:
 BCL:0;ARA:14566002|8062599012|19110799012|39105399006|31061999003|15030799006|15080799012|8060799015|461199028|40105399003|440099028|3412199025|102099032|21999032;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ew+j7QutkmwKahXgnymVt9+PcpKSVpeGDUWEnbC1inczxMjEgh4Mkd1kJt?=
 =?iso-8859-1?Q?2fgW05wXtUGKcztg77X/XuzOpDdxsJlAWqH7MkgLtj8AN9ldOWEpGWpwkd?=
 =?iso-8859-1?Q?KjnJoblT4+IxrnbZUztwMKReDYwWBIL/ujJdr+mcFddqHjR98xCvCZO6cT?=
 =?iso-8859-1?Q?jf8XqRiR8P9VkZSHfoImqP6HJIV8UEumT/torJfDitI5zivlzJFGYAvN5L?=
 =?iso-8859-1?Q?cdfNbkhS31x6Z14+KQEQVOgMkKRYIuK5ojdUuSCPHl3RoPr2rLsDUbqDEz?=
 =?iso-8859-1?Q?+BFc20NYxwT9uaE9iTHkViLZOM30cymwdNx+jyGfyzRqutK314lKEOKTb/?=
 =?iso-8859-1?Q?/vRmEBEO4rZ/S2vj4v8yjegTuZKMtRSyHpYjuoL2PJnWD+3Vdb+6fcZ633?=
 =?iso-8859-1?Q?ldSlloNtndSelcTFKu8U54MfL+BPV01yh+h5XDCHg+/dieWHU1M3bUv77k?=
 =?iso-8859-1?Q?GV1n6koCLNFF8ZUYXFhTLYJiJjQBuszV4g1zPcT1Cj74V3Y0WDAxdZrBf8?=
 =?iso-8859-1?Q?TYQbAvXjOclVrI+4ME8QSrFka2X1npVElZZSCyGaNrNumhFRhjCPj+oAVt?=
 =?iso-8859-1?Q?9/xMVKp9SPIpp+wAxVfj63Nc8ak1Y6imSsdSvSHfW9NXlRXGK5riSdjmGl?=
 =?iso-8859-1?Q?5GSTMx96W6eToKBNiePLsoRFdiCN2rwOCa9fArYNXXk2d7mdri9Ln/48Ye?=
 =?iso-8859-1?Q?fUAa4FDblQY9edmfePKBTy98odL8UY1dQEPzTzhzfbVKY8lyM03iWQy0yU?=
 =?iso-8859-1?Q?vogUBJHfEiDiAlR/lGP7YXTGTVmb/x793YTCgvUaUXvqWsFEro/xAZ3Un8?=
 =?iso-8859-1?Q?CX0CbpIPwAaHNTD2Zn4eCbAXpjLFgB+ZbWHB/TgTejdnwzgA14RKKkzxIz?=
 =?iso-8859-1?Q?HwhNIU84nMQYHQOQjX+xUeSDcWrsEvX1gTji15VBLg/QB/GBsq0Mrdl3fu?=
 =?iso-8859-1?Q?I+odMZZyS8l5w0E4j4j7g254a+ejyuKeQupkYiwrvfJPsxm8qS/0xRmbBz?=
 =?iso-8859-1?Q?buvJ99LZ7kt7a171apLNRcYwQgs2JGVeeAARSxCH9pT39TbedLaFGNPyME?=
 =?iso-8859-1?Q?rJS5NJbGU+y1Reaz7/RtkLO8xfRBz29uTYUmA74xZp0sT0pKZiPnxtRoQ2?=
 =?iso-8859-1?Q?2jV8vowa+/pgXEv/KWnq4zAUjLOGzkjHhC7RJgjp9YcwCZs7+JmArNpMlD?=
 =?iso-8859-1?Q?X4fTv3er5Rdu/sdmrnehvBICEAXYht7TNEYXHViH/05Rq2mtCnurQ5289H?=
 =?iso-8859-1?Q?/5H90hSMLYT58kE2YFeA=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?PuYEo6lKtzsuFFGnN4Y9YcxnDssn1KGlfRfy8HN9pBosnXkBFP0SSwNcuO?=
 =?iso-8859-1?Q?1L980Ba+Q7nBe5+sqxZ6wMEWO1/uyC56HClzteweQM9c2Ip3QynDOtmQs2?=
 =?iso-8859-1?Q?Yp3gyHHe1JzIFnpnYz9b3MaQgeKIaK+02lMCjcHy6USXU4PCEOE3h/0rro?=
 =?iso-8859-1?Q?dl8fLVTjR3O/hzKCQumOWu/VrP5MbfepxlaY9du1WlDUm2Hb1oNiUT6EH3?=
 =?iso-8859-1?Q?dsNOphRa80C61FNkqKA3V/0rlwweeWxA6nyZttUo8JxdbjjpiyzFBa8dQI?=
 =?iso-8859-1?Q?lTztMB+tp8GY2XZLM5Vqn9nGEDdC7JZf/8GRMBImgxcrkrnzuaVW3ucmRz?=
 =?iso-8859-1?Q?PYGbo+DzvEKOc/5kfmXrODPVIz4Tr2WHaAbZeIAjMhphNYiRm2qSQLTrrJ?=
 =?iso-8859-1?Q?4ZhNaIu3AL4mYf289kxsKiSDP8/Pr6RS+GLWMLsvLXd4ttOT38dCUDaxoL?=
 =?iso-8859-1?Q?p/NQikueoldFZ9aM1T2x1inAW2w8ZuVvaBNmCvYzjvwW5MA5P36uSdZqhW?=
 =?iso-8859-1?Q?lKhIHviv7GauucHGWuMdm0cuQ1BWFrQRRWlFOG+gMK77fpAM64dfaSLmZ2?=
 =?iso-8859-1?Q?mmwrNqyC4bxYXyc++ENUCx7Pvo/h2r/LZF7jEF3Kd1sCuztiqNBCSk43hk?=
 =?iso-8859-1?Q?8hZX9iMHGS4L5z2jOt71GRdewdjIyJMpCI1yuk0fCpI1/iAa23mPSqf9hp?=
 =?iso-8859-1?Q?UnmsHFS3+9AkBmGe9er0q2/2Oz665BlZK7bvKRqfaD3CjjDBVf+qsfeB4A?=
 =?iso-8859-1?Q?6iv4pA12Q2MHZQL7IIqQsTy0W3wsznYUBLh8GeX8N5wrv8c2Asp1dVjA2h?=
 =?iso-8859-1?Q?Pz82IVfozeGnqnL6ADHQjy4S0Lnc/WmNbJwkqf09OjT2+EXYGvgk6rlOxR?=
 =?iso-8859-1?Q?JTflfSVbbiqxCI5MlTyzA83/87D7ypC6BWsTW+VSnT7c0ymT8SpCeNYvel?=
 =?iso-8859-1?Q?u/d3/5y1aNcg3/HvidZWQhM9qxw5z1h3er8BHDOX44xsW0Bz/Gom+8CdTg?=
 =?iso-8859-1?Q?4v4BpD60iBBR6ihjMVEJ7nOohG8lOAUs/5HavxpsesA/SF/Bp5+OTto/bj?=
 =?iso-8859-1?Q?yFW1PMzLrkB50cbjtJu0jfiY+kG1D2Ju8LPo+Nz8n20VHPjCbuH5ZrDfK9?=
 =?iso-8859-1?Q?o53OtnbbHi700hMStqi6GpqWUKqOl2kaMHl4ThONj44mSi4tenOUX9Ry9/?=
 =?iso-8859-1?Q?NZ7WjFZyhPPDTfg3f/o2jN7Vpy/5H6d7Uom9kg3gZaMITwGz2S6Y6P6DNo?=
 =?iso-8859-1?Q?3vCB7VtbaNAqnJtfsBGbwhx4Xg6Xvnj1xe5Bl+AJBUbKYMMFMCmEtUd4WD?=
 =?iso-8859-1?Q?r1JpmbRKGYQ+G3ibd9EY7C5p5wTv4YAkxsrqXTmkQBmgqbz+Rhf/rDJtim?=
 =?iso-8859-1?Q?C2shTGeJn8ObTMVXf9m11G4E/xiqro7KB6YrJ1mMrEhHBLgZX7UGTG9F+q?=
 =?iso-8859-1?Q?6Mwvjj18zlsE0+cLXBbUy71VmyPGDrQNoCwT9wV0RlDd8usfI9FhcmFjht?=
 =?iso-8859-1?Q?g=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-c3f6e.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB3952.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d5069706-6f43-4f66-8fe6-08de6497eaf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2026 09:21:17.7031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR02MB5838
X-Rspamd-Queue-Id: 3F8CC40012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: q9xjih687dfn8zdw6s6wjwthb1oks1pp
X-HE-Tag: 1770283280-705426
X-HE-Meta: U2FsdGVkX19WUDbkYhlH+FfOp2Uf+6GcpS79sujCEbIKpqW0+WTSXamPTop0OyXXxzJTP3ZVKxzYFs+jWOJYARGZuCTUK9p5SZNMnpeAiufCuGnyQJDT+4jFHdEhIseRiW95L+2zkIz91NtVfuS8JO4dJfd/bpArn3NmD+OEOGsWHsCsDX8/iiQD5/0E9w8qhBo3qk40kRpWVYfompRS/6OXw07QPp0bulq6THyIUvfNRzIz2otDv1OjXV42DWM+cRo51no9iB3jAPauSQQrgUkKqu4l2RYj9v62X1pziJqHCRiE8++zSRjH4BjkUF5rJfYhY3pERTSr7YskfkhfRlKl+RXWUwXSzp9/khxfb2TpJYXfoSfoYASDrfo8+Y0bFXsvSiPWjT7sJmMC1UMP2IRIMbnJa0MD64JNwl808diI1TFuySKN0Vog4czl/voP4izOgs4qIpx7wOH1qkDyU9vwBO2oCuZE5d0pP+59/o1e4pMxXgMrAe3jY94eqr4Thw5Tv3I4Ui9goLvcFVjrP/t31bCTG9/cMGQX7GZGfOB5lvviiTrPSp9DDCUJWalhND0w1+6fc2bOrOj4V0pfQGkpS5pnBZ54MBhKw4/OiV8pyG52sZKHKjJYaJmZ0T4menpGOEyfEJQXFrdx8ppSK14UohL9ZVfr9EAWdw/qf4dBwXPC31wGcWfqkKJ3uHqbk5Ll4EeEUsrMbHvYZwamOuoU1+gnXLJ4ngXO3RprY81YnelReI4wwkrEv6qcpm+6yZ+XWH3bVLMOI3NJmlEY69fqcy1xhWuamOkIXIYVQBaOSlJ1+8Cpjeov3G366pQ3JjMN9GuD/KzbZ3eABIOE821R+24+Mf9eL7aCG1oE1Zt04+yUxA6R1Ps200iZNPQQ0WhGjHiUaAzQ/ue435hw1kflqhvGz0n7G/gCK/ZHsUQgTdlUgaceVa68Fy3kaftkYkkYLe9+NBCEaxTN/kk
 jVQeII6P
 Kscp9QOwLE92TMCeL/6R1EoHCPgTcb4Gcv2rQ2WnNQJsHwifB2Y/OYT8XG3hTRAGg8SnEddF+I+RThn9RRDIDCpFszvtxb68o3yo2Zd/PgEBiu0rdTTq5go35vuTfPLkHzTIt44KlnXE3rrGWVfIM8mYlHCTBJI/CASRgWe96TY1xYlgOkcTqsn+QTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello there,=0A=
=0A=
Source code analyser cppcheck says:=0A=
=0A=
linux-6.19-rc8/kernel/liveupdate/kexec_handover.c:1089:15: style: int resul=
t is assigned to long variable. If the variable is long to avoid loss of in=
formation, then you have loss of information. [truncLongCastAssignment]=0A=
=0A=
Source code is=0A=
=0A=
    contig_pages =3D (1 << order);=0A=
=0A=
I admit the error message is hard to understand, but AFAIK=0A=
if local variable order remains under 30 or so, then there is no problem.=
=0A=
=0A=
However, if it goes above 32, then there will be loss of data. =0A=
Expression 1 << order is type int.=0A=
=0A=
Suggest add some code or comment to document the expected range=0A=
of local variable order. If it ever goes above 32, suggest new code=0A=
=0A=
    contig_pages =3D 1UL << order;=0A=
=0A=
Regards=0A=
=0A=
David Binderman=

