Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43BAECFD377
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F36E6B002C; Tue, 25 Nov 2025 05:25:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4386B008C; Tue, 25 Nov 2025 05:25:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C3C6B0095; Tue, 25 Nov 2025 05:25:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70A5E6B002C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:25:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DC594FE1B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:25:04 +0000 (UTC)
X-FDA: 84148746528.05.9BD3775
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012056.outbound.protection.outlook.com [52.101.43.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4EEFA100004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:25:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KRNjLgGa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of skolothumtho@nvidia.com designates 52.101.43.56 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764066301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvo+L6GsQw6A3dlQtoUSr/FBaYg9NLLo9L4n7Gan7qk=;
	b=pX2lK5H4LDM1aHW+bQzcF2Kmyv/Gzlv/PriJS6P6UskCnKwSAPmn7UwfDHjSnzT9DWxxqh
	NhCJNtzEirowRTu0xMIse38z5QaPyS++BXehrdCQHibOvfKxjBmqIeXxrn2EBhp+7POq+l
	UEi7w2OT11/Tc5xv0rGvDlm9B6rS9/o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764066301; a=rsa-sha256;
	cv=pass;
	b=DlSQ0lqkzmuAwJ93vr5RFVb2+pbjGk6jKlnRTa8q13GlUuCDG292yDUp15yYJSGZ7vPRnG
	0Hswhs11gq+Teahk6F0TlVSNDYBbergrxYZqUg+mLihJdvVUviV/58kvyq067GJKZ4CmeN
	6mpfmZvaOymGkiOQqm7bYueZiBi5XyY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KRNjLgGa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of skolothumtho@nvidia.com designates 52.101.43.56 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lv6rSqsh0VXxgbB93Wq3sqP93hJFYufzQbZiwDakDsfkjUNWSjYJ3Xxie0C2GkchH1Z4aURP28DlB+SVogslGCMlqdQL31THns9aZXkJHU+WVRcQM2CahrXZD8YBQKSpNmJXEtzz2lIZjhAuBAdygylNAaw2MjsmD7AEA4L6HsevRsm/LcrDqPNR+QLt7O/eUB02en7Pb/n/FibRMIFrLWoy4bWZV5/EkjuXgt0+2Pp28dMo+bWGn07XWdeHEW01HThPtqvUBFcpJPvoQ3hz+001QWZ2MeJryUbR64p50di8Myu5Z08sIgCyp5GWU13tTJsM2vKwgOx9TAzgPAf3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvo+L6GsQw6A3dlQtoUSr/FBaYg9NLLo9L4n7Gan7qk=;
 b=CVS/EZiwZuYRoxhmkTGVqIg3I0jmg0qYaq6cNKAoAZHExa7NPHBUah6lbFYgLhnnPb/USj2HvAheKg3SsBXtLd/Mjxg4mX7gdZn5Feu8H7vN2sfoFvEpDrZxQl1ZJwg9u2cwP4Hor5A9DuJmLk+1/17x2MiKhUgUEXGMdeABc9NRkBXoh3ryIHqTYjPfh72rLJn4keOUmHLDdqzIXD6VwnLElASqRgn9lVgAgtQ/A8YYkv76/el/Dx/xlhTpZ6jOAaNoECogrc13c4nMlZ0zxvHJ7SZbBwNEwRv+rMudwMIV0exdBNZmgKGxosHc6uXpzJenDNwPHNjHJxlW+sWx2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvo+L6GsQw6A3dlQtoUSr/FBaYg9NLLo9L4n7Gan7qk=;
 b=KRNjLgGao6u8bIDk+3lQ/2KS5XMvfQdiMOpK+KJ1BfOu4ANTv+B50dDmkwxQ4Zw1WLkwJu8drJbwaADuF3q/XoXiM4fN8DUeDMtiIkan309xM2eKpLK5Qi4BlRsQJJGuD+uzgu/x7Qwr0laprd8+VVS5zdZ5HHRh3odd2+JbmsuNEUujuQQI78qOwDc6Hcz5mznYT47d7Fg2NXIIR84mRu2cUVVGD9rzNUJPjAAip5zj2JaNv/Q2sx89WcVX9Q2NOCBFGIcaswA8w4Q8Og0TCRI8xUTxmHAj97sT6HnB7j+sMU0f8Yd1k26iQfCWHRJqIE+oiu/hcdtbysVVa5pl3g==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by PH7PR12MB5877.namprd12.prod.outlook.com (2603:10b6:510:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 10:24:57 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 10:24:57 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Oscar Salvador <osalvador@suse.de>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "vivek.kasireddy@intel.com"
	<vivek.kasireddy@intel.com>, Jason Gunthorpe <jgg@nvidia.com>, Nicolin Chen
	<nicolinc@nvidia.com>, Nathan Chen <nathanc@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>
Subject: RE: [PATCH] mm/hugetlb: Fix incorrect error return from
 hugetlb_reserve_pages()
Thread-Topic: [PATCH] mm/hugetlb: Fix incorrect error return from
 hugetlb_reserve_pages()
Thread-Index: AQHcXe6SKInT3bUUjUO7F0yg/LEZTLUDLwtg
Date: Tue, 25 Nov 2025 10:24:57 +0000
Message-ID:
 <CH3PR12MB7548F6A324255D1100E01940ABD1A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251022102956.245736-1-skolothumtho@nvidia.com>
 <aSV371RAc5mrR84c@localhost.localdomain>
In-Reply-To: <aSV371RAc5mrR84c@localhost.localdomain>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|PH7PR12MB5877:EE_
x-ms-office365-filtering-correlation-id: 689f1730-cfd4-4131-4e88-08de2c0ce1c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?HT+/zbilCiy98h9vMjqPzn5tio+HW4fn7brEj+kKQwF02H/Nru6Q+g3t9ZKe?=
 =?us-ascii?Q?+YD9edMeJxhACndTV1hJ+QGCBfdpnbh7OGrNgydhb5Kgu6pE6d0noyETeDiP?=
 =?us-ascii?Q?XodaOi/vLYzblTMZEN/x+3DYKV844eEc9tJBynZupvpLSTXDu9Blo+Z/oMvi?=
 =?us-ascii?Q?VzH8vpq9bt1fImZ1MBB4RHrPlffxr8JWn2YlF9hPwe8NkrelR2HDyN5unqPh?=
 =?us-ascii?Q?RKjc00UEpL8hjdMmjg/BcMJqpGwc2pWwRm2ScG6KL46B2vdMqkjHbGH2NBhs?=
 =?us-ascii?Q?kw993qtJj6W4qF1YbSwiJTY9H0l1mwD8jkRDmeEo209+2UXUlNVeruTQAKEm?=
 =?us-ascii?Q?HaGbDKKLv357NAvEzHtf6maAHGSntfdD7hOPxLQE1A0ivRtG2Z4hCPJouNKz?=
 =?us-ascii?Q?1/iihRGFhxrz2d+TdFuUR8xKxLAVADc5XTn3/WTD9xeZWXQnvc5jgg+3a/rh?=
 =?us-ascii?Q?vlJ7BgKLYw+5sYj56aAfb1XwimKCGhq1kggagTqds/+KKC1RN+9tld+il0Gg?=
 =?us-ascii?Q?/qQ5+jaMzC98woWquS/LCjVO0YOX7eHTHIg0EJxvbHNQaQWw5g/MO8wZ8TCr?=
 =?us-ascii?Q?mVXXM7AS+DJWEXWJpEfQz2ZDa6OX+qE3rgl7utDzA018YRTfqQq56TJOTO5z?=
 =?us-ascii?Q?Oj0KUsumIkJ49J0BZnhP+0fQEY1FGjtBAb5cnG1oQcgzqSKEiHDLQ/X9doLO?=
 =?us-ascii?Q?xyzn50dedjHFt3UoibwiyUWFH4zjt8HZonOcbkB9Q9GL5JeuJ6BaPvjaf8n/?=
 =?us-ascii?Q?3K1hrRVyCoVpDQ/eFEza0Prk4gd99wU64JPh5qTnzGtOyllK8J1nzZoVcVgD?=
 =?us-ascii?Q?NWlkiOUP6TWZ6yPpaeMP5dLV5MTjOd7DxR/DHHMj0+twSmkfe2hVTocUmfKA?=
 =?us-ascii?Q?NOxjFCRAkQ7KEkqxQ8zqj3iMqVpSifPqfU7lVep3AqGS8pTuw+g5UKeoXi3J?=
 =?us-ascii?Q?fzLAmBex5k0t79n7BPx/Fc+r7aEklzYu9WmTyqSBKf0vOaylIqJuFi0n3MxN?=
 =?us-ascii?Q?KbSM2CL1h4MRhChu14G24qka0bl3yndiN2m5qZxCk5T82JKlgEmPbj+rgYL+?=
 =?us-ascii?Q?ZmYB3/MrhOkf6S5G4ferwWyLuhx84NgePc6jbAbR8f5h62/qG+EKTdlMxZCO?=
 =?us-ascii?Q?FnxrHeGNy6oIB4u4PsVIT+MeXBvjCLLqn2l1g1Oh7Y/oPz1zOEWDshNcABnY?=
 =?us-ascii?Q?QZS1F//vrujizEV7aQ5BW6u+LPuRWE/4QPWJ/JhZqom5WOKUboEXW2KFvC5b?=
 =?us-ascii?Q?EGsziUJVZWHpB0W7r0tPmx+ek3gl8eI2eCLErajCLhMNq5KGJypjBlQbsO89?=
 =?us-ascii?Q?tH11TYjR0EUZKZg/RXyy3PeAFzSURmX1vq62MNNTUyB8wwgL+AVAsTaG1aq+?=
 =?us-ascii?Q?FzpmWeGg8X5O09xCIdDYi4Sn98UNS5u7VsNUOdSZMYwYpQ/Y1UIAXfR5tJHJ?=
 =?us-ascii?Q?5ftUl506WKlhVjD6tzPfl2kMsq1Sd4PVnduK+TxfJ6Y7+CQtxrkpxD9jTQtC?=
 =?us-ascii?Q?KdZAj4BofIzUDoHHC6eNW3t/9tM47s6uyMUt?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?OISEbmgdmxstA91o1hKKCpVwKj4nTT8MNA8Po3tjEN4dobWrrOZE4B2KR8WU?=
 =?us-ascii?Q?n49J8KZIduspsuB8LwLRBnjuz/OTHJgn+tcFSNU9CtRHiX0mmecu5xs3m7WM?=
 =?us-ascii?Q?CjuWlowG+SzaOc96TFFZMWo7Zw37Hlgx/GMg1Ca+DTu8qk9q7NPuQHteqeKr?=
 =?us-ascii?Q?lZXE8YCHZkifpf9ycM3KYp/HuJYK1hrW+9jmcfBpVC4G49wfJwW+Q//ZtjTT?=
 =?us-ascii?Q?a8l7MSZuVsqBS9eBRPYlYmLtJWNc7cNl2vnqIB5Kv8agBLwmEcyEcMg8XRPf?=
 =?us-ascii?Q?J/D51y17Hq6ZMNFKzOyw7SyiST+GrgYxCizvsxGH/Y6fe04+eWGmYMa6O/1K?=
 =?us-ascii?Q?kwJXaf2iASWY6EO8E3GM4/9/7DsVCMaCSrk7NsY8xf0cLlgVe+GTWSt7vwYd?=
 =?us-ascii?Q?0VSjz4jON4Cxgfe0thuTdRob81fR5CVPLmAUGvW4oUJVGzjzBzeCDzLce2Nf?=
 =?us-ascii?Q?qGkKFzZkYJXEZxS5rZXildN635U4KrAAihMspGdqPKyxTLosbU6cyReDMZwz?=
 =?us-ascii?Q?YcBbqYho2ghiUEFaplo8dGHdLbZ88usMgvjZAk1DlYxYUwRJQ6Gs/NKMt2xf?=
 =?us-ascii?Q?1Ex5bbzGzRJELUJ/cqtzlksAwMmF91C0rlznL1wbDCEJGuKGtAIqhIa0xMYv?=
 =?us-ascii?Q?CleF1KjDyrbN4Cq4EIaahJDkn8Psm9SMs2IMSjp611Z679octPfyq0bp1wVT?=
 =?us-ascii?Q?ToeMEr4cc7nXrsSQV/QMfD5haDLrUc/dvzFkZ1m95/a3tSS6OQxZBlXIPsIW?=
 =?us-ascii?Q?QNv0LNt+/W20lTCu6RWHko2XvLqwxQwcrn9sxMqGsd+7C2bBhoijbkE/C8MA?=
 =?us-ascii?Q?w3QB6ksHogfPbgdsL+z/TfhFgdHgRwkMioBAJHB36ohjolBQk8XPT7rW+Aul?=
 =?us-ascii?Q?drLc2/rVIuGu9BkdqFFk0mOO5sfNQ+rNcFSdRSmhyz+/UGZ004Jomlqn88/p?=
 =?us-ascii?Q?j3JBx0Ertpl6TYq9VLt2BU7i/ZWdvxg2rMncaMwMbImyw97IHeY8ledHOPFI?=
 =?us-ascii?Q?vqOn/WWLuls1St0Th8lYpQw54bI5ziHKNHBM16C/Q58TNwk7OxmrfjftezJH?=
 =?us-ascii?Q?PlC2Xp9lrgpvlmeNjuuxwsXb11aL2dTMGpdiS6iNKj4ZdVhxnzI4Pyq754n0?=
 =?us-ascii?Q?da9LQUyW6bG/vlImgGCQ5bDL/719XfZDmHk0H+o6wMR4dWc+AsLv3mYscn3+?=
 =?us-ascii?Q?v0s2em3Ar4MRF7D5llPJCuApVXH4cXGM1gCwPJ9eku8wMlvf13Rn1OvrLPRr?=
 =?us-ascii?Q?dZmmc10vKnJE/O5XszqJpD/3TSayF/Sg6baJNyQiq215uOAfXdqrJ487Q/qb?=
 =?us-ascii?Q?DQDFzbjZ6nVFPkXMQKvwT6JwTPzh+tDJOtrbDbSvxsGlPPvc7qbslGVoYTq6?=
 =?us-ascii?Q?fWj0ekf/Bolabs2LO5bnpjciM2U+RkWbtG8Dh/qgciQhHuj9ie4opTmQ2Cna?=
 =?us-ascii?Q?meeKpQ6OHa48eD94gbe54J9GZFHcyqVwPvniSTfeltz/UkEearMOiU01l7kR?=
 =?us-ascii?Q?6ROZp9GV6TYuBxnXwP6T+NjCyCQDuxdQjHRsURjMr88IhxJTcmhMqeMi+xKx?=
 =?us-ascii?Q?6PQ601B84dS1PzV2KYpbkJqaS+kzMA73Lg/yR5Wz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 689f1730-cfd4-4131-4e88-08de2c0ce1c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 10:24:57.1830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bRle/Jzec96Fd4Dsi+5A0wwpfECMf7F36uz0txUF+sh0jwQjFjVh+Ywlzq+IdtcRbVMsGAeSn3Jp6FgcG6Y05A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5877
X-Stat-Signature: 8b8z3yn3mo8i4ofdjnb4m36zuebpkpij
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EEFA100004
X-Rspamd-Server: rspam10
X-HE-Tag: 1764066301-361618
X-HE-Meta: U2FsdGVkX1/80odwWRCQXyUsNjBCB7Fmi3/GQQ58NbKe/sTNWeq8EIiG19nf4YKKl8M3rpttsrvLfhJ5SEN6nz0SiNkIcv6aUVpTE3jZDeN2+MD8YuGZKa95lX8d0SLmqI7pWw+Qh4y+0Xg0fDJuCroEHxsB7+UzWW8WB5PPzl4tPzjh3shVLRQnzh8RTkodFJBm7jSx0syEA2dWi2/+wPeO5PCr1b31nah9pglgIK1K6ngA7pQszntWO9dnHvix++ZEbTk+XkqzEp31bMnXE/L1zyuNRXulRsIdGeY4Co7qweLbvPSu+3WwxlKfEfql/1eiVQF2ouUuKj6nr9+1Ecp+tSX9iXtjttybjBWFNR0o1EtXgySEjoAxuwNOV1/5FCENq3JyJflPfbqk2F1Zy9YXP/r7+62tM41Y65QBes0rqVQfWZsi7yOCsnyIArL8lgm8zAuilc1oae+TOrA6Zi5dAkT1lHyCv2D5Luo13lojTzQ54sOwPqdBN80O5xMSoNrkxONTCPBhA/avH2iUH3vaVzsmVp2sVZeOJHL159tS5hqG0CjqDzOIgpPd4WwveP/pcdtp1yxFhxrAyVPhjTDl8QvHqGFqgC9UWUyZ1CDXAz6Pjrs+CggMrXeNAX78f0U4YRpWPmUbxBhrXqLs+SNeUrbVoia3jMDtzNwwkpyecdwdESDSQ43kKRZ+9QdfVFKb2goLddnas08slvfG54Udhfb10Cori7StyxEV7AGApti0lw1N1bvug67aNcLY1lFexzLnfJdgu+LL99IFQLU39hI9s6ECS6J+hACB0W7n2Jmqg2adCHq4X19BdUpqP74wtuTho+RgCacJd2XxVvZUMGf2Q5Z6+8wPIJ6rT5h0VA4Va0AZqvlAjEwwcZFtpkCmW4vlG0TDhXfzJLIIYxYaFQejyRSRoNljQNgm7ODpER4kYL8KolR7F6xOpfueLd8+ZTugvIEEfnK7RIx
 b4jMILrO
 ALZ5yYalpQcPdlbOx90HDDq4L22z55v4btuRKyz0Vi62kVfo/e3lSmFk56VNRL0EXI52fhBKDPL2RdwsS3YBRwlj+Kic3p5eYRkmKvT/QzXGy1P8+mqvyRCQvFeJ8GzvvcYAyEvgVRcuZHuXb8qBbIuAkZqnZ57CGfpjpVHJMr2Cm8XHhz7fksA0QPvTkDuq+EzaBoRbIHLCwRG873KOLGe2BXD8zCEmjp2q5MhjdyQxvQMfP7iGoFG0yyZpZnrEZF1XxfTtA6b+kAUudlqlavs+u7BeuMc8ju6sq6pw1u/MPFjuuJpImbVyVvvxecw0W26CxVGgtAudVvoilZMyTP2U78PDiPV50B6mSX/QjCwsdi3z7xnU/bPRTHqFWM/fiVDxYAReO0p4gfNrlKEAlQcSgFKVQYV7k1yjCU62LYpqWb7zZwrXkMQkhIB/ZL30nlci34tIVLG4DLYc/ScLvuiu8y7DKacq5OqMQzD57IktMN9xP/OUre/u+qnhubdy1EsDXrBDFRd2w+RU5j6Th9SL5IGKK5AaAnAtjmOP30mfRs5pIkjKerH67trcfpR/kpiwkDmpOoDJ+CbQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Oscar Salvador <osalvador@suse.de>
> Sent: 25 November 2025 09:34
> To: Shameer Kolothum <skolothumtho@nvidia.com>
> Cc: linux-mm@kvack.org; linux-kernel@vger.kernel.org;
> muchun.song@linux.dev; vivek.kasireddy@intel.com; Jason Gunthorpe
> <jgg@nvidia.com>; Nicolin Chen <nicolinc@nvidia.com>; Nathan Chen
> <nathanc@nvidia.com>; Matt Ochs <mochs@nvidia.com>
> Subject: Re: [PATCH] mm/hugetlb: Fix incorrect error return from
> hugetlb_reserve_pages()
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Wed, Oct 22, 2025 at 11:29:56AM +0100, Shameer Kolothum wrote:
> > The function hugetlb_reserve_pages() returns the number of pages added
> > to the reservation map on success and a negative error code on failure
> > (e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return
> > -1 directly.
> >
> > For example, a failure at:
> >
> >     if (hugetlb_acct_memory(h, gbl_reserve) < 0)
> >         goto out_put_pages;
> >
> > results in returning -1 (since add =3D -1), which may be misinterpreted
> > in userspace as -EPERM.
> >
> > Fix this by explicitly capturing and propagating the return values
> > from helper functions, and using -EINVAL for all other failure cases.
> >
> > Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return
> > nr of entries updated")
> > Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
> > ---
> >  mm/hugetlb.c | 25 ++++++++++++++++++-------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c index
> > 795ee393eac0..1767f7599f91 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -7269,6 +7269,7 @@ long hugetlb_reserve_pages(struct inode *inode,
> >       struct resv_map *resv_map;
> >       struct hugetlb_cgroup *h_cg =3D NULL;
> >       long gbl_reserve, regions_needed =3D 0;
> > +     int ret;
> >
> >       /* This should never happen */
> >       if (from > to) {
> > @@ -7308,8 +7309,10 @@ long hugetlb_reserve_pages(struct inode
> *inode,
> >       } else {
> >               /* Private mapping. */
> >               resv_map =3D resv_map_alloc();
> > -             if (!resv_map)
> > +             if (!resv_map) {
> > +                     ret =3D -EINVAL;
>=20
> Why is this one EINVAL? Should not this be ENOMEM?

Yes, looking at it again it should be ENOMEM. I will change that and
send out a v3 soon.

Btw, there is a v2 of the patch here,
https://lore.kernel.org/linux-mm/20251024094240.337630-1-skolothumtho@nvidi=
a.com/

Please take a look if you haven't already.

Thanks,
Shameer


