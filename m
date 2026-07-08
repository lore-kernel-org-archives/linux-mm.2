Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05EBC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8101D6B008A; Tue,  7 Jul 2026 22:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A8D6B0095; Tue,  7 Jul 2026 22:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EAC6B0093; Tue,  7 Jul 2026 22:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 284AA6B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:37:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A06028FE19
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:37:09 +0000 (UTC)
X-FDA: 84964047378.12.4566CF8
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011059.outbound.protection.outlook.com [52.101.52.59])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5AEDB100006;
	Wed,  8 Jul 2026 02:37:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MFprGJWi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jf+DSRZPaPiqa23Z+NsIeIObG2sHTY0/CEuDSTYjg9s=;
	b=bgFvqXdJ0xxoWqxc1GuNqlgYSd8PwYd8fnRU9rC0pGhPD0+SKFcooctB9ymFimW9wALZ4b
	GnnY8jttTQe6+EyhWjFZrGo0yW/0yZKHWNewaHBhNgjM8GA+CLH8ss51JHvCi6Ree8feq8
	7//FwwQ79Z/92oXasqasj2OagYq1CMY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MFprGJWi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783478226;
	b=hxoBJooAfEOY60t3MwPxeYvTEV/LQGwD2FBZWq84xGY48MUw7/TZ2ySVNeoop+5ZLAUXyN
	HqCZvR6wEF5Sl3gwX94yY7K8ACw7cqbXqjMXWX5h96syJ8/ldVEgpxpQNCWtZVEPkFG6RU
	gbJG4rZW07p81MPlPf89xjcxx0BVUZE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VZZQ8cZA52MWgegKfOITVQAgcN0oUlLjyR474Ros5iq2rFKdnOuXb6pKZjs/pNJkxrBfi6ocQQapdwKi+8/reZbLST6nD8Jm/g6yDjDQA90L4Gu488H+gbkFtZctzwyW9ACwFMNctCUQz3rb6BJT5AIr91tV+/E+WocFTaXbFjDUKJVJS2kAj8+TrLEYoN//KBVVrYWBttNKHguWgWro/ws1CdBSiTZLeVJOr8G0buTR8DeSa++48RHv2468LoqnC7rU73jQ2BDV1CfXANhRCb4u4M9eXF+/BGOG0eLPaJ49T2NQuzNV2M4O10feAMyr/BGpcPgkafLvYBvQwZ7tbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jf+DSRZPaPiqa23Z+NsIeIObG2sHTY0/CEuDSTYjg9s=;
 b=nQ0P4/sdSXmiO0ZHr6pihPNjCu4cIgzODYN8EZ9QDLERGTyPhtE2VCqPaqyb1VpvWEL3Ux/zAU6jewidQKTqA+lAj6npH0mvZ+0f3VtbSE/4OmVa6qfMVJcXkXe3T9nf1giwt7gyg2yd6HRm88814Tm2nEDgPO7xNZAyaVd3pBObvJecy/3AvUeWiA1tFyoh6GYy/pjI+GDRw1/a1yOMVOuv3DDRyhcUvexi0mF9HGCEYG4xDk9X8zb74EAK70QxBDptG6fuoTw0+fw3iUHE5q3jkDJVkS8kKfegJZIjT9MoOa+dlImbJT/SfY4ZQmyMYxV+XQuAxJG0cVAu8zAX6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jf+DSRZPaPiqa23Z+NsIeIObG2sHTY0/CEuDSTYjg9s=;
 b=MFprGJWimBSpaXlX3i+O2/ZtL/fCHs1830SG75uwTc7F2hRMC3ncWb0JVlaaHVw/5hZW6q09BGuO3WhI8/sOZeQ7AO+D9CajqiB+24XtXHRarG62ZqCgB9uAFlnXlWyBTCLqWMfQlWpvz8a090qazpfvO9gxfqfSpFL99yPS5lBI5rvU/SFJdKATvfn429MzTUUbTzsxhPfQBEJcF+NzRZ4+7GGvLEVBadjnPBCkTDSl6lHNA2V6pikinctkgMQPNu3IleNkM9/978FewuMGSj90RnXTOMmMdo/rpYiR991nr9PKuGj5R6vMtBTYaohBDdVb0G3MmQ2Ou9MvIJZ0fg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB8778.namprd12.prod.outlook.com (2603:10b6:510:26b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Wed, 8 Jul
 2026 02:36:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 02:36:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 22:36:51 -0400
Message-Id: <DJSU9FF2QXT5.14Y23MIT6POO3@nvidia.com>
Subject: Re: [PATCH 08/13] mm: introduce vma_get_page_prot() and use it
Cc: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, "Madhavan Srinivasan"
 <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Maarten
 Lankhorst" <maarten.lankhorst@linux.intel.com>, "Maxime Ripard"
 <mripard@kernel.org>, "Thomas Zimmermann" <tzimmermann@suse.de>, "David
 Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Lucas
 Stach" <l.stach@pengutronix.de>, "Inki Dae" <inki.dae@samsung.com>,
 "Seung-Woo Kim" <sw0312.kim@samsung.com>, "Kyungmin Park"
 <kyungmin.park@samsung.com>, "Krzysztof Kozlowski" <krzk@kernel.org>,
 "Peter Griffin" <peter.griffin@linaro.org>, "Jani Nikula"
 <jani.nikula@linux.intel.com>, "Joonas Lahtinen"
 <joonas.lahtinen@linux.intel.com>, "Rodrigo Vivi" <rodrigo.vivi@intel.com>,
 "Tvrtko Ursulin" <tursulin@ursulin.net>, "Rob Clark"
 <robin.clark@oss.qualcomm.com>, "Dmitry Baryshkov" <lumag@kernel.org>,
 "Lyude Paul" <lyude@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>,
 "Tomi Valkeinen" <tomi.valkeinen@ideasonboard.com>, "Sandy Huang"
 <hjc@rock-chips.com>, =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
 "Andy Yan" <andy.yan@rock-chips.com>, "Thierry Reding"
 <thierry.reding@kernel.org>, "Mikko Perttunen" <mperttunen@nvidia.com>,
 "Jonathan Hunter" <jonathanh@nvidia.com>, "Gerd Hoffmann"
 <kraxel@redhat.com>, "Dmitry Osipenko" <dmitry.osipenko@collabora.com>,
 "Zack Rusin" <zack.rusin@broadcom.com>, "Matthew Brost"
 <matthew.brost@intel.com>, "Thomas Hellstrom"
 <thomas.hellstrom@linux.intel.com>, "Oleksandr Andrushchenko"
 <oleksandr_andrushchenko@epam.com>, "Helge Deller" <deller@gmx.de>,
 "Benjamin LaHaise" <bcrl@kvack.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Muchun Song" <muchun.song@linux.dev>, "Oscar Salvador"
 <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
 "Nico Pache" <npache@redhat.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Hugh Dickins" <hughd@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Kees Cook"
 <kees@kernel.org>, "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai"
 <tiwai@suse.com>, <linux-mips@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
 <dri-devel@lists.freedesktop.org>, <etnaviv@lists.freedesktop.org>,
 <linux-arm-kernel@lists.infradead.org>,
 <linux-samsung-soc@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
 <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
 <nouveau@lists.freedesktop.org>, <linux-rockchip@lists.infradead.org>,
 <linux-tegra@vger.kernel.org>, <virtualization@lists.linux.dev>,
 <intel-xe@lists.freedesktop.org>, <xen-devel@lists.xenproject.org>,
 <linux-fbdev@vger.kernel.org>, <linux-aio@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-sound@vger.kernel.org>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <cover.1782760670.git.ljs@kernel.org>
 <3bb8bdc4788230c33102166d56cbc5abfad9d4cb.1782760670.git.ljs@kernel.org>
In-Reply-To: <3bb8bdc4788230c33102166d56cbc5abfad9d4cb.1782760670.git.ljs@kernel.org>
X-ClientProxiedBy: DS7PR03CA0225.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB8778:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d82f526-25a1-487f-f722-08dedc99c8a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10070799003|11063799006|4143699003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IJg6EdRPZd9WVhujhgKnpJbCHuanEdRyEYJF1H/xR2IHNf4l16FKVIz74HfuoPctZTTfQSnfqG6NPQ++2PeSpebhCKhQRv+JRvBHJk5mdG0k9mYrctd0PPrQksvnJL75lKRzA7lc5xX5fuvCHXP0BN42CFzdSzbq1sgz8k7zet65CVVALweguWZP1V1pHN7JOEaY95FaGbkUD42nFTISX3PKBMyu9R+EdMImtjqn/nF50ILLPajW+5NxPVUdHxVdVtQoz0twBmrQXO0y30cmwh1RR0ls3/ojVSnrh1dgaoa8X+TtrWmwFQ5jYR5L702/JkC5lvexOIHam8V1zjUVZdRpL+dUNuJbEEjz88KTAF6bVIU5RNqCYfIW46t4BvWyPopNp0MtIYE4WYGymFz69uG/bwuSNcABIyUrOSEx+H9QM03TN86PpEVh5N0sseX9Hx9Tlu+ZI8RySDwyqLCPHP6TVCjx7wF/m2acj+8sMKDafToLdnE7bq17YmQKwf83DJlYp5N9SqQ8QsR6Tpb0TUNhLsjPESr1mLSqyrPNCzyrYBTMpv+nD1XO4HWnoUrznAlFcflPdhKTWK3hWVSA6ykBoS/HMAAC//awczhM706YzLgU27Ep9YUxhatBS60GijbURnHgECNTDXPsKIIrRRldoQdyz0vWOeSy63vByYk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10070799003)(11063799006)(4143699003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek5CR0JZK0h1R2ZwMjFselVxakFaTUxTVUFmb09RbTYyeVFqdnpBRFQzam84?=
 =?utf-8?B?TEk3N3krL0R1dUlqUWFZSlcwbC9aWDVwb21EVW1vdmJlNDRiREVjN1J3WHlQ?=
 =?utf-8?B?QnFHcFE5aVBxZkU3QkRmaGs4YnhSVDN1VkpiYlA4WTVFM05Zc2FuRW9WcTJh?=
 =?utf-8?B?QzFVRUlqVEhWUDByeTNtd2FNQzFReGtTcW5FdGg3bGY1ZnhUMmhqQ2hMMmJp?=
 =?utf-8?B?c1prZFRJR0FORlNhV3pJNWhQaVF5K044dWFCdFYveWdaWW5tYUFNYXR4WTNu?=
 =?utf-8?B?UlFMdHYvc28zajh5ZTc0Um1qR29MNlZrTXpteW1JWHVkMWFoMUxuay9keG4z?=
 =?utf-8?B?dEZSS1Z4ZFh2bVFFM0M0Zk5WbGZsc1JJamZ6c2ZILzF1bndLOVd0bkQ2WXNu?=
 =?utf-8?B?eFdEbXJ6N0hiTnNXbVdBRlJVeUYwK0lSL0VuSU1GamU3Z3NoQWZZNkFyNUFr?=
 =?utf-8?B?Tm5XQzA3WlVIeWkvRmdtUlduTG16QWpFRTkxOXl1Q3RsWWdpTVp5bGlrRXZD?=
 =?utf-8?B?VDlRVkowNUxkdytMUzc1aVlLeFphUVN4ZkwzNTJQNUJrQkJqbktiZDIwYVRS?=
 =?utf-8?B?dWx2NnIwNzhTcG94OXdsRjRFZXRiK3BFVVlQTnRSYjVzUndtN09Ca1VJY1lU?=
 =?utf-8?B?dXpyWlBpUkVxWVZ2c2hwQUxBTTFMMmtqZFlhRWdWZ1RsYytTVWFNdUxDbWtX?=
 =?utf-8?B?emhLRFgrZEF4enovSTVMVzgxZVk4Vm5YRjI2TmtQM003M1c2aUk2YThhVEYz?=
 =?utf-8?B?N0hrbDJEeFQ0dDVKWkJRTTlCTTlsa1RwSmxHTTFieHRnVkpGTFhGMDVFYXRi?=
 =?utf-8?B?ZUs4RDZZaysyRUlnaEt1NUxGVGtEdWdLZjl6ZVRZU2NDQWV6RFZXRUhoaWV3?=
 =?utf-8?B?T2JGRjY1ZGsweDhvVjF3cmIrYzl6SXhHdWFhZllJTmNScE1tRldVNi9lMkV3?=
 =?utf-8?B?Y3JDMkhMTVU3azNSdEo3N2hjNHB6K1NIRS9iR2U4Yy9RcXlXaTMwQTRQN3oy?=
 =?utf-8?B?OE5ESW8vQ29HUnZINWNBUnVZMytqUWx3VzJ3Uk5LeUNhYXNJZWV6SGlBNVov?=
 =?utf-8?B?Y1VVNXhBNlVRTFBzUWU0OG5DTlBSNS94MTdVMmRSUVdhWG9OQjIrYVgzQ1ZY?=
 =?utf-8?B?eDZhTzNNTmhBc251NVlXTDdCMjZQbEJUNUJCQlJmb0NJMnRSNi9ndVk0aHoy?=
 =?utf-8?B?YTYweEdlL2lYZkpWYmxESk1sd3pzeUZDOXNyMDlUT3ByUTBpY1hYM2VZb3Rk?=
 =?utf-8?B?aUVyNnlSeHFKWHhMYm5nQThwU3VnMUE5emNoN01uUG1kM2gyS0M4WTltN3Bk?=
 =?utf-8?B?dWhUVE56RWpzenM4ZXh0c2kyVGNiQ3JJZStOWTVPOGhjTW9MYXpBTnEydjZK?=
 =?utf-8?B?WTlWcGphS3NLOG5oNFo4Z3lDalNxNk43R2R4d2VVWlJVd1pOTVpLRWk4TUpM?=
 =?utf-8?B?dGpWR29CUjBrYzNNK01VdGNiSkZaKzhoVi9tb3JPWmptY1k2bU9tNUZ6U0s2?=
 =?utf-8?B?dGM1SVRzb28vTzFoanhzTndLRnVFQWhLWVh5SWhhY1djS1Z0THRSaHh4VU1C?=
 =?utf-8?B?MC9xeWVzRktiZklCd0dHSERod21hZmZzNmtsMUo0WklZTVM3blhVN09MUnZG?=
 =?utf-8?B?ZFJJaS84RVdYeS9BV200dTdGWGlrS2JyZWh2WUYzR090QTBLc0FzczFJN3lO?=
 =?utf-8?B?THpseE5BczFIYkZrRWdiQUZYb0pmQkZwTHRXVUlodXlicEE5T1ZZRVpHUXZv?=
 =?utf-8?B?RVJXTW9tTFBmYlZZdEVqN3dxcHppY1Z2YzNOaWVmYWk4RmQvVjBFY2tObE9L?=
 =?utf-8?B?SzZNeE1hWitXWEFyQzF1QktWVmJ3RW5oYWdEWlNuUzRrNmlJVFF4MXE4cmNW?=
 =?utf-8?B?UU5icGxkeEd5QlhteGFwNHNibGdjakxxN3VWZHdTaDdZc1pOa3JMYWRCTmdo?=
 =?utf-8?B?aGhLRTd5VW5McWZNYlk0SmFPMDgxVTEvZmpvNTBnQUY2UkJYMXJndWMzdjl3?=
 =?utf-8?B?RzZRTE0yNmxwWEU4d2FQSmtKdzhPU2JnUlBOS0FlVWxJMnlCaVFXbHhRN0J0?=
 =?utf-8?B?TzBlNWlyeHdZN2NLeTRWQ2Z5VmxuSGdqOWl5b3pKam82WFNEZFM3aXRUeVNV?=
 =?utf-8?B?OUxPc0phYW45OFRNeDM5RFU0bVIzVFBLOE1EektZWFNqdTNIL1haVnVOQU16?=
 =?utf-8?B?QkFyRnFnTms0USs5aHVlUXE5SnhzNWVrNndNcFV2RGhFN2pFdzk0WXR6NzFk?=
 =?utf-8?B?M2g5QXIvTVdrbTgwTWR3OHp4MTBSMTI2QU5tMzRmNGQ0bVI2RUFIbmsyR2sz?=
 =?utf-8?B?Sm4xaUFwbE1ES3VyaXpiYlNCWnRYTlB4aytRU0owd0o1TCtTQWk2WGVka2FS?=
 =?utf-8?Q?LvwN1dCgX2BEQ5HTa+droSbfjCAPGhBcCpwLn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d82f526-25a1-487f-f722-08dedc99c8a7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 02:36:58.9074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WjtQ2+h3pQ1C67hYZ/v+qccBEc8nzPfsA30B/zApM/vuVLU11R9L28Lb6VkAqY3Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8778
X-Stat-Signature: 8msb7o5ezkk9x5ikjkgabsjta4mq5kgx
X-Rspamd-Queue-Id: 5AEDB100006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783478226-166416
X-HE-Meta: U2FsdGVkX19vOi+6t8Vp9sxY9dXg+rLVN/pTlsqTGWblylxsV2upOCj0OdCiAp3lJCz6uG6gbC+FRi+U/7fMu0krGoL/SHoN2UX0TQfYVgj3YSuGhxOxOAaxR7oP96duO8sX1290WASkwenDUkBuI1MY7n8yUVM55ZACp4iAa6i4lN+IqMATJZncLBWrRt5yA0rYFu8ClHeNO6Qr3VdnMivvwGZhhqruraQxcaSgsZhBGrfz2QOsTBkCL3utav6bL+Xr9AoDfsqiH/9VRPi9Qh+1iWZfzZa2DbVNyA5i3VREjpPmHytN5ErPwBRBpTpVdB4p9AniQUc21CnUQmDT8Zt9EXdObcrUHBwtArTrBswQtZj4OyKOO+ef+lyIT33OTSTxKsb93MgmohEs+bRNE+11jAU0kaDooOtZDrvuR7A7Ti6lpUd9PKu00WazIWDpzsGVlP9z4hXLitXRAXFAs4Ngg+kc4reTEwm3sv7NHOClxRkvinY9wQUpOGSGvvCHCNmaociLlZrdsTov8Bb1R+EVgAjTmqOTsbL30P1Vyl2lmfNjdAjhAKy4u+HQS6leQd8h/7TZ9mGhQR2BIhC0K/icf6FPtA/OmXzJgJjFEMAiLOChWg1jqF/hgyyKhnA7N9Pi93lbjbDqEwhN8raLoW6G1/qCIRR7ePHg1QK81KKnora79V1JSSmZkSuO7E2ysHKca50K9YG0eiaD0va+uZd7UEjXTh1YpB3CpgFr4ql6ctbF3Q+iu/+I03+E4eitbwMAz6PCFwDjciJysYFNhIpH8Nru6qJ8ofFJxJEYno/Dkkl7PXHw3wXaiFnvURmmp50SnfI0bB4sOzwwSmSCO/v8Y2GxuUlGsm1pVa5CID6+hP6Kcr7a1yIDpk1A7+cUfIVMFiH+k5FYXCS94/ssYmME8fQQEYNB65iT4WuGOrWNZTR5pbmQj4O1H60SU9D72/fo84n4/AAXqI8jNIz
 TTx2V60o
 ShqCvd8QA+qOnIlYVLgOlVffX/vkPsknZZOEMCOMaUzS9/Wa9oimstKbQ0yEW7FSyuSd/6Q5A3DGAC7Z6hKvG5bal3FKKckkM+NJRk8p5CAAossRA00KSPYLCL/ju4z699F6nrnH8OqHmBADNAv8UyH7RqjSAAd596dTM8lZt/J9pIxE2RfQNSymb7JLROvGvShTnEuhKxlMgEf/+5tPi9MpNVwRjLSzcRm8UMl4FiHdDYsWsxgor+Z0+ot0rxAEBHGiWuVTPchON5fQUwPGAf9++Ns6DIgVkzNNEyiMGipd/k1lCuJehKfO6ouv9+Nry70sKsyc92fIDLZj8Q+UHwVZogZ/fem2989fM5X2L6bSLKn9MUd3ofmiVep+FBlcG9hNGormKP1Rp8Mjj47uQhGpQYLw/cuLbHzxnLvonhdnmeHhy6Bcq5UAybVV7ftSgpmanWvEu4rth5Z63Vl6SzWzpwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> There's a large number of vm_get_page_prot(vma->vm_flags) invocations. Ma=
ke
> life easier by introducing vma_get_page_prot() parameterised by the VMA.
>
> This also makes converting vm_get_page_prot() to vma_flags_t easier.
>
> Also update the userland VMA tests to reflect the change.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  drivers/gpu/drm/drm_gem.c                   |  2 +-
>  drivers/gpu/drm/drm_gem_dma_helper.c        |  2 +-
>  drivers/gpu/drm/drm_gem_shmem_helper.c      |  2 +-
>  drivers/gpu/drm/etnaviv/etnaviv_gem.c       |  2 +-
>  drivers/gpu/drm/exynos/exynos_drm_gem.c     |  6 +++---
>  drivers/gpu/drm/i915/gem/i915_gem_mman.c    | 12 ++++++------
>  drivers/gpu/drm/msm/msm_gem.c               |  2 +-
>  drivers/gpu/drm/nouveau/nouveau_gem.c       |  2 +-
>  drivers/gpu/drm/omapdrm/omap_fbdev.c        |  2 +-
>  drivers/gpu/drm/omapdrm/omap_gem.c          |  6 +++---
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c |  2 +-
>  drivers/gpu/drm/tegra/gem.c                 |  2 +-
>  drivers/gpu/drm/virtio/virtgpu_vram.c       |  2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c  |  2 +-
>  drivers/gpu/drm/xe/xe_device.c              |  2 +-
>  drivers/gpu/drm/xe/xe_mmio_gem.c            |  2 +-
>  drivers/gpu/drm/xen/xen_drm_front_gem.c     |  2 +-
>  drivers/video/fbdev/core/fb_io_fops.c       |  2 +-
>  include/linux/mm.h                          | 10 +++++++++-
>  mm/vma.c                                    |  2 +-
>  mm/vma_exec.c                               |  2 +-
>  sound/core/memalloc.c                       |  2 +-
>  tools/testing/vma/include/dup.h             |  4 ++++
>  23 files changed, 43 insertions(+), 31 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


