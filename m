Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C38AFC88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 00:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED5F6B0095; Fri, 11 Sep 2026 20:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7DAA6B0096; Fri, 11 Sep 2026 20:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E646B0098; Fri, 11 Sep 2026 20:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4766B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:09:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CC52A0408
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:09:25 +0000 (UTC)
X-FDA: 85203175890.21.1263E58
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011032.outbound.protection.outlook.com [52.101.52.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7156316000E
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:09:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="e8/U269q";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789171762;
	b=WGXMfnSeLOQjryPLv6dHQ50IjCy+WSu3WsYkvxC7Ll2WU3slFsi/v2BsDtjLnRz6PsUgD7
	Cg+cRx0Ng9oGN7GeEqYsndp/u7XLEL4Cw5GkNtOS5GPMoJgVAEAw3LjLgZ9PtI3xF/Pbek
	hNIbQPKzwMyN658WxJqlTHT7ksa4bnU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="e8/U269q";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789171762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYnEGF91cdZnjZWi8lLXYTleIZtomCADpDkcAPlzIuk=;
	b=THdG0eDM0aforK6LQPdslrSEjnfWAS3BXzqLTrGohJpJ45AG3F6Nt4FLSsOOGHRnepXB4G
	b9Upu241B1M2meYhHCgPs3rSX8BcawOEnZjc90hBZ9DzNoznflDPeOE0m8UrwQAHmFW/H3
	CuURbavaaPdT0CaLb7cr7f4Cl/u0mlk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eW2Z8U8gIPZDZOpGlFZoyQaPLHcFeKr48z+BJEtn4JAujHj+5PmTBz40HsBe9zUvU2pea2EU5kjmzwcJAC9FhEYodfXBzek8iNPizzK3aJejwhE5IWgeRTeCp26NaVutD/7hADd9KVzqAPISg9g5uN9dNIzI3Iybye+l29VWpuyOTa0ZM6Aht9TfSfG/q/5fkNaBFKZmwKFal9bsQ7k/lgHk8vklhuJidl3XWqj8DivX03q7Td8uFDINxnr2WBxtnOcD/AcvQDinFlL7xDV489oT7euMP0Ey67YaBQP0i0NaoiyizZRlqHEHOEv6loH7Wu6wEkM3mF1bfYqASekE4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYnEGF91cdZnjZWi8lLXYTleIZtomCADpDkcAPlzIuk=;
 b=WYiSub9LpOOh9zEtmirp2+tdzGigkVFlCOhLT5qkU4HqyyN77UtRBGlJnNzCJngGUL4/l/tAKqfGXAdcR5KQzO+j5O7DlPJldKSOtqsyBbxOIdfEai7YxFxS+DtwedIC8Ha3voWenWfxA/cZ26CxVxaoPT8Yyer0cbPWM1VEK9aS4X+KGaqmdVFLj8cx7KQ7/X18K3++Xuf7rDlt7RGv4HLTF7zhbAkPvMmXciV+loI1OApumeVyyfEHkI9qknkJVyi4DWKoMeerRsW0nqkez6LWktPHsZcmds0xsax7rhvpx+k79NfLoSoY1XiAmNW8R5FhWYgnwlbIS/sYOyOvYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYnEGF91cdZnjZWi8lLXYTleIZtomCADpDkcAPlzIuk=;
 b=e8/U269qAvudngnBDER/OGvbSgToQx57CuV9sMd0XJq7ajXX5qL0YoOVFNy6I25Cxhg4ZKo2Msi1dkFjSj14jeh1xXJ7HqFkXuBonkY0Zo5irzshwLRC01AnDXnXeMItycRubn+tgb/Z0QAmKvNqch/b8JC06P7beIOo3s7Pvj3t7ab7ognO5lMjyuY/NHH9ZvroQpwZeynK2Ma8BT2eFelZvSancx0HveQR5LH6kVrOyDx3Vts2ty++2iBMURj58VpJE3GPJd/fXXE5RS4GgbNi/aSCecynXrShEJm9tM5blxq6/C3Mzb/1lwhLOIizcQwuBlvhaY1jlVBvaho26A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DSVPR12MB999150.namprd12.prod.outlook.com (2603:10b6:8:388::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Sat, 12 Sep
 2026 00:09:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 00:09:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>, shuah@kernel.org, david@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip khugepaged file tests if mkfs.xfs is
 unavailable
Date: Fri, 11 Sep 2026 20:09:20 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <1544B919-099C-4D6A-BDCA-9F12110EE2BE@nvidia.com>
In-Reply-To: <20260911165610.e1b1d957e6c73a200b64e546@linux-foundation.org>
References: <20260911124517.63714-1-jaeyeon.lee.dev@gmail.com>
 <aqP7gW98GIiYgL1z@gremlin>
 <20260911165610.e1b1d957e6c73a200b64e546@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0082.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DSVPR12MB999150:EE_
X-MS-Office365-Filtering-Correlation-Id: 470ef0f9-e98b-4fb2-e731-08df106215cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|4143699003|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	S5mvP9EczUZpM5Uwqn6ws1OsrA6cY39j8okkqkCnMH5+5hiojSztrgQgM+Fb59JoPy6eCCMrwMvhQdXrushCNqdLcBwxlomWNV9AXouC3smA8X87OxGegp3VkEy7dL7o1DvFCgRm5McO0xQBiS0QGqdd7VQL6Lsz/zpM8glke9EQgzAH/Zx4VxSg9D1Yn/TtXZCdiFDuOMqGoU/Jq2BGjN+iEz0eSQXkHYsofwxQVxYBVwhjEjsVfVx/0kGcg4njGxF0OkYCqKLinqTI5PUAvE44VNP1+AO3WKK20IQBIZqtedQg3mnAWs4IkzqtpuPiz+R/IdyQR/h1VEQvteQVA9XMSVnr5GdxD02pZe9c0cVp+SHmxYCmqiPfCDoYh6VBSZRb0ukrUa++J374L2cbSDR0T07H0w8T0tXWb/vfL0ihjJtMKAZRwlj++n9WwpH8weJ2FbrrrOyANLeJshZaEMS9DO7bOjxS3rBmsiwEU0z4OlDl5urhIN9lstSXXEv2Df9u+0i1NC0ozrScCEsR+TMocWbqqYrfbWw9EtmoQhmGqZvIJNSFvrblTqpEQ0Gl03dRKq6TlARMyqvgGOFeX5vdEYIh9bo3V7JnlZb6/LmsBvFW3qIcpgkBmN49h1X06atbHCRHZYqYNOzKj1yB1W69SsWGBmNrlIMRM/lcGz0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(4143699003)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d+qJynyEd0YxHKe2W26ooJh9Tg768RgHvjs2cBsLHjbf3QMkU+bESQFx/37A?=
 =?us-ascii?Q?GVcNwb4RRp+12Y+oHfGSuc8Huc+Sww0zSi8pxr4fy81dolH86+IPYxzmibXN?=
 =?us-ascii?Q?xZRf5OgaN4JNcUcoGgvhYNbuPvcltzqw1G6Vp47waq/1pnjtSMy/d1TEXJZC?=
 =?us-ascii?Q?mL5OeE2Fz+BNo5ipjbwbfMtveAYUsb3JSM0bSe5TKsxUiqAvzrbZuHfdiSwi?=
 =?us-ascii?Q?uqp7jF9v2T6KUBpZ776ZXEIvLXA3TFA9kxqIXLTRVovM1qJTv0/vf42NNcYX?=
 =?us-ascii?Q?fgfugVcWU4Ro+B41NlMGEb6X6vRcFgzFFm06Ozgd7xUZ25I6voXNrqBguQbR?=
 =?us-ascii?Q?f6bOcN0V3I9lNfzcByCBohx2ps/yyaWwtQ6dyLYibaLG0TnQUpRS7xI5GRes?=
 =?us-ascii?Q?/lF688NstqatoTS1ep8QVTb5h775EsHtQvBxvDDq4j3QOmeuVr7q0UD0yaPf?=
 =?us-ascii?Q?PcWgHPCmPGm1mBwgV8dsvg2b+DkUI5i+kiUfJW1n+ZnFtqOaVLFYJExvRu/8?=
 =?us-ascii?Q?7clDQ9G70EEzQhkKA7+t+Tj8Y+VWVbnuW25mqy/rj/BQ5wbENYLtIQUC0KN6?=
 =?us-ascii?Q?VcORA22e3jKHZogg68YMDzUx92OmSEshKcKXngyw2o6it/zaepJV8mMfijm5?=
 =?us-ascii?Q?VHrY3eORCClSMlJfwFEIfRoRF1y3o64YOdP5VJYh5d7LriggFkUr9f+jPmNQ?=
 =?us-ascii?Q?9vKVMuu4h5WT3B7RTL8zh0uPpvY6hXUn5nspxxc04nqX9bK9s+VNTnnf9kh6?=
 =?us-ascii?Q?Ny9VSWrrYBbnXCBw879Lol+k8QvF0lx7XlOlwxt3vd59LExr/20+a80CKJPm?=
 =?us-ascii?Q?cZ0wHb2Cq9iiKpkr4F+1pAWgXQwSsBFluf/f1eCckBOHIghj9gyfAO5XqiIp?=
 =?us-ascii?Q?uJMNJBjusu3pj6D15KI0b6tQmHkIyhaiSyyZFstSeBjuFe9pANt/BND61dmM?=
 =?us-ascii?Q?t7B7FEvhlvM6ydaP5iPLHzUeKhAg8SH6uICZERnQ5xQutPD08ra5cNszRj42?=
 =?us-ascii?Q?DW8Gnz4QBbS+Ogvg5cVoWQr7t+AZk16yJEFAuJKtee6lfOhZzbCqzqRFG54b?=
 =?us-ascii?Q?oTFS0ZlZr3YiefWZTK+cDUB+lBJN0KO3YJack2ZJoJFvF3aVpY+5LJZ4NN3V?=
 =?us-ascii?Q?sUwFiOZqqyRUr2JZbytON9TV48WcYrY7ZMhyUAHc0S8HyiEzYqENaA/7NIoU?=
 =?us-ascii?Q?qB3z/kPQIcbY5udNxwKHO0G7/hzsa+azh+xmjQOBxjR8YKUGiTk2t1v71J2G?=
 =?us-ascii?Q?KCVKQCkefg5jTWgBibu62gS/jVagL/YpGf9AS6VMxOkX7yO/6LE0H5OlsVkz?=
 =?us-ascii?Q?r6S7s3PYn1itk3B2cTb0EIWpDPVA6IDi4t9R2n4qZWaFc/dMSAhw1rpQEXZY?=
 =?us-ascii?Q?sl53wRTRfFcgUAXjeUHaMbOGZBqBhzlfTw3TK7J7TsVJLrydHJQ+5/wF2ogc?=
 =?us-ascii?Q?CXwbKF0iLmlTvWmIO/8nESTeqLtotUhZYLBMtBvlgxugjos4t5scpVZ9Dpxk?=
 =?us-ascii?Q?w12wTnR0SwWX2Nop0pwpeNz9Q8hOZyAFG1FClgsy9NQl5JBcA/4l6jA9j8y4?=
 =?us-ascii?Q?1CJrH+FP7EOVFmBhPoFn/gR2jqoUJrWGimFU+6eqvQWX4/eMXjue7vc58FYG?=
 =?us-ascii?Q?lA+MebyxXmsS/1Sy3ANzygaddgwU5ua9liJ9NJYAZrxuC9NAWPhRyt1yHsnt?=
 =?us-ascii?Q?tn7hXb7G3JsS3NATEqS6ZmiFnh/igSzGnfFuantRywERivd3Wny8AgSZLg4j?=
 =?us-ascii?Q?DM3Ovf62YQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 470ef0f9-e98b-4fb2-e731-08df106215cd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 00:09:16.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5de3pkXcg71p6uawfN2rZOZ+Vb+26lm4csCLdjH5IkkoKefTgTwqQzyRG5WLs15z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999150
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7156316000E
X-Stat-Signature: mz1u1kt3sgimqrhrfb3ihux7psh88gho
X-HE-Tag: 1789171762-659300
X-HE-Meta: U2FsdGVkX1/xP4skOzJkKGaNEljiOQx94xyZdrekz1tD1OAYkzPzs5bJp9wEqQS0BwE3JG3BdYFC2vLbYbhPZhh+jLzoUXz82526kmmiuZcp2q4MLm0mV+y7zJ57IGtinsGHprOseikYyXdBkpcNaunB7qZ3ESydpB8+Zx9nfRqxLrqBXjczLItNyiqb5C2pU791jAJwDFFj1ie2jknYSs1/lyZCP0nzIFKoWa6RVYV9KYqWBvYADmLYt1FBMmxZ+yG7HmtGITWy+zpmFV/hD0U0P+b8lHdE2ZaJDJehplV2YMc/5y0NrMzOqw5BOAmX+JgfRvXbnDwGP7fVkssfgXXw3wWzDkwTc4DoCaTiYqCBarVAu0fJ47U9/5pgjJpHkdav1iJ9IZT1MaqsUlqblKr+Qk3j2vG6Ao5KM2HI+M2PK0XF42la3yakyx0BmDfNA/sla8mNeqe81W2zeoba5p51bqni/l25xJetQM/XI7RwN2mXChqxOsGFwUzY5KWeW8dhE0ie77MUtkupGSgFgaGBMzL0GZMBfo4oqTNxavtNTWszo4bAXbOFMfoySGLTQ+uOgGmPHoki6iGcyA83/y3EtM28uMSgCi7PZf8M0ysbxD/KOPc7gMFKNv/ydZxWy46EC2ITa7g+EV+2atJOHS+oEPZ4HFqxSSOCNVHycmKS+RmriYcucegmwSS0AVQTFG1KJSoDJ6/ZW7bw3sgR+ze/tljhAiv/ETLkJu27h6nCn3XyJ704Gr/QloO87QVP0MFu+WsJYcesh/WoGKHRO5femOU+xETs46OmdNGLc10Cfii2ZNltzHkLph1BHW4Zeyy0Sh5oImykafiLp5W7geuBjtnrRpdj7hsVHqE8SBsFkMuFs3RGyKs1Q4IYM+TE2MwSSczr4jJ2t9H4EyLYSKs6l4PbrjWe6beieY9/XTM4UCnRxaIEDra30aVj1Ye93XOXkg0Cwv3pKi4gDG4
 Hs2uA9NZ
 vNX/GqBwlXKP2zmPMVo5+RHHzcYDH7DWBjp7BYBLCqWUWPC7uqaV1PTS4SOcVkModJzCa1zgo36FI8mNHKdtvWG8YKxFlBD4sUXsbCpzqyhrl2N8FLnCbTZMTnd1BuQcFetjighScnbivnvt5mRCgea9r7hK/4azGmD3CYMzwpLgd6CTE/EqtigAiAI8+TU6LG30tQXGoLpSjudOu9cTw3iEIB/qE2fJrPkMGLJscBLqdWoXgRzLVjFPgts+VVY182viVwbKlTps3rFGWN9qBZ6lkSaiPu/xjpisw2uPBZuo5sF7onQFo558WBSCbYbt7jVDYNAKBNGyvIFz0c+orfqSMY/DhaF6zP4eftkDe67lEFRjhEq0M2NUa3iUg1FHq+z+qiISOjSl9epzc/i8hMT8lUL+78GmeDrUMkd1KuzHz2b0tnvbl2xTtprsIomJ7DYjUI0NYDE2pVueeNEFhCl5cpUJbhVEga4jyB3uIUzHFkaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2026, at 19:56, Andrew Morton wrote:

> On Fri, 11 Sep 2026 14:01:55 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.=
org> wrote:
>
>>> Assisted-by: claude.ai:claude-opus-5
>>
>> Convention is now:
>>
>> Assisted-by: LLM
>>
>> See https://docs.kernel.org/process/coding-assistants.html
>
> Yeah.  That's so lame.  I like seeing what people are using - it's
> interesting.

It is like free advertising for these model[1], like I guessed.

>
> Also tautological.  What else will we ever place after
> "Assisted-by: "?  Dr Watson?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D816d9992d9ed434ec52cfbd63080d518e535a41b

Best Regards,
Yan, Zi

