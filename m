Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B30C6D66B80
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 18:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ECD26B0092; Wed, 17 Dec 2025 13:10:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179856B0093; Wed, 17 Dec 2025 13:10:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023716B0095; Wed, 17 Dec 2025 13:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E77CD6B0092
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:10:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C66A60D5A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:10:40 +0000 (UTC)
X-FDA: 84229753440.30.A599C35
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9DD8480019
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:10:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oyrYMwIB;
	spf=pass (imf02.hostedemail.com: domain of ankita@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765995037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmjOY8YZbZbWQ9GMKtdXdPlPz3rK6FGqYrMeiUdhqw8=;
	b=QqGIL0HPBpIN/hDOAz7wGQWAGbvvIjx6LkEevnwksOYZ7/5zoPqQ7VKJ8rZcj18KfMnlao
	Kj+Wfk2YrxTrIOXcRWS+s6taKhkfDnESAvOWPw4BlzK3v3gYeMbmb7vGvji0rrdsLPKCq2
	GmFozQngTphLMkXU3RHvXqFEq9E8JfI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oyrYMwIB;
	spf=pass (imf02.hostedemail.com: domain of ankita@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765995037; a=rsa-sha256;
	cv=pass;
	b=nxM3WYu9zlOmLnFBtyG8AaQGZ0GDTQPBTZjKsi49zv83Eke7FZAWp12d6V3F+uC/lxnUKP
	Sc4D7P6J5to77vQ7OgU3hBxsPGUZ3/npyRQvw8ps7WvohrK3qgy0ct55Brjkb4G5rUGhEw
	nYxA49liKWenTRpjdJfbix6Ju59AvXY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AF9H4Mv4C5yYvY4HXdX7j980smUKnOBUIkVI9jFf5xB94VmdQFUsKlMJNI3g6m3v1d1136LmTOpd8Q67lXX7baWJe6gF8nKwharXvxPaAEa1RSW3R9lDdGAqLe3C50BtaGci359YQtGqpAcPBnlzR7oIVr4pU+SrTYzgX++BYXOScqvooSZpW4zHFGSUzDx9wSHXU+mimWlyGw7HnOQSnQJFC4fUC2xM99gMCDzFhHiH/AWxQ3ICD/JsyPMCwMKZfJCdZKEgHCBlNjz8dphA17Kdy4THeCAEDMUY4MmGVXvdLX1T/jSTQdzbfxkIJKKeHYNoRUTJ277LQk5BxHgfDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmjOY8YZbZbWQ9GMKtdXdPlPz3rK6FGqYrMeiUdhqw8=;
 b=A8Fv7A0XYvkFngnrpMoRduUlrmIJPTl6iEaIqrqZfziN8iNxRnFp5phcdGMFcE1v6b7TNruo1x0QBoaxXWhQJbaZu7Lv0rbWUKS6ih3dVppn2IhMEJ1l2yIAUCxNVWoHPqRUruPd2vkikLhk/2wl27l4aZH3lxDNpHcO6T3PENBOKLCV2b0l3B98bGbM4YkNnkTQgKsyU/14HV3Io+RocwUVAwa3if3xklCuZpky/rDVvsY+h7zF9Seoij8Lki3C8HnPE2IMAp3yDQAmDzvEr61MtGl7ZGJuJ3tSktROUHyZHOXmJ4t9gi7tArM/d7biW/zIurzvaVtXKECTz1MQ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmjOY8YZbZbWQ9GMKtdXdPlPz3rK6FGqYrMeiUdhqw8=;
 b=oyrYMwIBDItEVdTKp+omXEtMZcIEwl1YiAmD/4ndoWlGXYKxKHYOvZtVJ4ftwalejhDJcTxefdN++iqmAwOI83AdRvTfluM6NS2hTrDnAzqmSlppjn9ZG0MCGO+q3/fuLOqdM0tXBng1H6YETjqUoJ3Esr8ab22IVO/zofX7taDLkFZiWTQdhaPRVpptMn5qn8r7bRGfJJ3bh2qtIuYWYCvaZOWqXn1nRHKwZCjp09Yf95Gi+tZ5/iiyh9WXeyvmC+bhghmXr1ykfQ1CgxYPRv8qHoP928SF4DT0A8ZIFyHGcdQra0ZPNYc6FlLgul+YJfrxEWoC+8qT4Kb06w4mjw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB7934.namprd12.prod.outlook.com (2603:10b6:806:346::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 18:10:34 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9412.011; Wed, 17 Dec 2025
 18:10:34 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Miaohe Lin <linmiaohe@huawei.com>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, Shameer Kolothum <skolothumtho@nvidia.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>
Subject: Re: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use
 pgoff
Thread-Topic: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use
 pgoff
Thread-Index: AQHca+uU78WraO9/5EOAmO3/L1n94LUlLXGAgAD5j7Y=
Date: Wed, 17 Dec 2025 18:10:34 +0000
Message-ID:
 <SA1PR12MB7199065CD785B5FD0BFE6FB9B0ABA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
 <20251213044708.3610-2-ankita@nvidia.com>
 <f871d90d-11e0-1719-c946-1c0bf341042a@huawei.com>
In-Reply-To: <f871d90d-11e0-1719-c946-1c0bf341042a@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB7934:EE_
x-ms-office365-filtering-correlation-id: 14b4d720-0a22-4b04-321d-08de3d9792eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?5CU3YVifES8PK01TdzXZz90Uz/wG1dpGfhanHjmGwg/RXOUxsLh046AQZC?=
 =?iso-8859-1?Q?0C5iG/uOxzfvlF5x1PgWPxIVK229Xp+qe5eC93yUj0P7eJRIUSzjqnWp2d?=
 =?iso-8859-1?Q?oUGMv1eo3n1EEdn8e+bxdvZTwFWwSyDzGjTDbois7Eav8RVbDd0xUR4vg1?=
 =?iso-8859-1?Q?Xpdcs2s4QlNMaaOOX6RytTj4hJc4asqdDxdxqWmoMi+6iMoMifYQ2DwTB+?=
 =?iso-8859-1?Q?gDYSmFPF5oLIgqARGskGSVrXJexxzfVzxxnyiv7Ho5FElroo7qFwIsePot?=
 =?iso-8859-1?Q?4DVCHAUqb7GvKNR1Mcwde6SJTAioGkGIVMlAWHGOvJ8fOBrjWlvKJw5dLa?=
 =?iso-8859-1?Q?wPrKbwCM4bLk1WJLUkw5oAI4MMhAsDZlOvAVp7Z5QcyDA6xl9jbltz/wKP?=
 =?iso-8859-1?Q?nQMSJcluTsbxYAudZffU2FCoXJyoBasSNPiIxhhpxZKJkKZtNzCz+V7FeI?=
 =?iso-8859-1?Q?m7kFEj4ToTkkiAOsqES6CRON/igBfcZ7mkeiV4kgangnePOUHPZLvMtQqG?=
 =?iso-8859-1?Q?BlU/wS2zpmIyogLOjMuGcrXQYE/WFMFe76mRpCnfqB9PTGcDgtmDE0PNVK?=
 =?iso-8859-1?Q?QZ1m3ez/YMLL78ve1nuJWrYlZqCNZLGphfsQ3cQI4jcQ/Hdl0CIedHczI0?=
 =?iso-8859-1?Q?pszRfZOlHTt+bdNw/F81k+GgD3tBrj+p2rITbOAaOgXVpUVgsIT/PlKp3c?=
 =?iso-8859-1?Q?IU4HR17XLTjZsBsQTqqzmidoU5UL3Bvek1qDlt6FeflZDPRxy1122OZUoz?=
 =?iso-8859-1?Q?2kn0EOygT8b+lhhLnz/GfW2TTLdmX2+ephERG9vqmLIOsfqvwegLVP58tL?=
 =?iso-8859-1?Q?MhixaY7ptB7hjr3hDOCttqgGzxr9rLRcTgfBMtfq417PNR6XoUwiQlmkAG?=
 =?iso-8859-1?Q?67tdMyxW7XVZ+hxT991LhOu2lFLBEHk1Ru4Y62mmXc5Qopzk1svzqKOUd3?=
 =?iso-8859-1?Q?ryP56c4TcF0pVGhpWUEkQ5wIpaS4dJoFOU0iV/d4DJ8lQ9wrV0wCuFQLdo?=
 =?iso-8859-1?Q?hQub3HUfrD/3BYTl42FYzeLpClwuwclFYa85VzHO5PDsYGVWPRDScmM0FK?=
 =?iso-8859-1?Q?5R/SlJ0sCIjVJpCrZVo9L6n5JerOlBSzWcojFTb/PLL/mJjFDYCQ9hctW6?=
 =?iso-8859-1?Q?PYrVXV+pYpYX+iCOZ4SziOQgeJo0aaK43p9TjrCV+Fgn7AlAeFFRJZG2rQ?=
 =?iso-8859-1?Q?QK0Y7ZkOno0Z7EcMAzCraWvDdAK7adJJxJ26c+6kt02BYKycOwTHjjJcBf?=
 =?iso-8859-1?Q?uBlG2LUuuKaq2kzOqKrUE0hFf7eWbvcdNPfaEqIS1Yj0s4rqC+/7lzVlSr?=
 =?iso-8859-1?Q?vGhHGLDU1aC3Q01Sr3nnXNjU06MV8zGAbd2eRNRv1lpkNbEPewERk/kAvU?=
 =?iso-8859-1?Q?wzHl34eN66UoDdrlF/FRgzaT6im9hoa90N+LpMyA6AGtHJ3sLQtiug5u1F?=
 =?iso-8859-1?Q?3pab/bUlToPCvQYhv6jzYT3OImEzeTPkWi1rTk0jirkRfpnr42GSFrLROt?=
 =?iso-8859-1?Q?4YQQwrcziF0J8YXr+dogLR4zGoYnMtBk4D45smT8U46IHr8ytPBAUdN/1v?=
 =?iso-8859-1?Q?AWaEvs0boDE3lG4X/6d1NRe5RpzX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?8skR0hDqJc8nwYANzixzHKCb4F2kgyftYJJgWLqS/m62jWjiPLGyuch10Q?=
 =?iso-8859-1?Q?wME55kcMovxOq/Xo7ifXZ/xp/KljHqpnmOJUyCZQBW8Ws99yf4TzK+cJH3?=
 =?iso-8859-1?Q?UK7c1qyxO5sm2qgNO5Ns2sbbzMWerl/Ycksg2oohUpynw9sOMktPQODMnV?=
 =?iso-8859-1?Q?OjioEIFudIZt44dDjD62bIEn75WSPvFMhY9dsoXCqEHkE6atVDAKFaYM7d?=
 =?iso-8859-1?Q?H20s1FvvWnQrAMPp3lK3suQEHQelSFrEO5kuEsm4szBQVprzOYokFMKzTV?=
 =?iso-8859-1?Q?Jzca3tnxPWr0FraxRcNmn1Jn1WLEKZfkRymiHjsMYA6uM9qIVJmP9jpYff?=
 =?iso-8859-1?Q?8g7FGNNEsjY35SZzKtBHIoA4nUHxpxOBJJkHvOftwbcDCt74iD4b5t22dD?=
 =?iso-8859-1?Q?5+G72XWMlaZ5HQiwX8f6mEq9zPdW2igfEhBT9xScPwSEvNOkqlSFhbsT8U?=
 =?iso-8859-1?Q?WHo2sQ8fFHeGCv+5dk4/WAHZj5I4CCimU2G4RRKtEgpNXxJlItUM/uVLAh?=
 =?iso-8859-1?Q?0+Tq2WXAEqtFiVwZVYo0Am16U4nD2uiBNXsyRyJmRGr6dGSCb78VHl7reV?=
 =?iso-8859-1?Q?v/tzI3gKnVZdVYXwJa+9KtHbeKzUpRkaDGK4ocHufJEAQu+hM9hdXZpetm?=
 =?iso-8859-1?Q?+uJ0Hl9ttpmefEXTkTjeG1IOUZlebEksUXTzhKWA+0+v6d+CdmVmcK3IO8?=
 =?iso-8859-1?Q?LvzlgEJzhPV3jNUnkvM47kleUdY6gPpQszUJsBxtSpBjyglfsGywfnqM8y?=
 =?iso-8859-1?Q?UiI6628+HW1kglSQz16Ta+clB4Lcn+LcRDHyK5pTwHX01ZcuJqLXBBhmai?=
 =?iso-8859-1?Q?NOBqjzb54vRfaN6cj9b0Bd1jyFnMeCTtKL2eUXn49YfT8z4n+mthymRdE4?=
 =?iso-8859-1?Q?F9pRNmVSSKoESc5xd6HiukhgIWZP0/cJzNAuoDNU1mwXjKAr88C8m9hHg1?=
 =?iso-8859-1?Q?z2CxnGksg8XXOCcKMhvihpkxwmTH5wbSGuKbToxlHwzfAr0PbBqfyVww9n?=
 =?iso-8859-1?Q?tvzi5KdRN1HPOwgIym7GpTwyD422iQaHWL8k9K2r936eSMTwl1wJW4zW+w?=
 =?iso-8859-1?Q?CwEmpr8VNe8iuDgRVALNmp4QmZ7gmDfaH5Wjz0Dl3xltPDeSwVAHMFdA7X?=
 =?iso-8859-1?Q?rLqwuLqRy3JejFzLc23fITcb1v4/ccsbaCRYVnLTGoeO781RkJJSkN3zHd?=
 =?iso-8859-1?Q?sitHzyLMgZ9W/GI6+8luwAPHy6owh8xlon/D+SZkgC19xNzPJ9RdMzqm7T?=
 =?iso-8859-1?Q?pVUPWTCdfiJrVCuiMKQfnwfAaPQqILGt1pul/WDIvpaq2vkjgFzql2TztG?=
 =?iso-8859-1?Q?PPynC1Wz3hstVt6lROnZygU9ViLanjKaKETN+ni+qpuSiIU/08sGDP78tm?=
 =?iso-8859-1?Q?zK4lpDVL3RJqE895cwh0EoPaxyYXNLIF/zA0WhJt9/qYqvoLsaTFP+W/Xl?=
 =?iso-8859-1?Q?CRSJWU5Lcs7zCSUH73tH77WY2ebBVzwengvyGsWNpTx/Tns0FQsLptriv5?=
 =?iso-8859-1?Q?A+geYovN26m64KEsAcJ8lo7TsrzqzSsVi7O0XDg8R33AyCrxCfm8ZF/g0z?=
 =?iso-8859-1?Q?xf9B1B0ka3ikUGJ9ATXGscFNdVvA0EUpPFTr9gFB1Dij66UIWEYo8uxM9U?=
 =?iso-8859-1?Q?CG9XH9Viu3dmk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b4d720-0a22-4b04-321d-08de3d9792eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 18:10:34.7369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rhAyYvEM/UW7hsw02rGD2neCJllsJEfMhMaGrSepYSWdZDhRikGMFhY8NrJtOmZzVBjIP7r580nvGukawvnBLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7934
X-Stat-Signature: wst3yzzjrfnpzx7g1k4rdy5dxnnboiz4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9DD8480019
X-HE-Tag: 1765995037-812865
X-HE-Meta: U2FsdGVkX18DzbWssVR8D75MkLNFfzHp0oHP1TyJFpYz/xd7JZBvfgDoYZp8TMsbELTdeWs9GAuFFQOx3SsC9EIV8SbHuUpiCVUPZsqTTSg6A5Hni/z4235/WijNuotsO2FpWRCsC5t364N5/fTiN40IoMPAdxeM1lZmdc4vzhxpniBw0/6BFT/Xsy+CCJHvptAjonkUwDgvc87eRLfEWH6KQfwJwBDVxdBnI3vlq6tpwL8hkcfs+/Ojfh83tI44UEhXqTreWOGQpGAj/kU1ed8w0r7VbohY6556QXgJPAZOt/reZLVFxrlTxr9JWwm4u0/734qSznjTCTNa91HVGgzX/2FRir9RPSi3KJHFXnNPoP9ZZI1AjCXJjrD35QqSWHTKOGj3pMZk0sdLVHsvrcBSIsLipD51E1IKvsT4OESySkgJIfK3vCMmCD/Jy+bKiWzkqQ9nybNbfI5FhKquMR+/WVn22BBgDtKTysLlnx7GZe6mU/lav+DViXznmzmxZ7kkOJNI0E5iHGTdimsokDwWEv0+LLIJ4h/XcOADZePzpUxGrH1bDksvkHnknc6lWpVDt00i9aMxwTD0TvCUStQUQdCWhqbSdr5gUD0UbPdmucpfEJGwLdWsyWmXnI+xwahgyN4u9e1E9PSfqlB5qCq6Mcc6h9DEPzF4gWSTf8bfBVUyB8u9nm2xjUFFCZeJOXuChYf2Qp2+RWhHLjS10/wsyTsOg1LUrLcNBoZTcIY7ExaK+aUN7on4X/xV/zOsOD18ACOVbGyx/jd7ppgjpIuYvrrHzIljKfF5fYfRrN3x6z7LcOXVFZ2u1PpXq0abGIS8erEQ+KZiVMWRUdQugORiAx3W60q6DEH01k3iI6R+Dw2Q8uLINQsUV2dQDffHv5Rc80hSjYbrKt+t4NfaEkXv9lCWxILemXUWA2pU8FsLJZkPcnJZaBwKRpf/FjdmhyiqaYHkhy4a/nQmS+G
 DKleEeD6
 sAXgETRLUltudQPCDe6cQxHz2Uy62NO4BB2FRbNzn3yShJTXHUiehzeazwrcIKBxaIRiaTMT3chLUuDXqFPBdOCDyH5ztZiURxsPvhNlJuYXmbMD3E2ndblNKU0ynfsCxZxAO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>=A0=A0=A0=A0=A0=A0 i_mmap_lock_read(mapping);=0A=
>>=A0=A0=A0=A0=A0=A0 rcu_read_lock();=0A=
>> @@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct address_spac=
e *mapping,=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 t =3D task_early_kill(tsk, tru=
e);=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!t)=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 contin=
ue;=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vma_interval_tree_foreach(vma, &ma=
pping->i_mmap, pfn, pfn) {=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (vma->v=
m_mm =3D=3D t->mm)=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 add_to_kill_pfn(t, vma, to_kill, pfn);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vma_interval_tree_foreach(vma, &ma=
pping->i_mmap, 0, ULONG_MAX) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pgoff_t pg=
off;=0A=
>=0A=
> IIUC, all vma will be traversed to find the final pgoff. This might not b=
e a good idea=0A=
> because rcu lock is held and this traversal might take a really long time=
. Or am I miss=0A=
> something?=0A=
=0A=
Hi Miaohe, the VMAs on the registered address space will be checked. For th=
e nvgrace-gpu=0A=
user of this API in 3/3, there are only 3 VMAs on the registered address sp=
ace (that are=0A=
associated with the vfio file).=0A=

