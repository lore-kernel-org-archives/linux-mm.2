Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 340B2D58CBE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 04:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D9D6B0005; Mon, 23 Mar 2026 00:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE596B0088; Mon, 23 Mar 2026 00:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F906B0089; Mon, 23 Mar 2026 00:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 314036B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 00:16:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A04B113BEE6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:16:27 +0000 (UTC)
X-FDA: 84576016014.26.5AF6FA3
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazolkn19011036.outbound.protection.outlook.com [52.103.13.36])
	by imf22.hostedemail.com (Postfix) with ESMTP id C9B6DC0003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:16:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=hkdGdBl4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of mhklinux@outlook.com designates 52.103.13.36 as permitted sender) smtp.mailfrom=mhklinux@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774239384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCvlBXZ99NDG5pUFS9gt2G6Z2/x0v6v15bYfZuhB25U=;
	b=uydNgVlxQl5jhYRhRj2rI/LFOI2uisqsioSF2EE4cVHbORkS760XqfBAixMGVnu+YVHYnD
	FeiYwAkIIgQ7pDy+6ZFRZt6RGi5VWp8UPucNeR/z6dDfaktrs92jagcSySflKxD63riYH8
	Dr/yEAcUVY0Ew7bf0z1A4XS2xprmP9w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774239384; a=rsa-sha256;
	cv=pass;
	b=xvUgAvXCzLoxtDS1ZyIfy5hj0ZZC+/U1xA197qhCdekdMAW1WBy70ypFEVLglqpykQE7+b
	LzShP5p6BKLqsQzsjP7vaXsGFOIm3jb0I0Cxc95dcgblC5COE46Lk3LnA94tnGaNegIlpl
	yhADhqHPj2XpTjS0Q1TUMqBIgnpiiRE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=hkdGdBl4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of mhklinux@outlook.com designates 52.103.13.36 as permitted sender) smtp.mailfrom=mhklinux@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dCfOTcVkN+MJK3Jh06UvxjDCUc5A+5aFISjcZJogegWIqsoBoAxYW7++ud2uy0UlKhplHciU6TdfVSuDs2FdQkwQlEL3zYsqQw10VJMAtZH78t3ANVViCgkdasQQirKUuIIU0wi8KyeGq20fP9JLbdpkTSNNgDaBLJmlN3La9MaRjjerdBJnxk/ZpHTCCpThQrpb1Jp+Pwr5UtaMw/ePvbzzLkLpHXNdO3PXke6shBQBsjOmM8e3+W3zVcVL/F+j1lSXMCP87rDr3+Ja6vLcLMqoHpyfvWpuJS8uuGamU4E6A3ccx8wzgQHqfwUrAbPUCXmbG6y0FoAlXHcgq8O23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCvlBXZ99NDG5pUFS9gt2G6Z2/x0v6v15bYfZuhB25U=;
 b=d9YM24qG78WxbUeoehMX2UN9+YpL7gRbqhFyN9lVphDvbyL+Q9QmLLysGN2xxlGVqfTjAUbU4L+talLB0ww12wh46CJtENV+B8wY51IOAhO247MoW8UW2mo/rs40Rt7tU45VYTez1zAvTSEMfxh7Cxerq+ZKR6mCr3CoYMXD34IVk6fRUCCrWjbWyiwPpkXcxY2hhu/X1JdpbEAdcqa+IssjvxMab/uFJb1DuT4C1NLsirEqNd2/13HYh8QDVE0fr3DXxSHwwQtFHKsLOU7GAp1snrdXN2tv40c0nXZh64kPhHxw7kuUAjDQv4CWVEvjw2Bf5tbLQbpTpHOfAze66g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCvlBXZ99NDG5pUFS9gt2G6Z2/x0v6v15bYfZuhB25U=;
 b=hkdGdBl4GhpKB4eBfHmXOjRFGtlCoLErRHJ3nFK7ly5al1EUpRTQUQ4xXVjZH5Q3Khffc1y8yhyWNYBs+jzN/4aJQsaDLdKKAu6NMgBMT6xJHD0tFplc7xCQS0VKnXkzoU8pMRHxFYAEfGwDg/UJHCb7Qe7Vyoickj7I/o80/WPAMAqXcGcU+xQRM3wOsrXhYupAzfWeyVwF6LYyIP3hJBts9aSr+qB48wCwWAna6oXFI1qGMeG8YkYA9UOSwSULSVHUjKeI/ZUIoZV5kKTLMZXQekpInERU9SbCK2SIIFG2y753n6U9s5bc6EkbWSSYfK+ygfqmqLFPLkJ6cRTcgQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by IA0PR02MB9193.namprd02.prod.outlook.com (2603:10b6:208:43a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Mon, 23 Mar
 2026 04:16:20 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%6]) with mapi id 15.20.9723.018; Mon, 23 Mar 2026
 04:16:20 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Long Li <longli@microsoft.com>, "Lorenzo Stoakes (Oracle)"
	<ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan
 Cui <decui@microsoft.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Maxime Coquelin
	<mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger
	<richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser
	<bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
	<david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mtd@lists.infradead.org"
	<linux-mtd@lists.infradead.org>, "linux-staging@lists.linux.dev"
	<linux-staging@lists.linux.dev>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org"
	<linux-afs@lists.infradead.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: RE: [PATCH v4 18/21] drivers: hv: vmbus: replace deprecated mmap hook
 with mmap_prepare
Thread-Topic: [PATCH v4 18/21] drivers: hv: vmbus: replace deprecated mmap
 hook with mmap_prepare
Thread-Index: AQJN0rqm5S7tosaoM3nkaYB8eJypuAGlwE9MtMwd4aA=
Date: Mon, 23 Mar 2026 04:16:20 +0000
Message-ID:
 <SN6PR02MB41573DF211DA2469D7FFE892D44BA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <05467cb62267d750e5c770147517d4df0246cda6.1774045440.git.ljs@kernel.org>
In-Reply-To:
 <05467cb62267d750e5c770147517d4df0246cda6.1774045440.git.ljs@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|IA0PR02MB9193:EE_
x-ms-office365-filtering-correlation-id: 39a7b7e5-fd47-45ff-0fe0-08de8892f01f
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|31061999003|13091999003|19110799012|8060799015|8062599012|37011999003|15080799012|12121999013|3412199025|440099028|102099032|40105399003|41105399003|53005399003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?/N3H04TX5bQahuSHyUaieq8RAF4eEp0DeU+m1gxuxPYqKo05Rg5bEthYXy0N?=
 =?us-ascii?Q?7SH4HlohLeS6InvGttrjB4SxysDESZLPBoQWfq1pWOWy8V0RwCCEjYRyroMM?=
 =?us-ascii?Q?PiWCMUEwQdoQ2TLCfacF5D5JPl5FfMWhTCjfOmnuJ/XJqM2HhZfJJTCCdP/s?=
 =?us-ascii?Q?mtCJwE/7NlQ1YQBHAsToPL3VKQ//bY73JrFHJAg04TFtTxnVsuYkwaMkaWQ5?=
 =?us-ascii?Q?CjUUcz8WwXXvJ2OrkvZDAxrcu/CsAS+QypPLO+l2y6tER5FdizzmttuZ+RhD?=
 =?us-ascii?Q?vGzzgKeyNib5W5I1Jvqo2LSp9K7+EVQlnLuVvlE+q8Vwi5KiM0cP/1WL4vcl?=
 =?us-ascii?Q?1iFsRh3nMwOMWFNhMVAw4mfIpB/P7NpVPHcaTb18aL01uAuik7JWV1cw0Hk6?=
 =?us-ascii?Q?jHImw/whHJn4lEh8QQZl/kJHUZWrxNIGMXH8e3pLjMsF4yZJJHfbnwO6ti0G?=
 =?us-ascii?Q?fZ2LNG8NCyjQpvHfdOENae8alVB4aqAsrX18h2QLJVjGrCQSvprRgUVMZKGG?=
 =?us-ascii?Q?Oz5G5hw4YCBiRWG0E8UXiKVOnGvk/Tgk2P6wBEEdZ71L1sTSu3cAWHcrmHE/?=
 =?us-ascii?Q?0XGrG/GnnnTmgOM1g1WYEQ68kJBpKBn1vyxZkF63sWG+b1l5ysyjUwbFzLOv?=
 =?us-ascii?Q?ypEv74WbTjJ2SPsrZAZxD2N4IqYbvIq0ZNbroUGEKJNd8LGY6YwHjkHRwxwv?=
 =?us-ascii?Q?NiKKDVYdcKXUf61EB0AKbHXPBq0Eg+b76UpRtHbmbjdIBWfrTUVoo47QXzJU?=
 =?us-ascii?Q?CPMgw3HHhTFXHztdrE1aWtJeiMRbyC/PRiIGxf2atZatkjfe5A+pArLRqnb2?=
 =?us-ascii?Q?fnK7OkffAlcRzD+lkYY14VQG7uew80QoDEVx5mXYq1qBYX+3v8q5qanYVj0C?=
 =?us-ascii?Q?Vpb1FgEwlpgCV13XnGRc6lqclLC5MtsW8kzGgbxMcWyT4LYpKq6WpJtvnpaz?=
 =?us-ascii?Q?HgfFhxUq62jDj6JgzEMEhx7fUrD3V0J6fCfVchBE26lg3WgveIQBCYcK1qEz?=
 =?us-ascii?Q?7bA8gm2IeSLoxeicTkzr1/AzKieOvz+rWKmNOyDMaJ7wmGc=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?pAMnP1LvvhF6KDwQuSIFbjHW8GgI+vXR6DbPhPgwY7SHNdHVXCQ9HaN3O2lo?=
 =?us-ascii?Q?HCs2smjpU0aA6wKe89W5KOYn7KnlqqvDpej/UGUbpFK6dToRKGXKbWQWmvZ6?=
 =?us-ascii?Q?NlQfqGQbgtrVCNczIH2pMIFB7AYgVIGAttry3EdFXRS8nuozl/sWJdCJOzZn?=
 =?us-ascii?Q?TkyDp6mpsaLiXS3/1nJLjfZw94prMwcak27DqlV0HDRYBu9aDnTG3hzT41r/?=
 =?us-ascii?Q?P5mjl4A+bGyp5SSG/h4g6+5VRc9QADCNkq4mSuw0rmINiM5BIiPhqtAv9FG4?=
 =?us-ascii?Q?R/yoiwHjTwrjNf12DhFLgq4pedb/rrhvQTd8ggKIAUdpg7PaAfBooBPoh9YL?=
 =?us-ascii?Q?7OmoCBbOGozkr0ysbUr1C1b+zmCB/2Es32Iq2m5lk8LVZB9Gm6ag0DlYxufH?=
 =?us-ascii?Q?U9dPHDHSFSVFT8PWzB4aB5rIVseQKu0ki7jlUvkPovmqJcZU/D8tQhmIvbw7?=
 =?us-ascii?Q?VBpfOln/+y9OU+idyZmvLe4CZ0hUq81M525qlghOvgy+VlQVBmWfxBJqHjCC?=
 =?us-ascii?Q?zLQC1BW0oSL06F3LsHA2843eMJlIJXFuustI7ZoAAlZicR/qgM0d12P7lSmE?=
 =?us-ascii?Q?zlIJHXS3TFjHV4S+dc/eyEiYVo59KSeiC01WcJMD/8iKrjs3iNmEBMU8yGwk?=
 =?us-ascii?Q?dPqfwplnl4VashuIWIlUh6RDbomjJsbDV7DdWVODh07HelgIsQaNIaCv+2Cn?=
 =?us-ascii?Q?MgCGrxrnbOAOpbMv+0njzuL1fjySU8OC8PsdeNzLJWaacuQrk55yFar9WSUP?=
 =?us-ascii?Q?V9f5oMNkQQr5IwEhiHNg6mGSmnVgWvof/vALd5y/VzeO8nPtoRXfw6uXxBDf?=
 =?us-ascii?Q?usv5O748XBNIuvGWHd54GcnwUC2qnRlemQBMN/cL9LIvL9tbnh5PBKJKJ6P1?=
 =?us-ascii?Q?JDcGYxLcW8fxNyXXyS+FDHrGYW8bz+Q4BlkHrIvxm3qgeoHeSOebN6aA9qTB?=
 =?us-ascii?Q?0pjNBiXu/OJSrn7w9sJHWG1uys2agIEeHFVTSU1jXb0INe2GkG/MbX6dvC7f?=
 =?us-ascii?Q?T+nqZ3S7mwWAQzv/pK/aiNwEPVXWC/0bMgSfXTGSFE2Kq3hRu7pL9R5B4I89?=
 =?us-ascii?Q?rPGPtLKHpG6YW+fSuVD6zzvp7anVQAmcRKM3zfEsI2XBr03XegxQdtxuximM?=
 =?us-ascii?Q?PUXExKxk8G+thuLDCWkertAMsb8HJNm4yv+2cF9tb1b8a124oLTvj2S6hpsh?=
 =?us-ascii?Q?Bf3EFX2CrQUjHdRfZKlKSSAxkujLMJK3AtLx3Q17IPA40QdOFXwQLutI7yxA?=
 =?us-ascii?Q?tFnogOlM9DijqvgOCL8YqXBy9Qr1uY2SFQLb0iaixSXbWow7+fu6Lwl1C4dD?=
 =?us-ascii?Q?HneraP9k0fQ3+IOA4qLCFgZgNR34FAktHImiSbpDkodftG+5+JAh9ZEFtX+n?=
 =?us-ascii?Q?4qbj2yA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a7b7e5-fd47-45ff-0fe0-08de8892f01f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2026 04:16:20.7940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9193
X-Rspam-User: 
X-Stat-Signature: p7qieoauj1x5cehjatj19niccm5mbwbq
X-Rspamd-Queue-Id: C9B6DC0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1774239384-253069
X-HE-Meta: U2FsdGVkX18B0oOPQnsqt4Hiz2gLBDxkwZoNt8N+A9BUzRNmsYaEuF7Ohg383NsFhyAJWsaG9LeWR80ZBkJbdS4aLzbkMNGQmK6ys7Z4GsCq+aGkSDH5LU3MgKlFz/noNBo8SBKYlX0m1n0i3rAZTvvcXVnaUw6x+FbZKZTagYfq5ez3Dp5LivK6aYMzAuelq9Iwjcsf+0Cu+yHNBOMe+jiQRyI3+G9iA5zw5ZVOTDBVDnuzREZJs3h7Kg7z+2jIJgifhpxPJt6LyzuIhGiY9k3+vekTo+PMDU8IoyoX2TPShpTOpMlBuiBT7gER8MxX/ASaCpl+2VK4V52FrfivnqlESYK8B7nPALOcwzoNgNGJZ4UA7hFWdhjXtryCd5EGFHyzlHhpwM2MeIIWZwLW+ZndOQCbaGqU7005+eCwXVSwnMWjGhZ/UFk1OierlwsyLcFfY6lv/0Iy6yWAPGY/N6MdSbPKMCel4iK6tQTpGvw/ogH97PhHUlpcKrPi+sPefGQUnrag3kO1j71W1hoARHaaZ5UGabA7PXFai4k11W1DHv0VUfv+8To2A7Zw6LdcmQBuISE7LFqq/+yP8yPWMXz6hQ3eB76ahDywltUwqBsd+9GQ5gCXD4jgAPju95gNJlX4NGVvvVYTrgCT8/3AE954e4lluNbFOKc76cB0Yv2QyJlc0tf8aSHHfgK2gL0dXkXOSQPwXwD9D0MNj6V7FhzM8ce/mqHiHpJ6L1sneE1sIpnkKBMsH6hP2d/G85+S8XwFEofKSzvPSjlp5kYAVpQhz+GH7azNl+XEy3DPeD2FT/g8kV5XoC7Deq1CHSnTz4H60IcqfdPMlFFEFhkFgfhpwKRoaqxRiusdY6HZxqgBE0EJTqKweXe0EZMwJDt2LbqXg151WI1Y5sg47aZDA0mkLOgQzVJzaVO0OHgtv7Gcw17bYvXx1jbn7YCmXaHYsqKz+0UfE2la6p9f5H7
 n5JpWMNn
 HhllpVrKW0Qz0NU2Ghyibr7y2WR8W9achZTxHvausF0LlR45THO3G9GG0Uj/GXmvTwQ8u03ai11wYHk7l/Q6oF7etaOVozoRqXSQBFYxCkT8AiTPaiDr9SfaVgxINa7Ek/bU9s9sBNtzvgpz5MZIj4zgzSULpKmy8TJ/B/YPMDQYRtXHpdLpj5fsxbdlI+xaMRLGpvzjL72rmo+3CFry9SVs5fShyjWwfOwjXxL9+2x+bEiyaGGr9YYIFmGQqv2vAiVbWYXeHA2KhDxqeA+FWeBObNnhFBwmu0X+c+Yoxt4tp/7SBHVkTq/al5knP0MnT+kHdFyDVxN8KaZMCssuZV4cknctdjE6ieAIvbWDqIoAFic4BNPIxX7IJrC2J+kawI5TW8YEyjVQXphs+elFPrGxM5p+UEbfmLaMu9bGN5YO++H15qnYu3JJPcLNW0q5om3i5dvEvBuiOUVLmwliwVW1imjSP1IBpFN9Xn3uh8xcEOgZZAWTNPY+EgIFkb8tqxIwdWubvHwS3sPyMl14BW2QtALmekdTfxHLnOdw9KezN2hNq0efxIAxk+Ldl5zm0qZu+IyZer1AzWKSAQGIZtATHyF3vY9QQWgxVMUIymJEtYF5ZNWeFSrNkrCBfDaobpwR2DbrT6iEIxf8hSjFM+5BnQ5HDiKiAEpGao2p5WT4x0OdU76ph/+6w9+ZPT0hCi/kbODgV0iWJE3iBSRUpLZc8C7ucx8savE9d4PuBeR75zYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes (Oracle) <ljs@kernel.org> Sent: Friday, March 20, 202=
6 3:40 PM
>=20
> The f_op->mmap interface is deprecated, so update the vmbus driver to use
> its successor, mmap_prepare.
>=20
> This updates all callbacks which referenced the function pointer
> hv_mmap_ring_buffer to instead reference hv_mmap_prepare_ring_buffer,
> utilising the newly introduced compat_set_desc_from_vma() and
> __compat_vma_mmap() to be able to implement this change.
>=20
> The UIO HV generic driver is the only user of hv_create_ring_sysfs(),
> which is the only function which references
> vmbus_channel->mmap_prepare_ring_buffer which, in turn, is the only
> external interface to hv_mmap_prepare_ring_buffer.
>=20
> This patch therefore updates this caller to use mmap_prepare instead,
> which also previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
>=20
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  drivers/hv/hyperv_vmbus.h    |  4 ++--
>  drivers/hv/vmbus_drv.c       | 31 +++++++++++++++++++------------
>  drivers/uio/uio_hv_generic.c | 11 ++++++-----
>  include/linux/hyperv.h       |  4 ++--
>  4 files changed, 29 insertions(+), 21 deletions(-)
>=20

There are two mmap() code paths in the Hyper-V UIO code. One path is
to mmap() the file descriptor for /dev/uio<n>, and the other is to mmap()
the "ring" entry under /sys/devices/vmbus/devices/<uuid>. The former is
done by uio_mmap(), and the latter by hv_uio_ring_mmap_prepare().

I tested both these paths using a combination of two methods in a
x86/x64 VM on Hyper-V:

1) Using the fcopy daemon, which maps the ring buffer for the primary
channel and sends/receives messages with the Hyper-V host. This
method tests only the 1st path because the fcopy daemon doesn't create
any subchannels that would use the "ring" entry.

2) Using a custom-built test program. This program doesn't communicate
with the Hyper-V host, but allows mostly verifying both code paths for the
primary channel. As a sanity check, it verifies that the two mmaps are
mapping the same memory, as expected.

As such,

Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>

The most robust test would be to run DPDK networking against
UIO, as it would communicate with the Hyper-V host and use
multiple subchannels that resulting in mmap'ing the "ring"
entry under /sys.

@Long Li -- I'll leave it to your discretion as to whether you want
to test DPDK against these mmap() changes.

I've noted one minor issue below.

[snip]

--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1015,8 +1015,8 @@ struct vmbus_channel {
 	/* The max size of a packet on this channel */
 	u32 max_pkt_size;
=20
-	/* function to mmap ring buffer memory to the channel's sysfs ring attrib=
ute */
-	int (*mmap_ring_buffer)(struct vmbus_channel *channel, struct vm_area_str=
uct *vma);
+	/* function to mmap_prepare ring buffer memory to the channel's sysfs rin=
g attribute */

Changing the comment from "mmap ring buffer" to "mmap_prepare ring buffer"
produces awkward wording since "mmap" is used here as a verb.  It might be =
better
to just leave the comment unchanged.

Michael


+	int (*mmap_prepare_ring_buffer)(struct vmbus_channel *channel, struct vm_=
area_desc *desc);
=20
 	/* boolean to control visibility of sysfs for ring buffer */
 	bool ring_sysfs_visible;

