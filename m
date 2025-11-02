Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AAACCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 11:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD738E0003; Sun,  2 Nov 2025 06:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E1C8E0002; Sun,  2 Nov 2025 06:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5352E8E0003; Sun,  2 Nov 2025 06:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA598E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 06:56:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6E3A1A033B
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 11:56:03 +0000 (UTC)
X-FDA: 84065513406.20.207CE48
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	by imf20.hostedemail.com (Postfix) with ESMTP id C90F91C0005
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 11:56:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S6up4bLv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ankita@nvidia.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=ankita@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762084560; a=rsa-sha256;
	cv=pass;
	b=AzafMcnnOnShH16bTxicgbfhEgXst0h5bFU88oYiZm7xZnJGWb0nvSXKLonBOP/AoInG9O
	xdFmFO6hz2jBJ4jg+ZrUKyFyl+sT2G0hu17RD+2eaV1FviV1O4LZD9ex6f2FD2nSbFx0F+
	xvk4F8IyzAqM2yNU+w+2krNiwpFhkdg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S6up4bLv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ankita@nvidia.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=ankita@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762084560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuDdd0Q8zyqrZoQJ6pJc61hYLOQkagpe3idtOiW5+wA=;
	b=f4ASJq99j997bH0L6lhuGPlVBAmKM/c1sHCFto7Bzem7kpWMIfP+Gh6Ve3+PygDRgB8oSK
	PQ4vhOfTg+d/Z1hV1mYxeYDHYjUdIaHHmz+8ZhXeL0eQH72E1KVlEnD8TeTGZh7Qr7x75O
	ub8TUT9CDRM2NeKjYUWkF3g3bJ82XDs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ssx93AMdtlDXd1/PDbkSH61tatsuv9L4MTf7IWbxxL0aEmZTcdyiQZ4e782hhxjh6Hy+mhwiauxjklcozecUnOJZrT7TmbEmYxu+cVBpylnoF3haIxW1RI3w2Kk7Gl/+iarCZn4PhyhNzNzqqNbrABF2JGL+VuKxc1cEEXqDFoAahuCca+htOs42I67pVTZHuiBPxly5ztwclO5kgHtRxya6o4ryeUigT0A4fBpPgBf9NdslC8WNZGUcUejEWC05DvZL8ANTn2oB+d/FuAmUdOmhp67nTwg70lxql2rmnxumcvWKZuQfJyt4dlTifMybkCGudSikt/hHpUkHYB9XpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuDdd0Q8zyqrZoQJ6pJc61hYLOQkagpe3idtOiW5+wA=;
 b=NpIZhdk3srtUJg2lyLbAxIk3XAnQ6YFNrRZv3LFHMU7q88C17lFpUba9cyS7KtdU1IPA012TAGYsBMk+muwXRnFfRSCIE5/kSr5/Nhvnk6EkXdP2/dI/9s3MX6cYfPp/jd+0AA2EQ3BQhCwxrPqF9XmF9WV6h1YMUJs4rG5VZjKqRtnVTJDxFDydgpLnK6KpjjSHt+y6ei2RK19smvwHHtHlMk3lK27esVaRmxk7qMIRR6SZ2iKwqr9L97gFSk4nf4mlTW5dchbav/cemfTPr2HtNS8HnYJDFwrKCjqRDnEvyuqEj/FfAUSOZHdd4AuzhKhOmiiElyVQJ0lze8YtmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuDdd0Q8zyqrZoQJ6pJc61hYLOQkagpe3idtOiW5+wA=;
 b=S6up4bLvGQREaLn4gko2g6C/Quay10pquJuiNgno0Hn/VI2zyWEa7Q24OKVswSf1azOvvVKTaxiQFsbdl6MJI9ywkMKq7voZTX1QYM32eNKgL9es9oDnjKvFjmdJQMTJpg9dBYgq3UEAiiJBOWp4qJSiAdtizHZolweg264EUF5MtQRYv+gxTZ8z3w9G0SXjQgjc7UPtU4/2P9xt4Zp0LdqInT8DPfskHXtWsaMZFkoyLdQWTc3kb8xq9//Y1faga0bIT44KOxeMGBBnJxbufJhmR8sWzF8pjzaQ/kmQkOHaNRp2g23H9xSU8TjZSC/D13wboCg024kda4MBnOUK1w==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SA1PR12MB7293.namprd12.prod.outlook.com (2603:10b6:806:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Sun, 2 Nov
 2025 11:55:57 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9275.013; Sun, 2 Nov 2025
 11:55:56 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Michal Hocko <mhocko@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Aniket Agashe
	<aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe
	<jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer Kolothum
	<skolothumtho@nvidia.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com"
	<guohanjun@huawei.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Topic: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Index: AQHcRoOUWJnftWewAUixSPYj9sJbdrTWte8AgAHBIgOAA3w5AIADW2Zm
Date: Sun, 2 Nov 2025 11:55:56 +0000
Message-ID:
 <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <aQRy4rafpvo-W-j6@tiehlicka>
In-Reply-To: <aQRy4rafpvo-W-j6@tiehlicka>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SA1PR12MB7293:EE_
x-ms-office365-filtering-correlation-id: 61930f60-0af9-4cec-1377-08de1a06c85f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?wOuzUAAHHdGLzJ5yBinx+nuODCZz73blgEt4TlR/wM7ggqxAcCeloXclvN?=
 =?iso-8859-1?Q?tePA2wSAC3kuyBdLB/YuOkcn5gBafvFJiHlxKDcpna+ANvY07esvE74S/X?=
 =?iso-8859-1?Q?QHMst3mStWDxvQt9VkMeyjIYiTxK3SRVcXE5S06EaVFiNn8ZC5ptFOgOWX?=
 =?iso-8859-1?Q?YmppWIQLSX6WQTJFpW/XxgEQDhoei5mL6LP848E7OTijTbRu6CPsa1+tVq?=
 =?iso-8859-1?Q?19hg956r+dR57lGd1Sc5Tw9pdwwVHS6gddDEjF2i5QXPA7QJah+c8HJ1dw?=
 =?iso-8859-1?Q?97z3U/YK5OGqYyiG4q/tM8sFGztPufwjP+s1KrDP1nQQa3XznNgSgzrCiT?=
 =?iso-8859-1?Q?wTYl0AMFTFovJUCuqDo5b32aWFFlJr/4qjU0XeKjysjnZmndQxP6/5NXnB?=
 =?iso-8859-1?Q?idjo/VhegmqIfHKkyAhAVDM96BJA6dSq2ZCPVp8/1jhjakHLLn727RPwcL?=
 =?iso-8859-1?Q?ALXs2Hvm1y5h7FEZBBNW2xwqsffgHfofbtrApmZ7hCB40BGKwTxd7pZ0GA?=
 =?iso-8859-1?Q?Jl4rJ40y6wwFDBLzqqiykpM770gk58TQ0747mN7iiEE6VA4uZljEUIohwE?=
 =?iso-8859-1?Q?7qAIJ0H9WaIOx3Kt9lXN/Lizn1jK7W+pTojDQbujpCi1oBvg52td6irK1x?=
 =?iso-8859-1?Q?ATtLI4n3J91N4jOv8Qp0saNp84i1K+I5NRK927rZ+7+RAqiCq5s9Jjhoyr?=
 =?iso-8859-1?Q?fFTqOwn2iDkJ5L2I0e1sHjXSVLzsa7IlpSZ9mPQjnH6+LB8D97BSJW0sH2?=
 =?iso-8859-1?Q?t7Amm5gS+1s4JsPJ2lXr/Vz3NY0iUXElDVbgzUVynj5HgbACz9K/dn+aWN?=
 =?iso-8859-1?Q?/NoClsUss4Nl8S1m0PDVdrSJFx0AaXfYb82FOrehjXf6hVkq+WCLIm8jVn?=
 =?iso-8859-1?Q?XpKqmvitz36Kb5PAD+KedpsAtraeOKXnBk4dSr6pJc2T8e5Cp5bl+6bamP?=
 =?iso-8859-1?Q?EeTW+mrK3ZEHsgy5Vchk0s4h3UpjJOQv1JG4RGoF5OccC5BUWNHQcGl6XY?=
 =?iso-8859-1?Q?n97mrYYBxn9A1XT7/WJl5dvxa6vT1VAnFbXXUFPBqFsBQRneV+Ggn65CHo?=
 =?iso-8859-1?Q?TmSxknfRjwrVipLQtEy1p6XDmQIAKpWNJPigAHOLVPRtBihStUCi2Lah1R?=
 =?iso-8859-1?Q?yrKWvjE3I6e8DGtMwnbQgoXcnzbOcsShwMYATntXIP4l4jHoVYySaj8uuo?=
 =?iso-8859-1?Q?bgM6tJJns0XK1Bizv9MWfq7aOuzAjzYnp5dMhNk9l34xu0BA18tzczDEhi?=
 =?iso-8859-1?Q?M0wxp7Zyu4bH972hh5AzLSkKzK8i0rl70ripHfGHqjdWFAog9FENcsrENx?=
 =?iso-8859-1?Q?X0G0Sg8XZx3F1jQqRUYg6AUqFyucU8iqzic3o3ZBw8hLZHYj3Wx3qfKTag?=
 =?iso-8859-1?Q?k7KJ2LSNYfB4bg9NbtGXXa0AV6ort6259aJ9RGwnJ02phSmWBu2hbCpk1i?=
 =?iso-8859-1?Q?CNu4jjpPfAILCnKdcfiHEutUh37stQenqmNdlfAh148FJyNEJyFclW+a1+?=
 =?iso-8859-1?Q?yXeEMM+KAkpojMgJhPHEKpC1NaSDS6JNx/MI8hc5cnT3Bz3dGBPBEdyPUp?=
 =?iso-8859-1?Q?xXrTjM0PV8Rt+20HNyz5iV7UXYdo?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?YD8gFA5HipRQ+OaDg5qZDgfbz8MLB9FP+dztZq6+11c6SQl1C1kRb34e6o?=
 =?iso-8859-1?Q?Seilt0svRFcymAhUk/RVIuExWj0d2ai4WC6DVWFLcJBR3kjnsZlj/EuNla?=
 =?iso-8859-1?Q?PBipM4ZbXSIpQ2irZFfNByugLr1tgZFN9qafGAKFdds6H/C1XdvBbs4whj?=
 =?iso-8859-1?Q?UKAEK6RzkXlY8anrtU/dhABdYnccY6QPmE7ul9xHMUYhDYexNOlnq/ZW13?=
 =?iso-8859-1?Q?uaCMbqbxIbMlgNrbvq9HxG5MvL8+/94ARUesbDYAKHyLqSm5J+JaC9A74G?=
 =?iso-8859-1?Q?r6CvuhC0h58o1Z1+KipHeG59zltY1SAtjj0GMfnQ2JcvM5TvDB8J+9SzUv?=
 =?iso-8859-1?Q?/R7JtPkS5tDY2+ElRZ9OGuQh82cXVsawUgBNsweI2qK9bXZH9bwvmu0NaV?=
 =?iso-8859-1?Q?4Q7cgjF979aGWCXvDXQD9hvKk1ueQaWMXgGBBWZKYiRpophqeKAypTgiFS?=
 =?iso-8859-1?Q?nGpQRVlfdnoLpN7e8wABvS94+d75Y/igjf9ku/Ydc9XFecWaNPUTrWzVOh?=
 =?iso-8859-1?Q?J+OnT0KX+n053ytOHYexkj8yLmhCvPZD3SkHsXNFdBMfXAcXsjGRAQJDyH?=
 =?iso-8859-1?Q?lM2lBSSHY6OvdF0mDettduI7bqdLdkIeZ/lbHQuaKD6LU8aBFRAD4IOYRY?=
 =?iso-8859-1?Q?xs3IbIzqoTvfBrnJsVN49kHSbZd4oytHIWsbuRkKJOblRxypcLDZ0oio7o?=
 =?iso-8859-1?Q?bfLjDi9UUrKVs5OcqsEXwgv2PXQzNKZq4rCcAnmfbrrWBRE/IX306qzivw?=
 =?iso-8859-1?Q?y2qFKc8wQqmQadI7zo0Xc4zBzcz03DYwLxLhWGTN5ztLukInDDInZYa5lS?=
 =?iso-8859-1?Q?4unUkqiVcIe3dML+WbIWlr58tjbWLJ0URN0xOge9BvuxUk0q4/+9k0xIaD?=
 =?iso-8859-1?Q?eBQRvltbPzt5jY1jROhKP+tPKp07auTuVpfCteCtHmboBf5+wz52X+6zOt?=
 =?iso-8859-1?Q?itw909HsbbAPdRl/gul0r3QaLa2qJuVciFweByKCANFHafs4wKl6fBJNM8?=
 =?iso-8859-1?Q?EAp6+/gXwHDu0tgQGn/3J8swjlx8whoXgsqVQjO6QPHMftiOtYa6nw4ZSR?=
 =?iso-8859-1?Q?HvUStPt1GNcj3qk7jEk2gJXTEi5T2VbeOJtNZbOUDbgGK9hbhKHgLEAM1a?=
 =?iso-8859-1?Q?u0XRjGV9Rg0CVKknGIYKB84GmPchtUwpMrR/F1JcKr/o6CSnHiYmDdvp/0?=
 =?iso-8859-1?Q?Z5J+COkAnPh28kJiGILYapJ3vNHMKQ8QfSWuLNNcNQ42C2gMji8bwePDg6?=
 =?iso-8859-1?Q?o7QZOmAixCR/0k5XAnkFq4IKiQoRcsLDzD6q5nZYaLObleg6z3hibDeuU5?=
 =?iso-8859-1?Q?sTotD11VnuixmDT8BjIX78r1TLmy3Q6bh2qS1zS8DAeF49pODPGkAK3UQ/?=
 =?iso-8859-1?Q?mrbQE4pAqqrCLf5fMMCr0klpfAr2d1GC/WaETdwYAGa9K/0+6T70KkefKg?=
 =?iso-8859-1?Q?8Rs+ikprCwOCIXcRG1+x0VntEFTYu8OH4Zrzd+jluVt/2y3m06K6BL+QHH?=
 =?iso-8859-1?Q?HtOsV54edEkiCU/HnMD4y5SugxLZMBWEk5zUnceH4/Pbsl+Zu8hKGRgPB3?=
 =?iso-8859-1?Q?zkeaipkEt4BoaD+i2cO6dBZdBQYCuU92yasQmfnMWuT0xoG4JzGgLAeq42?=
 =?iso-8859-1?Q?iFrkuC1YKd6ps=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61930f60-0af9-4cec-1377-08de1a06c85f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2025 11:55:56.6396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tf+c+lzor0k9PMPetaszYbh0ppJaEcK6fGeqxG78k2NKJzlQCRmDbPwX3ZNBf3ErY5FHY4EZ6IWufGyRxcHzvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7293
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C90F91C0005
X-Stat-Signature: 94migybs91y476tahkn1jws9rem35db5
X-HE-Tag: 1762084560-352936
X-HE-Meta: U2FsdGVkX1+jzjsrtBELvq40RRCgl/lkwajScGBHGxG+OcmncZiRutKCBiMjop4LKYOmFJq6LIFJwotRU+/8LBFGpaf3BYAc1Lo+76MKE03TAkKayhDrfsQpQv7FGlux1REmJz62W1s9dLHwN5cHVTD1SMq8gEyR+XYkJR7OkfrkLySjEJCa2GxucOflT/9tlzGCQzXidEG48ZdLm2FBOEcqZzb6jAFSOzbJ8UUXbX0j+XMh/KN5zHi6/ouhnk4BdKc8C+aPGjJpLwM36E9bEM63eKs3WgklJfU7ep2C62qhInd7DD5noBoBxyyJmI+D8tbV43nXmW8gg3KCe//f2Zs+3cSsfDM99B9pP1Gh4nDo816Pnh5VGZBDWNUhvcWDEeW+G4Tqiwqqn1sARQPXJRDQiPGaFE3MBlYdtvQ0l7GohiC0r27jv4AYNRrdUPFpmMpoK7aviJ30D6nvoIUbf8rmyNtFeoh+5J+ZBz0CK6gZ+2D8Ew93Y6J+hF4775d2VmtzuIQTtpX7JJZgqstf+msfy0CmcFmvrQ/Opx1b2wuY/T08J22XhfTPKJLUJu6p0wvpjc3DfN24rUxFuI6QeoXrXLvfB3XS8aAzmOZGwoyXAvRToxB2Q9Df3MM55iw28zda7ZKJSBlO2Bmm3zeR8BJRbKY6f+9gHxXrvVdcH6Sl/OnR2TUUzs45YoEy4nXvZzv+z6f/2FSu4vxnO8nyrL6qDlLDY3noGvn2iuIv4hM69odRdGI3Y0didEgBSXnSIeX2O6by/e9bRSvxHV75288UagFCnsAmXofjqNz/Wj4gQ9PkFgCXcJ1MZ0xS+EjPHHTw7fyDDk1zzEBhGxPgFVCC+xVu8sVuGAa6dQLE0JZzZZh08AtL+FEgwzyy4jPx7YCwPRYsXI5dsNS8uIMDbnhZgWIAQ1KKCrfJDYTrvzlyy6SZ2gqUu6QxOIYke9rbuNabzWF4W3nAL7r5Gk5
 3I0ZWYja
 ZCb54iI9Nsy0RGhADw793E2SPo8VM/w06CRaB8Ncm5byemEjg2wftyhDNcUi55TQaTjb/vDP7aaagIZztZmkXe+tMGKTHGS0gOF/TZVcr4NJZv8YYr+suZrzfW3j5Ve2miMQodJTPJvg2w9xRy7Dk5Qu8DGpoCGfVjOKC6pMYYD6cAwNv6eHu/3tCYCoQmmSSjtQxMCIs7trNQxwaMuC73vsw+tZQ/9jksRYGG6zxzfBp1dWHpqEBDO9GaxcQuNaCZ1Pnm1gtcEdxE3DDvf6lIO2qMiPa0fjh9V93Cx38Cvm2BsT8jWLVK/R+O8/v0fynxXEZAFQ7vg34HJcP2pykMi9eVO5zIIfoxHWJD7PQIrlQe65juCscK3VCYTDz9Iq0NbOx1KqE7JTdmrlYiuldG2awRfU5J5E1uItbrKjZu4AyHkQIivBGvAtErGrRZKgloo0fTVo+6Yy5HE07rVK2wzFZZkfQm7UD+GFx5kYwTaAdRPh0lDeit6S3obQ68o+PsH/a/rxF05w3pgEwO4xOnN2+DybDcYFQXytM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> >> +static void add_to_kill_pfn(struct task_struct *tsk,=0A=
>> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 struct vm_area_struct *vma,=0A=
>> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 struct list_head *to_kill,=0A=
>> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 unsigned long pfn)=0A=
>> >> +{=0A=
>> >> +=A0=A0=A0=A0 struct to_kill *tk;=0A=
>> >> +=0A=
>> >> +=A0=A0=A0=A0 tk =3D kmalloc(sizeof(*tk), GFP_ATOMIC);=0A=
>> >> +=A0=A0=A0=A0 if (!tk)=0A=
>> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;=0A=
>> >=0A=
>> > This is unfortunate.=A0 GFP_ATOMIC is unreliable and we silently behav=
e=0A=
>> > as if it worked OK.=0A=
>>=0A=
>> Got it. I'll mark this as a failure case.=0A=
>=0A=
> why do you need to batch all processes and kill them at once? Can you=0A=
> just kill one by one?=0A=
=0A=
Hi Michal, I am trying to replicate what is being done today for non-PFNMAP=
=0A=
memory failure in __add_to_kill=0A=
(https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L376).=
=0A=
For this series, I am inclined to keep it uniform.=

