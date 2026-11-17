Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714AB606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Un97rvNg
Received: by kanga.kvack.org (Postfix)
	id 72F656B05B3; Mon, 16 Nov 2026 20:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707426B05B4; Mon, 16 Nov 2026 20:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0D26B05B5; Mon, 16 Nov 2026 20:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB1D6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:10:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8ABCF1A02A3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:10:45 +0000 (UTC)
X-FDA: 85442831250.25.DF220F4
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010032.outbound.protection.outlook.com [40.93.198.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id A61034000C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:10:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Un97rvNg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of alwilliamson@nvidia.com designates 40.93.198.32 as permitted sender) smtp.mailfrom=alwilliamson@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794877842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfft3FxSAS6eoNGEWMG30BVw5Pica96XKTQg/v7qC94=;
	b=afVt8HqYKE7QXH7QvePiAcDEtIiZ8BakHa3+baRoqGHsn/yeZM2G2xiCie80OWjiQ5ioqZ
	01dHqBVn84YQjOkjX6X1ql557wzZ65TaOTc7zSCSkI4Y+I0ghAW7PDpGnpvCqLDCQ+vR01
	Uhu1F6ETyJW2X7sH0HdFLrKnhT4gjsE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794877842;
	b=SjkApkUzELb7LyhbUy38kCgCPpyks7WG+NnKsyKusDxGi35i61i2u21u7Z0GyzZNE47sW3
	4AByxs7s6utIt2pLh04bEGf0q3D8GlSqUapKOUEF4UYj7UCgWQYFi81ZfjSa/Pz9jTaNck
	U/YLVCKhvrGEODgdikS30aofqnrvCjg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Un97rvNg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of alwilliamson@nvidia.com designates 40.93.198.32 as permitted sender) smtp.mailfrom=alwilliamson@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6Mx9m+9RzPcRI2OJ8k1BngtPVwmYH04WA+JcjzBGfWmDQ2F6Hd6lL1RdG6tDp49TkzBDz7UQy2biinc7xpX0ScroOPpO19gPnT1ikCmzRR5girguHCrZR3wk8o7Jwa6+HU83U3u4JzZT9TsLUYtWvJQy9rF2ZCIJ8kEHPvFy9cIzIy1k1D2pyCi1K8h+5R6nECl1rK0UxDw0zJG9q+wh2HTx8HpCkwohNyDmOStmPfjIOt8vAw9X+wO/Wm4cSpcYYmS7ZLb6PSkxqpcHRnz8VFDYP2zplH97lla3hRMIToSgl+D+lv/534I4liI1h3jgU2dtmugKtBvvHK9VqjxUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfft3FxSAS6eoNGEWMG30BVw5Pica96XKTQg/v7qC94=;
 b=vBaxvGphxrFnEhtjZ//TmUOsGdeOy9pmt5cya2kER8A0CF/+/aFiJDnpYRp/HPJN72GLEGEuqj2TapJtvmoOhsxjH6yJguIi3tjKAoHRmVUUueudS1Li2yT7jrVbia9ixyUzgdONPEQc32dq66Gz01TStmOm+LphNlqY/ImvZMHN6WcMgebw1MlvZQSZMgRJHRfEPo+G72HntALjGrzdd0vhq2YCtXG1PvSGfl56VNw2ZPmit8mG3deftckqY0wETYHRWkBmBWRHYR5NM8uR8AppPLXWHV+Dfnv0L/EmhCw4ir4COVNfJpvYPxmNlKdX9msn9ToHV1UZyKNdDhmQOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfft3FxSAS6eoNGEWMG30BVw5Pica96XKTQg/v7qC94=;
 b=Un97rvNge6bXtxxtxa+HxVLlDgfAo6GWzUtJBMANd+KK5UdsfYuRdOuktzztV5TrGvf63VWiq/xIB2VDKt5WVGZbRq5hIm7AUNu4Kn19guuVKvudMM9uuFVCZiBc94O1cExdZFSg5RwvooOgzh7v/B5gK0M+aqNqoSDrKT0CEsFj9U3D7QFriNouW4ouqBxtd2QeN/w+e3UJFCKuwX2F4Hh/O1gdoXzqUx0ZP+amXGiZHvSN4jpoKAIedmUlJKiz3hHR3TxCEyNc1FeRcOOGEM214nsDodDv9UoJbNXgQ7XCede0lhuXm62zeXIdh/ybIIA8IxCr2qVX2gE+uWGSTg==
Received: from LV3PR12MB9411.namprd12.prod.outlook.com (2603:10b6:408:215::20)
 by PH0PR12MB7011.namprd12.prod.outlook.com (2603:10b6:510:21c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Tue, 17 Nov
 2026 01:10:36 +0000
Received: from LV3PR12MB9411.namprd12.prod.outlook.com
 ([fe80::98b7:86de:b69:2a15]) by LV3PR12MB9411.namprd12.prod.outlook.com
 ([fe80::98b7:86de:b69:2a15%5]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 01:10:36 +0000
Date: Mon, 16 Nov 2026 17:10:17 -0800
From: Alex Williamson <alex.williamson@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, Jacob
 Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon
 Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike
 Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja
 <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma
 <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 08/13] PCI: Save and restore the ACS Control
 register and Egress Control Vector
Message-ID: <20261116171017.2342bd11@nvidia.com>
In-Reply-To: <20261013162529.1928093-9-dmatlack@google.com>
References: <20261013162529.1928093-1-dmatlack@google.com>
	<20261013162529.1928093-9-dmatlack@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::9) To LV3PR12MB9411.namprd12.prod.outlook.com
 (2603:10b6:408:215::20)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9411:EE_|PH0PR12MB7011:EE_
X-MS-Office365-Filtering-Correlation-Id: 07b5d6ac-384d-4c4e-5c4b-08df444795b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|4143699003|5023799004|11063799006|56012099006|261026121527099003|261021123027099003|261022075727099003|261021121427099003|261102130727099003|261102123227099003|10067099003|261009223027099003|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qTFc4EU+y7ycnOGx+y0cWTtFVfpott28BPCG1ellZw4Qw7q+xF1idJqD+cEm/iIMoPayGh11HsQwrCwxzGMGDcgx6Ajy9iPUfDvi0yiroaXb64lKXtXSPVDVJp1v0Ehhxn3k21K4B/kN9BUW1WmJsXVu3FdIslEJ/no3+iVdGBGi1uzP5gkSKa0EPQvbgL/B9A7gwQtNWQy+/Yy0TKKA8GQe4a/1qeYNT2+wh1kAgLG9BMSgMBrFa+bnrEDmQxp2Cb+d/Iryp9WX4PRaHnzrfYD2Wh91qXY04/2ooyu4Ci0gKo8x+cUYgNsFZ/+hEyDIQGCIMlXWTo3dt1RnwOxO0yE/aG25fOH98fnCPcnD9fl1cr9yoGjP2GZZ5qZedVlVVXE2GQHxepPHTop7/bCqGCizYF44n4PCB4fL7niKlQaaL4BpUGX7DXfNC9o/wOjpGsQRX05R/vZ9MrZtC+NqYqAPTMvxloEAUh9xXPqGNRKtOAWN6Kat40UQoSZDB2uAExGY76gy6lGvRtsuh93URO0QCqo9rMW5sufpRNHs9t43Lxb4lCC5qZDTeklEuw3ywSdB7eep3i2gnol1VH5z4tknkgaqVrFPHWLFsE9o2pruS4s4l0ZBDhLRPVRcRR9N3MEW4NQEyO9cc+aamLrYZ5AX5uWDJTU6yEOC5c6lJxo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9411.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(4143699003)(5023799004)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261022075727099003)(261021121427099003)(261102130727099003)(261102123227099003)(10067099003)(261009223027099003)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4Q2KuJvDgxhmI8OOxuLhhyJXU3AQ9Ywvwl5FKkGKcWZJIFARuVcuIgpnjDjB?=
 =?us-ascii?Q?TMIiAM5D2z/Uok5xMdYk5wOmBHIzsrAy5eF/ZIR3pkHcME23Lli0LqegAWuw?=
 =?us-ascii?Q?VHm+ENVtIqFNT5uQKfKQ10EuvCaYCAsI98Ih0T8PApslf7+/I1E94SOpZN+9?=
 =?us-ascii?Q?bvKUhg4zJWqYNJCs4gZH51R/7wJ8cQz3ANchY0fyANtzC2HRIzzAhWzadMgw?=
 =?us-ascii?Q?08LkES94UNe/uJTh5OXpLV+b2sPm1+xjsnZgwWHHxdKN1VNbzSuUJSRE7a1g?=
 =?us-ascii?Q?S8RDuA7hkNngJd1n1AUrTUTkHiqZaFGlWZQtEjf1gwZoqYnTY62XJllhoVtp?=
 =?us-ascii?Q?5QSKNjBEbIl9w0VVdiea+QDo6myH9ZfkFA8/KkgS/2WUUvKr+Fo1rnfac+DX?=
 =?us-ascii?Q?1bC8y4pxVeZOQK8zupntTw8Ljn3HYMRRMgJg82uyUz3S7KV64FygFEUDKVRV?=
 =?us-ascii?Q?u/OOX+o2M39Sab5B1tXbt8XBoRyGsSPqIiyKQ2yW/pc2PMXqESB5CPQPjVmx?=
 =?us-ascii?Q?DVII1B+vhMP89vmNS0qAEwMosuR4L+dj5HagfDXSURGC6SoqLXXOvNO0hNgv?=
 =?us-ascii?Q?+X1aaK6NEbfPdKQO5zkZZXQrTCfycljpG5cAFe4BiBzvP2uwvkXk0MSIXmc6?=
 =?us-ascii?Q?ydwiI4jcDPpbKI9KKW3cLZZJ3mp+2f6g/3w9YVRwgFPw4XGJsEwBOf8yuN41?=
 =?us-ascii?Q?cNhndnUalXZxs4RS9EuMFef+9vGb/CD+BJu56twdsDPxtXbaJRYg5zlY1zP7?=
 =?us-ascii?Q?RM1BAdsGTbdb7SDTGyUJfCWHThO0zo+7mcWtcQxaNdGDI//5dJHAx8abQt0V?=
 =?us-ascii?Q?/fdSX7TF2IfHEWrgyHvAhoGN2ZjRKlYGFEai9OXXIObdsP02zk/tUim2B1wu?=
 =?us-ascii?Q?djU6sgh/kujgBDuO+EI2NwvB+QAQKyIBN09jEPm0mGzv1IJbaNWoUN7DN34A?=
 =?us-ascii?Q?vprLV67RoAzMXVe+Bg4pmxMv0JuIKAyhHeGRG/XjU+p8yx6WgiFrLV+0c99U?=
 =?us-ascii?Q?i6OY+hrsSfWnfKHrLqDrMvNe1MtWMoP39E2lsnVwmJjFGQ35U1Nfi+OJXZRU?=
 =?us-ascii?Q?l794YvH898jRhxaZ+3LqDBB7aYg76mgrX/DA+FQnlVL/hd/u1Sp7TnuL/tDd?=
 =?us-ascii?Q?llzNAN5Go92oX0KOGmYj2h5yGgxfjbsNypla5HIBPGnk0LJ4DgM8fzf9Mg2k?=
 =?us-ascii?Q?XDR214NU0OUw3SsSWB7Ft1GAyBy1x5IFHGqH+G+X4AGjxL8BwsPw0C+Hh0kP?=
 =?us-ascii?Q?pkOAuSKWMIqZvDVWSJdxo0f1T0Zumc222g1KsK/ZRbSy6us12sXlEhgkI2x+?=
 =?us-ascii?Q?lgtaO9Eo2S+6p/dTz0kAMcrVUBVhfG55a6hqrc7IsD9FXWXWse2JCJhI8RTW?=
 =?us-ascii?Q?2VrX+7ggEqEi49+17YCaJbh1ywF8wlvm2mXxLuCatlGM8wgWQMn02NZx4E2U?=
 =?us-ascii?Q?Wl2wFsNrugw5Bd9fL15ExoWely2y75/bJ4D20QgFmou44uafv3L5SYRL9uAJ?=
 =?us-ascii?Q?KgKTVxAMR5FkOwqL6ExyxToAPQCjoiLo2UPp59xMsnhOTqEhY06G+/DrL0kt?=
 =?us-ascii?Q?Cm1i8dWqBjKMTtZcGEh0HOz8P6ZPLANncrnTJbpYt6+30UY7f7QFyYj8VcLw?=
 =?us-ascii?Q?LVEOTh/SJadZt+iyx+oP5kn1Pt4ARI5qFkEGBPnInvteK+0bO+0UgWwPx+Ql?=
 =?us-ascii?Q?RTg7mCbOuqyis0x2wbSszE81xqNYDgQzIhTyOwQhoMiCVb6kazAckPX1IIVs?=
 =?us-ascii?Q?jKwTa8Jjag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b5d6ac-384d-4c4e-5c4b-08df444795b1
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9411.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 01:10:36.4690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nnbg4ALepdpXVKRDbC5b2FqEKxX+aSQi9g6/E/KRIxytdSnfayQ64RQ7iQegmHzOM7A1+zAqQ+s1CnymsesE9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7011
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A61034000C
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: k1i5jnocee3xjwq3bejow1uskrrp7qyo
X-Rspam-User: 
X-HE-Tag: 1794877842-56318
X-HE-Meta: U2FsdGVkX19iszCXRZ2JDz3t4j6YtNfWDe+qLyF82o8Yuzjgt5/c1cT4YDCa9Xl452kgzauAKH32z5klvMZ0licBGfV8FBtFZGQcJ6Vc56opNF0cvuIt89m666knZX/04WvgXJ9pBrfgwUuOCoh1h3JhGHEKZHjfmh+MH3Y14gU8BQCwMU3mmK7Vj0oBULuzTvlR6b+NOT4+ynqRSXHpQJtqHCczvTTC6Lr1tdFGcSrfBpCa2cwBQufTXwLNcer3sw7q6BVyPyJHlNdfO5vd5r719RdFT/N/y81TzmPoMLCbFZnMHH7HC7TBO+StrLRXICXnvlXg7B2hO95L+LyFjioEjFukO19kzqUC/Z456HTx9JwOn3N46gGyeNFy0XzdW92RhFhiW9URPtKNoEHtHik/owKbBeDfXbuAyKk90y+zWnSMnb+mxddtB2/H4by5sWX/trPvZfapdJWW5pghb87qrJhc4wQ4wTH3yT6vG7UGvX4frP6N881dQeLFYNEpzGU2PN5vDwFbpqHAITgACJoqWSNQ428zTw6SLW82x49Iy2XaHjrXJ0EvCBSVNWp9G/GHM+SDUCzEAbiXd4I5Vl5q8H7RhopNACvPnauwpGP5qYEbTRMbVcyvB0bA99R8/e9wPT8ipnUDNLqJzfT2+rDgr8o5SY1Gh+qcD71zvKRZvF665Y1/ufyzM2phs0FVqZ3xzRw0twBmKd1YoUbUvkrN6oNUTtzmKiBbT+4XgbVObdhYZFTF3qnAQGRH8w6UgdFzYU0Y1mRciiVxyhT4vLV1NKohyujTRKtseByavRMXTnv5/wKJGylQ+LeTwkfkXcRFTvV0ZxC8yUSz3Ni771OMtJu6sEPhTNGKXhJX3zY6AVB8BTSosJhG9QnnXieqngqS+1tOl8h4itWoM6OMyca1GdqXEyXwoEEdxxbaKrne3VuVQBEs45tCwkR7tydv0ZwmfLzuEFs1749Wjys
 iEV+Scn6
 K+7nQCp5++EX9udtfBZV0k0Vri8F88O5NTS4X6x5KafTSTyRlWYqsxtmuA6X0QnR6y3E7w9wtl+yBHlmL612t0NKRq2+LZaGPYIHL5OUNXzJhw9WsMuQ0+7lA0r2Y9s7bVwK31uyMG1U0r+/OzEMdKhoEuUtT7TcOrjXmv6vJml29fmBLoeQZ0hXiLkYebuuFXnkToXqFoanggIEhkyxkaBkYqG2nED4ZpJX+p9LOIeUNwh2KgSvtovgzufGiNJ7J1vLTJ7el3tVsNYDB9PebMSosFMnxsjTkFHTc2S3S9DWADs/OQlrnrDIU3m67Zarb7weC/7e3A+1q7XIHYP2fZ0Fqw1HlLB6r3X+8VudQTnysYt+coWzXWf2nSW2mT93umLvH0geOB9lNzud1CX8aTVZTmjNYjdnRd04IOHbUjrximC0pIgxSEd/onexX/Ikcov6gzqeR1J2lHeO0+eIVZrv1KkqkW9Xw8QStmMS2GKaDnsd+suJbj//0snGtuc2MW/7s3hhRKBSZbj/JjomrvUkyyKyiWY20FiDzKBfeMrNtv0Ls7zQVzaIIJl3tcKiccxfG7bIxaA5olmPZxUxu0t8u1vDVBldiwpC+c9kbA0m8YF313EZHaRCsY2WnJCE/vMN6/HcmPHAD9+JLIvvy5nnxYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 13 Oct 2026 16:25:24 +0000
David Matlack <dmatlack@google.com> wrote:

> Save the ACS Control register and the ACS Egress Control Vector in
> pci_save_state() and write them back in pci_restore_state(), instead of
> recomputing the ACS controls from scratch with pci_enable_acs().
> 
> This makes ACS symmetric with the rest of a device's saved state. Today
> pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
> the ACS controls from the kernel's current ACS policy. As a result, a
> device can come out of a reset with different ACS controls than it went
> in with, e.g. any controls programmed outside of pci_enable_acs() are
> silently dropped.
> 
> Notably, this prepares the kernel to be able to adopt the ACS controls
> established by a previous kernel across a Live Update rather than
> assigning new ones through pci_enable_acs().
> 
> Save and restore the Egress Control Vector as well to keep it in sync
> with the now-properly-restored Egress Control Enable bit in the ACS
> control register. The kernel never enables Egress Controls or programs
> the vector, but the firmware could have and they need to be kept in sync
> to avoid changing how P2P traffic is routed.
> 
> The Egress Control Vector Size is a HwInit field of the ACS Capability
> register, so read it directly from the device to size the save buffer
> in pci_allocate_cap_save_buffers(), similar to how the VC capability
> relies on its HwInit fields.
> 
> pci_enable_acs() runs when a driver binds to a device
> (pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
> the device's state. Refresh the saved ACS state there as well, otherwise
> a subsequent reset would revert ACS back to the configuration left
> behind by firmware.
> 
> Devices that rely on device-specific quirks to enable an ACS equivalent
> keep that configuration outside of the ACS Control register, so keep
> configuring ACS from scratch for them. Do the same for devices that have
> no saved ACS state at all.
> 
> Assisted-by: LLM
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/pci.c    | 146 ++++++++++++++++++++++++++++++++++++++++++-
>  drivers/pci/pci.h    |   5 ++
>  drivers/pci/quirks.c |   7 +++
>  3 files changed, 157 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b2879a6be5f8..944590fdef48 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1021,6 +1021,139 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
>  		caps->ctrl |= (dev->acs_capabilities & PCI_ACS_TB);
>  }
>  
> +/*
> + * Layout of the ACS save buffer. @ecv holds the ACS Egress Control Vector, if
> + * implemented, and is sized by pci_allocate_acs_save_buffer().
> + */
> +struct pci_acs_saved_state {
> +	u16 ctrl;
> +	u32 ecv[];
> +};
> +
> +/*
> + * Return the number of DWORDs in the ACS Egress Control Vector, or 0 if the
> + * device does not implement P2P Egress Control. The Egress Control Vector
> + * Size is HwInit, so it is read directly from the ACS Capability register.
> + */
> +static unsigned int pci_acs_ecv_dwords(struct pci_dev *dev, int pos)
> +{
> +	unsigned int bits;
> +	u16 cap;
> +	u8 size;
> +
> +	pci_read_config_word(dev, pos + PCI_ACS_CAP, &cap);
> +	if (!(cap & PCI_ACS_EC))
> +		return 0;
> +
> +	/* An Egress Control Vector Size of 0 means 256 bits */
> +	pci_read_config_byte(dev, pos + PCI_ACS_EGRESS_BITS, &size);
> +	bits = size ?: 256;
> +
> +	return DIV_ROUND_UP(bits, 32);
> +}
> +
> +/*
> + * Return the number of Egress Control Vector DWORDs held in @save_state, as
> + * sized by pci_allocate_acs_save_buffer().
> + */
> +static unsigned int
> +pci_acs_saved_ecv_dwords(struct pci_cap_saved_state *save_state)
> +{
> +	return (save_state->cap.size -
> +		offsetof(struct pci_acs_saved_state, ecv)) / sizeof(u32);
> +}
> +
> +static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
> +{
> +	size_t size;
> +	int pos;
> +

Nit, moving the device specific enable test here:

	if (pci_need_dev_specific_enable_acs(dev))
		return;

Would avoid:

 - Allocating a buffer that will never be restored
 - Saving ACS state to a buffer that will never be restored
 - Testing for the device specific enable at restore

Otherwise,

Reviewed-by: Alex Williamson <alex.williamson@nvidia.com>

Thanks,
Alex



> +	/* dev->acs_cap is not set yet, pci_acs_init() runs later */
> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
> +	if (!pos)
> +		return;
> +
> +	size = struct_size_t(struct pci_acs_saved_state, ecv,
> +			     pci_acs_ecv_dwords(dev, pos));
> +	if (pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS, size))
> +		pci_err(dev, "unable to allocate suspend buffer for ACS\n");
> +}
> +
> +/**
> + * pci_save_acs_state - save the ACS Control register and Egress Control Vector
> + * @dev: the PCI device
> + *
> + * Record the ACS configuration currently programmed in hardware so that
> + * pci_restore_acs_state() can reapply it after a reset.
> + */
> +static void pci_save_acs_state(struct pci_dev *dev)
> +{
> +	struct pci_cap_saved_state *save_state;
> +	struct pci_acs_saved_state *acs;
> +	unsigned int i, dwords;
> +	int ecv_pos;
> +
> +	if (!dev->acs_cap)
> +		return;
> +
> +	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
> +	if (!save_state)
> +		return;
> +
> +	acs = (struct pci_acs_saved_state *)save_state->cap.data;
> +
> +	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &acs->ctrl);
> +
> +	ecv_pos = dev->acs_cap + PCI_ACS_EGRESS_CTL_V;
> +	dwords = pci_acs_saved_ecv_dwords(save_state);
> +	for (i = 0; i < dwords; i++)
> +		pci_read_config_dword(dev, ecv_pos + i * sizeof(u32),
> +				      &acs->ecv[i]);
> +}
> +
> +/**
> + * pci_restore_acs_state - restore the ACS Control register and Egress Control
> + *			   Vector
> + * @dev: the PCI device
> + */
> +static void pci_restore_acs_state(struct pci_dev *dev)
> +{
> +	struct pci_cap_saved_state *save_state = NULL;
> +	struct pci_acs_saved_state *acs;
> +	unsigned int i, dwords;
> +	int ecv_pos;
> +
> +	if (dev->acs_cap && !pci_need_dev_specific_enable_acs(dev))
> +		save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
> +
> +	/*
> +	 * Devices that rely on device-specific quirks to enable an ACS
> +	 * equivalent keep that configuration outside of the ACS Control
> +	 * register, so there is nothing useful to restore for them. Configure
> +	 * ACS from scratch instead, which also covers devices that have no
> +	 * saved ACS state at all.
> +	 */
> +	if (!save_state) {
> +		pci_enable_acs(dev);
> +		return;
> +	}
> +
> +	acs = (struct pci_acs_saved_state *)save_state->cap.data;
> +
> +	/*
> +	 * Restore the Egress Control Vector before the ACS Control register.
> +	 * The vector resets to zero, so enabling P2P Egress Control first
> +	 * would briefly apply the reset vector instead of the saved one.
> +	 */
> +	ecv_pos = dev->acs_cap + PCI_ACS_EGRESS_CTL_V;
> +	dwords = pci_acs_saved_ecv_dwords(save_state);
> +	for (i = 0; i < dwords; i++)
> +		pci_write_config_dword(dev, ecv_pos + i * sizeof(u32),
> +				       acs->ecv[i]);
> +
> +	pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, acs->ctrl);
> +}
> +
>  /**
>   * pci_enable_acs - enable ACS if hardware support it
>   * @dev: the PCI device
> @@ -1057,6 +1190,15 @@ void pci_enable_acs(struct pci_dev *dev)
>  	__pci_config_acs(dev, &caps, config_acs_param, 0, 0);
>  
>  	pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
> +
> +	/*
> +	 * pci_enable_acs() runs when a driver binds to the device, i.e. after
> +	 * pci_bus_add_device() has already saved the device's state. Refresh
> +	 * the saved ACS state so that a subsequent reset restores the
> +	 * configuration programmed here rather than the one left behind by
> +	 * firmware.
> +	 */
> +	pci_save_acs_state(dev);
>  }
>  
>  /**
> @@ -1800,6 +1942,7 @@ int pci_save_state(struct pci_dev *dev)
>  	pci_save_aer_state(dev);
>  	pci_save_ptm_state(dev);
>  	pci_save_tph_state(dev);
> +	pci_save_acs_state(dev);
>  	return pci_save_vc_state(dev);
>  }
>  EXPORT_SYMBOL(pci_save_state);
> @@ -1877,7 +2020,7 @@ void pci_restore_state(struct pci_dev *dev)
>  	pci_restore_msi_state(dev);
>  
>  	/* Restore ACS and IOV configuration state */
> -	pci_enable_acs(dev);
> +	pci_restore_acs_state(dev);
>  	pci_restore_iov_state(dev);
>  
>  	dev->state_saved = false;
> @@ -3532,6 +3675,7 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
>  	if (error)
>  		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
>  
> +	pci_allocate_acs_save_buffer(dev);
>  	pci_allocate_vc_save_buffers(dev);
>  }
>  
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index ba3c3fddddc2..037c1674f164 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -1095,6 +1095,7 @@ void pci_acs_init(struct pci_dev *dev);
>  void pci_enable_acs(struct pci_dev *dev);
>  #ifdef CONFIG_PCI_QUIRKS
>  int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
> +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
>  int pci_dev_specific_enable_acs(struct pci_dev *dev);
>  int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
>  void pci_disable_broken_acs_cap(struct pci_dev *pdev);
> @@ -1105,6 +1106,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
>  {
>  	return -ENOTTY;
>  }
> +static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +	return false;
> +}
>  static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  {
>  	return -ENOTTY;
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7aee30734303..e500c202d2ec 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5476,6 +5476,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
>  	return NULL;
>  }
>  
> +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
> +
> +	return p && p->enable_acs;
> +}
> +
>  int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  {
>  	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);


