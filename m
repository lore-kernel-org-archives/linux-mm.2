Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E449606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=M35hu6UN
Received: by kanga.kvack.org (Postfix)
	id 3961D6B032A; Thu, 22 Oct 2026 23:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DF46B032D; Thu, 22 Oct 2026 23:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C296B032F; Thu, 22 Oct 2026 23:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E353E6B032A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:19:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45446801A7
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:19:14 +0000 (UTC)
X-FDA: 85352435028.25.0B47F30
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010021.outbound.protection.outlook.com [52.103.20.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84136140009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:19:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=M35hu6UN;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf26.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.21 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792725551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JCYanH8hcSS4tau1i+r2BdXAet9Ro6m2E5vuWlOwus=;
	b=T3/htToDtg6Vp4eyWX7vE5rd1NOLC3qTAugdl1Zl/C1ED0J7DZq5L42D3vsAPq4GRGp+PE
	dIYbc9mtHKkmw8dgqssPRoeTI/27e5de6eEtOk7KBvDPMDbrbq/ke9hFELA3UmNTFc62Im
	T//GRgOQSMhnZmb8W8HcuhVJJ6jsQo0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=M35hu6UN;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf26.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.21 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792725551;
	b=dhYr2+eF5QWmq78L/dkYqSFYb95OuwhaknXf4dzWUorcdCRszu1l8ciGx6lgBuBFUcoklG
	q6Nyrcnw+9WDa79IOcR6i+x52r6jnmPRHn3O6K8GO/0St6rRjR6VDZDCw0ka91Iw4/SdNj
	xLGxT+WAk8UBzYaps6KTnLQu9VD73rU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G/+SFeCGzQ+oDuGlfX7oawBMTmdEGhjn27hnYdOfzd6FRODUVgbCmH+Iq27WI9d8xm/MsW4hwFBBg2O5JdRVjq4XVnme77zmjW/Iz4RNNKlHxB3GMXrovKIosUYpKFA1hYH7xW3xBW+zq5mvQvNWhh8aolmbvxyqp73ZTBwGTxjaf8sXhekJUJqF9lGjcw7dLnU3ERWZEqxVFyhZWvaqZlnXEjskpLtdrRt2CnkPPRsdzHKbW/+Iq1wxHsrsC0fMCXURjoTpxsYUlXXZVa6Zh1QH7AjOWG8j/0uCbVm532Zh3WRwXBKd9GenmVJZm1aBR5rS6S3DyC2qw6WtE2HOkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=0JCYanH8hcSS4tau1i+r2BdXAet9Ro6m2E5vuWlOwus=;
 b=rnKuAFLmcRQzatzUd2f0Goi5op6Lzc0Gv3imM3TEZ6rgsTJ1k50VxvliUVDrZywzmLxy7WjANN9RnxroWHWMEqRbl614pUP3ATOwGAN0sOFeRcSUj4852NY95tfWvy1S85hALs+3d85UadKpXW1RGHiP9Uv4Ujab7ZaJeTCYr6R4jUeuWVaOg46do/IuOQV3JS1W2+Q1llcytrr89YnhY7PbxLMCrnGro67bdjrx3cIDfMZ6OhvvCtbjEpbtQAYxe7/z8xhWRs2UrSaLL3/P+Pnfea7lqy7SrfyXgD96A6w1RsNNdWiJRtOkraAILGdol8PffWmlcROVnzByY0Kk7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JCYanH8hcSS4tau1i+r2BdXAet9Ro6m2E5vuWlOwus=;
 b=M35hu6UN99yrRNdltxqOulOmbqitNRZYr2rN7tmxCXUOnhI7+jsfK9IA7F9rVZcqCG6pOuBecvJuCt5UkkeVYX1Soo8G1srhvlopzYFpKrYlQUDc5noqZlYydwe4rRSY/aV+5lf7htx9/0grAHv/27PdO6v2KS1HrO5uAvFDM0jg2xiDFfEPgGLSaqrazkz3S/pyrovjzxtuisMsrPthT/DV7SN/9NthJT0T+ZIc5cNHcBQEOjV7gCMa5CBMa2i58X/IzoYh7ajnbVY5sQo3yxibO/43UAMQnLstTmVshCXhyysXkDctX15R0i6j2wf2ZdoRt8O0RAmjfawq8a61DA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DS1PR05MB10613.namprd05.prod.outlook.com
 (2603:10b6:8:218::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Fri, 23 Oct
 2026 03:19:05 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 03:19:05 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul
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
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: [PATCH v2 3/3] ipc/sem: remove obsolete SEMOPM fragmentation warning
Thread-Topic: [PATCH v2 3/3] ipc/sem: remove obsolete SEMOPM fragmentation
 warning
Thread-Index: AQHdYp1AORTj4pQi9U+RHJ+GlDT8vg==
Date: Fri, 23 Oct 2026 03:19:02 +0000
Message-ID:
 <cbd5dc183943d2177e5564f6e8ec92499836c7e5.1792724953.git.x-professor@outlook.com>
References: <cover.1792724953.git.x-professor@outlook.com>
In-Reply-To: <cover.1792724953.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DS1PR05MB10613:EE_
x-ms-office365-filtering-correlation-id: 280a61ae-98f2-4bf8-0776-08df30b464b0
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|24121999003|15080799012|38102599003|31061999003|16051099003|24021099003|4140399003|19110799012|8062599012|8060799015|25010399006|52005399003|40105399003|26121999007|102099032|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?+EIy1WsC1GmahC+3b+LVOOQswnNhv+6DtESwfVho+vRCYPtKg0OUxLZAD2?=
 =?iso-8859-1?Q?XVAkDZZ1bmw92zugSmW85mQVWp7gpkjtqkTaCYnva8JyCMsluStUAKi5Wg?=
 =?iso-8859-1?Q?JAVldwslnTebQtMrQ3WbVKSmlmDS1v2KMu9mt+6wP88qCFxCoKpEU+WbK/?=
 =?iso-8859-1?Q?1e62tXBM0bA+tvPpz3I49O5Vai40SvXj5FIoQL+5UIFNj498n1FYBYDNEh?=
 =?iso-8859-1?Q?ZN7M0vSWr8p/SypIBnoccjysWDQDscrNhpoOTueVHjYy6nV0tT89LTbtB/?=
 =?iso-8859-1?Q?6qXXmQlY58MPRkMvzX+2J7d6XazQgQA1Bzt6w8TeXySPIEr6Dzp2+KoeGj?=
 =?iso-8859-1?Q?QL+L7O7+hII2lp36BnfCQy22+sPhGo06Z8d7tJwnf8k4fwqBdDP6u+iLtf?=
 =?iso-8859-1?Q?fI9SlDaMhZyuFI+afFcXA8dWhr91hG5slGsWME/cgb+Ji1RY5ZRLyj/bdY?=
 =?iso-8859-1?Q?u7Qawe9OykgD79tcpE2fChA+fIH8uSfvLL/xT4tpK8yzV3QCfTNMS9/Lb1?=
 =?iso-8859-1?Q?EUdEjyE4ibQEcEmfwI1jIHVNxjvCc6hSuU51IdoHGX7Zi46NEBM5Fd60Ja?=
 =?iso-8859-1?Q?cgtDmHa09APf/yP56cqevDpc1EiptC6hR8cd9RVkbsJnGCUnNajcp+en9O?=
 =?iso-8859-1?Q?5b4eYPdNZM9lXTi6z55MLSDFkUEbLKcICYEPPpUna2C/G4bTliivAZQyz+?=
 =?iso-8859-1?Q?PSjG/VZhGxM1jrp400v+wuCLeiiDxdLAlvWD79ofUhd/+biWV+9sWVz3o6?=
 =?iso-8859-1?Q?BNJSAdU+Uh9nNKGaexBECras/fUQvM8Uv4x9j7lBEmNJzTVxKHVL1rDrxf?=
 =?iso-8859-1?Q?eh489zCUf7oXZr38LkiQTMjIrKF10QUlGh+J3hDIWb8XuzaTu08bWmtZG2?=
 =?iso-8859-1?Q?C0qMcjc7aUl5n3+F555EL6nOIfyAwoqbdv7oPzg/iskJB3XYpoRBtJ3aEB?=
 =?iso-8859-1?Q?u9wFdQdJUH/qhN254GKzbdOu9ds3NbwqoeE15zdI2sZG3tJOiIPr8FK9Uq?=
 =?iso-8859-1?Q?bDuc0p3bPMw0iCVQ5bo9EavzzF/C3f2qms8u1j+M7KjzCnKwIXWkvcJ/Oa?=
 =?iso-8859-1?Q?ni/PY2tYmYPMr2CUAOJ/tM8xbKJN3X/lAfHtdoIH+DEsxWS06YkuxI/835?=
 =?iso-8859-1?Q?WFrHnJ4T+6lYkAByGWPkXx5oXdyH2U6tCgkDY9aUP9nbkLyggi?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?hSLi5xRs8tXnI9/ZdFcNF5JveStganvXDWahGVmjb7t84LrG4ep5pWnkMR?=
 =?iso-8859-1?Q?WnKzRokkUJK+Q7QFwvygL5MUZqVYt7nWlveQ2kFhyAgPqWLjjpMkF1SrjB?=
 =?iso-8859-1?Q?+cpjQvMZX2y8b9bWLQvi6j+AZhwsc7uVgkrSSh6KxQ9svyRfTXQflxchAW?=
 =?iso-8859-1?Q?Uqqp0JpQmodbaWoGPxkUIVhFFNcOVHEt1cQNaoK6kJQzMwgOdr2/7wd0QB?=
 =?iso-8859-1?Q?mF/BaOdTHhxALqgHkO4uoJ1DW5D7Di/RQcMwjb885f+tx8x83F/2hdC44f?=
 =?iso-8859-1?Q?hbuz8C/c4P53TjjbwC62YIIOjK8/9vw4k7RQMHlU7TsEhBlWGdsoJ4nXEs?=
 =?iso-8859-1?Q?+njB/+UHAhWmbkxf8pjfAk4fvJwwLd7oxsompju3VIhMfVSwH0NnPW+0pg?=
 =?iso-8859-1?Q?06+f9Rpa+THaj0VI2NVcvK1mFq/uVB2MHFLK0dThhKn97JokC7f1+25de8?=
 =?iso-8859-1?Q?AUVzzX6/5AdfyvJljhbpwYzPywGHA8GILl9kcreTEprPyxluF32sBSgUFh?=
 =?iso-8859-1?Q?F5UL+AZsy1ZNhSivQcQ7go0klmw29+sNBKAOoCiHHWbm5HxQPWLF51uQb9?=
 =?iso-8859-1?Q?Ut8quJ2Gup9B4UrqX3KBv/zAhcBtmvJPO40eKCtvY6qrUUm2M7p2MO062P?=
 =?iso-8859-1?Q?VOKKPC13TAeFZq1H/fdVBJqAcXFtWaZx/65M7LU2wWCq3gfsnP0gWu4epO?=
 =?iso-8859-1?Q?HmqE9oyqD4Yu/RNc1h5IrRwfovVCLjEJqi87MlVgtiRFW+o3W6A/VPP26m?=
 =?iso-8859-1?Q?hbDWFuqt4w3tc845pIjUKHrdFlwXSCJtVmHnsOfwDxFuguT7W4E7f9RIzA?=
 =?iso-8859-1?Q?wei0j7JDdkirud5MlI0QdEhnPET1XY3IS8r7p9zYoHmd3b99hSqY0GSBTp?=
 =?iso-8859-1?Q?olrvg30k1hMM9SHaJNjgFEBpbDpXlIV6OFIk5TrLig7NduiEJ11oVAQ7OX?=
 =?iso-8859-1?Q?vM1OiacVfTgHp5mCLgtW5LvVF17nwurumd+QZ9JmrTJSoyBbfN7/Oueb44?=
 =?iso-8859-1?Q?U3VQauMY56OKBzxIZoGDaeulmCVo8e/F3YVp41EP7RmplpuQivGxhFExSI?=
 =?iso-8859-1?Q?CXTh8F1Y+HULALq1wWVw5Oae45ooe94ANJI0K2lWN6nP06YcjcfFgHn7Us?=
 =?iso-8859-1?Q?y28FTJYZX7/Z67zNAksKkeinTlmS1ZxxGkrBQCndL3Q0l5uRGPUXBwq9vX?=
 =?iso-8859-1?Q?1wBJpsVO2+TxvUiiPb7iNBlDQhufzWZfe1xblRGf3a5VNpS5TP2XLY+kCn?=
 =?iso-8859-1?Q?A2WqK909DrTcFun2v994sXv8DilAMEXbMJs9WvtOGapZ4PW5xNAw+udUCG?=
 =?iso-8859-1?Q?2BpttnFQLNj52SIF+M1dqdZkW3KT10p300kgRzBAUliQjYgT7gx6u14IBc?=
 =?iso-8859-1?Q?QmuSGw8Kcd5jc9FDtpWViw+5Zxl68a8dNgFs1N3tElbcAOn3acDe17bRV1?=
 =?iso-8859-1?Q?q/eK7BT3jUxrem1D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 280a61ae-98f2-4bf8-0776-08df30b464b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 03:19:02.0681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR05MB10613
X-Rspamd-Queue-Id: 84136140009
X-Stat-Signature: fdgdmaqx4my1fdwjy7suapkymh63d6pb
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792725551-609933
X-HE-Meta: U2FsdGVkX1+biiDuGBkrKaeQqHjXglUAcKfD+HQbPPnbWiK3iBpb2qs59xK7wgMIfrHHFq/qpvf0K+updMG3LXdOEQTuAMIU8w2k/WtNUpiayM7U+O9O63+k5i2XVIhVSvuMaT/LQ+froOcg+BHS5+Ej0Aa9F+9Yp7HcUSdj1vERnyACRCIniDmArFptQycCJV+dn6QfR6f6hDjQA/Jccpe2R5Kl2iOuVMJBzwEtBlbvyisXa2KkVrsg+Myh8GF1YrsE40j6jnTWpzpnJ6xrmXCpeE1J6mSlQT+f8trUXVIBg89MX0YAx9C9zCVSub9K+1dnwkcNZ86bn5frNrIwtaTj9pwLXMyzfHdQweLRwAL+kk16SCMD36KdeAsZf7F3qJE/KOWGRenv1bTyvZfFURWTROUpf6817Tcp7y1wFxZJO8rYNww3G0GQUhTIKQ9qvs9VOH7i/r25jupKBV3CzbgU3lVu1+qP341sEBlrzTdQAIJXO+p5PWyOPewVXRFNNPmp0hhBukNa0iO+mLznCfG8NqrJl9/lyk3WBVg2PRkG5hCh5wmwztIRkF9Jh/t2HwNITpR2DEwMBWxgmeb55ud5rWN3p62VPIyx3PKuzGXVxhvqOqFjXP9w16hlIdvFZfcqQ9GQY8XfnCCafjbQ7IHb+AsyCaT869Gpytp5JiREGQiGq+8l0CC1QzLDovosF5MVhBNkF7Bd6byf0YvkmT8ukrCN1tMe/Ziw5l6DFskkiEsvNiAE+2b4CB2LLu5WM4pto3uzHcZ0l38Y3q/6M2DkksxBZC7brFvNhxB5auh5GFXlughc8Jn7PKjtI8dfsHS38S0TftGZAbFHcZYYx3dTu2x2MOdudK4Ax/tF9PwRlYC9B2iswaXjhMGfcv7Ees+yJJn5gsEsd4177o/B8SP2ay3h5vOpxeqBTm+8RXQSX/SgxVhmh4qytWZoMmaPv+79G6G1PbxTJWB1+Ls
 Zr2A9ImD
 6tu0eBaXoRwYlbuyauhQ2qMxBL8xE8KpqzqZYC6zw2CnbFJE/HeRA40ET4tHBFHa+biophbd42tZO9eSQM9g+TQdLNtlVKMn4Sxmfou41JJuQB0Ba9h+mTFklItd2GhmGfLbgxeeBK5onrHxYKLGp6BlnhYD0FMJheF0j5RzoU8QUoVZFmYsHG1MdAuJiImziFGcCGG12Sq2Ka676KXPjtAWVggyDO2UrsFWgJaYA7WdSLamTTv09Vc+/dzyGSYOBgDyduOmV/uNJAxQl5kU3nael/ibXtV4Hg/7V0oem4UNrdD2wmF5sfGOEFlmygjokzDY/AUdmBrjvgptbsc3COYE/cMgSkxdzSw5cz4YwxTWjJ4CBdH5IT7H2E57eoTAHgfXRsgC7uaCCgtUHT/qblf+bttxaOG4TXX+7WaZeBRgMoeQlDQmdbsC5LhhGDoYgQlFWZODnkwGx6bOUUz+DE4HxCU33u2DxDt75Q7VASkGfSXTJtJwonibJqQ==
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
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 include/uapi/linux/sem.h | 7 +++----=0A=
 1 file changed, 3 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h=0A=
index 75aa3b273cd99..cfd772f4c3396 100644=0A=
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
+#define SEMOPM  500	        /* default max num of ops per semop call */=0A=
 #define SEMVMX  32767           /* <=3D 32767 semaphore maximum value */=
=0A=
 #define SEMAEM  SEMVMX          /* adjust on exit max value */=0A=
 =0A=
-- =0A=
2.43.0=0A=
=0A=

