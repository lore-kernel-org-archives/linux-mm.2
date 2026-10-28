Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080D3606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=WwGD87ad
Received: by kanga.kvack.org (Postfix)
	id 2DF4F6B05B1; Wed, 28 Oct 2026 13:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28FE76B05B3; Wed, 28 Oct 2026 13:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158286B05BE; Wed, 28 Oct 2026 13:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB3266B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:04:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7321B1A0187
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:04:03 +0000 (UTC)
X-FDA: 85372657566.19.E3BFFBB
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19011091.outbound.protection.outlook.com [52.103.23.91])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8F6C31C0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:04:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=WwGD87ad;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of x-professor@outlook.com designates 52.103.23.91 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eUKVajRdu4AbC2/Ds5ZHTCDhRVBFeY6CqT0aypmTQCA=;
	b=LTUoTN6+xucNyWRXSUOkNeXVRgIXn+ttoBvRQV5guIPR2ogNTPIL7hFxf2VOE0cd8cd9SP
	2lOo/JQuJX0hn4mP+UsTWS1CCHEoVxaZ37xb0YLSJkGkFbjfiQ3gWNj3u3liOSTLzVYePn
	pJlKnD26tQmX409AQ835IASc7hxnytE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=WwGD87ad;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of x-professor@outlook.com designates 52.103.23.91 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793207040;
	b=rzKYQpsVzjzZZ8FReGK4kohFx8DqkXW5yrQMiob7/JjLGHLltZKtPVEgET2IuW1XOFkSrC
	xOk1x5LIKsujJg374+dbcBr+8+bbEXh7GopAVNUm0SvTG11Xue2R1If848gORWSgbgzv7q
	7UVPM6ZZrJRB6CnQqUsmdbQvJHpFD/E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cV1cLuOzTpLgkxLDJKVpXsJ5NJeUYbe4KPCkImO9hho9uPDrNBHm6YbYBbHT/GwYY/SbSzDtKwGaT9jPfS4eaZ4TUhugfPro6GY2yRv9XOPEmbVfv/ApHdf+cLtHxJ0K9Zpr/rGONEjapejByIUcTBPKFhmtPt/1e+4dt5UqR0TXUvx9t84ePqdeMgtF5KgVefS1kdRAywWsFWxBTJ0iW4ySS9+eRIE92d59ijlFRCGvo+AARKo56ae+1baBc34mQVee4uRu/7y31z4RR1yupr9XPJVELq4rI9pvZvjb42i/TU47c2Z9OJfMF+7WzRy9pAT8yn8sCvHjLl/eUEARfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=eUKVajRdu4AbC2/Ds5ZHTCDhRVBFeY6CqT0aypmTQCA=;
 b=VN4uka4h1zW26ZReVOiek9M9h80lqGC19YPPvnGF/LwYJYC2qcD1hgEeJcqVLzw/TC7OarpiBNCT1Mng9PJFDJiikEB4zmWImto0zC4fV0KAV3LFRiLKynfJcrVM0Pl6nxAQOCue/xPyw3FF11vUq7SZTRrLOn3hwwkhlXhqholXfIAogIvnd2oDUqfXKnO8cOl7EFnXktmCLAewcc0cF8QUR19baVvg+mI7XsdNX7tP2RivietZG9eHSfScH7Gq/ZEmm+wx2D1rXHb3gfV3VK4fRWudESQIFCQxehpxZV7bFVlX0qCV2uRfvoaLpy2OkI6W0fB9F2cX8s/2t6L+wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUKVajRdu4AbC2/Ds5ZHTCDhRVBFeY6CqT0aypmTQCA=;
 b=WwGD87ad0nQH2qGBpn1iWlXLC0CezzdEHO+C+5xH9pm8clIXzIqF+0dT2ZT0InQRrhCJG9iELXSFHehpa4SA2gTZi2r/Q0BCHi3byIF2B2WK/NjUUcRNwgFcSp6enlODC5ODz+YdNmTh1dpinglH3LXumKbGfXHnZGy23G2BGrCSfOcVV9w1ZMCIxPJgxXPIBegvfuMpfAJgiEUpdO92SEIZOaD+vFHTOe24IM4uGenxkzMNmIO0aYG64ZuWraBML82iOMJST5Z+3zK4mEhtwO9Adkl41isyB1dXPjjkM/aJqR9RESj2LHJ/VpKWonPhrIfXG8AvubFwucO1gKxAJg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by MN7PR05MB211011.namprd05.prod.outlook.com
 (2603:10b6:208:633::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 17:03:55 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 17:03:55 +0000
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
Subject: [PATCH v4 0/3] ipc/sem: account enlarged sops arrays and validate
 SEMOPM
Thread-Topic: [PATCH v4 0/3] ipc/sem: account enlarged sops arrays and
 validate SEMOPM
Thread-Index: AQHdZv5QzwKNSv7pEU62b6kz5Ec/iw==
Date: Wed, 28 Oct 2026 17:03:55 +0000
Message-ID: <cover.1793207025.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|MN7PR05MB211011:EE_
x-ms-office365-filtering-correlation-id: 6bd5918e-a566-4051-c6d8-08df35157386
x-ms-exchange-slblob-mailprops:
 iS5pQZgsAQDZd5pLvsexcGXRgbvG27NWjyGi5xh2ZvtRlhrJvf9Oi4M8PU/5zWhl7g6ym25nuNJtLP0dhn1Lx8wDyT1lj2AktSNJLVZbhbna9eWhdn1wONNqA4OjPRgfGuwtt08TXA0xdGXovwxfpsXnFkX4l6JUmq6Fj+e/RCfx7QQuw++jiUIb6TwXsHqvuNckjz9lMOcJJuTXaJ6AffYSh0MATzrZDWfDtlS4SK49usoC36qGuLHJvC3Ilu8WopAg9UEOG0IYvNL/OuqqZKfs2oU1zreg4D4AAQ6hJUxlF8gkbLxXKSn+cPqZrOaTxnbHae0zMVDXmspP4e04ogkbu21YPccU+8unJ0S9H18d9Tfexjsjpj8ILb4VEMJ9TP+7MGv2KPwctOJ9eHsabRqbaHtCqHCHYVcIhDM/XrCcDgYa0RAlSLkpNrDIkrpf5oCpIf9O/LB8L5iPTX6zvi70IpkacqwRUYD4n+ZjluVRXBgYb7j9Sv9hbdH/iS8DRfOvHTgJUmHvK69eE93AWLnE7mE280tBJHWjUQ/MFQ2t3drIRnqGRPVkLeunfhgyMLmwfddkCMkSL6vV2I0KqZvFt47I4ldVBO/aZpuMhztuMq4LnjI4NoJ51QqXuwPzFgSl1g/3PyqdwcUetu0wkQi+M/rHdDShWOjw9DRHOGuu+4aycMCvJT1uboLyNT6AYN9tcATSuFP/n4u4x6OdrhHcrvR21PqcJbZudX4VF33NPJaUoAXPZ502ND6c7j6iY5+BUgLJkHVC80o17uXDLK0egW6VNHbeiJikd/4NvahYkgylk5D+c3KZF+76wxqi
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|5062599005|15080799012|24121999003|24021099003|31061999003|8062599012|12121999013|8060799015|21061999006|11091999009|38102599003|4140399003|25010399006|19110799012|102099032|3412199025|4302099013|440099028|1602099012|53005399003|40105399003|26121999007|10035399007|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?wdLtkWy+B4ki7gO1E7+7FyyXzY0qhPXGIXTXfpXSOyAe7/3m3uBwfvv+kl?=
 =?iso-8859-1?Q?aa8SmrAE/q4igbQnPtfPkfPW17A3bcWVPIrjfEXkYXzgg8fgTrA9Qvuuiv?=
 =?iso-8859-1?Q?Bd33z7ta3YUK5nh7m8r337fxXEAN/EZUGwavPyuwKSY0WuovsiLCzlbs2q?=
 =?iso-8859-1?Q?aCPBFFK/js3yyB2X95rN5VkdXpcctyfm/lw6YoS1dBwOoKUGbENYR0fqvp?=
 =?iso-8859-1?Q?6k6vTgGz5w3BuK1WItUWyh1X+5Fc8yQS8QgEgygrgFwBuGrKMm5OFwSpvX?=
 =?iso-8859-1?Q?LgGcnJDFnXiMYEGRkYML13huPU7QoKbyIKSODAQqbsQXd/xPoXuW58Enq/?=
 =?iso-8859-1?Q?/ByruKX/vTokbPt1kJ6WCPZ4b6rPpst5ubC8jmBVPVWTfeT1+z34QjTj/s?=
 =?iso-8859-1?Q?HmwuLjfkWUgbVikdbwD29GF8GubaA4uVxjyphO7rWW0Xen3Xlybibvrfz9?=
 =?iso-8859-1?Q?b7YnXXIkZ/bNKd+yr5uNJglusOLhl9Z4MXWEbBF9PpbSu7kZKwW4ouA0k6?=
 =?iso-8859-1?Q?5UNmbQyC5WYpzjc2adar/Ywenc2C6cH/0NTrM8jDOHJV1mgewc7HGtYaeR?=
 =?iso-8859-1?Q?Nn9Su5qGKHlghObG+hcZb06UpeM1wfVbZUsLtOg9skID3g/MogA4dBCdTK?=
 =?iso-8859-1?Q?TIzBYe7PLELrVpSYEIjpFKIEIP0SLHHy0p2xuL8l/cghnQ4fj7F1myb7p9?=
 =?iso-8859-1?Q?JKsrAUXuh6X/QK4kb32uVVX2m8zyujwYCXywl0qyTG1nCksmYgk/Lbw0kQ?=
 =?iso-8859-1?Q?qhUpyIuiUzcELQfiOiSmgY3JsW2NYAmv1HPgZVr62AkGXdF2BUrNjwINE6?=
 =?iso-8859-1?Q?wjMmjfX1lfvZK8a6rVsTu+gHrB6uhkf08VLdGitMoG0J7nptG+56NEV5UQ?=
 =?iso-8859-1?Q?ZGa1Y4ePVZF7L3swgpcq2NMpA85QVLDhoisSvpTGQfgOXICR7dcLOTIUwd?=
 =?iso-8859-1?Q?qsEbsDtDY6oBOHRHS+HZOke7sUA+s/cIGFCAblR7nJ+N/SwZ8ES5lfMW+x?=
 =?iso-8859-1?Q?7MyHx6EZax4gmrykpl+YaBXU7zxvox33Ojuhc16K71PY63bDsaAqBQ/dcZ?=
 =?iso-8859-1?Q?L9SXBB4Fkxzo5FYEoz/G+qWCzEStaTQ5Kd5HGE3HOl4YBQFia9lW99TTcf?=
 =?iso-8859-1?Q?8hwFzV5zC4G0Zw9POPCDI3oeu02OMUbcqMDHO1ZVmlRVv45WTA+UriQCJI?=
 =?iso-8859-1?Q?9/ozoi3xQu5+0VydAuIyVCVGbY+BE3k6F7933F/uj13bHDqZv/rxgqXv/9?=
 =?iso-8859-1?Q?e6AKIaPQg0t/aJ3q9Jbm8o5Z61f3rKcsP4rcLc8YF3xUbf0FIcQWqMul+3?=
 =?iso-8859-1?Q?qGkw?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ZWYpbE8SAVgke7msKuoSVmuWP/NjYGtwFEsRCjXJBL/FzkrHtwehLtvf3Z?=
 =?iso-8859-1?Q?BEWV1hXaMuYv7mGcvl7+NPI6PXKHhdlzXhlfkK+Pfi3fj8iN3yYfI2SPnv?=
 =?iso-8859-1?Q?NvxMWkQoTD1/9EZ99k0XExKHww6Dh3wwP9F3NabooOR7Eo7R6Y2s4v3Iiu?=
 =?iso-8859-1?Q?SLMwvMNfeVSpc++uiDT8Dq2KW0G+wRyYAk4FPlkGwixmLU86bFs9NhDHz4?=
 =?iso-8859-1?Q?5yuSdxVygB7+GZbDGM/E5IU5d8pzz1dZv1kRAYcpMxRKfEyhNQevFlegmV?=
 =?iso-8859-1?Q?HKf1ZUtbrV/TaOrmhu56EibnumFNGlomrH8s1ZkxKc0qaeEyvl5OkCSRT8?=
 =?iso-8859-1?Q?VAYtbQj9nsIzi02gaswajJGWUWm+Qus7PDCL/guHjtgm4pF1Ch5xcVg9Os?=
 =?iso-8859-1?Q?SifWjsmtfHba3GAJtS2uucwXRbZGjtDMuy1ReDxfEcjdE0q0NC06V4qIGK?=
 =?iso-8859-1?Q?bhupoRA9Qhn9xy/cKf6b1xXU/0kKH0BUMNLV8tIAhArs8gkZ1gO05MBaVf?=
 =?iso-8859-1?Q?1KMG5E0noFDFUhn4zbd889YKeJ3R9eT7izkOL+/nDp28nnSvC5hP/RHGJh?=
 =?iso-8859-1?Q?2/zhL909gsURcxARZsbXy/j9e2sOQQVDO4rOHvH34Ej7dJMMv3PQ+D7PAj?=
 =?iso-8859-1?Q?wcE+C9ItdK2lI+R+0MrnFnVvCpVmrwFluqXL33NZkZZZYujTDJZFDX+saj?=
 =?iso-8859-1?Q?xFg2P1YEyvAS3GIHio2afY5O+i1eOvWzIfSFbedmAvlTz9sjTH3+YPgi2L?=
 =?iso-8859-1?Q?UPIsHlVXYBKQlD6BTb5q7sUbDjT4q/RalwlL51Anjq9U+6UsNyt6nw/T5j?=
 =?iso-8859-1?Q?83KB8pZQiDyheSmfyZodpW8IYNLdrgdRsKt/JFl1Wb0trnOzGrSSStVaz3?=
 =?iso-8859-1?Q?nXVRkIpJDJj6gn6ONdr6nWEMxZwMI6xfhx9zcEOr03RmGEWzQ69ITmq4+P?=
 =?iso-8859-1?Q?B5IbIGfvrClEu2d+eQG4BxcepvcLjTC/9SKPQK13a4d+vxCHtkYYholJ6c?=
 =?iso-8859-1?Q?IDusCgXmD48OpL5C/6VaM36mU+dvoBKHf0Y/kaEPbp5Lr4PDVGKpATfRvt?=
 =?iso-8859-1?Q?l4QUv9tX5Ul2TyNVqxziPSZmspAoAkYq03SinXlPv/tE3L8zsgS2gFk80x?=
 =?iso-8859-1?Q?4vOD5pp7dhWTfznkTRLqIs4MIineX+TNdjwoR1Nu1zEiKYGATvqZTBH+P+?=
 =?iso-8859-1?Q?+7HYoy/CYdMTrllNFxlkCZfqapQnMbV3ZfnMjjVbfWaXL3a3DDA9xccXFi?=
 =?iso-8859-1?Q?BD+3yAE1JOiB4cvf66rdrWbZLXOUwqwkfGb6HbnfYP+lU5sf0AN7lbV2c7?=
 =?iso-8859-1?Q?/qn8Z+sjznq52zzzAjxsVRxcZnyAgj0DmJ+gy2Via+PE2x84rcPdxhqsnh?=
 =?iso-8859-1?Q?ULhtxQvYeZSSZAUWnFrzmPmbsozczXCpYUnPIYSWOqg6wPugN4I7ls3a02?=
 =?iso-8859-1?Q?Nub6gh1PDe3B0X9T?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd5918e-a566-4051-c6d8-08df35157386
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 17:03:55.7712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR05MB211011
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F6C31C0009
X-Stat-Signature: 1fcnbhnrxyp7496h6q61enkzqzjrifxc
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793207040-728621
X-HE-Meta: U2FsdGVkX1+3hp3N+QlnW2PLIhvxcuKNIn9MsMM6wXW90MK5tpqy9SIkvDLWtQgm7yQ6jMNytigk6CoNN5W5QteCshkrWBYZNE5yL+dUh2585gyy3/+0gZxi3nAZRugYjWU5u5NK5zRk8PY9Tkt+24mZ8pkFv39fwlF1b5aaRJWMBOCis4Xadec/PaS1nG9s9KhgkzIDQDdKEbFZTtnESrR2aK7yrwA4rFEPin3VbBMJgUW67PYZ6z2+azuWbi7y68qfzgqW4Kx/yD5ynuHUN0Nf53uUqzOwn2SVXskgEt2uQMruYKIR6s22ccj8sDEeb8T0wsquULUk1U9a0Z7BXGxJsVzTB/0NvKXxSxgjdKRtab2yyMLh0o4v/+oyx/wV7/AcYSKYuw2czxFA+lc4w9afS8JI5BBixLfbBbw+TyqQBT4azNvnorPrrltfCYVY74iapbFK0InedZZJg3h/dA5BnNxi5Lov47wBRIYuHiGvu+OFRHdQXUP35dyYa+lv2IinjL/qUj9+hXgSlX+R1XNSEUodnzIl7+3Tg4UBcrPQFBnBdXQSVEMNubsG8gjdFvJlvpXHUHWZxddM5fzXy3vjwssLsuB4rwUyRD8sYa2CAqlW4ZEPMEXBw6yiHEiiiACTw4hXVEpbDs2s39a0ZbtWDaHwrokqW+2Gz6AKbVK0i2Oj7ZMziX76T+5TACVRrjs95BU3tn95I4lLttKgBQLqpaLRT2Lv38QyA91FJoYY7OCpsKEmYUpKaqDhBbjB2c2xUnA6vsGKSiqry1t0JxvHFROmCAd1QORZOylqoqtIOqa3NwP++1Aetsl0wHc5/AjdKUrVGMMhspXolw2Bb5CEyKc1YNtNl9D8XNPDsyIFsFhc/BWeTyG6+IK/fAGOzJOx1Iwn4nXDQYcDbXagftxa1EfXi3wGKRbRNbPvvzdqwEgjCRAvmbJi6GN4tF+0JNdDanO0JpTTqkV0cGz
 xyKDAzqX
 fDKmr5VtxvLxh8pKpNryiAKeFjR5JSV8k03PwEIBce1K0EbRfeCrSwLmEPRq1CQVy7GUl9xLcaCL6edqAd7WyGQFqwDSS+F4iaadvub5lBQ0TqdktzvLCtKNZprGNW+0Xa1SJAkzf2l5LjEHpouOZhduh+7SYZgrTC/0DhCN/NKEIWNrJggvVrciKmlpfEkeghWQeHywgo1kubp2RikY/lk38n+m9eHPO7THaabpEp0JEzlblnQLEWQ9E7Xg83fDgAWcLHzbdVTMQzlEvEy9706ezwAOSn9J9u0XBdZIipanfYgZYvQdqfFkPB+VAMwNBNp6znaWtzxrf54tXAYPf4cTC/48lgnwrdWgNtV02L/3A+f/fDGvvwhwyvvRG0D6rCP9Yp6cuXt37zJuSskR0EkYA+7ReuJbG7kNUWg9aZLBZUGwcXmpA9QS3nFTPN0GyKA75gSfmweM5qy7s9cvjBXPM1j5vHOpy1PNSq/onNdYmW88mjYqKkm3NMqAnUylBqoJp9+5u4Qm8DVhd4Zr7AIISNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Alejandro, thanks for the review.=0A=
=0A=
This version replaces the memcpy() used for the local ctl_table copy in=0A=
patch 2 with direct structure assignment. This is the only code change from=
=0A=
v3; the locking and validation behavior are unchanged.=0A=
=0A=
The series separates the accounting threshold from the UAPI default.=0A=
SEMOPM can be changed when rebuilding the kernel, so it should not also=0A=
determine which operation arrays are accounted. The internal=0A=
SEMOPM_NOACCOUNT threshold is fixed at 1000 operations. Allocations above=
=0A=
it use GFP_KERNEL_ACCOUNT; requests at or below it keep their existing=0A=
behavior.=0A=
=0A=
The sysctl handler parses writes into a temporary array while holding a=0A=
per-IPC-namespace mutex. The mutex covers the snapshot, validation, and=0A=
publication, so a failed write leaves the live settings unchanged and a=0A=
partial write cannot restore fields from an older snapshot. The snapshot an=
d=0A=
publication use READ_ONCE() and WRITE_ONCE(), and reads continue through=0A=
proc_dointvec(). The unused sem_check_semmni() helper is also removed.=0A=
=0A=
The UAPI warning about physical fragmentation is obsolete now that the=0A=
operation array uses kvmalloc(). The header describes SEMOPM as the=0A=
compiled-in default and retains the uniform <=3D INT_MAX range comment.=0A=
=0A=
The series is based on 7be4bc52fd9e ("Merge tag 'driver-core-7.4-rc1' of=0A=
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core").=0A=
=0A=
Validation completed on v4:=0A=
=0A=
- a W=3D1 full x86-64 bzImage build;=0A=
- a W=3D1 i386 build of ipc/ipc_sysctl.o;=0A=
- initial and user-owned non-initial IPC namespaces rejected negative SEMOP=
M,=0A=
  invalid SEMMNI, and malformed writes without changing live settings;=0A=
- zero and positive SEMOPM values remained valid, including the 1000/1001=
=0A=
  operation boundary;=0A=
- concurrent partial, full, rejected, and successful sysctl writes complete=
d=0A=
  without stale-snapshot overwrites;=0A=
- successful, EAGAIN, EFAULT, signal-interruption, and IPC_RMID paths relea=
sed=0A=
  operation-array allocations;=0A=
- no BUG, WARNING, KASAN, UBSAN, or lock dependency report appeared;=0A=
- strict checkpatch with the intentional CONST_STRUCT diagnostic ignored,=
=0A=
  and patch application checks passed.=0A=
=0A=
Patch 1 is unchanged from v3. Its previous 32 MiB memcg test with sixteen=
=0A=
one-million-operation calls reached the accounted limit and returned=0A=
allocation profiling to baseline; that test was not repeated for the=0A=
structure-copy cleanup.=0A=
=0A=
Changes since v3:=0A=
=0A=
- use structure assignment instead of memcpy() for the local ctl_table copy=
=0A=
  in patch 2, as Alejandro suggested;=0A=
- add linux-hardening to Cc.=0A=
=0A=
V3:=0A=
https://lore.kernel.org/r/cover.1792808260.git.x-professor@outlook.com=0A=
=0A=
Review of v3 2/3 by Alejandro:=0A=
https://lore.kernel.org/r/atyvbQ5xxtxcxBZE@debian=0A=
=0A=
Yingjie Wang (3):=0A=
  ipc/sem: account enlarged sops arrays to memcg=0A=
  ipc/sem: reject negative SEMOPM values=0A=
  ipc/sem: remove obsolete SEMOPM fragmentation warning=0A=
=0A=
 include/linux/ipc_namespace.h |  3 +++=0A=
 include/uapi/linux/sem.h      |  7 +++----=0A=
 ipc/ipc_sysctl.c              | 35 ++++++++++++++++++++++++++---------=0A=
 ipc/sem.c                     |  7 ++++++-=0A=
 ipc/util.h                    |  9 ---------=0A=
 5 files changed, 38 insertions(+), 23 deletions(-)=0A=
=0A=
=0A=
base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614=0A=
-- =0A=
2.43.0=0A=
=0A=

