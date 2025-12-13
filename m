Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF054D59F6D
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 04:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037516B0007; Fri, 12 Dec 2025 23:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03376B0008; Fri, 12 Dec 2025 23:53:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3896B000C; Fri, 12 Dec 2025 23:53:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C40026B0007
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:53:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E80B14048D
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:53:04 +0000 (UTC)
X-FDA: 84213228288.22.4CA2051
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010030.outbound.protection.outlook.com [52.101.85.30])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5E44F20012
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:53:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=idxL6oXm;
	spf=pass (imf03.hostedemail.com: domain of ankita@nvidia.com designates 52.101.85.30 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765601581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+HTCVOBo6TEXmDWrloiVInElaLaXqqfEDAwCDwhzJ8=;
	b=r6uD30N9Yqw7FYk3eaO4XdS2AFRhoaXO4VfpEGfrmJXDMnhqrP1YRjVw9mlzyGIyP/Zqw2
	LvQDSBZpS1aOYGJY5W6djffkofIpoiXG96LQlQuf/xuQFgPwuRuN0UqTvWd3sLu4JGwR2h
	jfom/ikaYHFPxU+JpsJddetHaK5oYxE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=idxL6oXm;
	spf=pass (imf03.hostedemail.com: domain of ankita@nvidia.com designates 52.101.85.30 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765601581; a=rsa-sha256;
	cv=pass;
	b=6DgkRodcgxCrj7P4PU1emiRvtjsqYI4pJhTYlAln0H1sGrJnElOpm3RZa4fJi8HNgDHE+A
	Cg60xeuqlDJDmpyLFnfduh186HFcbVVYtOEFvrcWFyzqbqEY48grxUduHfsdEBFkkV4QSd
	nhHNqJpPR0RLMqrrKSoBCg/TgBEqIF4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLmtSNRaQ8FHY6vuNhzhFlMFY3Narw+u4y7OuNNxONZplYYxcCOnNrjRgJ9EbALxjenKjlPns12K85xIQE586uzQtuPrtPWaWMD9cF1XvLgWQZm9VgAupBF1Jooxl+e+8uywsPGDlmgRWq6U8tCqj09gw6QHwOa+1rwejdR4Ru/B685Nd/2nKf4sT6eiZQVipkPNIJC7V71jr4QSujxHj8vUeSiu+Oa4nlp86iuEhMf6/dImLSe70bRxS2dBbiEEud873CxSvoLWhcXjUBdKE2vlEDnxNmlLJOKGNOV3hgI1vqEcwhoglPGbNofdsS1qQNT4upAbk/+GurhR27FNeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+HTCVOBo6TEXmDWrloiVInElaLaXqqfEDAwCDwhzJ8=;
 b=Lq+e/ih+r+PyQS8yeafAeVC3FGB8pENBqLLotKOh8iFN9jG892CCmwA49F7bAqcRhlP5XARMGjOZVSGrjUIPiZ5lQF5bjl1nzLdQopTUdn4uSsCn+XZtsNKqJmHX8E6dmRzNj7ymg8EYzU0S9RsT0ZelbStLLUZrm6HPK31SbCs/3cyKiyz+K0EpRnNSJO6AMTxQcXYluhZg5rzzDEWQCiEcWE7YXWYO9khRhpANSNtugrMHKRqG2uc9kH6CgZXKxR6tmr+jAZOzOmMFvMxsmlKoyewuAFNlF9siC6JgFcf/F4SuYz9I1if+ihlkbqoK6P3yC8Ip5tLt6FEwfr3dbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+HTCVOBo6TEXmDWrloiVInElaLaXqqfEDAwCDwhzJ8=;
 b=idxL6oXmUhtYmiy2dC+wu70iaiAFXOpVh+2VARJZJTmiBsoJwwnjAjJPVZNWoCA3lIJeJrjnFcy9nu6a0sqZyPBKGQQ5336q2dthV0vwGpXAXvFQFO2ucknkaPxFJabBVPXqe3KyTf5yl0pkra547LuKsgtTOxG4RptfwpKeN3LeOanHzlhvL/wLL4xxuHGCetu8OJ+CnqKGVgMxGV0Xi7ajID/be/xxDFKlsDM4XOLoDwp4eRQKZH8Q0B/o3vGdIYz1w+gqCqz2JC5YYTN4+Z6c8SZBlBJVx+EZwM+RX+brM627+kzK4ocQL+GUwWcRzHx8kktnduIEuFwjkO70MA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Sat, 13 Dec
 2025 04:52:56 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9412.005; Sat, 13 Dec 2025
 04:52:56 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
CC: Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Shameer Kolothum
	<skolothumtho@nvidia.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, Neo Jia
	<cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v1 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Thread-Topic: [PATCH v1 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Thread-Index: AQHcamyq2Se5E0Bmd0uZgPLzFbZ8gbUerqKAgABUrDI=
Date: Sat, 13 Dec 2025 04:52:56 +0000
Message-ID:
 <SA1PR12MB7199E3B570F2E05183532E52B0AFA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
	<20251211070603.338701-4-ankita@nvidia.com>
 <20251213084757.0e6089f7.alex@shazbot.org>
In-Reply-To: <20251213084757.0e6089f7.alex@shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ0PR12MB7066:EE_
x-ms-office365-filtering-correlation-id: 4b1a2c11-e039-41b5-dc85-08de3a037b54
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?dJzO9ZdqIkG97nA3wPS84pv2i4cADqYmEKbq1wG2yOvO4XPpopX8OXAzaU?=
 =?iso-8859-1?Q?NPQGXTsyy+NTzXqslas498Ru3+6hwiX4g3DSXd0GQwSXqWZowwttTyZGr+?=
 =?iso-8859-1?Q?JUsGdU8Vq4ooxV0YT5ZiMsltmvfOj8p2omOcW+uw+Y8c6tuXDed2zRTBWF?=
 =?iso-8859-1?Q?bc+fc8hq+yuAh/RDjUcoCBJXtcScrXCYpYlSa0W9iwECn5QqQX27KI/C03?=
 =?iso-8859-1?Q?7/xmYnrK8+HDqj0RPxba1eI2YHaWB5BJyrv9JthurUtRR1b1LVQ/pD1Kbk?=
 =?iso-8859-1?Q?IjFbQ8bLLXEDmS0rvLOHaE6Oz+nKALco4OGI09ruSZYmPjFUn43Bvntl/t?=
 =?iso-8859-1?Q?BY2ATDkTZpa49COl4T/WTaJsZY0/9zQ8SHvjOgzq9zfMX+H8NliD7Ii579?=
 =?iso-8859-1?Q?ROGx/+PLxdYYVNWhYHypVa0wtJ21jTH0yGOKt2bd67b6oqTmYc+md8Ym0L?=
 =?iso-8859-1?Q?AvhGRR2gTGC8RmkBJtAzz+oiGtdUiDtpuKQDllilmhldFOvxy8aYmO2D0E?=
 =?iso-8859-1?Q?u8/60+MgGKw4PZGkOD4LdtesTs1KrAKKV+c3pVXqozW+r8zq6xzpMpUmlg?=
 =?iso-8859-1?Q?y2FqC2wJTc91ft4GX/x1O+0JizA3sm7hlTO8hoLCvvpMVxVgUs7xmClFc0?=
 =?iso-8859-1?Q?41shXp8WdbC5UiZXard05LBOhc9QXQN2KPJIEHgd0txQt4ZsfbSvLUlkJz?=
 =?iso-8859-1?Q?gQPfzK5ujJiQ18s8HuLq4fDsp0j2Ja+AwzlT8fZhqL/Uh7JDSp7Nli+RjF?=
 =?iso-8859-1?Q?z+28qcCIk2/ft9N2/VjfeqMw8b47yHDdQBPEETq99nFpJIS+wgHSLrkaLL?=
 =?iso-8859-1?Q?T7IeJWNzhBzqWLXY/B3b6L7ZOZ7mxBic1ImoZ/nBDVJm1zkmzu1beffoBj?=
 =?iso-8859-1?Q?/cpEHyWLWTHluGXsW6SolfzTr5LQ6WE3SotXvpV+qEBRFkOJLc/5gEA8cL?=
 =?iso-8859-1?Q?yfU/MCDulTmZbFsemDFdAem3WcVaOSMUTSpSWm5hhmR9qViCQLgG/CBUnr?=
 =?iso-8859-1?Q?873oQ16wIcs2zpqwnn/bzA41/3Uhk5pcXjVCWBoVAxqS6zHtqzDGEXYUiV?=
 =?iso-8859-1?Q?0FlE3uhvcWEyeuYJoTOaNi7JCioUiLAxm7RyQz0mRZgdYlYdOVagv1WEVp?=
 =?iso-8859-1?Q?Y0lF8z26Xkj47h4HmsL+tfl7ghaqWGaWba1TCXnCiYPNgMbzpXl7GZEdb7?=
 =?iso-8859-1?Q?Wym3zPR9962cBH3CSPJqMs+y4GLawuFpQ46pZ3NSxc3t9WPOGM4P2apmo6?=
 =?iso-8859-1?Q?4h+s21PSGgbld1spN7LV8vQZtKC+weSTGXmnNaqmMIkoN8QACQrqKX17yq?=
 =?iso-8859-1?Q?mABYQTjhQNCO4xA6DDeQ4Q1WfsqEDaNBBqRsJVNpDLw/QdX2JbDJkbfbtT?=
 =?iso-8859-1?Q?AqSNrhEYgA51LeZlp0VZrv5MopXN5uPpvFMPL2CtERYt4Mvl5eQmCBVJiF?=
 =?iso-8859-1?Q?g3nVD0jMBxrG1mfHO7anzEx0fo0WEhNqL0G8R9diytjz/tSDWyWh/OaM3N?=
 =?iso-8859-1?Q?e02MWpYLnIFbQdnDFCPceZulBexsx23qptBXPZJ2YznCC60+gyOHxKnnQG?=
 =?iso-8859-1?Q?gyK6GuJR/UAn5rDRNxxvFtExkkYX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?q+qbhgOpuAUy2JULRXaPq5J2hruL8joZgaCmVcTAGoDdg4C89VSh/VzFIg?=
 =?iso-8859-1?Q?c661kTI3HXCJ5bkn3DRkcblwYxA/BMLNPVGCD+ovShhNEO66jP3pMVm3OF?=
 =?iso-8859-1?Q?Fm8iTYVc8rBX4EpvVkinGoIWJ6ZJLuVEbl7F5uAm0L/RFzlYJ5Aok3Qhce?=
 =?iso-8859-1?Q?7Q5VdgWQL7ihoeljQwmu7bhhmQ/PlEHDVs+p/0pE2Gw4/7MHOcnWSTllQH?=
 =?iso-8859-1?Q?r3zEBdmgXWBVhw1JnGPT/aUJFJa/MvKcfhkgKR494Zm3kBVKopANrhxIxB?=
 =?iso-8859-1?Q?PgYbbBHxqkIbxIC8C009rBzVW+yjjFedMNdxbk5GBcKIE70XoF8YRhVba6?=
 =?iso-8859-1?Q?Nxw5N0So4dZNY4Hq8dzSRBxO5asxHGkJHPnSkWqXEeKut7GFqHWW5a/10A?=
 =?iso-8859-1?Q?Euk8uQh8L83YWafLfauJe5IAGd0jck5+Z6XsFBLU4UpBcZTrB7EBlCfOxN?=
 =?iso-8859-1?Q?NP2id9qvFhuS0txGVvTRo9yyhLp4p9jtfR50hLqbcB2vTOy99mJNCo8bu9?=
 =?iso-8859-1?Q?DcKqBDzi1dfvnPRB8KF3JetWgNi6FaL5fFATOPzRu5FnB8D4TJNJQfJF3B?=
 =?iso-8859-1?Q?IUuN2KbO4ru8MxwhkvQcf4aPnGB58MTYoBDxlWzTf6OiP7QDHmzB7WKUoV?=
 =?iso-8859-1?Q?k5dSueUVTfb0AWLPa3gaceGYtUz0qJK9//n++ck1nOmc9V5Nz1zRc7jbpW?=
 =?iso-8859-1?Q?iAzcuC/exd5k/79231WEvUEdfzHrWZNJTFMhndTRVyoxU3/6FO2OGxxmL1?=
 =?iso-8859-1?Q?2ST/+PR6Vh6pOuIik0XWgvvfiBBE4tsF28QWLc5DZLBLUjW6UBQQqsiksW?=
 =?iso-8859-1?Q?fSrpzYuX6UP4dLSAukGBz3T4veO9LPseDo5YcKts20QCYpsVbn2LLrBYTc?=
 =?iso-8859-1?Q?5u67CCD0TmdrlbmBt4jb8hKNdkrgqgUqCasgsFfXtH4gQPnJtbJvfHd34I?=
 =?iso-8859-1?Q?t+NaOmNErjRNOtempx52dzuffZJFZ7zoMcuc6OxKL/M1dwQDRMd9Hhmzf/?=
 =?iso-8859-1?Q?TXwsKLugdu8wYdNct/1SOn/MEyyKq7G1m3dgdP7TI7fIHouksqWW8whM3P?=
 =?iso-8859-1?Q?p6VzD3WIBD3OGlYziTwDsoudPJn+t37/cMhiXWGBnW6JQqxGyGdUPaSuxO?=
 =?iso-8859-1?Q?UdspfzjEc5Z1QlvOa5QZQpsO9J8sZ6FhMm8RFwY/3FTIeYliPXSRzWrbKL?=
 =?iso-8859-1?Q?lVBh0cQP2nHn8BvNQeE7olNYogfCliWmUAweo74Fz/3KHKVgO09vfdX3yi?=
 =?iso-8859-1?Q?sGpD65GCny9n6TneTp/zN4XRAqU2mNnHrBBltyMbOOxSjK61IOXH2A43NF?=
 =?iso-8859-1?Q?k6dZM5fIlgktMBhawK5panqaxq1nXhxRlTsFCct9bKR4EyI6mhmIrUjPpt?=
 =?iso-8859-1?Q?hHiFndXYeosD7N2usDtMbnhHVG8tsJSCnlK8/+0JiAw6U+25+fro83LrIb?=
 =?iso-8859-1?Q?CSVQhYiZR+Bzkq7eDsw3FgCKboKKwmnQM/bnhzyyUIZpd5FZEmarjmeLTi?=
 =?iso-8859-1?Q?IHL5deVRxf+KBgLIyEgi9s8wyCHKOdz9V9oL/wD7kRgfqH5lSehQJW6Ws8?=
 =?iso-8859-1?Q?5HZbvPi2g5hCT4gjo+yhw+CXbM/mTTpzqng4hVkCBRmv8+gg/shslLBiSL?=
 =?iso-8859-1?Q?tHbUxhbe7sZOg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1a2c11-e039-41b5-dc85-08de3a037b54
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2025 04:52:56.1471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KWfrWX6wrFZ91GsIkGM/BajdhEzSUuJFOxWH0Mmr9xi7t+n16XPoovYjv7hN0N7/Xeu6egnMJW2ALtfcZpdQ8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066
X-Stat-Signature: jfe4gfyi8pnt5j1kwfwz6hyi3fnpz8rw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E44F20012
X-HE-Tag: 1765601581-258615
X-HE-Meta: U2FsdGVkX1+QSINWeQiGXiLCv8x63FcF+1+f6cwjtNGjyuPqO+MG0xvWprMlLemncRGAiCoIlYgaAFYox37QufSoIE+1lMhl3LtHqQSYEF060IrVRd2xeRXnh4GWhK46grC6byq2lrP8IcpKJ20428OwaT4Y6ukbOVMWx9BVtdbhzBsS3wJQhx6k4OOMcagut/JfL4nffutRAnS6/+OeG61i1p3G6f1mTFzEIRkDywd1yKMBPrO6OEnXhqY2aofsylSNl6G516r339pk41s2tN0lea6/1eLr96irF+K2h/4WjXx6NEWqxD720G/AZiCKo0IWcP0kAr8g5yFMY2TMWLsGv6WUzSIY963zBWBQg9w5HW/B6z9ah371nr5LQ5OkXZRUG9kpsmDDFLrLRJTaQYLpD/EyO7Q1sTY5btL9yCT75oOoKFZJJCNBaY5dPl8vXrbIx3ACDSxZsDZzcRQmuQI5FUUMO5syRteS/6pnC/m8JNj9VAiC/fv5hX98QqezTbnHyfCEpXXlbyCJjW1ux0oC30dOiElsISNhJ0+nEWpqy2yGhXTvDXkbHbowearAQVvbqP64fz9aqvbChtSrAoEGoHZe1EOEieZgJTBJnbqW9TTXtVGVGubNZ46os2dLfKyYHNR0IiVh5E0LoHyPFf4Rs3NfahKwDaYbq762x9iPZYdPHm6YjdXGXr8D6UWDEyZ04q8vLXaajSHiWX2v6zYL0Vp5PWdSOMvPP3zrANh8f+lLXGJejwg+5Yu460qsMm4hIf2COBqL+gk3z9dsd7tReu4BCgMG1k6lJRKiTdad19qGvuBN2KMzG76nRaTY91FM+mzTOoOUgn9pR655EYt1Vrjpv0RRP7I46+jKoelgd4IxmGhmE83JzRz7dH2D4y3F9StYgifVXzlQ+Z3I/iiSlZDHdAOKMDOpNBs1bIoZLPqqc9EuuIRsUxWcpU2oYEJybsOjKkKIpASdAcW
 I/uvQ2Km
 ak+Fap0E6bWo1mjTwRspBdIpTPwxXcQPyxpbI4ecuhG6PCEmUss+MS+3oQ/YAUzwEAN0+QVeit3M6BpWwZRriTu8mC2w+k4wri8offGk5huKqnlrgFNOItsGMx215CeD06nBOkRbtXpACL7HziCknyyMxCD6WfulVMUsVKwjiiYtGbUiH8oTwGUnfeef1eUYNPwhvzzaDwoS68v+Ads3/q7Cw8JrEMa8df3zaOtSuGaAZzjfja7CfYkLUj2HcR4iTFuN33B+KQzl09NsLPUbOPNXR6ISlANy2VMETSA2kcqOU03SqFg3PcjS7KM0WX+jwSotAQZSLDAdUinQNkQdEU9QFiv33HFImhTnARbyTtqUYEf8HX7IO+//gluvQgqxebe9FjMyBtJaGbo79cONq2wDZSQnqpoEPMVCCH8pe1nBXMZx3jniqpR8PjshHMCGBkf1efRMg8Iy2YhyQFtevEoOFiQBN7iQT+zHjPb5zn86MFiLHxhG8VD52epzCprPbYj58svzxZUd5Ooy3ABKlujBEs9bf7Du1mHG6WFKUFjug+W+0vAXhX7ZAujzPmP9E41eBq05e2TE5Pm4yzTz/o5aMew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review, Alex!=0A=
=0A=
Comments addressed in v2.=0A=
https://lore.kernel.org/all/20251213044708.3610-1-ankita@nvidia.com/=0A=

