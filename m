Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1B4E81A3C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305C76B0089; Mon, 16 Feb 2026 11:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DAFE6B008A; Mon, 16 Feb 2026 11:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA936B008C; Mon, 16 Feb 2026 11:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 070F36B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:26:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A04CD160DE7
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:26:58 +0000 (UTC)
X-FDA: 84450848916.08.B706E98
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19013082.outbound.protection.outlook.com [52.103.14.82])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98921140004
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:26:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=NEFdeMil;
	spf=pass (imf09.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.14.82 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771259215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EWILtn9mDDo+7xZtOr90BbifjSYdGNl8fl0FWUGUNA=;
	b=A5PQFSYpS+Bn33E0SrCm/+Vj2MHbKpjv3MYVxjtFasYjkFWFWCBDwP7ko4oXAXkhIZg9Km
	/Ep9xO13xH4u59mI3MkqM3fRXkpH+89b3uZpQNNVO0HTmO9uYvvbwT2JSsZT6yFK4KedXY
	eecrP4+1UFlgbrBj4yAvOkbTYDNPHJY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=NEFdeMil;
	spf=pass (imf09.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.14.82 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771259215; a=rsa-sha256;
	cv=pass;
	b=IFPDkpjFWOQXcwP1s1aNNc6TbTLz1D28MBWYPaWgEU6CnUshgvV5pxsTr1n+fWJ/xCiuto
	edWh38RvD+l7eedRoMgH3l7OGpta1PYVwuH2iTCQhAtd0y2nQl+29hM9sLSR9AaIZgat1d
	amwo/N3jbM0e7tdR7/bubwktv8viF5c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MiNTQmdeWr4MEb8/BghxXKUR1mjK2RtGV5S0GkXTz9B21JsRFZKHGtStB3F+WwVQ3HD3gX/mKq0FBYS3pa241QWr9U17dd0L9GnBLesuC//hC8XHJp5jj4+7N9rIiQLGSnQ6iVuoAy3Em7rZRPI4U7km2cbR3y2WBKDjQaZX2/S1UA0ZHFmPgoIisRlD8+n4PRS80irim7fT00LlmOrDT63m3ZyX/ZeJGEEWx1L9mn5cpzJzCTOAUzxqqvcK+Mn7K2UrSwyTiX3yCMfYnSs6L/SIyE6OFrQb8z0xGE+4ejsdY0/YxSYOZbiAwbN41Y+Ed0GtYAxI8ZcfacSPGX7ShA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EWILtn9mDDo+7xZtOr90BbifjSYdGNl8fl0FWUGUNA=;
 b=e/Lo8m3Rt9uI5mZK8D/xwBHG7g4P1Yynjb9v76Afj2dq7/347b2hIl1jXB2RSCetYSWsCrhQeWHZp2EB6IghJwsODIAM6k9jlb3XLkpyXY0byv1K76NFT9zkG4L2wvulrcpKk0XKKuSfOVFw29X5uwOX0q7HKfp82G+m3Mr92YvZboWbNSzmch5cKkNmcJ8+aXEx9ckatKTEDTpR4K2hVfM9CZ3RIFsOqc6meVDCKfBcpZTdyf1EoVxpJaE8SLi61vizNLxZFvYtGfHgLMsK7t04s6lArARV7PxNjrnYlnmM8HR5GpSxTIfniCaqtfpVxUMpwhvsAdBacpADN6foPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EWILtn9mDDo+7xZtOr90BbifjSYdGNl8fl0FWUGUNA=;
 b=NEFdeMilNPeV2t2gs78w/JonlymFMhtOet6+RY9n4fk45crt83XqFxECfNj5O0Yn0fBsKR18wsol3xtWKCVHWxAYgp7pyJ6ep9yAUxMkCTRRCZfbrrOHjkD0itm5WKo39Kf41hWv3ukOlYYI2f/3uWnGh6dLeM0hhreU4Hl8JvgFAQWXhez58y7Lzf5cJ7gC5IRUlEO7LqlOtKsPUJG5ekEK7GH1F2kRXBcPIGEz+G8Z3BTPtdUp0tvcXIzbvpFfMMPYQipliVpHdI9sIY65aH3zDAa7MrVqCsTfwZaWWwrbwTgMqEQ+bRbmFMTWyM2ycpI+GH4W6TV5bd/RHfQp8Q==
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com (2603:10d6:103:2c6::9)
 by RO2PR80MB6326.lamprd80.prod.outlook.com (2603:10d6:10:6d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 16:26:52 +0000
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82]) by CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82%6]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 16:26:52 +0000
From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "sj@kernel.org" <sj@kernel.org>, "security@kernel.org"
	<security@kernel.org>, "damon@lists.linux.dev" <damon@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [BUG] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Thread-Topic: [BUG] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Thread-Index: AQHcn1mbZ6+3hbtq+UqnnhH5daxyMrWFedkAgAAJcrY=
Date: Mon, 16 Feb 2026 16:26:52 +0000
Message-ID:
 <CPUPR80MB8171469FFFD8E642D7B0467C956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
References:
 <CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
 <2026021646-sandbox-duchess-5b7b@gregkh>
In-Reply-To: <2026021646-sandbox-duchess-5b7b@gregkh>
Accept-Language: pt-BR, en-US
Content-Language: pt-BR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CPUPR80MB8171:EE_|RO2PR80MB6326:EE_
x-ms-office365-filtering-correlation-id: cf25873f-78c0-416c-804d-08de6d783130
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|8062599012|8060799015|15030799006|15080799012|12121999013|31061999003|51005399006|461199028|40105399003|440099028|3412199025|102099032|26104999006;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?bif/7IWgGdLg2tJBiU1cs+5A3218H7RpKu3NTEE5gGAU0X3FbMqAXHMs2X?=
 =?iso-8859-1?Q?qcZxj9oi0rJIrQ9z77Ll8yRtZmPDmVbCDsIi9WwU9tHlOYR3XJml9lHNqo?=
 =?iso-8859-1?Q?HZNUN1m/sYbKptRxWCAUzGZpb0aU5yiJ3zT6p7d3jvOurEa3h01BdJBuJl?=
 =?iso-8859-1?Q?tMVi80+M/1Kj35A14FDOfIsjNCwoFSEhEEYuKs3jjWopgBfZbKoo6ZSCwq?=
 =?iso-8859-1?Q?/jQR/F5TAOeIFs8i5wyr3bxMw2Wbg3LRNB/9IcRZwoSUyRL/w71L5blIto?=
 =?iso-8859-1?Q?kZ6Vnfm4qKCFKsYocU/q5qa4SrjCZwm0lctZfkcAyOj9uWrl2Tbtw5heEv?=
 =?iso-8859-1?Q?5IjQHudOFXNkuAC48lXdAA+HkPYGfirN0ln/s2x2CjqB2eqnRwQXXycpIZ?=
 =?iso-8859-1?Q?l7Y1KelVwTsW8HQ8cb0g6Bfs+lf8WHmHixCkTZQx0XWNHCjV84nfB9x58h?=
 =?iso-8859-1?Q?6mVKMkjVBmlyAowDydIDC95WZukuKwvCK6YnqbEYl7eLFO5yx8ju3DUTu3?=
 =?iso-8859-1?Q?uVNdd1YQLIpXdgOo4tAM9Wtt15C9HvbwDAC2Ij9B7GHOmV43iJt21YlUia?=
 =?iso-8859-1?Q?ViZ78M4wCHITPKmoUb4CBvsD846apWeZv25SMjgSZ/Ndj+/hEoMI3wDKcZ?=
 =?iso-8859-1?Q?VoG/AX7VSd4rroHl+xNVHrWRkz2zRDrYjmPbGcLIJtJa15OkqMxdHmla4A?=
 =?iso-8859-1?Q?hjGVrqAFpROOKXx41lX50wi8tGUzeuOa0n2iYxV3gVA6TF0C0U0fC7jZDq?=
 =?iso-8859-1?Q?/spMPZNkzCLYsZaPPGI5BKlig1J3+RELAFog7dIasQqo5NKkXGDobckaTo?=
 =?iso-8859-1?Q?9UFJ6X4JUl2ieIGSe6aidDVNThrWGyMi4bOXDm3Od1Gw9Eu3llPVOwCJ01?=
 =?iso-8859-1?Q?Au0Ttd9rlUd/j+5WNoq/ub5UaAJcq4zb6owO2nfdQVmBeeW7q+X4egNr74?=
 =?iso-8859-1?Q?t4u/ZSIOX0ogJ46uC2/e1O08KD05HH+Nhiwpogd4uecgo8Ly+p92GOA1E1?=
 =?iso-8859-1?Q?/mbB65GL8j8+ecYPyaSs5lphMn3aesnZVMa2jcVU8SSewGb/hUfmx6Urjp?=
 =?iso-8859-1?Q?nSidECfX6tjHmTJ0qwLV6BkT4QoVnjlebnyhzw7aovYoSWN9S3rrn7Q2kj?=
 =?iso-8859-1?Q?qJ2ppjo1/H5dImcwfW+smAqNk0kB9P4vphKDYBwO8q0TsEtpL/rdVr7kSI?=
 =?iso-8859-1?Q?a22yAT7z+h9m2wrFsUTYYvh0fcUwmo5SNgwHVn2TKWQ3rOFFDRfJr+djFE?=
 =?iso-8859-1?Q?554BFUU/DFQv4eVtBsKAixM1qDPoa+7uwzJcSF2ZNLRYiF2k1NHxtQp1GU?=
 =?iso-8859-1?Q?goQ6RRjCjzsGTIQSlqsCmDhYKw=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?rJw5WCnaWKwnD3jmLw21JNfPHc+F+n80f532pOLNaSPRoCF6I0FrSxZ1RT?=
 =?iso-8859-1?Q?T4E7NOrKOK5ts34z6vJ9vmntivEaPTwHDB+tmZvTpf8uObM0rY5oUdofv8?=
 =?iso-8859-1?Q?4gOwBtjqwDrv+ygehdZFXNSR1BfSBtNA3iDZWbHIsDNPlZWL0Kcfbn58el?=
 =?iso-8859-1?Q?aaug52PgBWqLuSOPO0lv4/ztn5gRuCwvaNM+mpLT/G3ORn7Ug0hl8+ynR7?=
 =?iso-8859-1?Q?Zx04f6xoBP5herXXscc2cpA8dNAboOjLLOPh0+XMYra6aKc9ZuQE1+bQXn?=
 =?iso-8859-1?Q?RAVa/Koj0MnTPS8gTc/A75OzOrRutAu5EbTG0/ZfhcQke+H45BNQ+y3sBR?=
 =?iso-8859-1?Q?n/rzq5UmGrDv4dle60tZLghcuIwtfa/oXnLI5UuyKxm0gCcs8ETj4fiO+4?=
 =?iso-8859-1?Q?uLZTFOAsY48f364fbts8/n3qPYF0OGT6pRAHCHRwqAKIShP+LmW7VnqCNr?=
 =?iso-8859-1?Q?h7YAUQVD1s6EPCY2g6OQe86jyuyzL7BxKBKCh4ntv6E5oJHwleMidGBgM4?=
 =?iso-8859-1?Q?wFGCGlPTpqfjDWbXaTzdiIh4WoLRRfi3Ozt/OHGBZtjWMK1V+a4NWwfTzP?=
 =?iso-8859-1?Q?HzMtA5R07J71gNLAOSE6WFwLqVExzSdMV2I81PjthQSeX9U+RL9iQ0Kn/w?=
 =?iso-8859-1?Q?yoKxBclcEvKNMvKhlB377WVL37C8Pw9FSf3CfAeX5cm8ee3XjHyJjq3lQq?=
 =?iso-8859-1?Q?6/ZXHNa2lI1vYYuq86n5nkjz/Se5/E/zDg7t7Tx0jXLo8EmZtMSIYYP5jo?=
 =?iso-8859-1?Q?dYA7wAdSUE/vb2Dj+XU5aYitJhS1xnbnG75v1tHJQ2FsMUf+XSp3NTLURc?=
 =?iso-8859-1?Q?OjyObV2Pl5Sn+bXZy0yw5ed5dVowff1X2gOS+aXEfaJzecjU0un83bHcyg?=
 =?iso-8859-1?Q?e3C/wpMmeDFHjtmbfWf9kmSv3ntkVseCY+OXiwjtwapq1ZR2QVbenM3knM?=
 =?iso-8859-1?Q?wagAx6i5V6R0Fi49/04MRUcuHa1wjMXUB1Xz1gE7G5irMS4+5Vj98Y6+jK?=
 =?iso-8859-1?Q?wDy3yRaZYwz4/BgHHYS+7cn/mTlEY4T0DmtV4QF6Z0DAxioiUnQRtCLd2Z?=
 =?iso-8859-1?Q?0gt2ymeuee+4rx4FO0GGk+oOBYfR8Uhcb0iK3C8ucEMg6LM4SDVDAJ5G2C?=
 =?iso-8859-1?Q?uq4ZD6KUNZti/jLJJM9vULTXEM8JP2GoQjINSHAlmnLtl9Udzl9j3pv0aG?=
 =?iso-8859-1?Q?ux1Sgq3QiKdVIgW2y8s8vBtwcZeyOlatVSlxrcTa3fRbzoCLP1Qv0ml8sT?=
 =?iso-8859-1?Q?wf525a4Taze4z3ik4G82lCmZZ9/K/HamGxcRUxN0SVQl+jCclTAWSOCK0s?=
 =?iso-8859-1?Q?RWOsJn8VHvJne59j6pxZI9MIkWdSGqTB1rYhRsi+qug9uY6V3ksFpDB1TA?=
 =?iso-8859-1?Q?gNZCHckpk5K5jj9qdccNS0ovggJtoojhn7T/FVAhwqocveXMMpS8JY5ZP/?=
 =?iso-8859-1?Q?miYMsoMWQMS7m1KZiP8TAQeOiIPTlg337Nr7Pi2zKetuss8geOgeUCsO2y?=
 =?iso-8859-1?Q?xZB0U2941TL/ZnDkTTXMeB?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-8eed7.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CPUPR80MB8171.lamprd80.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: cf25873f-78c0-416c-804d-08de6d783130
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2026 16:26:52.0840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: RO2PR80MB6326
X-Stat-Signature: uskub5uuzmj1ifosa7f9sie5hp4r9inr
X-Rspamd-Queue-Id: 98921140004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771259215-577956
X-HE-Meta: U2FsdGVkX1/NYIg4MWAwrn5QpiJriW1ubGbWb85ODdskSDDmJgA1Yr71i6+Wf0Bgum+ZRURiq+qaoifVcmuUt6+CKKHobl7mu6rWN5/8JRay/Kn8dJJ8qpcOVnr85XmxfZ8oj+wIDigf4RB8WeYtkJAOdT9sZZ/fxxpAZ/PFAfHNfwSa/1dKd3ewpsE3+mucVtE38/nkJnQxVOZtardPsFBlFhF8xMS7bC9bGS9dJOOxLkGNOKq3F415DXODOLb7Krd0KO8M/+qV5LlRml0ZJgV5nFli0SYIlHDNhVecpDOTl3zYR5PtaQZX6dBnZBrFVgq4ZQOc++c5LzjOBhaKlK8xSFA+arQZStUd0I0G77Q2SR+fUNsqANRu2QhgoxZvJzRFOBWDrTKbAc8C56ugxMqIEGqycbQg4G09f2ntBBb5Tvz5bcog5JTgrZA1IlJwHsArP7qcm8d1G2ZDTRFIy0HRpBkViRGhsjggBIQHnr1MMsiaFM0XbLsu7+aXyPLtWp8ByqbD7KlxcJlxOzkpd8zbmQqvoIRedxf6KCqXjbzoKa+Xb8C716Lr4l1zn8TrMEIM4bcudoThlnwN2EOGcRMdRD3/glcH7c8JNkDAoF0oLbEupmwmqpiinkdvcBx692ec2Idh/D0Hd5BWvFisf81pgfw/9RwvyLZ673IwkJUBlHJ0RjciZFMmzvanSggQzq5X3XCohpaNf28JK29mhLPHCfUq3j2vG4i0f1vZrrhmyCpcn29WcPpUMjUUI8DI18vO83ym7fWALEEgoS3R3+AP/M/diU7bEjKe4ytajOpiCw7U+/TU7XbRWPqp2rh4WFVWRmxrbcYLmA61yVoDZunVPD1MR8ueo7Uk7FWYK7quKK/G/U1uJj2qKwJRJHWJdt+7JA7zIyfVC3qzzjMRxC0xBR8UvAQYhOfogpkHmqQBaNZte3/wuxk38x8tl8DYHUdIwL6hxswnK78vM+J
 bHYkq1rz
 Cn9h4DQOJqZ68YRejo5iG1dp0lVzi2nHqz5ZsdKWC3uEfz1vzAnZxA/zuLOqxGa1115W4tE3gcOhoyvTjjKTHuwZuXRZCj7fxG+tPZMJPVTH6HBMUcvBAcozCeSXIJEAzaKJMaOGfRwip6tBlUzKQD2iRqCodc12Uuwup5CJB3CDVKq5w6BzHzRLem4Ig/TZD1nIHn12LpeNYVL/kpMfyznylnITiMInCs9Lhc/024upZdAYxzVLcvGYv+FRfUVcIcz8y18C3GtHnbNoXbBwCxfy5dfiliY9kHjQcEbvEr0pHKf91foSQ594q9T9bdyNr4xv2MWcDxsJyKlCngyFg5hbZE8ZdK8cEPm4zOSzu2nc/KYZ3+vIlOtCaj9n5uQ6qKj40qFWccgYVHhR4vF8Z3H3lahl6MdY+5sWIbx9v0V+oM+WaF81bumyddO+GoqlG1/k+pLUZ/h1bKLSI6d17+K3VyRpuqWXvcBXy3iy0Icd0xEfs4ix635aA46t8DeVtBMl2FZpERqwzV2QLIpGdz/uXocVAATZwMTiUmEqbZCh9L3xjYHbHdwabcOcQlNHVcu9FfJs+o/GMtRyVUvGwfeERzYGfm5XiRsjMg7v2X3XYBrISGV2Ho9RGk1q3j0Sxqw4J880DUkE0zRSYaDTjV1eN2srkKTLNUsBNQGi2wzSYFmesrKLpsSilSwMQauO9zoPdjT/39amiwEuAGcLP66/KlEsJW0hA9qeIEb0jg5mtAgg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.007401, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for your attention Greg and congratulations on your work on our Kern=
el=0A=
________________________________________=0A=
De:=A0Greg KH <gregkh@linuxfoundation.org>=0A=
Enviadas:=A0Segunda-feira, 16 de Fevereiro de 2026 12:52=0A=
Para:=A0Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>=0A=
Cc:=A0sj@kernel.org <sj@kernel.org>; security@kernel.org <security@kernel.o=
rg>; damon@lists.linux.dev <damon@lists.linux.dev>; linux-mm@kvack.org <lin=
ux-mm@kvack.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.or=
g>=0A=
Assunto:=A0Re: [BUG] mm/damon/core: dangling walk_control pointer in damos_=
walk() on inactive context=0A=
=0A=
=0A=
On Mon, Feb 16, 2026 at 03:34:44PM +0000, Raul Pazemecxas De Andrade wrote:=
=0A=
=0A=
> Root cause=0A=
=0A=
> ----------=0A=
=0A=
>=0A=
=0A=
> Commit bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")=0A=
=0A=
> introduced this function without cleanup on the -EINVAL error path.=0A=
=0A=
>=0A=
=0A=
> The sibling function damon_call() had the exact same bug and was=0A=
=0A=
> fixed in f9132fbc2e83 by adding damon_call_handle_inactive_ctx()=0A=
=0A=
> which removes the control object when the context is inactive.=0A=
=0A=
> damos_walk() has no equivalent cleanup.=0A=
=0A=
=0A=
=0A=
Can you submit a patch to resolve this to get credit for fixing the bug?=0A=
=0A=
=0A=
=0A=
thanks,=0A=
=0A=
=0A=
=0A=
greg k-h=0A=
=0A=

