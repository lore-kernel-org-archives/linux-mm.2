Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50AAFE81A36
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870756B0005; Mon, 16 Feb 2026 10:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81ABD6B0088; Mon, 16 Feb 2026 10:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8A36B0089; Mon, 16 Feb 2026 10:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1516B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:34:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E8E6BE02F
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:34:52 +0000 (UTC)
X-FDA: 84450717624.07.24EB1D0
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazolkn19012053.outbound.protection.outlook.com [52.103.2.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 00F074000F
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:34:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=Fy0TUAGq;
	spf=pass (imf04.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.2.53 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771256089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HD1caESgMUAoHdncCQposqfL8Adrw0WkWTSG8FVAw1I=;
	b=txJRaIukrHzx30cE9qISKmSbUH0cdeBfOUMUFPJlaO53SWufmj4X+q/STv0C53i2sd6yK5
	/6pAdXyWk3zm6m87BP6mnnA2+PELRMy6HG10rgpiZhYIb8q5/CdJhLVLaXYZoRQY/JsgDh
	Y7WCX08NcZWL8KcLRFwexLsR9e3VMtw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=Fy0TUAGq;
	spf=pass (imf04.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.2.53 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771256089; a=rsa-sha256;
	cv=pass;
	b=bmy7aIFqloGhhFi5v7crGNJsCY2A7NU+YvX4cygE+h641ZW8l1ltEIi+inaoCa0REdAhzl
	7oZaATHPTxVvMojHBAcCb2huKQUBM6UVShEuLuBK0XMvpCKftF5eZHu5i9s42vJMO/aI8r
	QA22wA0idVjR86EnoIeYC1LHfLA9VKY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vnTnJXes9RgDi3kVnefjG/Q53yHm2P5xiJRromeBn7CI9Z9bPAbw9P9CmcJX4Ot0qyY8mwJEniTCJ43m7+/rykNk2MO74aRSVjJjcchqU0MooeqCBxpzdAHBZTyC5IvWqgPlzRhhh66EyfdRnPk2xge+7GVGNIPsDiEB2CuW0ukSByQ6Hf3DP37rIOdv+OcFFxYdx3NESvx6ZoT0yNarwPfKB2binSQLPX5eN0z3cdLbqoCIybrZ0OU0jCMULjZeZdp0uTwI8a2pKikKYO/TAsPuDiR4GvuV+lnwUk2Ia2vrp7HCkMJj8qhDmmpJNS4Wd9D+kaFKCfj7Niotnb0+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HD1caESgMUAoHdncCQposqfL8Adrw0WkWTSG8FVAw1I=;
 b=sFSG1+uvPISx4qCZlYfBnnouKBf9ZF5d5ulu8cMT1Qic7KXawhsK8Grrxqa2lW8VtYkyd+S0ZoYyuDGCLJSbjRsqB/nAUy/JUAS3QqjMbQt1LTS1Sf1Mfrjb+lRLxkHXfCnDgQ1F4hzXCwd0SMf1Uxd9Cs2BeTZrVa7c2NXnxbAay1y3O+mmGw4hoz658pvY72pENmF7m8rHPZkrktZxvGS1WPp4zCVtgHbE001JTGMNG8liR/o0mZC9bynEG9fRF30le2JeyfLArdvP8HmVHqrfyCbLwo/i3fFclJAMZhU6kUcK4Cu/5rIIEPsqJTY3JlvNuX0Jh1MyqaEqxfYn9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HD1caESgMUAoHdncCQposqfL8Adrw0WkWTSG8FVAw1I=;
 b=Fy0TUAGqlzbjRxelmBujT1r7FRWF9AbQuglL3aqRIoWK2xtTioCIXepw+ACYy11nZXB6dicV+7ZYAnnIxWQteR/BUtLmSvfsjUS1xUY0LBV1K1/PqZL1BqOPafiBBnFKeFAuionJMW22YrxONjXdc+r3sYrbYiyMOYqLGAajVhw0JYrJfF/zZJ52Gb77yugBuzccTgDhJl7P6yDripJFbnVVYBtK84pWzrjDQnXHPakL/ioidRvWH/jH5Y8A18MX7Vv+/8dd1el1xWOOBFnFl6ALYDIt4C2t6Ukb6vXaTCxXxq8JDcfc2Q8u69Qqc+UtIIwVYgk/2A33T7CoNFKSQA==
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com (2603:10d6:103:2c6::9)
 by CPUPR80MB7307.lamprd80.prod.outlook.com (2603:10d6:103:1f8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 15:34:45 +0000
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82]) by CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82%6]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 15:34:45 +0000
From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
To: "sj@kernel.org" <sj@kernel.org>
CC: "security@kernel.org" <security@kernel.org>, "damon@lists.linux.dev"
	<damon@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [BUG] mm/damon/core: dangling walk_control pointer in damos_walk() on
 inactive context
Thread-Topic: [BUG] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Thread-Index: AQHcn1mbZ6+3hbtq+UqnnhH5daxyMg==
Date: Mon, 16 Feb 2026 15:34:44 +0000
Message-ID:
 <CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
Accept-Language: pt-BR, en-US
Content-Language: pt-BR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CPUPR80MB8171:EE_|CPUPR80MB7307:EE_
x-ms-office365-filtering-correlation-id: 40f1201f-fd88-40ec-36f0-08de6d70e922
x-microsoft-antispam:
 BCL:0;ARA:14566002|51005399006|15080799012|15030799006|19110799012|461199028|31061999003|41001999006|8060799015|8062599012|40105399003|3412199025|440099028|102099032|26104999006;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?y1Dy45D/5uQbPU13DHy6SQExfdCjLGy79UDPJUKoMom7Dow4VgDRFGFPED?=
 =?iso-8859-1?Q?rMIBFgiF4o+UrPtxCPijiDhyOv4XovPhKlbQVLFeoi1CJgo8jZTsQTJMAS?=
 =?iso-8859-1?Q?JF8HB0ahy7BR/pndHdbUo05wIAt80m5FVNUS4LS/m1Pu2xEJqt6br9jKjz?=
 =?iso-8859-1?Q?wVRebEdNLfSu0sBf2F8RfjImEzzhhwWsbLfiiARMHYWpJcaoYBimRjZeFq?=
 =?iso-8859-1?Q?0crtLWETSqHzeDRHMEu3GljE+NdIpCAbSNG4xpKj/69l3DO4KsNWr6Nos8?=
 =?iso-8859-1?Q?6Bpujgxqc6EcLUFLzfnXUhNvu7cLSN6cOSiaOlduHtXCaILH9ZyMZMTtCo?=
 =?iso-8859-1?Q?my3+whf0d7B4jIY6YF5U3c9fAAB8HGxKYdgwK5Up0JLjPZJFKvgygtsSQS?=
 =?iso-8859-1?Q?cvYfnU5FfGPL3uVA5TCsb5mCsiKYERS7Aa0alSnohiBjdPpy6uDEjHUTbx?=
 =?iso-8859-1?Q?MfZPwYxvjmGpYMP9nMWneXn1UkvRC1HqPseJgjJTXgK3VBJ76n2CIgOskT?=
 =?iso-8859-1?Q?cMZFs9+vl3wLqj/dXsmVCDGgMU04Ii0D9sR7IG+qDkNO0NiTbw5XfUyolT?=
 =?iso-8859-1?Q?zp4aBtIAqJ9i9no9URsPQkwhG0JyJI6PzjZea67/CJZyklogr1FmKmhOt1?=
 =?iso-8859-1?Q?iVEhhhhnvg51d7F7+Iu/XsJGO+oBdXRXyHhS6MHeLlmaV3Gf5BYVmjJssJ?=
 =?iso-8859-1?Q?g6oaY7tbAjnqqRacmJfrp3g+fOFebf3A6dpk+sToSHdEakQWKhHUimr/+D?=
 =?iso-8859-1?Q?iJ2PVyc9K+N2H7gdRtrryxyUt+BHZVPaIgDdcb3eXPEo8vVG2qqH5U/TVm?=
 =?iso-8859-1?Q?0fsAVfY2VUsPU6vMmQjeEVF7ORzniEHdUSAW1j4Z/2KEnv8OPzmFox9MIs?=
 =?iso-8859-1?Q?9LP8n/qWUWqXikDyafjb/likhxZ0pRUX6/rcqWzdSOo32XEOI1y21ECMWc?=
 =?iso-8859-1?Q?TjAsrlfixKqdUZjzfL/vmpgZYNJ2/Wzllm7xmmsoBizYMAu8pkrSfQc5+M?=
 =?iso-8859-1?Q?ZqqEwR/9A59L/nLBkvbE2rfVP6NRq2TjGPbDH+iUhAEkr9XDDepLElZGN7?=
 =?iso-8859-1?Q?Qcpg5BIegm0SsE4va4raY7H9zwGT1HtyCes+7yKtnK7lZhZ9FtcLNEjeJx?=
 =?iso-8859-1?Q?zLAdMqUrvqssoUhizcJn24+X8ahYsTXd6UiUTQMNwA/QVcGdG70pnR6jEP?=
 =?iso-8859-1?Q?vaa8bdyEQRoO0JK4dZ8KHb/md1+NrVsZrYoW9X9YecVPVlIsLIuYwaRx0P?=
 =?iso-8859-1?Q?DpEafwocqJ2DNLqqUKFCZgeVHPYtV2Z6FpDH2k9qLAnKQYvgf28Ur0OVXC?=
 =?iso-8859-1?Q?PlYbGURmA7V/KQ+0fvJGoPla6w=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Je+KAWVzreXxSlhhl2BHmClA9sE+2Tw8vdadYhwrJYkFLVIOOUPZKMwrGS?=
 =?iso-8859-1?Q?ZZnDFta4kHeZV+CODM+X3nkUkc8nHHjSicVhUD6nwy3/zEjF1Kz76C7FbG?=
 =?iso-8859-1?Q?OahK5bBM/WsdxtrRWxg6KiQ1xQ304+LIODNpreIaZMw7Xj4u96SWMp1LR4?=
 =?iso-8859-1?Q?KA0HpBkCMXCK1Q7Mkt+gRl/iCAeeXLjfUKqTnHQTosAbRDMGtit7A87xZW?=
 =?iso-8859-1?Q?3VuMtSY/el/jsMIQ4zFJYhX2yesFIVH7sH325LukpvPvGOrWIhkEAy9qq8?=
 =?iso-8859-1?Q?+BA4LEx3KO+gi2z5nebRQiR4DE/k/hTEfJYfgXoYzn/Eru933/DCMMpIo/?=
 =?iso-8859-1?Q?CHqZs48b23sjH6/iahrjaxiRAbb0mRBMSBos++IwZlo8yIYaPyFa2DXRMT?=
 =?iso-8859-1?Q?6n65XGubOw6aaf45RoJYrqQYa/5jSabsJ68Y74TeVpIi/PweiUSpqQ8aOO?=
 =?iso-8859-1?Q?VlU9wN2XPtGGOhYiN46XMATiwrWbo7misenHMmrreGaqj9Ri7ofZKou+8+?=
 =?iso-8859-1?Q?2o0w796f+J2NlxpFajlWs1x8C2ptxJt3m7J4H59Hu3xlS9Q1xyb5Lsh510?=
 =?iso-8859-1?Q?OK4pkdJMXkeF5Uwee2PcTJcJSxhU/tH6bifVkdh66XofYehQIUBAs0bCNE?=
 =?iso-8859-1?Q?hmBrB7zdiBv49+tJXFwpbHARGVexpUFOM4Z/cm1C7jHKay8/rJfRFgC4US?=
 =?iso-8859-1?Q?EC+kNJ8ifJILDfm41x3ONoS4cH6htNbm7rRxVZiP1gBYotOQ3gUbJaTumv?=
 =?iso-8859-1?Q?R/NwFuEsRk9bECWNc8jIoEUSARA5Mgsc/0iTMD4ZaQBkYPW1rA2dk7EtWF?=
 =?iso-8859-1?Q?8Yvld37Jvw3fob01PNJsApvtaudyzAI96fdQlKNDkkFnkVFXICCjrbHXCe?=
 =?iso-8859-1?Q?ZExkRS1URYcCeU0c51DMf3L98i51UMnBR8nG4Epeis42KI560cTMr6FjjS?=
 =?iso-8859-1?Q?5/j8Le3LyKnyNwyu8gBH8DuzNYFBu3h2YSiew0k2KqGgCtxKOwBteQOaNM?=
 =?iso-8859-1?Q?dbRZ9Plb6hX+hpbsHkpXRezgHYL2cfp+5Ps4XyA41tolJ2JDXx3Ofejw6Q?=
 =?iso-8859-1?Q?5wp6ntNjNLXQaWKj9V46WbCMREimzX1OIIzik2hPlOob1/RKRYz4trEUnr?=
 =?iso-8859-1?Q?kS82+2XBPMvuQDWFKFHfJrZy3WfI/8+DdmbY7qJ+q1Ce9VzvKix6yO+Lbl?=
 =?iso-8859-1?Q?hZ8UXDJNfzWM8E6YcDWDQflKcItllcOfWDLvbk5XQyzqjxrsXQLbA3PSTo?=
 =?iso-8859-1?Q?xUlWmCUh22SYrBbQW5SkZFUTIip27KKpOd7PHncSdCQaTNmHr8LAjSHOcu?=
 =?iso-8859-1?Q?exepmYLd5Y04yaSg0noblk/BvjusNlYJMWvD/AqgSjSyOnSP2OHvT59NKT?=
 =?iso-8859-1?Q?kakXwLZRVRLHQFRorNwZe8DotItqxZQYrlGXwhee77VW1r5uu7/uxHAyuk?=
 =?iso-8859-1?Q?4xzZffWxq318kqOz9AZ2gSu1D0PsP1P64cnoFIY8a+n6ioKwqlyv62z4D8?=
 =?iso-8859-1?Q?5iof2nfa/JadD+aJOYbiP+?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-8eed7.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CPUPR80MB8171.lamprd80.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f1201f-fd88-40ec-36f0-08de6d70e922
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2026 15:34:44.8026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CPUPR80MB7307
X-Rspam-User: 
X-Rspamd-Queue-Id: 00F074000F
X-Rspamd-Server: rspam07
X-Stat-Signature: gp1u6dyjmmibaacsozfemjpgjg7kmqzq
X-HE-Tag: 1771256088-970227
X-HE-Meta: U2FsdGVkX18MM00GxTg3w7ZFwc7+/a0A5STQMRIqSpmod8EggBulex8royRgkibM3LcjHoxHpao1eMA/JE4aSQrEIwstYYCxSbQ/BPlVW2OYFS6AjzJbfo8m5y/ELEKlMOKSmXt0naEwRhlHmBazMlVgJFs6/Y7kLfi/i/E1tRMI6dLEuhYKZGDce1cZj1ut8EMLIW9s2GANY0XiZfFCnomVl/6m77TSm9/j/QiAeIQfWs9XjNeOn1EpAvuOa37DnwF9OAJRY7uOqOyZ/GL2/otOod6uNDF7FxCzR0RSyisLh7M3LAJfCJKf+t7/U/GNJUEk8cD1u3LHkmiEF+W/ReZz/jVJiNYAySd8xf5UXEnlGkArxWsphztMTiTmy66zxC37G8JgKKSA/0U79SOQ3Kq+l8WRDa4Yzc0eheUOy63SxYONZTGh3fWxKNYYZkuP8flrqRDddmGqEzvbw2inZUg8yJp7ZrbVAtHP9rZu0Mj8VyLsIA2YsLAFu8GR3V5I9b3hpWGv8O8UPdCMxwD64QhouFuNlySVvciLqr/1bKqPSZq4NPilwSlRhrAf5AyPpWDzf3CgQkeuW8MyqUjECcnuptU8HlK7hMHebAnL7dYB1JwhewBJ9MXnUtSbB/Jwq47dvim9SfUt6aB2C4sAPqGLnGCy5IZ6Yp87sx79vln3nH/9LV1VLeG/GQPBrAmI8dIMbJz/loZ9jYJaX4I9n19ljZTT5yvk09S2WTQ7ftQDRszC/nJ/hMncVx3VoNttqWu3C3isHh5RjIBh5lAz4QwGgbbbU9I/k5KvLnSw12zsKwWGw77cztdu7eEtceVXzdi0F9gCu96XGeu/2tBhNdpUEGxxQlvPVRGoGE7bwjlJAOGPoNzPO+s1yMAjsVEnHynNQ5KBKsoJ8MLt/7LA0U6pp+o4J0JUCUVhk5yrsRDj9CU3mvTnxpqUARjXisSN6q8/Sj7VtQ0SvLa50tf
 Jsk0yykK
 EEUMPEfzY3GkF86zI3259kKngK5WnYD3f1qoflH060/Z66icirDVjq76X2qvOsQoqh+v36tSGHB0PQdAIZcLbhlV85hQRaVg0bj0157HtJaj2RXFPu79vfNm7bSYqlwHcinTccp7NMlk1lfzrjOF1WjhGNJyWgZ2CycHLE6rLrt0DWMnDPtqkhCs/DaglWTqAJK+nqHfoQ6eDNYHxvpj4NavtZN93PG+S+l8+kx5nDPGr0PjbPgpBV0JVeu7y8xBaTkW8zC9OCcNHWcSCSGPMibvwWgVuEp32blxX3XF94Q0BS8e33xMpGoJd2YdPqsksisUI0Bdn2jE6M0U+Y2O2DhqNJGn4lDOpoAzZD9Njtq9uIb5GduKclJdnF9AO4D1rukJLi37uYJz75L0AmyPmhZ5P8AFgUd+qt5eY6Vbnd6ZZbilTYfY2firSd3kmhOK5fng5RfsRY1aWQqUMIPmUa9ByGPvi1NouN/rAmPHOSttvbPbjuSQLMOBbDfuonZuRDl3lQpsAvWVlaOpIaAKAFSuTr1GO6aXOf+3NC64EZU8DqGlhMbvWYNmvZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000073, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,=0A=
=0A=
I found a bug in damos_walk() that leaves a dangling walk_control=0A=
pointer when called on an inactive context. The pattern is=0A=
structurally identical to the bug fixed in commit f9132fbc2e83=0A=
("mm/damon/core: remove call_control in inactive contexts") for=0A=
damon_call().=0A=
=0A=
Description=0A=
-----------=0A=
=0A=
damos_walk() sets ctx->walk_control to point to a caller-provided=0A=
stack-allocated control structure (core.c line 1560), then checks=0A=
if the DAMON context is running (line 1562). If the context is=0A=
inactive, it returns -EINVAL (line 1563) WITHOUT clearing=0A=
ctx->walk_control back to NULL.=0A=
=0A=
This leaves a dangling pointer. Subsequent damos_walk() calls see=0A=
the non-NULL stale pointer and return -EBUSY, permanently locking=0A=
the DAMOS tried_regions interface.=0A=
=0A=
Affected versions=0A=
-----------------=0A=
=0A=
Introduced in: commit bf0eaba0ff9c ("mm/damon/core: implement damos_walk()"=
)=0A=
First affected release: v6.14-rc1=0A=
Affected stable releases: v6.14, v6.15, v6.16, v6.17, v6.18, v6.19=0A=
Tested on: 6.19.0 (commit ca4ee40bf13d, QEMU/KVM x86_64)=0A=
Current mainline: UNFIXED=0A=
=0A=
Reproduction (confirmed on 6.19.0, CONFIG_DAMON=3Dy CONFIG_DAMON_SYSFS=3Dy)=
=0A=
------------------------------------------------------------------------=0A=
=0A=
  DAMON=3D/sys/kernel/mm/damon/admin/kdamonds=0A=
=0A=
  # Setup context with scheme=0A=
  echo 1 > $DAMON/nr_kdamonds=0A=
  echo 1 > $DAMON/0/contexts/nr_contexts=0A=
  echo vaddr > $DAMON/0/contexts/0/operations=0A=
  echo 1 > $DAMON/0/contexts/0/targets/nr_targets=0A=
  echo $$ > $DAMON/0/contexts/0/targets/0/pid_target=0A=
  echo 1 > $DAMON/0/contexts/0/schemes/nr_schemes=0A=
  echo stat > $DAMON/0/contexts/0/schemes/0/action=0A=
=0A=
  # Start then stop (ctx stays allocated per sysfs design)=0A=
  echo on > $DAMON/0/state=0A=
  sleep 1=0A=
  echo off > $DAMON/0/state=0A=
  sleep 1=0A=
=0A=
  # Trigger bug: damos_walk() on inactive context=0A=
  echo "update_schemes_tried_regions" > $DAMON/0/state=0A=
  # Returns -EINVAL, walk_control left dangling=0A=
=0A=
  # Confirm: second call gets -EBUSY (dangling pointer !=3D NULL)=0A=
  echo "update_schemes_tried_regions" > $DAMON/0/state=0A=
  # Returns -EBUSY -- interface permanently locked=0A=
=0A=
Tested output=0A=
-------------=0A=
=0A=
  First call:  -EINVAL (Invalid argument)=0A=
  Second call: -EBUSY (Device or resource busy) <-- BUG confirmed=0A=
=0A=
Root cause=0A=
----------=0A=
=0A=
Commit bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")=0A=
introduced this function without cleanup on the -EINVAL error path.=0A=
=0A=
The sibling function damon_call() had the exact same bug and was=0A=
fixed in f9132fbc2e83 by adding damon_call_handle_inactive_ctx()=0A=
which removes the control object when the context is inactive.=0A=
damos_walk() has no equivalent cleanup.=0A=
=0A=
Impact=0A=
------=0A=
=0A=
1. PERMANENT LOCKUP: After on->off->update_schemes_tried_regions,=0A=
   all future tried_regions queries return -EBUSY forever until=0A=
   the DAMON context is destroyed.=0A=
=0A=
2. DANGLING POINTER: ctx->walk_control points to freed stack memory.=0A=
   The struct damos_walk_control contains a function pointer=0A=
   (walk_fn). If any DAMON API consumer reuses the same ctx after=0A=
   damos_walk() returns -EINVAL and kdamond is restarted, it would=0A=
   dereference the dangling pointer in damos_walk_call_walk()=0A=
   (which calls control->walk_fn) or damos_walk_cancel().=0A=
=0A=
Reported-by: Raul <raul_pazemecxas@hotmail.com>=0A=
=0A=
Best regards,=0A=
Raul=0A=

