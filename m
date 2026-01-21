Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E22C44500
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 22:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA556B0005; Wed, 21 Jan 2026 17:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991346B0089; Wed, 21 Jan 2026 17:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8486E6B008A; Wed, 21 Jan 2026 17:14:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7004F6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:14:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1CD28DAB0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:14:33 +0000 (UTC)
X-FDA: 84357376026.24.70796F2
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010038.outbound.protection.outlook.com [52.101.193.38])
	by imf27.hostedemail.com (Postfix) with ESMTP id 13E0F40004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:14:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lVzelwO5;
	spf=pass (imf27.hostedemail.com: domain of ankita@nvidia.com designates 52.101.193.38 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769033671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Frif6f5nPpXYErZo2xLHdOQllGt6qYRyu2MVMyt5X/Q=;
	b=Zv3y7bHsWTHS7Vokc/ggwIgjRGUvnhu8BIXr6BrUID8RerRLQKKZABlq5B33YweJioOQg6
	tm2W/cliG9GkY3kHny0ttvkBYkeP+XFZV9a7DlaCXnkXX0kPsO9D69FCrD1s1nKkBSBZST
	rUVK/NSvPNgludpYOkl7sQDAqzVHmTs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lVzelwO5;
	spf=pass (imf27.hostedemail.com: domain of ankita@nvidia.com designates 52.101.193.38 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769033671; a=rsa-sha256;
	cv=pass;
	b=vxVI9TZZX6qLMBhU3SYzSM70KSOlNUhYNJq5ISGd+uJs8wpNKjgYFCCQQamw6qsTaZBgjz
	CymIfAhb6upjm6uyyW3qm86xExBk/JXGW3xlHOmVAuMv/lni+g6aGmsaWcu1qFBAEmPpfv
	WeFiosdABNhFOH6rbNiZjIWFAzAWJU4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EaI5KhloZHLCNps0e6rsZZUG/fJJzGHC8Z/b2QJEVm92Ww1NXQnFGR/KxavG+huzaIUFiwQANuTcPmpz2Cs50hFnOGOuboKuakQnYkn8tY29EhDyGEzsyXLJMUEVv/bSBPqZ9s5hyvNcDNFPvd/LHnUeFB73JQt7zQWCK2GG44aAvwAClwgvmYGlWWyb9652ySdKc9WOEn3H8ijoy3F4ssyqCJe2MK+KvooNIUB4MJJBYndQ9tOy9hdf3iZcdxpAP695FMgmjc0bX3S36IgrfLOdLB6C/+vGMC2Gg+/DG2EVoSL9duVSHJ0xIM/oqR++rqHg7GHWB1GO++W8favF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Frif6f5nPpXYErZo2xLHdOQllGt6qYRyu2MVMyt5X/Q=;
 b=Z/c9rolqA+N4kcyHBnxgWHU2A+QBkvDRvcrDbWXqKoAEiorrfFXWQfDhRHOmaPeGWcNxtfvQP60p/EUNAa3j6GZuclC/G+/BlAF1zqz+3Rg1WLVz/IiJPlpH4s8/YlqyDB+pL2cv4AdEGHJ56e8/OiAzWmACiWq3KUkWSM7vcYBRCMK5DJZyBDxNmBBsoxj6nuhNLOKVyROrhHivdBgu/XYlrHm3fq7ekwMp1eDRDfttqIzzZdkSzm5TcmJn23dYIcu0XJVUhPxLh+b5mzkAPuCcdy6LfWptXmqTVfHXzVqwgTX5ShSq5ygxYqa0gJlgdcHJTn/JLck5U0ilZ0nLOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frif6f5nPpXYErZo2xLHdOQllGt6qYRyu2MVMyt5X/Q=;
 b=lVzelwO5wkAy+r08AAtBbGyd0+ldp3Dpzny3c4AUjAxq9a2QSxclUu3N7ukDm9poRI8NhoAnJ4Outczfcnirca7+KW6J8ad1SQHn1c+YyV2Bz79Vx1/J3BASBxV4iknxQZzgSRkHuS1jQraQp1zG1Wndf7RFsABZR7G9MPaWyA7DG1XAGnWuh5UTbOtwcuK5NklHKfcTYvMTjNoJQj+/hEUIoet0e5F4oYKYc2iWjEqMV682fy2F3TQJdUJgDCcP+3Ka7MEbej53c8ysjRTukP9ZutiBCcETPM7WFR72EYKDIsmj2AYZBqUx67xBSv0SjEuL4EUNHKiKv0sSf/IMlA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB8601.namprd12.prod.outlook.com (2603:10b6:806:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 22:14:26 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9542.009; Wed, 21 Jan 2026
 22:14:26 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "tony.luck@intel.com"
	<tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org"
	<rafael@kernel.org>, "guohanjun@huawei.com" <guohanjun@huawei.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
	<lenb@kernel.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Topic: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Index: AQHcTCjI0pjrCheBKUOiFkE7k4wQB7VWDd6AgAASNA+ABZtFAIAA4DaAgAERvDw=
Date: Wed, 21 Jan 2026 22:14:25 +0000
Message-ID:
 <SA1PR12MB7199E04FC278F6F8D2CD81A9B096A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
 <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
 <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
 <CACw3F51qrBXnN370Btk7=bcKU7s44nmQYfN=EAfq25MondRUNA@mail.gmail.com>
 <CACw3F53n1ieCfP7Dye96S1WPpein+x6wTVUhE4aVkRG=VppC-g@mail.gmail.com>
In-Reply-To:
 <CACw3F53n1ieCfP7Dye96S1WPpein+x6wTVUhE4aVkRG=VppC-g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB8601:EE_
x-ms-office365-filtering-correlation-id: 6e5f48b2-d763-47d5-c6f4-08de593a703f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?MLPmup9LIlG9nTY2rmLTbFjwQFO/QjMqNfScA7zGubLUPXsbTwPEB3Pql6?=
 =?iso-8859-1?Q?DkPdSBTEClo91p+0v0caNy3JKF/HE4pxrHVYNtXlMtAYYnSzE4WOw7BF49?=
 =?iso-8859-1?Q?yzdVr8bV4GptgYUe2Hfkr+WO7WLz00nxdHz5VPmmRXxaWZsUzXpvJc0sV4?=
 =?iso-8859-1?Q?6Aqkd2S37xhIitoBHqdCJ08bx1LS7nAZDW61x2L1/h4zDsJ2W8IaWNpxSz?=
 =?iso-8859-1?Q?tL8JttJfMlTAEDSOSS+hpTU+rpxoZpUQ/BpEEEH35ihBwIxiTU6EFJ9nDI?=
 =?iso-8859-1?Q?W4oCCDXOc47kpK4EzjbemJueUmQCKtYH3kUZJQyhAz6Gs0Z9QhKlIC8qB0?=
 =?iso-8859-1?Q?hmYLJtP/xYquHciUDo7plkdQh28SsaHl5EmVPQvcmArsGmW0b6uh40SNcK?=
 =?iso-8859-1?Q?S8bX0N1uV3sCrS7wSHIb3F9uWzLQUXpixKZfZcLhJdqvofakOdGwtQiNdQ?=
 =?iso-8859-1?Q?7AML1v1sAM3d5lzku9CVH+oRz7otixzt0BzQs8JrHvJgr83OZSknXdLbSa?=
 =?iso-8859-1?Q?fPaCPDHbJqNEDE4P4A10VRWtWRsI/W3L8FiM48fDJvdFC4EBZ++pqGcqaG?=
 =?iso-8859-1?Q?woC6FMdVg7WKD/P+eH2B/s3jrHQ3VgscUY0HeydZr1dOe01aarCtE7y+Ka?=
 =?iso-8859-1?Q?kh1iENdHS8yT1fmdHOzA/92RrVzu9ZavGRusxV8cWjoCrIZKO4WKq1VKc9?=
 =?iso-8859-1?Q?2r7Ba8BRr6h3JodN4TdUJFSj8TH20XZkKLBR7HUax8ObSPHJQuJDysA/3v?=
 =?iso-8859-1?Q?QOmlhDnfQOGb1YGaMPNFbSE5Yyxto4Me9Wy26sUsNxZPRWDv642csS1aeP?=
 =?iso-8859-1?Q?uhzLA4Dq634eNUgUcLwmVzJNaXXkBIcItlhoLh6FcxV2HIDR8Xm3uJN279?=
 =?iso-8859-1?Q?SZmJASrCyiPpeU39JW68tpPP82OrYga3NQOGIbuQe5v3oXTFcP1oZj/GK+?=
 =?iso-8859-1?Q?paVPrOuWG1eyp7Bqi6h3afn3otiZqkxOhZx5CCnXggdSqYEoe4vVpxt5SM?=
 =?iso-8859-1?Q?OiTiiSMoNde7KK046g2EsXIPB8zq0btXlas8ER0rV8eCmeY5l0kFTWBgFl?=
 =?iso-8859-1?Q?CXU2x58YJixphAR9nFsSPkkJmmk8ua/qsGxWKXJW5PrqVy/x/rXf+NyjYZ?=
 =?iso-8859-1?Q?Tf7CRphFvjFJjDxY7/wzJDZrtVQ7o2c6kbxJu1xI9RIpYa4tKXV+W00zMP?=
 =?iso-8859-1?Q?divlRa1RTiJi+vBPdJoShgnjhQH7RkySMBwqrG4zVAB3Zn2UQkaNCu0sJA?=
 =?iso-8859-1?Q?EN4QT3vAviOa2vz6d8gi2s6gb8L7CffTYsanG/Q5fQyOvo/v4kjt4ySdW6?=
 =?iso-8859-1?Q?SWWapIfQTlPqwqA6+e91T2EQZNtiRYbpstaiioOfADSNLWj+oB9iKZnV8/?=
 =?iso-8859-1?Q?5X60QB8b3oVoHq/q9kSWxsXKxTdYKwmDdm30uEud+ZTX+kecRPdN0UQ4Ef?=
 =?iso-8859-1?Q?Sh6DX1Cq0FTfZZzCpvYkKFySY2UE81AyN9U/CnX0gDwjKpZBQC5WluJ4TM?=
 =?iso-8859-1?Q?e88ov+YduiiM6tQ56PxuPTonVzjkFKEoHVPZyQQF+af9YvwcK8XsA5eYHS?=
 =?iso-8859-1?Q?I4XVa4G55A1XB9EAaFfu4zVaW0hVdfPUSjPhPCkr8FLRpwWLj+bcUhkU8I?=
 =?iso-8859-1?Q?EsAbLt8I4xx55btZf2EO0XVHI5CRtr0HeLG+P2Tm4F1/2oWWFbDxWNvl9o?=
 =?iso-8859-1?Q?waM0tRUbC0+VdgDpjFE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?7jIPlu92DGXxNI/QFIM9jagWq1TMeQg4xCXoqXs1G8KUxIGghhjUxfwcOT?=
 =?iso-8859-1?Q?qNCQ+Zo8wUniBzWSew6nOfrQsIQOr6+tdZ6qFuIvMfXGFtdb3POvW9qJmD?=
 =?iso-8859-1?Q?uTgwGQgJhk9vU7ZrhxA1Wu+9zGBM5sy8QZEYnvqV3GHp7SyKk8nHg6wYHl?=
 =?iso-8859-1?Q?O6eaF7qq3e9OesDaJeH4FHIHbHg39WZS0F7HDYSMiUh4n8b0b+fvOMUpzM?=
 =?iso-8859-1?Q?jGBuvrT16sZxbD2RRymmpkCJqMBq/2Wge9jDxmcJqUvv49y+2/CmFaKQyM?=
 =?iso-8859-1?Q?raT9GsIeEnGXIV+lHt474o+nfYvymgM+7ycv5zp+L0+FVOOhfo52ptbRn0?=
 =?iso-8859-1?Q?33otVIb6IlyxQrXZ0q04YpRTRBu778t3zdiS1scrK1bU2c+EeLr6PomTv9?=
 =?iso-8859-1?Q?voTDnXKDKUE9xRgY4sIawwk/ZiVRVRKtB2OzwiOlQuxwQsivfnQVOOO9fX?=
 =?iso-8859-1?Q?zCSTr9m48AauXyrBRQHvvdILkHYq5q9iwQfe/yesfARXB9w/R86xP7PQ9s?=
 =?iso-8859-1?Q?njtD+kOmgtJzLzELzGiznSvNVGCnPjC1hdFx0SD7gvKZuzrY53aKLe2DPX?=
 =?iso-8859-1?Q?7QzIJEdiidMTWiklVEdVGVxr9Msb7abx0IBv4h3oN9TDPJ8wCI1arLeWT+?=
 =?iso-8859-1?Q?BwPsg45ULLfDQebPtoDmCJ4WsSYOb0DcsY+Ss7RlPDx4BCeXNa4pIXDjOc?=
 =?iso-8859-1?Q?v5DGCvjfxj9kxgC+PNwsmIos4EhEglAe4XyvUcoaVGaoVoZaLCg7tAUw96?=
 =?iso-8859-1?Q?ZhOQOiY3MC+hJBPcuvuWZPhQU3ajRwGQ8AB/MIQItug19kI9OEkbnmBVHR?=
 =?iso-8859-1?Q?Ka0jGBfG1HUR51PmobcSoqdeujp5GFPyvVm0Fq1el57AQ2aLGldTgm42MG?=
 =?iso-8859-1?Q?skk5yIvBqD6nsS61H6lGzxuoopTMvLYtvGwx6wdKJ24TuZjIPMnX3Pv3p3?=
 =?iso-8859-1?Q?EG4rJBe8uRS/O609qK5nZu6TcLxZmzOkWPxsZZUvgK0MO6Qb2YomsxTtzO?=
 =?iso-8859-1?Q?xsk2sez4sz+yCSv8MiXvT+so3DaM5gKA0CxPr+bRqCisDO8674FmNTSeXF?=
 =?iso-8859-1?Q?ApqhM1G1XYtI7Jq3QgfAvGQ079qK3spL3/+rcZPiQQOS7RodbHGcgwbDXb?=
 =?iso-8859-1?Q?hSDx3RgB5Rxein/PUvZIfmb3gBspU+nSGzNnb99ei5DBTQlM+9agCMXjGx?=
 =?iso-8859-1?Q?MqJ1TFmQGrD75KwPE/6LbIKp7Scg0v2swpA4OX98hJDm55XHsPBxpME81q?=
 =?iso-8859-1?Q?p245/s0CscRKKKAJNTqkobYg/O84a7rq76FrHegReqiygcj3SlBZg+PRwt?=
 =?iso-8859-1?Q?UiH5WrkpAw0U2AcXavPkGcOHXpFkCqfJ7PEP9mgwjty4t7jj5UGlY+xjdw?=
 =?iso-8859-1?Q?w/v0/5n3XShmpaNGcj1P5j3nOSGwxITvdSZ9xmukT02hyuUtJs5xSJa81C?=
 =?iso-8859-1?Q?sw16yfpjMi2HKcJcxnKZZTXv0ctwy3Wt+2NXwpXF9iwLxhDxOLYnb27Xpo?=
 =?iso-8859-1?Q?jicHZYFeRHo4dgU/WsSEvWqVYJ4Rh61Mgq/hNidMIBciRtg5yS6IfI3LyT?=
 =?iso-8859-1?Q?xOGbBOFGnM2IwuFihTZ6yChxTzPeTIBdnWKAwbqIiGx5CTnve6i2VQ2CXh?=
 =?iso-8859-1?Q?ta8A3wj3lF9CKV3yhvA7jrtrKESvXaa+AYWUIGuJr9VP525thOQMd0xcNE?=
 =?iso-8859-1?Q?dtJcyfcSKkvS4aGMhtmOAl3WKvaVE4vmLJ1Xp1kCbaQU3T9J0TdOlMQB9U?=
 =?iso-8859-1?Q?miGpnYtJb0wN/Qkku6krTIO1VjeyLtcwzIPeoxZq3M+tsF?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5f48b2-d763-47d5-c6f4-08de593a703f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 22:14:25.8715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ynuh29DfTPe3M/qPHhhfv1tqzZlHS6jmOoPaVIl+bKQSx5AlgBNH9x2WAYin/q7aiynLAwCDr/OHpXloxmGZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8601
X-Stat-Signature: anbdjj7c75iw6ejac4qekn94q4k4p1np
X-Rspamd-Queue-Id: 13E0F40004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769033670-682750
X-HE-Meta: U2FsdGVkX190LJPAwtgkJLAxKInXnpACsXn1PpO2aB3L8zqvGprKl9Cq8qP7ZxNQKa8xFlfuRbjvZsfoNi+GeVHigTNtvNsJJVMR/j2tVS+54YvHf1XlUVIKd98/mdXfCGh9HpQoc3LzzdPsfStPuMYEGNMovUtFtG585HYDqRcck4yfzAUipsC3xHmyhwyeExGChk+SBklHId4M/wjq7xHv4Vvk6oCYpCV+hbnLEFAynpaBcjRA4t24Dy5wfpwUKwPCpW+7kKmjx/oO0WB3hh7uQu3zhozBBLJCDf48nOfWRv33maI4de747Jlq0R+2L8XIMIdfc3I05upwG1BtlQ1dxLuKzkGyPh1vkH7x/CZLerNyCpi3FgWnKOJDAZTO0iaOIuAoVBya3D2/cd5ENJi0+lr7oVanyy/OjxX/67oeymxyFcZbbENSzzEXJ5pzHk1o2pC/ErzqDmhLNtc3m92Nzm9OJ5ZQhfowOBYjshevdSdyDmmv+A47qkL4UR3Yl/3/NW7z/VKRMwMaNTQXULrUeU3GN1d8GzglK6Caa9XUY5GFcsEOSBCOa6xBMDzVaR8gI1NpLi7COJuUUMhsnt9AVBiO+f9C6qZeJarz/ct8kO7HSmvSWWBV9Oc3WP7U6RLZjpwfxXsrURIrY9dKYEzMQlOlWe+3OhiqunNUeNk03834cMr7yrbcUOAw90QJoU/Q1BaGngvKsPWwYSR/MI70oNBKGMPRF0yylpoL7Nrd1SixG/hVVMGyHWwWxUb6524HfdDe/qhUgkesc9t59bnRBZue/UNalFm3u2fn7ue/TK0zMk6gYhpaWrmqhKxFG4pZhUOrZLzUinVKpvEKLJAJaBSf7uKe3LfAz33kqep6LrOy3BsE57L6N73zuhIPOkk4t4KKTFe1qQBy5uocpwUR4sZdYruzfZ71uKv7meGxpcSET1a+Gw1rEtH/lXQAWPf0pBZZUWtLHdtYn3S
 atIXU4iP
 rcpr87ZzEewnalUrbxIBjG7vOTiJISL2uy9cZeFBRHIzXKFuJAqCouc1ToNV/5WFUJwjpQoeU8oG8UTV0hqs/4+04NwsA1gJk+yvnImiz64rJuwdYlKcAVGHnKvYWtlq94/Uy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Sorry, one more quesiton. I saw [3] implemented pfn_to_vma_pgoff=0A=
> callback in nvgrace gpu driver. Is EGM driver's callback posted=0A=
> somewhere?=0A=
>=0A=
> [3] https://lore.kernel.org/all/20251211070603.338701-2-ankita@nvidia.com=
/T/#mcc9ccec90b1ca755ad9af0a821f5ce524fed0ffc=0A=
=0A=
Hi Jiaqi, the EGM change refresh is currently in the works that will=0A=
make use of the new callback. It has not been posted yet.=

