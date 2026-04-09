Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ADDFF31E53
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20AA6B0092; Thu,  9 Apr 2026 11:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8856B0093; Thu,  9 Apr 2026 11:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90F646B0095; Thu,  9 Apr 2026 11:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 809476B0092
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:58:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BE4C1A06C0
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:58:03 +0000 (UTC)
X-FDA: 84639473646.26.E71F5F2
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013033.outbound.protection.outlook.com [40.93.196.33])
	by imf17.hostedemail.com (Postfix) with ESMTP id ABA4840008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:57:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="D/uNJ6Ib";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvEFiYYwoZW9/qXT4K0Frz/GfgBFdkb7Y19UYReD/z0=;
	b=Khjdh2CmoUrYQFX3zEFtXxRliqMhE1p4gjsi9rQFwcz7yFbCL5N7OX742UQkCEQH2sk9u1
	EFuIq925gAFwbSXJb+ZsgyKjR4TBP+zDQQ+xwsp5/RZUzu5E3cOf1dfnuZPvfKpcRprZlB
	2cEeCCF8Telk2Z7eTzohJUjm4QHrp6k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775750280; a=rsa-sha256;
	cv=pass;
	b=uQmZHlxBva4m8VTyxU7ch5KVEjiBnZMWQAa3aJAcUqZECTQwBFTOiDbhSgfL1PTJBtDk4r
	4ryiYlQFC2/Q9hpEbnRG1zjxJ2SMptzhUDVYwA72/jboCK11S2bEPSrZKp+FhFqcWPIeFA
	unw1arByORJMjTOsVRvUQCmnsxTlvUY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="D/uNJ6Ib";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwnrxtcqb3ZGZRJYpz/17vvoPUaL1FsH2waEFt47/89y0sn6Cf/V633n4Y5HaTHtLZQr0bOfpdNBLNBeuIzm8C8ARsQI3lqi/tDobgwCI/vzlw6z2TCx9eX/wL5ODKLSaL/qQCo1DiKN9Kkf6dQ+xKKKE4ThMnYQSe/EGNu/d0Giovf9JJs0u7wYs/IG+E/+9ozszunINlMUctcQ/OgQApFe9hJoaJyMO7meyoem5cCRprjihu6jwWOjqw6tZs2kUnWLOeviba44riYk1sgNGFYucugchrado6v9qkdN3dHbwd55j7LwiriZp/6W0fGsWtWZ2Hq/tEZvchr78TXc9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvEFiYYwoZW9/qXT4K0Frz/GfgBFdkb7Y19UYReD/z0=;
 b=xZl1q8zjMCgnCHSQr2mkQPrMBhmtLRfxbYvGRw2nE6lIkXsHL7I3whrSZvZ+PBGRe088f1N2FYPW1EWcqi488MqRPnRmw1VY63TmEij/8RrenbRAduysARt+eoClhw4+0QiL8RhHY/HtQmhNf6tCD7EygPPY9KBhtgLt1e7zi7RwUSys0svEkNzVIIfLLk7eoD8/1VIqadAs8afNPdSUwcnKrnJJ2zjgwTSotqs65AiSDI8VcGxE6fzcruetDw4DCfV7nGfattOMjbvGb0NJPjYDuhgydD0+Q4HyVzQK3eZI0L6L+FiUWW9ZrHyvQ2cB5lswuM+YkOtQFce62CCQLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvEFiYYwoZW9/qXT4K0Frz/GfgBFdkb7Y19UYReD/z0=;
 b=D/uNJ6IbeFW5S4gQnXXeTPRkEBpzK/afkbf7iChGAlYDlqX+X2UH+1PN4KmxSlwcyfJyZfxRYJYbgd5NPA2yNqZ2AySysQAmvnH6yLUU+tqMKu+MHrnoLe7JmXH1FZWPNWPhFXzXaywIbbBoGqqoIBlSmRMoX53XNP0t5d7xTo9OOg5gX2eDHuVNcWCdW0efllcozG+rh67s7znDGZq8JAS86bsZ/TxbLLc+b1izk7eiWFlCWsf/6nFI3tYuH6pyaCPjo0Lkl2vX2twELH2CMzVWojCu46fHr+v+iZD6GmmDhYsjBfu8vrnc8YpjFzOR0aBGPleV5ZOB+TXm3aTmHQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS2PR12MB9615.namprd12.prod.outlook.com (2603:10b6:8:275::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.20; Thu, 9 Apr 2026 15:57:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:57:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 10/10] mm: thp: x86: cleanup PSE feature bit usage
Date: Thu, 09 Apr 2026 11:57:41 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F9F90195-D89C-4DBF-BDFC-311A32D00B9D@nvidia.com>
In-Reply-To: <16fe2db0becab98db70f53e4ce1422450a9f40ee.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <16fe2db0becab98db70f53e4ce1422450a9f40ee.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS2PR12MB9615:EE_
X-MS-Office365-Filtering-Correlation-Id: d8b71e36-a2bb-4c25-8bfc-08de9650bc8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7hL6w1UPu3+bD6oo3Okdc5dnIPTPRmOBM3EhQuc8K1lSx2FYh2tXkbRCvn74bTn3/mvN7SSB/LbMVYjN712Xzix4UVkTmGPKZg1edKhV0ixTCvHqk1WMFUP3UvaN5S9qkh4e/2zXORPR9ry5CjqjBn98aKJ6l/WQgdeZn+ISLTGVxo4tJLsA2RTtwL75D7HhZlcZF9oOdFG5xhZvHwbhxNxHtL5JOCjaqg7hRJ1gVJU2IQ/4XyzDy8/UEXERSR9of/JQtvtW5LCLg/j6MExPNtH/8gbGSc/SO0UOv24wsejhPxvkH8WBhdDu/h5mtVc0Bl+5lRbAOjldQ6ITl7aKr7q8rPVxZrey03FfWl2E6hK1SBY2NiFdBOmTKg8PhGkOYpzSK3ZylzckJzxQz7K3zkVhF0v1rJvSWrx6juET4Z6R0FHVcy2JstbpNJjZcw5jQ/QGzXkacFofCAvjskwMuUZIEuSZiCc257ZOu9QiZlYznAd1G+IYOiG0GOtFz1ia8bi0bYFLeoXg1Pe1CAAOOnSk6fqtoLuE5Qc1pyJR1utSqVgzmpmMNciIsz7Vkt5sBrkLJ5k4lBkcd70+BftDVSmXadGcCurnM4rwNUJMpDg1q9JFLDfWBG0PXdTBh/rJG0T3+8fnmoQvSt4UU3irIk6kM1NoMANBFWRGaEUa8VouF3gRA5LIquVEpXwSz9X2l14UtCOAlEEcBl4uGgoQXFKZDWqqfeoPGq3cQblBawg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HJhpy8cd+nY2a7AeZpjXaPgKdtLYkXjuDlTPux93pysmZ8p3npLgMTqs+P39?=
 =?us-ascii?Q?sz/OzypOuA4R3CBs9jUH5blSbFEPRxxuohTWcdVN3lCLgawG08zdDqQtKQ/p?=
 =?us-ascii?Q?Yfwxxg8IToIiwGXO/Xs5cyCiKHUyY6SCXFcnORrhvA1hOrO/Agk0m+z3pwr8?=
 =?us-ascii?Q?+LyhIcR2Pk+6WsXGwX2EvPlY/M4jRXXSqpeHkJAMXlZp65FpHt34Zi6HS4My?=
 =?us-ascii?Q?O5TtD9h4DVw0UGuqOnYp/LmN2JYM8wYTBxq3APWUvJaG6+GFuN+TZlHMYxEW?=
 =?us-ascii?Q?Wak6zhHOgOsJxrK0BaIw+qziHM19R84QwWzAkjpQtOh7M9fa8H718x5UcQQy?=
 =?us-ascii?Q?SYKVr+wFAJZkjX16UzD9G4bV882LmDB97S9+L4ah75FYCiySa6vULWMOjDxB?=
 =?us-ascii?Q?THgx1SukT2vJlXf64xO2fMNQr1tTKt29IRyjmyL0LcQf6XVpOJA6h3gZ7Teo?=
 =?us-ascii?Q?63GAfet6rQrYWngGdy6w1IIEC3aNnvoT5ieMG8atvceC1N0gSA3BN01G09+h?=
 =?us-ascii?Q?rsdmEGZSL/6rJ6FNokOHND89yoH9LXzWQTgPlMgsMBJUTabFOEYi058U+/2Y?=
 =?us-ascii?Q?b4eXeFuSriXVqTCPBlnM1k/M6xnNdfW5mXcZR+5O6rnE2LAo8uzvG+i2c8rQ?=
 =?us-ascii?Q?rGrUy63l+FBk2GIAS5epjCg5mGaUQI4Z0BFlXRsWbWzawxsSRfjtju1WX6qm?=
 =?us-ascii?Q?YO76TFA5j+SOl6gy6n2itdRYkNmL0hZpyGdV61/GJJQVaMItmtZnt0XB37w1?=
 =?us-ascii?Q?IrAbzRlqt9R0hcEGOr+O6omuihiyaauggZm+8RsRE0iCuEWaer89Y5EASHxU?=
 =?us-ascii?Q?tKyednoPih2USsiYbfzyfuiGICyGvya2FZNTXKc85d5GKqByOdmCfaIlFixw?=
 =?us-ascii?Q?mXUL5LBSaEmr67UhyXMNnlHGJ6edWgpWgzK207igcyqw5V12I0Vpz1dM7GGS?=
 =?us-ascii?Q?j5L3Jj5OLZIbAluJX1W5U03vNJbMdCJ8QKBrAh1bSze37U1TIOncE26aLE7Q?=
 =?us-ascii?Q?xiqXnGQmAdbjJ8EGoN3A7YpTm0Gr9j55mwr5NpMsmxQLKq+YimRGkLNwUbwD?=
 =?us-ascii?Q?iOuZqX8fAyI5Wb9UApgklEOXquPIGZEz42066LBnF2iwhWcwUOsTLRvqh3lr?=
 =?us-ascii?Q?0MiUGN6hobCURvXut0NoAXUH016eP6UyjXO3lqNiaFslNLXHh+r+AQKjizy6?=
 =?us-ascii?Q?YL75f9SJqmjfwYWlghkApZ7KyA8nlHUU6T+lh+Pab/zMaCTLRqE55FRelHAf?=
 =?us-ascii?Q?Oskid9IDZHMvZnJXpAPlzR+N8rPpq893WJAhB0d0ytWdG2Z7t7hs5TvcLm4v?=
 =?us-ascii?Q?Yw3DjB8aNhfYd2wTo1ynFQYZemer2ISzk7zelhOj9DzxPIyiG2x3O/nrkAY6?=
 =?us-ascii?Q?u2Pxww3wAGqNtjIMDnfPh8bXXlCGH0ZCxMRK+pw6Rc0UITc9fScNNQzZeQNX?=
 =?us-ascii?Q?p0Yr3LhBnjLPaIKbXrMS5sDlZSEdtkba+5DpISia7edSZO/KybfWh/LpVYjD?=
 =?us-ascii?Q?Slc4rQ2FL4XtbZZg9LmMKZKtsvsUmGP/XR9dNBT5pYkG94jfQ/F+8C+A9RPe?=
 =?us-ascii?Q?uiTH+MtuSwGD6jhT7tknuMxPaEF91bt1ek5hB94u+1m+s+71TA4dNMXq3wTF?=
 =?us-ascii?Q?7Prd+5xLSJX2MXDSbHfgblTKC9Pav3NZVcxQBobmBgiuRr1MwiivIk9chvSj?=
 =?us-ascii?Q?QcYGYWspAHrGLKQCIkIQU5+Cr+0pJVHkmgNBigyVPVBwuUsnLpVeGp1KOP5Q?=
 =?us-ascii?Q?Y8YrlAniRQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b71e36-a2bb-4c25-8bfc-08de9650bc8e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:57:43.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JdFT3naKUAY/lUgERhYet+tkKtu6B6oy2iKU8+obKHPSpu6RF6h0L/vF3WTraGy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9615
X-Rspamd-Queue-Id: ABA4840008
X-Stat-Signature: 8e6nfwrdhb1i48zh41tsgathsfh8puze
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775750279-354413
X-HE-Meta: U2FsdGVkX18prp4lR/5RO4vNlPOEqE8KUoccOYiF0ErsyX9cgEpKte1/QIbZetJG3IOmKxEnM+3ctXsH/+HgvAKOB9D4a5BoJcpE2TOX8AEoyN+II4a1vej/x8WqI5Kztb5SJ5sj8/lJ5ua2FOWKby3QfRlP1Zyw1ggYcv53F/CrwkVwaSBV5ZBD1BKbo/zv8QDXsQ9bn2oXRin1GfmiY2fVNwJUHqcCh6Nyit94cEd+Q/01naWgeDfr/aNfEr+UER+wqDumy5q7Ptxx7X3R5ptI2ooeAnClyfdbwWpaE+OMz1elP0ZkzCDllD9jsr8CIkzmVvIXxXv4WLRCBdxV1SkYLtBdIrd+LklrOKR4JRhWu9e0Y7mqQf+JR/U1MqYnchzAnp87l2JLhDRhLzjqgN3B3m2GqUBYKvYbNWaZ+dxMKd4hC25bOxH0Cmw+TAu70NYMQiwBxn0lyi/IBMW7ruLeGgRQmOzE1Qlpn1e753jt8Ah7gtI0/M7R53E9T3iw3O6bT+glOgU1NKgEW7jIewircS5SvjsCHiOldL9JQny2QfXsc3Qwg5NUuJce2Vkb7fgfl+FcMqOudOZCo3vX5G0kR8mCQcU+VMaLVpaCVVAwUFZleavcfvFAInyYrFrNYxSMXoHh7F75GeAoAUuIBhUGiZaz1WGwU6zGNxmIYbAiP/bQs6fMHoGVqdeK4UKFKHYsmwMTO+Il7XreqpcvdzW3kVMQo4KDtoYsGdYw3OhyG7XOCVgh+D5b7+x3puk9mD1OHjW+ctj4ggJWWqJZ+CrQ1eiEGh9qZYeslMXFX/IdWXxS3geoaJI67Z7eDMzvYL3tI2V3QV5E77S5jh006HG+pd2K9lq6R7XXm15piQnwjfhluDx1xvf8CaEfpPaPdCC8xHmRryNjQInAVa1nayD3VgU5jxLgwlNT/TzEw8TjUA6SPp1Bj7yzjV57JZMzIp6pKqIlE0rM0rYb5kF
 H1FBTakL
 VEbiGnVooaCTee+1sStqYWIxMJ/as4XJUZvFDO+zDmGTFw3SWwjaoMxBxoU3kk6QTfz7NOOvvtT0Uq0etp1PCtLZMWRtBaFs+B4nxDQnElLYwwPLkCujs/yAIizkbasCvp1VphUZ+Hitq3jbhoZ4R8IAp5GSjcstJTncckfPg+ifZocX+ZzeJytfWWG11nlsSDbCI1BHs9AuYNqOk72Yx8CyQ2SgR4wpGHZb5QCNPXhri+bTdAFaqTlJBGCI62v3T/K5RKeWvmCfkD1fEaItcUVK9i0w9f8dJlFwDQxSk+2zkYW7MksHQisuCBTft5EAei7g9naAiuwF7/dB5FAQaV/gsDoBDQV72GbN7mhaBVHhMmT3I8S/pf+CrlK7gLFSDBDri
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+X86 maintainers

On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:

> Historically, THP support on x86 checked the PSE feature bit to enable
> THP. On 64-bit, this check is redundant since PSE is always enabled by
> default for compatibility. On 32-bit, PSE can enable 2 MiB or 4 MiB
> page sizes so it must be checked. To clean this up, this commit:
>
> 1. Drops arch_has_pmd_leaves() from common x86 code. For 64-bit,
>    we assume PMD-sized pages are always supported
>
> 2. Checks for PSE only on 32-bit by implementing arch_has_pmd_leaves()
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  arch/x86/include/asm/pgtable.h    | 6 ------
>  arch/x86/include/asm/pgtable_32.h | 6 ++++++
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgta=
ble.h
> index 8fe95270b713..f45568f9513c 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -314,12 +314,6 @@ static inline int pud_trans_huge(pud_t pud)
>  }
>  #endif
>
> -#define arch_has_pmd_leaves arch_has_pmd_leaves
> -static inline int arch_has_pmd_leaves(void)
> -{
> -	return boot_cpu_has(X86_FEATURE_PSE);
> -}
> -
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  static inline bool pmd_special(pmd_t pmd)
>  {
> diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/p=
gtable_32.h
> index acea0cfa2460..1db3214cfb45 100644
> --- a/arch/x86/include/asm/pgtable_32.h
> +++ b/arch/x86/include/asm/pgtable_32.h
> @@ -44,6 +44,12 @@ do {						\
>  	flush_tlb_one_kernel((vaddr));		\
>  } while (0)
>
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +static inline int arch_has_pmd_leaves(void)
> +{
> +	return boot_cpu_has(X86_FEATURE_PSE);
> +}
> +
>  #endif /* !__ASSEMBLER__ */
>
>  /*
> -- =

> 2.53.0


Best Regards,
Yan, Zi

