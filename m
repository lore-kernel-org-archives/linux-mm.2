Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59306CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC288E0006; Fri, 29 Aug 2025 12:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C828E0001; Fri, 29 Aug 2025 12:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515D58E0006; Fri, 29 Aug 2025 12:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 387A08E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:30:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2DD314063F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:30:07 +0000 (UTC)
X-FDA: 83830332054.02.744B0FF
Received: from iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.221.209.22])
	by imf15.hostedemail.com (Postfix) with ESMTP id DB7ABA0004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:30:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YGFeCoXh;
	spf=pass (imf15.hostedemail.com: domain of "prvs=32944d1dd=akiyano@amazon.com" designates 3.221.209.22 as permitted sender) smtp.mailfrom="prvs=32944d1dd=akiyano@amazon.com";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756485004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUKH7q64B4AZKyl6BHgnsCPbmL/bBGjfZAM2AuF142M=;
	b=wjqpU5Ju+DYUKs8joMPXEA31ECYVzTBMGYiofejMhy2zKpISvKxdEhnYa0PDAR1HLjVNz7
	VyHhrRuBa0gZ7PxPh1oQUjhH5VGqvYuMq0kmn1+1GDLkovUU+Vg/40mAQWdh3IXTfQYtcp
	/PS9jewr1nJJ80b4pgqGJdrhKn7gYic=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YGFeCoXh;
	spf=pass (imf15.hostedemail.com: domain of "prvs=32944d1dd=akiyano@amazon.com" designates 3.221.209.22 as permitted sender) smtp.mailfrom="prvs=32944d1dd=akiyano@amazon.com";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756485004; a=rsa-sha256;
	cv=fail;
	b=jSDOLHDz00f/ncUbJG3x5oBSdU63QOTNVUiXBBTPvNm5dThmTNe8gtjPaN404AXe7dqH2v
	GXuwln7JcwejLHaZEjp+GD99l5MuvC/MlAvbJCUryio0L2PqXBRwUbmgrXUQIcSQhe82OM
	CJyeWgQIEbzmQNNHVo53/ebkIlYuPvA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1756485004; x=1788021004;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=IUKH7q64B4AZKyl6BHgnsCPbmL/bBGjfZAM2AuF142M=;
  b=YGFeCoXh65xByF0w6D2DD7yXAxex80LyX5TG8jq5sHR2b6XACsKA+0oA
   lqBC2hMY3CQxGXH0gr4tHetL34yKCZKYj3wxhU18TtuCzavVVX/OA9175
   xDgA5CCQ7V203hRbvx+6TUMJDgMTsRnryQFd9iL7P8r2g66kiqyHJIqEf
   eaf2EdK32xXeSlIxr4bdIr77+a6V8otXfxLOKxJGkO8EFpO2Cz+4eKT4H
   J12ArGie2qet1kDfojlyftlpHqkOBVS6gHsFjlFHvt2GU1S1nMWNjZcXF
   fy6djeAP+k71rqMjYpiPrWyYsaD2xC6ZiqkVaOe3l3QDZTh4TjeMx8acr
   Q==;
X-CSE-ConnectionGUID: OvK25TeeSeK03kBznH2NIw==
X-CSE-MsgGUID: 1jG78zBmSY+y1d4F/Fqq7g==
X-IronPort-AV: E=Sophos;i="6.14,267,1736812800"; 
   d="scan'208";a="1617061"
Subject: RE: [PATCH 11/14] Documentation: net: Convert external kernel networking docs
Thread-Topic: [PATCH 11/14] Documentation: net: Convert external kernel networking docs
Received: from ip-10-4-10-75.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.10.75])
  by internal-iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 16:30:00 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.29.78:6180]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.50.39:2525] with esmtp (Farcaster)
 id 59b93efc-7ead-4e12-a773-4e7cd5d1b3cd; Fri, 29 Aug 2025 16:29:59 +0000 (UTC)
X-Farcaster-Flow-ID: 59b93efc-7ead-4e12-a773-4e7cd5d1b3cd
Received: from EX19EXOUEB002.ant.amazon.com (10.252.135.74) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Fri, 29 Aug 2025 16:29:56 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.252.135.199)
 by EX19EXOUEB002.ant.amazon.com (10.252.135.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17
 via Frontend Transport; Fri, 29 Aug 2025 16:29:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xtENIYqvRtgX8aDglaxuSt+48zVaccnoEXpnVDszWlXifGkf0SwNKXmgc1yy5/PDep8yBC0SyGMMALlOsRKtmoWNxGtRbGNxCYFUXuHlCDrC4BEl07iMnuNPqM1VjGVoAQoeCn9DnJyyPfGcIUJlDo5KeMPVTQuXoNcXpa3lkr0EEUp0DdwMmsVGIFNtnWDkLs5ktjv5pk6U6YATlNECApWH/N/vJUg9yV3914ukC4nTYXRJ0O+4dsPkiqaV7VaFB//bqNSVVg3Hp3HsSdLo0AkXQYhzvTQeES6VmogVwFJZF1eUFJTA+7dTtqz9pmaLq9nPdVHrMQLzOqM0kJvsNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUKH7q64B4AZKyl6BHgnsCPbmL/bBGjfZAM2AuF142M=;
 b=wq6IsXOecUvJu1WfbChOLnHQv98h+xssqAVbZOEJcjBa20XhC2GM4tQOcAq5ciF/d/qZTaKYAdgBFch9XXFVPnEdGYue7ANs96dbmV3V7vs1LfeCGkPtKPAHNv5wn6pPzT2cuwgEOev53shUmUiGH+jmIIqkTOx+30xonWlmzmZOVz6+ZzBiCjnWl71nZ1ZcFa6ysWA/FgxDVipZm0CPd5ZpmRC39ondeoU6qcSDVbz8tCIxo63nv8wFEuMUmWseQSrEH0kqUa+TafLCLZJEq1RlWkWgT2kZCtFngTjEkEdin9CGIu5Vr/tvFhMNEHV5KzdijkRH/qI7yKN4SUGCPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.com; dmarc=pass action=none header.from=amazon.com;
 dkim=pass header.d=amazon.com; arc=none
Received: from SA1PR18MB4664.namprd18.prod.outlook.com (2603:10b6:806:1d7::5)
 by CH0PR18MB4145.namprd18.prod.outlook.com (2603:10b6:610:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Fri, 29 Aug
 2025 16:29:46 +0000
Received: from SA1PR18MB4664.namprd18.prod.outlook.com
 ([fe80::55d3:142d:553d:9b9]) by SA1PR18MB4664.namprd18.prod.outlook.com
 ([fe80::55d3:142d:553d:9b9%4]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 16:29:46 +0000
From: "Kiyanovski, Arthur" <akiyano@amazon.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux Documentation
	<linux-doc@vger.kernel.org>, Linux DAMON <damon@lists.linux.dev>, "Linux
 Memory Management List" <linux-mm@kvack.org>, Linux Power Management
	<linux-pm@vger.kernel.org>, Linux Block Devices
	<linux-block@vger.kernel.org>, Linux BPF <bpf@vger.kernel.org>, "Linux Kernel
 Workflows" <workflows@vger.kernel.org>, Linux KASAN
	<kasan-dev@googlegroups.com>, Linux Devicetree <devicetree@vger.kernel.org>,
	Linux fsverity <fsverity@lists.linux.dev>, Linux MTD
	<linux-mtd@lists.infradead.org>, Linux DRI Development
	<dri-devel@lists.freedesktop.org>, Linux Kernel Build System
	<linux-lbuild@vger.kernel.org>, Linux Networking <netdev@vger.kernel.org>,
	Linux Sound <linux-sound@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Jonathan Corbet
	<corbet@lwn.net>, SeongJae Park <sj@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy"
	<gautham.shenoy@amd.com>, Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>, Jens Axboe <axboe@kernel.dk>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	"Andrii Nakryiko" <andrii@kernel.org>, Martin KaFai Lau
	<martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>, Song Liu
	<song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, John Fastabend
	<john.fastabend@gmail.com>, "KP Singh" <kpsingh@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, Jiri Olsa
	<jolsa@kernel.org>, Dwaipayan Ray <dwaipayanray1@gmail.com>, Lukas Bulwahn
	<lukas.bulwahn@gmail.com>, "Joe Perches" <joe@perches.com>, Andrey Ryabinin
	<ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey
 Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Rob Herring <robh@kernel.org>,
	"Krzysztof Kozlowski" <krzk+dt@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, "Eric Biggers" <ebiggers@kernel.org>, "tytso@mit.edu"
	<tytso@mit.edu>, "Richard Weinberger" <richard@nod.at>, Zhihao Cheng
	<chengzhihao1@huawei.com>, "David Airlie" <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
	"Nathan Chancellor" <nathan@kernel.org>, Nicolas Schier
	<nicolas.schier@linux.dev>, Ingo Molnar <mingo@redhat.com>, Will Deacon
	<will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Waiman Long
	<longman@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, "Allen, Neil"
	<shayagr@amazon.com>, "Arinzon, David" <darinzon@amazon.com>, "Bshara, Saeed"
	<saeedb@amazon.com>, Andrew Lunn <andrew@lunn.ch>, Liam Girdwood
	<lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Jaroslav Kysela
	<perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Alexandru Ciobotaru
	<alcioa@amazon.com>, "The AWS Nitro Enclaves Team"
	<aws-nitro-enclaves-devel@amazon.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve French <stfrench@microsoft.com>, Meetakshi Setiya
	<msetiya@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche
	<bvanassche@acm.org>, =?iso-8859-1?Q?Thomas_Wei=DFschuh?=
	<linux@weissschuh.net>, Masahiro Yamada <masahiroy@kernel.org>
Thread-Index: AQHcGLuTBzGQJ2HjQUKWAGuAiYwph7R5z5Qw
Date: Fri, 29 Aug 2025 16:29:45 +0000
Deferred-Delivery: Fri, 29 Aug 2025 16:29:36 +0000
Message-ID: <SA1PR18MB46647E011B94C5CC701F7104D93AA@SA1PR18MB4664.namprd18.prod.outlook.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
 <20250829075524.45635-12-bagasdotme@gmail.com>
In-Reply-To: <20250829075524.45635-12-bagasdotme@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR18MB4664:EE_|CH0PR18MB4145:EE_
x-ms-office365-filtering-correlation-id: 2351047a-1357-4c69-30c7-08dde719445b
x-ld-processed: 5280104a-472d-4538-9ccf-1e1d0efe8b1b,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?Y9Ys02gnEJbWPt+eT+U/MY71EKPRYTyZT2JzkuTz1xe2f2N8P8bGN4znEb?=
 =?iso-8859-1?Q?CYv36gAwTgpCldhxYlTRS77nGlIMePC8jpWdyaKHKs4/QaWxAnFknquQgv?=
 =?iso-8859-1?Q?6QhkT+DWIl7xt0KUeC4z1rV6EmvjAoVborymKzgstHU112TqUthTP3sR9z?=
 =?iso-8859-1?Q?IOmJS/XTxwSNYRUw38i9wPSDVvDjmOZInb4LHsCSFxH3boRYnjbQ0rYOrH?=
 =?iso-8859-1?Q?8aosECfMdk9EUrl1mP5RNitferT8DRyNsa5qAv1MHqpEvLwiX2/14ep6iB?=
 =?iso-8859-1?Q?obUbfDm62MIyRCI+vIBtoaGzt372h0uknTTcoTcs6peXVRtCmKbDjg6IBr?=
 =?iso-8859-1?Q?02mvhzFARUM2MuttCHUMKqqEyW7MzepFKW2AKYV5jKr4Y7j4kRv7M/87Um?=
 =?iso-8859-1?Q?GWuzGmVLtuvpPOVtqnuEeXa0/4Xod0iXvBMBJvcpyxSSSr106aMFwCNp0Z?=
 =?iso-8859-1?Q?1Y2/08y/u2QuD4oS9Sf7QUS9DC0crB1rATOUFVZ/QpO3Xgyzfm0RyOOSCr?=
 =?iso-8859-1?Q?NVYe4uyrDU3ufVxFduB8LRVwIDxEnfhjKvIqFPtgQ1ny+DffCeLrESQcxE?=
 =?iso-8859-1?Q?4N7UNDYLC8iKUJzfggWCJOtagow0pmbDMjbPlwHl7f0983pZDtxRWmkCiR?=
 =?iso-8859-1?Q?NK0F2JzSK1k5v/dkboceaIktU5T3Iv+G1X6AV1LRVAnvNr6UpU0v2achsU?=
 =?iso-8859-1?Q?MmUH+djEYxb8TwAYI7B7iOfZXO2P8a5cdspxb43dvxJvgLvM37V9tQlbNZ?=
 =?iso-8859-1?Q?lFAJ09LRoEFuEyi0UrrLUIjL6yoJqZRcq0hcmPotF7Hm18i/pHILaxURjo?=
 =?iso-8859-1?Q?kDAutEIq83FsT7yQ0b2vSTLPZwyqQP/nmUBW6FNPi7ENXys22npsyVXh8D?=
 =?iso-8859-1?Q?tGx+/S4/Gi6JPoBEXYTXuRpZvGuDFuHBN8SrUCI+mjUixpEP/q5D3k2IUu?=
 =?iso-8859-1?Q?HtuR+J9wpVsTOTx4JKPZweAZo2rJAu6rEvdrLDoq9n39JTj0fOaB84aM32?=
 =?iso-8859-1?Q?dMTA4qx7/vcvqJijNlw4QdisW8IhQhvxhslHnaGqy4RcfGGATWcKcTbgW8?=
 =?iso-8859-1?Q?56+6PDrKTPE+6n/E7MwyhHBA/28CkFdAKUik4bb9hKLSCuHgNQI43gcVh8?=
 =?iso-8859-1?Q?NhcEJODpE4P9v56aj43xh1hcWZ9NHFNlQWOvzsvJKCyyW1CPsvpi2V6voE?=
 =?iso-8859-1?Q?ksLmhpiyB/wB6YCdhUnFHrmqgVvGg9jcDzaVPYDrcYyLvQL8iuz3PSBQVF?=
 =?iso-8859-1?Q?jPPm/zGCWLxEa28wjWrya8OdmTbViOo7eD43nHhdZb59VLm1X5m43BHrkI?=
 =?iso-8859-1?Q?GdPegWDi8jYOgPWQFUrPfn9eBVeKj/Pxc05z357yk9g8hfNtXxHH5MepQt?=
 =?iso-8859-1?Q?dZ6gixYudDjTDpsGmdilN3V5yr5eN2zftqyrSY52CkxapTOk3ChqOk5HR4?=
 =?iso-8859-1?Q?wOLU31QA1eTy0ha5nOeamOxoA5dN9xHQAyT2kFGcVtA3gVV+TZk825/8/i?=
 =?iso-8859-1?Q?QmQmyxmEK6P+GDFJI/At23PG8tGAN407c6QECO9/ce6jh0PLXUJW9rHexm?=
 =?iso-8859-1?Q?CTw6zVeVY4zRfhhVbpLXAOvZ+z/n?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR18MB4664.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FxkdxsX4Ybdn+q9ZpwXflRzDTr62JDlnYm3D42LaQVEm3V+vLWxj3gF3q1?=
 =?iso-8859-1?Q?rOGS4Wu8vkkfrN+RelS9TCYjLq6ZHm7U0TKovMIGd6ovmetjaRGO9EEC8v?=
 =?iso-8859-1?Q?MjVvF/Y30865iWklmOwSLSZ17y/j+W1zVRp6mfCLvdH3xEy+gx6LTwROzZ?=
 =?iso-8859-1?Q?iKhYTy0+ekwMwpkmioArTqE4RUZUTIuMkj8xBs7vdZAB1WwxfQXn4n/Rut?=
 =?iso-8859-1?Q?/lwaLv7+4dkqpF2qZeYNs/5KcloADG7IqRTXGtIUb0C7XjeQ3AKmu10I6k?=
 =?iso-8859-1?Q?zCdMrbzpV+QQysdEM6PMIIM3k9Ky1fNyPKhZYr+uvsD6pcFQ6u1lvSGE2i?=
 =?iso-8859-1?Q?niipjghj05d0+d3cP8pv1FvTNCY0C1pbST1aGR2CdYzwE4Q7PPX+sbto2T?=
 =?iso-8859-1?Q?abH1lci5iYl2udP7bdsrMTA5hJaxGUCAcQk5ko2bTUUIoa6glqRzgODSIC?=
 =?iso-8859-1?Q?GNCo9EjoeMSQsJlK6b1eOlrdIeXPNO1doUaaTssGNZLCCWwTKKOruhav69?=
 =?iso-8859-1?Q?g8d6MRvviA/Q+1SiTcERMfkUnmY+vF+8E9G71vcBg8O4pmZ8LJVL1Xi+N2?=
 =?iso-8859-1?Q?vk2meoPoTPK5CKG4DIo7Cpk8Ld0GkrB3qvLWJETsUwbVL1s6/xkzG9u9Yo?=
 =?iso-8859-1?Q?VlTExGdeYcnwL/BF4vKwB2nIAZIMDm/YJdOWZsx6seL2jlqWqrx1rk1GAh?=
 =?iso-8859-1?Q?fV8O8wNr5ahRxm65cF/l0v+cm7TvZPbd5jbEKlgNPfQd7KS4uV5JjdjF/q?=
 =?iso-8859-1?Q?qcFnR5BYpfNnKU1afhOzlNe/LYGmE43A2gH04+j0FGv+9rKK3PROOof4D2?=
 =?iso-8859-1?Q?qePL0CbYM6PiWFEdTN6zxWx2K+K6x4KC6xu9hOy5lLiIv5wE/ln/J8GKky?=
 =?iso-8859-1?Q?M+XJiDloFrCBR04DPcq6pQvaBP1E8DHn5a+aPDF8Sbi3PeSg22pLIh9Mqy?=
 =?iso-8859-1?Q?xue1RkxaHhWFgZFlSsSV7r42PvNvpGGn6WcsqmJDzrMrHLNArdR9a2Duy6?=
 =?iso-8859-1?Q?vBk0U/2vvkKBDpOFIH90NzO2xBSAsl+uQqGybysJHNs/tnwgGDI2Z0WiUq?=
 =?iso-8859-1?Q?qyzfWTgbVu8W4Xn2q3+D+m8ZpEpCM+euu9rMX/ROxvfi9rw6+tsw4kUz3A?=
 =?iso-8859-1?Q?tKLBHrqqQs3pC5RZbqiGmN6E9n0VsRRrV7BKhOERWjFDx5P29NMdxZ4V4P?=
 =?iso-8859-1?Q?zyzK/9woYmfizLHFCLFYIzS7y8OfhdUL4fhzC/5DihYZ4XU13hnHPGIwAM?=
 =?iso-8859-1?Q?Je+Pwn7rVWtOs73OJQgxUISrD52xDJo3l4nTLpEL2IIt1o5+bTGLhdwpD9?=
 =?iso-8859-1?Q?IG7s7kjSmiEGFsY7lJIO0h0oT2cMA9vxHldypzS8MXLmwDnQUkd/bY//6x?=
 =?iso-8859-1?Q?jcc0aD/4jT1gWr1gUQAG/DPdyrLKsJAbZR/i7khJaq/YAxkfHzRB8Gv6rm?=
 =?iso-8859-1?Q?u1h+G/T3gnu3YARUvpu81+WkM7dzmB+uyxIP+dTi5caF1VdxkkawN2fBuj?=
 =?iso-8859-1?Q?UkQJZHmPcRMmIbdqcUA5w67QLGJv4nNUUsJyD5JSIoKjx3DS22tZ7o3kQ1?=
 =?iso-8859-1?Q?CpBROfMCmldWvuSYTlAZXzHmx4kSy0DHooIk8i9oPbeZFY5vBUVB8mCwrT?=
 =?iso-8859-1?Q?B1xISVEUAeMeJS5BZ08J2DfFYZifnT4ayw?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR18MB4664.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2351047a-1357-4c69-30c7-08dde719445b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 16:29:46.3033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVgFsZAGNaAA9eeS15tivTDWmK1XhrMYR7+sAIZd6T5lrUSIL/Z7akZChYV7Dedcir2CBw/WMllCE4SWQHjGsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR18MB4145
X-OriginatorOrg: amazon.com
X-Stat-Signature: 3m98gchioba8qpmxga7rpwpd3ro84y8c
X-Rspam-User: 
X-Rspamd-Queue-Id: DB7ABA0004
X-Rspamd-Server: rspam05
X-HE-Tag: 1756485003-156307
X-HE-Meta: U2FsdGVkX18p7npjPKUaT1obr0R3juzluqqpHAaOLl0/6yMHByWNeIe/RuMZak/nTi9CUwflteS7zRPDSdOnz2Bcju0m5azj7pJZnctiewfpsrXrLupaD61gBXs6aSFpRvpx4YOy+R45tw7X3yr/sZpF2/glixWjyIRwVDJxRv4bBoD3mwITv6sCstH26PrASLY7r7uRF4s8mIoWI1LaxSc4C8eg0N6oBxss+Epw3un2E49JZw81qDvBwbb+ht5PhsltQBQgS40zRBvKW8jHZH51hIEF4ll9+tamR46PO5FqZIvMPsMrykBo6YeEqX7dzF9xwvnh4hy949lvPEmEiE/fVpGh1Owx0/DYURheapZ/ALgITW45ijK5hb70XGUTV67kO5fd7NpKJ2Cs+ArMe+2NPprl8zexw6ExVrqtKo2NFTK85kHurH1VW/++fizW6j2seZBc1KmQb91ALAVrS+GWAd3JkKu8FcCOATCxVgQw+vSNAWL+kVqLDINEyNa5gHUKa3ggG1Qid9WeIzAfbzQ2oW/d99h0RKFtMT3OO4ePaoT4kSKBxKQzUuzT1JH2SPvLhZ8h4QiMd4gEqLd/f/jMoWGAafMlM4MoGugB8hRY/4XKZ/wmC9a81UFO27P7QoQiXHpWWoiL2SR34iitkJEdKjkcbsE23B2g8cS5yQHQaN1cpX/e4hTA7B/7Thottfzw2CUWyrA+4cXQQiTvUoG3MDZz6jeyAdrOdhj6zQlNqvoK7860MV+XSI8hyXc9gOZpRzG4i79U/H9unrWenHTgZho2amlqSVHtH33pFb6row7PGK9kL1Z09JBVE4J4ipxuujaHxkETDH+Z1euu9ksrN7IC7BSb7YH63wiG8azdAOnPvVeptzmkUaCBhc0Xo7OJA3y3lPKd88zEBTOR9pH66nnR7tzX49z1lobS5CAszVtixzzIwMvANjuCubkxQOspNHj6JIZK/IzaHT0
 dt6TQIAa
 L2Ms//sX3x2+zm9l2XkUqwfNBGA6w4KjBipeApWcDpj1mCux26Z4f3FaDFeZK0zBBv+5bJKam8bhCwjRGVB5A9RscB3qqmaYt32MRsZOBv6TjS8f4uUzLNcTpt6NdBAmdKrbcz+FB6Lwr7pyl5Q0jM8L/e3DXxhBNgoOX73KPXglOImSJGUlrLW7dWnYplNTbGmVgNz5I36c3LgwJsMHIdUx4C312tK2qGH+Qh+M/yJWbhhoKaFVMgzXA7ZIPQjrUWOhH+/ekkgsvUdS/0klrTTSxe8HgQVDTYHkTx8a3dJhWaDWg6q6MtGoJ98KxxtfwEtbVuMwDW2qKXusNpdHMR9eLWJptcdURH7LZOO49ckxzv99I6smEBu95RUVTokI1A7bJ8cQjt0IWa2kz3cipN3s3P+KSLShv13awMgQUze9yrtEl8WyBfXqOCcHkBy5CuziIlGoSYkOD7BOVuNzPN+He2J9pROJ+I4BBm4Rps7AiN8f5Pz3pl5HaTyjUyMqhfQZwR0UHqxLg6/ipPWzBJMauFsIKaE9iTjgYKnpEFYv9dxRVFnFCYH+We/Np5CMf+KotRptUqfrM61Yam4xyC0r9UTNOxaQHxdeghjnoeB/6VLdWCLAXpzBgFfbLeFkKeeKPUd9/Ba8K8BUzNzIWxJbtbzZAA4k40fFIEcdmOum28Mvzowfyy1rj9xU3fYzVcA4J9NBgTd06yDrUWNs0l81GTynQ8YVQr7kmwnM+3IZ/yQ2f7XLrokj8yuEOD7KuyLhmABeG5TVt+E1Xym8xvdlj7pZr1f3DbhiOzo4LJeGZruZQKTzbSBpNLcohmu1BJQZ6RrgsNtjTePUvni2FdTR3LWkp1Vfo6VJIpTubLNqvkik0O8/6llKYHnUy9V36zePJVfIT5jKoRMrHDa0UNjDc+f4b9Pa4tjYK/bZwmYL2aWpD47RC9GTZKVFyZnjj0QRj2u70MXiEs4RevtTbBAUGLTsE
 W/+AxvO2
 Qd6uz6JR4XQoKNI9my3QVmoBu887I7+W4m08HKZNof+09g1wEOk6G7x26jDqxHqiQTVrMahy0AvnDTFXtGOPVQBYPrj7NFPLqNe7sXfGaPL0Ncmcj0CwdcBg91FtspEi2zV6BqCN6XW5xspy95Jqheorc5WKMVMf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Bagas Sanjaya <bagasdotme@gmail.com>
> Sent: Friday, August 29, 2025 12:55 AM
>
> Convert cross-references to kernel networking docs that use external link=
s
> into internal ones.
>=20
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  .../device_drivers/can/ctu/ctucanfd-driver.rst       |  3 +--
>  .../device_drivers/ethernet/amazon/ena.rst           |  4 ++--
>  Documentation/networking/ethtool-netlink.rst         |  3 +--
>  Documentation/networking/snmp_counter.rst            | 12 +++++-------
>  4 files changed, 9 insertions(+), 13 deletions(-)
>=20
> diff --git
> a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> index 14784a0a6a8a10..b7b314de857b01 100644
> --- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> +++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> @@ -366,9 +366,9 @@ RSS
>=20
>  DEVLINK SUPPORT
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -.. _`devlink`:
> https://www.kernel.org/doc/html/latest/networking/devlink/index.html
>=20
> -`devlink`_ supports reloading the driver and initiating re-negotiation w=
ith the
> ENA device
> +:doc:`devlink </networking/devlink/index>` supports reloading the
> +driver and initiating re-negotiation with the ENA device
>=20
>  .. code-block:: shell

Thank you for submitting this patchset.
For the ena driver change:

Reviewed-by: Arthur Kiyanovski <akiyano@amazon.com>

