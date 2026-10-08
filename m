Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7633ACA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 10:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB746B008A; Thu,  8 Oct 2026 06:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3831F6B008C; Thu,  8 Oct 2026 06:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271296B0095; Thu,  8 Oct 2026 06:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDC9A6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:42:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 130A9120232
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:42:19 +0000 (UTC)
X-FDA: 85299119640.02.9504489
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013026.outbound.protection.outlook.com [40.107.159.26])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B71EA000B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:42:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.s=selector1-NXP1-onmicrosoft-com header.b=WdsxKquO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of peng.fan@oss.nxp.com designates 40.107.159.26 as permitted sender) smtp.mailfrom=peng.fan@oss.nxp.com;
	dmarc=pass (policy=none) header.from=nxp.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791456137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IiY4eOIs8J7uAWi7PGNUM9GHXOK/i8AU7rGMcwmbFds=;
	b=2L7tBp76V/XFiPc27pj55qHz4e4wVBcEEFS3pJH79wMNPdJYB8piuBbG/+NZGkopgW33ew
	TNGfP4uTd/vlKQ10cEeJARC9pOxzcn7wC23DAF5hP3V9dB8SZiD4iKnIj6ZRRWmu0zLCzm
	VL+EObvSxOj6zRdpdQDw6yS4jNfQpaY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.s=selector1-NXP1-onmicrosoft-com header.b=WdsxKquO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of peng.fan@oss.nxp.com designates 40.107.159.26 as permitted sender) smtp.mailfrom=peng.fan@oss.nxp.com;
	dmarc=pass (policy=none) header.from=nxp.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791456137;
	b=zrqlMhCgsU7VZ29/i/5xQBZUNNJj1yZrfk5OFbusqMuMepX7gnCuQRI94NzYPiLvGK0bBG
	vfI61EuL38mF8uTG7m4GL84u68Fnm35GFvs3zSbALeD9q6bE4Aqd+zXTmpTSV2BP9PcSYh
	WK1mhK05dJmwVQjMDnbar461YG6MEr4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AQU0q/Ht8KbbssvPaYg/XQwvDTJ7FszSso1AFOUxxml/pMkLvPXkjvdTmBmGdLkMehxK8Q3YAS/2k5Cz/lOEFUsodUQqbnLbFkTACoiKL2S6ilWJUUr9SxgEuvmRk52yXHOCF8Se8qIMMMcSEa6fJXqvzg39UXdwMm9i2MjkuW8ntLfxIdPO9vgJgpiJ6SWPB9+YK6s9fO/rgMZqzUGj+ErctZIU/Hl7/g2rVut75ve3TlUU8h6QxHj1X53zi2Z9xfYOqV6vSxt7K18K6z68DaQGNmenv+4n2uNdZLOtTcwJ/OZb9l9krnsKjYiggXQCAbdxaUsUUFDw8gdJs0GG+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiY4eOIs8J7uAWi7PGNUM9GHXOK/i8AU7rGMcwmbFds=;
 b=e86qRgm1XBOqK3yA09xmGxOXbec9X5G4HEeg4gLfQh1RzfxHNBAxphowUbK+z8E6pGeXdxKoFYlvuVtFB7DcswHy53yaa+6P7dlXqHmV/v7wKRn1h6yTGX5+34CSqDnho4XxYxzNCov93Iy2SfgW6CDgx0bBT6jZKuzPeMT0/e2rNSzkiF7kAZUlFTY7nz+FCA8W8EiGeEkMupj5z81MYj6RvRT0/5JjZr3Wa201XQrkB1TeoRj9GZu/kpAg7lRwhQqUQltvr/m2HrB4ipNVcZCsxIIOYQV/UnqPoms8fuu8Jnk9/YT5g1WbvVmiYhnV2rtinnzyPmDa0heX2HOkaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiY4eOIs8J7uAWi7PGNUM9GHXOK/i8AU7rGMcwmbFds=;
 b=WdsxKquO4DlUEb11lCpbORXOzgkcu1P+YKmCBpmBk/CEbaecDm/bv1e3ejxrPAHUA3DZg9smPzRHpXblNWomIb1YxZvFwaxlL62v7hp9pd0vr43QvnQ796xBjAOOfsXoG4mHGzfpcLVjfIAzEg4pJAdKM7jLTq6CNaiH83zJ7oZSd10sFqBsgdHQJjX0tYA3RihuyWW2N6sntSd4rtYJ+hzNqUMJ9XFp1FfoJ/HdbIvc5Zc0zCFc/W+iTVKL4dmuQbHKgbnGpsQFjQHzECMJ5UJCR4AGyC8Y9DPRZnrwzhVp6uMx5N6ev28ElRpKJHf7+YmtURDnuGblruH7sbz4Hw==
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by PA4PR04MB9365.eurprd04.prod.outlook.com (2603:10a6:102:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Thu, 8 Oct
 2026 10:42:08 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 10:42:08 +0000
Date: Thu, 8 Oct 2026 18:46:41 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Michael Reeves <michael.reeves077@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	maple-tree@lists.infradead.org, asahi@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] regmap: Remove debugfs before cache teardown
Message-ID: <asd0kW0o6Cn4KIgD@shlinux89>
References: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
 <20261006-regcache-lifecycle-submit-v3-1-37bdd82fd47c@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006-regcache-lifecycle-submit-v3-1-37bdd82fd47c@gmail.com>
X-ClientProxiedBy: SG2P153CA0026.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::13)
 To AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|PA4PR04MB9365:EE_
X-MS-Office365-Filtering-Correlation-Id: c86168a0-7aa3-4c2e-138d-08df2528cd5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|23010399003|7416014|18002099003|22082099003|4143699003|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	kwqMRPWGrdvN+9YuoiLFiEuhIG94oR9pXYXd3P5ADd5eOAFfKuzGOowaxMBnRsaA0+VrSVdO+lgAZwyyH9qHHup6xHnEvJNNuLWALfDtTTf16vIrDquwl3udjUq9R9Om4uy6LtNV5UqM7IgN73RALDadtAK+qP9MZdjtpKpsD8a3OusV5UB9WZVFiG5pBoCMkFLjsRVsOJXBPFY7LwfQE7wNaFenyhgx5BJX94yABFTBjmSeo/EGJo5m2pg8t0VEx7Zz7eyr6lQBz16C0C1x4uBN4rkMJQbWD1s6TVjd5NFCeXTyVqI6Bwz6QQ0wJYhBx2FbvHtXoPWHhYqrbkbiindVkX81Ed7TXRhTg8vA8kAJi6W/3fzmsSAIFRR7QBFE8wyjHuF2sZgLj+hudWXwJTudXimCR1PT6YJTcV1CTTppUqyabKftpaUajy4BnGyOr+eCqi1+4U02zjqN/cVkpaFoz7WCmKGAXgpSeCTfkSffzCyLy/1n9uiRCeA+fE2q/wOfSOcl+GQYBIPegc+AJ4Ir44d/6LjAKtErzszNEx53UjLtQ+reaxWc89rsSO1Xby/ed3RTYK9LUDDtNdoGl9nV1Rf5HOtaujdQzDBeH78kHOIv7HccNHFGflfobMNC5EEgsmGnGwjA0X3lkNrwM//FAdtWrjlbpz++qA26HuI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(23010399003)(7416014)(18002099003)(22082099003)(4143699003)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dt2EuQn3TaNjZvYToTCVmStwlqS6AoBjHBygfsTCI2TdGOhy3R4o9CHT4KN3?=
 =?us-ascii?Q?8mONHZ+9m9Qd2TR5Z1G/s+HfASfQXfw+rtIBkqwUsP3Bxhe1fp6wLjnulx7o?=
 =?us-ascii?Q?9TU1TAoty59J6Zir4b086gB2bVtjBODPAPMA83d6mg7pZ5eNFj5bHhvJkLiN?=
 =?us-ascii?Q?wbl5v8v/GXrSC7RcvGh8IuAh606YWyQxKvNAfwzR/KMvR8UnT18XJEq+i6nD?=
 =?us-ascii?Q?JKQI9Iju1FPqb/MnbOcO1K6nHZG9j9wCNVW4xiAUln3YpVNywuSxm3YhBZOp?=
 =?us-ascii?Q?ojeU2ZICqdcCvpZQdWFjFnTxZbc1i5CSxzWbXdFVwpKF/hShZcklDlJ6hTQ7?=
 =?us-ascii?Q?CB78F5A0kJOrF5WnpsuDMYQEqwn4SvsHMvQGlqj+YmsZt1u+DzkBREO5y3Bw?=
 =?us-ascii?Q?SLCHZkUFRlJOm0AY2EfsVnHdf1Ordo5WEApXndJ7ODDQqVi7ybIjqJMK5ruC?=
 =?us-ascii?Q?T1Jnqaz5Llbt3/5S/wNXZxX0vGP8BMQZsuCAhmCB04V9yBHTBayoztpAijFO?=
 =?us-ascii?Q?6vX+F97pBmyBE+PQldiR2WDIxk2lmg9vq0u26n2vf1hhq8Sqv/uQdyGozcAX?=
 =?us-ascii?Q?bB0UFzgDoR3TJRUSSwA+Z34fjSacl0qS6wJM7FdtWZoq1ugu97aW9BFsCJWF?=
 =?us-ascii?Q?rhx5+1Pnsk0+5HsnZteSHxLMjJwt3tfXFS6ZBajF2aCh2NCqEgf+aWrbigG6?=
 =?us-ascii?Q?T7Ol2YeRSIl/5H3HgJM1gVZRRBQOf+qNKwZpjO0OmHAAbhrVJl9Lw5SbfRRU?=
 =?us-ascii?Q?+Jv2z/xYt1t98Zf01Oq1ED2oA8w6+9Rue8nP9W9WxYijuxvvNUlHJyD7j9f5?=
 =?us-ascii?Q?C95B5v4U6lRd9/3k3YaIBFW0Conk5TT4kxf22424MRQOjtD1PaRQj1/WfgQt?=
 =?us-ascii?Q?MClf44e5IBtOwA9DaIkwgnH0ePicDbPmgizYNma1ZUo35rBaDCjP2CxrZqFV?=
 =?us-ascii?Q?AYaycAmanhJuHV1oURxNoIZ6YPTRYd+m96pB7oNQn+vb+jIMQiOAwzVxX9QL?=
 =?us-ascii?Q?tBWSk8ARo7y3r/DzykQ1AU5ki1XW0ALUWq6UxMY4c97jbR5h5yax9C+X0bQG?=
 =?us-ascii?Q?+9ssDFVkf9RUQcsAB13TNLbbeBUiqMUeJRAq7404W2CM4H934izIIHMQoTLO?=
 =?us-ascii?Q?nMcxs7/RNQxACbVaQGYsSSGV8BjoOZkV0WVRP7Gl69XO8i9flQH1It1EaOYh?=
 =?us-ascii?Q?bGVlRvPAuxYSwHjYKZWIgDHo4xlJraYGe7ZTKM4Ub3nMRo8zQWWGTIdJpcgL?=
 =?us-ascii?Q?GTLsywXRXRi9/Z5d/6Q4qv1SAaBvVZBNpz6iLzPD5aO9jTfDifAi0wj/RhU9?=
 =?us-ascii?Q?CJa2FShdBT5nt1wnJ4Ce3GByYAO/ESqkWeOUg2m0BEebTiAitWpiDxpi1pws?=
 =?us-ascii?Q?N6uYN9l0/WKVxW66hXxMxmBtZ8JoyAwvb/ThygFuLKYjkk9GjjtqiXd/AFE2?=
 =?us-ascii?Q?XfJiJBy8CSPI9x2MwGSA1YS5b6IpYWmmIWtGTM+QtNB6AoLtLejiOx/csXoq?=
 =?us-ascii?Q?WxuukoxINVPSdsD+jlDmiywAtvl6JBGTY46wcyCoHQDRRXKqqWz6Wlg79EVu?=
 =?us-ascii?Q?paE2Ai93l3rhYgEOuX1dm5szpxI3U1Ey3Y76dMCEA5/FE+exZ7oUpt+1QEzN?=
 =?us-ascii?Q?bBiuE4trxvicmns2uNmLvrJHMJHTIGFr84wMvQAqX4tsspJLngaKXNZ13tYG?=
 =?us-ascii?Q?EHI9k1qUM4XDi+do7zeADNNcC+47ruGDwDlf3ENb/XS2uh+N5uC/JVw/b9bW?=
 =?us-ascii?Q?KeY+t+5GG2c1v9OyhXYCubVmd+jnxZtXUi6Dvns9ZyeJfRL+Npca?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86168a0-7aa3-4c2e-138d-08df2528cd5b
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 10:42:08.7168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TKJsSTkNBbrTzD2jGlbi9OGzuMct6o0fuXFnHYRJa0QSg+31aoDWtHsek7+XSJDc2JHYedjmrkCYOVEGv7YhQPuWYLHNXKoA90rexB603zYGzAjNBBCC2s8aQ2EEIWB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9365
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B71EA000B
X-Rspam-User: 
X-Stat-Signature: mgzr7zfyx7am1n1esdio3jfzipop1dyg
X-HE-Tag: 1791456136-834066
X-HE-Meta: U2FsdGVkX19hnjp+El05jo/OsK619VrFl2BuScggemifV9knKjGnQAaMCLkaG4kr3v8ECV8cWtwNtyF9oBr9Zjmvz5n4N9Bz7ZEpTmMrGnZpovLBv15MrlZl37RthC4oppJCsA/DIrUNHkjT1heGOsTPcTfU++/61ba7Ru0UIXanNw26SKQKcA5FlW9zDNvUPWyo/vBtO5HPHAKtcd7f0cnYvbC0GrUSfsxKVvwrx6bmhKmait20secYgZr56w4vwoU5Z2pRsUd/07l+5rXrPE17QhPNvsvWOouMfgeXqLNVey/bCy0Zc6bSKAVib8JTsmlRFTAmH3xyu5epKj3Fq+/xxEWwTthvEFt1g8VDQlG5Z/z/cI970IUAIlYEAdVS+06J8WaGJYz0V6+QbjWKN9ZqgQ5FPFA/WgDrTMaMApJV3uRXPB/g/Rav5zvVPk2M3rKmrjbrt+Wad71gSSbAP3Bm6u5bXuSpXKjA+5xwQ8wZ1Vh+RPjBm2E2jcFnef4kvlP+vgPR65Sp4WW20yEUHdmpb2QEBOqIm15EkUPF7wzLVIEj5WVZurMUsu8RWq6BMzHGA9vb1kVEhmh2sAYLEm67uiDTxmJG07nNYuVDVnPtEkOJeadvJKXPzQCDa03ZSwxA/CTSt+rOjGh/t+Yok6aY7nXETiK5up2sAhMtlwpV8hJTVjUvYR2HbQzrT9JFKCe+Ydbani2dXDCAfhrDvtrR4h31xTtO2Eq9G9M07znS31wHR51JRHd1y2D2Rldf4AjaUh7V7sIlbPw6szX/EYmgJUndNLwQDyRB8MNRxtonD72jFi7RxGfEFYH2lHYf5xsn7UI9/BcZI7Q+Effg4ySNDWbqqCyDGaM09a+ZV2eGG6tXHqXS4hjw4hk+o0MnjneEjx1ObXvJOXna/qmNI5cFKGjeFvVN50kJcAERqFDQrJceEgpNtNDPYfaRgYRwhEiswoTMVO/zojiidr2
 6zPgsr0F
 BBSsJpxqIVgc1krXjubzlm/p3YV/dPgIf9WKwbgHMluo+zqaywbXo9rCuJbezUhrhy4/nfhjjGtDmO9V7YjJV9hphVqAbsODcUhzpcH/foxAy8NKr2JjTjC0INigdCDye4LrAMn8oNvIT39xZxSNd100Hgs8wkCAaqBR6UZR8t+PR3MGT+z57a3l8zBJqovITqMrKOfg0rbkA4ruk+Z5gNNN1m0TYpYKeOP/XJ4KjSP38AyWDbTVmn/8/PJfJ9YlRTxkUm4s2DmIpDMcBmOrtxgDRoHXbvfB8TEdo8S4S0ipj4liMewjoY5L/6Q/kp2DeZqGSSXOE4lUyvDi6FYJTQgNc4X28gLD5+aAv00bDlvQ9ByjFRi1Agww7BoVzEDqhV7CN/zx8uZBJaEtlaFBFGjiRTuWdIUtxnMnaFjNz0VDsdyap8KYlkwAiUqcPqHnnIOLUcvhTOOMB2k4GVZdI2tM1TpJvmPd+lO6PXjjFa7AJgIBDJfSDRqThu8rVEq/JyK+oDNdvo2SWfGFzMlceviccY7B69WDFfl+yl6oU0mJwfvpdrTQKwzOgsqc0vQCvRngKmf4TAUoIf0Fr3wZYgXFsbioH629nJ9T0r9ub4Oe4h60+lIOHjN82XVwjLoIoS7ybCkpTM/g45Wh/diETEEfOBFInFzrvzwoQ4wRzVj1Hu8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 06:03:15PM +1100, Michael Reeves wrote:
>regmap_exit() and regmap_reinit_cache() destroy the register cache before
>removing debugfs. A concurrent debugfs cache operation can therefore
>access cache state after the backend exit callback starts freeing it.
>
>Remove debugfs before cache teardown, and clear the debugfs pointer after
>removal. During cache reinitialization, recreate debugfs only after the
>new cache initializes successfully.
>
>Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>

