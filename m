Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48122D49C9F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 10:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A01F6B008A; Fri, 30 Jan 2026 05:53:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E076B0098; Fri, 30 Jan 2026 05:53:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F356B0099; Fri, 30 Jan 2026 05:53:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51CC26B008A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:53:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDAA313B474
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:53:15 +0000 (UTC)
X-FDA: 84388318350.20.EA91BE7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id 15F36180005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:53:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QiGUnuiu;
	spf=pass (imf06.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769770392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
	b=Sxr+kYk9AjzSqxl/X+Ud6szouZ8FSqSiyCPuXG1ywSXhZtdjcJ8+qYW1cpRaI/6/uMOaR5
	gbJXFGJKlMYJDTMUm6gzNdH0mN5dAz9XdpSEi6p6h9Ofm5ylZG+51u2R8D9ZchNgzSLh7s
	1ViOYUoXxAoEhuT+VyStwD8PWrv9LEY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QiGUnuiu;
	spf=pass (imf06.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769770392; a=rsa-sha256;
	cv=pass;
	b=DfforP+P6cXGbQybSxYc3f5gkbXeHfKpvJmVMKGrLrCSEl4DjlXLwNBxbQi7RRCWCu3T4n
	R89iq3gwXKFBcBrkLtYqmhe8Sp6Q6sVU9z2Qb8Fk9fpwt0qRgp5b3Wq2Gz/Qz69oLYsAsQ
	B1v71Oh3xwfxSLpF+cs6/+6Rz/FZllw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZulm34NQ1aJkhL6etuUiGoR9dyZ5BbxHsB/Bvrjoek7EJJHXpV0x0l+fQ5paFuL/AY0xwhUsAquwLDHWgdgrqIEbsYik7IGBiI61syH7SR50SUPSeQJYzc4cZMfUOjmSb5mRzYALxBKQAJNwRQqhxWHxflKvZuII+jCZG4UVn7bi9xbnO3nMDbxAlK3Bcw+duOQ5sxBL4+/AYB1U9LqlBfekn8cZjB+xQRSj0BjaZx4EtDCJUpfDbNOrwj7M0SITj1OsEE627DGk4b8CTatLGP1S9rCC/W3nTr14x86clBI+qGgWAkzM3/48BdvGFuf4ZrherkM9XUmRYuI6upmIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
 b=LuA3UFDwKC62b08b9GdP6nuXSTvGx+ojvmahKhfseMkPucw2I0r2wISFsANfhb2HvhfPpO9tfOVM0eJt0m3ibsUzg4+1TFD/698ymbXX2RC7+oGxEq46aewZ6ySMoTcz1zmJDmGpJJPGJ59ZBFLcksVq4eJCViIqo7+1UOmy44MioXpjQEM+28MIKgXiQHkayeM5TU/baemj8ZgGpOP8M8TYvdRyBuK96dj4SJxxzgC4hzB99nWUjURM6PGuZXaN2UI/42nRx9FEJzPcE83qdR5bOtCkRJOODLgKmmT4vZqUauHzOCtPD+jga5HoH+vzE2dh7wthkH95DizOkmrbtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
 b=QiGUnuiuCVTvasuaAQaVOSFitMOo/eCQyYizW5jEzi4HLskWoP0FVGF+fO8QhTCHHLXNl0N4u77fNu5TX0HSzuLCK+QPCoaeFXNb2tf5DzEybPbwBP9qGRcuNVZFJYMIWXZUqQZrV5k27qg88CIwgfl1OrWUUV1Mce3TmrmK8hev0t0B4SRFfXIeLxgh3iVOLfseu8s/bxQKGDeE4PS0m+qqeD0n4Uc9hJJ5ySnpRMyXJLlch81DuEfpI8ZLVvOLN1TiRF+F/HBKhlt2iirXvIcWk/UBTIURrEDcVHQfuyCBOPkXmBfalqZPf0aanDlWT0TBlUxn99TlprRjhf8FLw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9760.namprd12.prod.outlook.com (2603:10b6:408:2f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 10:51:37 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 10:51:37 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v4 10/13] mm: Add helpers to create device private entries from struct pages
Date: Fri, 30 Jan 2026 21:50:56 +1100
Message-Id: <20260130105059.51841-11-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130105059.51841-1-jniethe@nvidia.com>
References: <20260130105059.51841-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::28) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9760:EE_
X-MS-Office365-Filtering-Correlation-Id: 3de19806-7f44-47e5-4b05-08de5fed8a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Crp0X3lrdSdIWZ1ZWHQ14rm8VFeMeshlCgiul2HCUjvvhMa5Ka5vi82BAmhw?=
 =?us-ascii?Q?wRqrZELDj91y9Jp7q/Pg4fp2OHqszO/4kmS9Rnxr+NLwkLvJ1y08vxF5XsIJ?=
 =?us-ascii?Q?6Q+DRLSSBR6tnHmE8LpqnVQU8AS4NE9kxAq5/vRYAmkbcJyLkgnYIODgC8gE?=
 =?us-ascii?Q?F6i/68xdR0KxYIxB1fgJce6Cyq1LSnEH9MLmn5+lsLcqvKg76BmbswlM5TSm?=
 =?us-ascii?Q?GwdNskOibh8zai9Q/iAqv0QdwGTQNFXXR5c81PvGxbrcn6CNf7MW0eqmej9W?=
 =?us-ascii?Q?hf1uwAEn+LXCwiY7Slqo0kDO6dEgUxATpUNItkLP/3DrirsqTk3h/vkRIl33?=
 =?us-ascii?Q?tzLhX4/CY1ufge0S5uM2f2HmPDpVEkXngeDT5CT+sIFD2LOtTCTUE0vatPRi?=
 =?us-ascii?Q?aELwwrp29O+YzgcYvzefk8x36VHgwP3E3juk4VDrXBUV6K6rMPzW3n/xUM6k?=
 =?us-ascii?Q?VQQ4TMNarvSc2heqw11z9lHIVT2o74eg0CNn2IEtMkiZFuLPkVnCpidf39c6?=
 =?us-ascii?Q?CGeVpM+taVjXOHjZqFLklsQsAOmYLTtsREQrfyYczQE42Vjj3I9aOcDkGwaI?=
 =?us-ascii?Q?b5CfVdv2SCyLCtA6ly8HzsSsxmdxtnKXEe10V8pJlh/OIvSqakstGd2Wm5/m?=
 =?us-ascii?Q?r5B/24FHmMh2wNJ2eu7w1QnsqOsWaHh/sEEn8aXw8J5g6FuCjvOOz35dT54z?=
 =?us-ascii?Q?Bg8nm2DWJB5gER03FrqNJp1NV9AoC0FXl6mGMvrm6iviBS/WFkeQh8qwGA49?=
 =?us-ascii?Q?ac4pQAVB3bdG1iY/gxYPE8hLBTQTOjFX19qbyW8ZB3aha1khmF9jkl/DeHZq?=
 =?us-ascii?Q?AmpkC1KJ9dX8gkJlOebsBvc+YWpevbOZbU35R+lCzsInmKM8Z2w9DkMPGPvC?=
 =?us-ascii?Q?YqfSAaV13T42m3DAPcKMbRW3v7E96ycN4g81vRklOHJubZ3i1mGKK9UvLnjt?=
 =?us-ascii?Q?zBOj62Sa9qR2pPMP3WeTZ/tvhLirHCkzP3jN41HiZ2nPi6qRyZ926tHcWEEC?=
 =?us-ascii?Q?ibYzxFrggo2ddHRXV35H0b+6sUknnUjiN+SzS/Sq5GFn2ih8Z3GyhKN8o8wQ?=
 =?us-ascii?Q?R+gK980ynt9uf1KkLiTw9gCzwt6Ng3m2xjFnxasGtvg9MB1siihXV9yh63ML?=
 =?us-ascii?Q?HdqkRhQrR0y5DQsWcHJzm10JTH334xMQFLbG7WNK420mvrclP6VO+wvVrwaE?=
 =?us-ascii?Q?KQqs9qCkEsUn9T2YVrSq+W0vxGB2KFiNxbeA0RTu6bRedVxIoMAa4vaWAKja?=
 =?us-ascii?Q?vewaUHP0463vDvqY7/vfoHy2kGFuUvSQ+b8Oj5MYmqXNAzey/nyDH1sFgMI5?=
 =?us-ascii?Q?A6SyAyKyKkgj5lq0TDR2QHtmmTCQFYh0p+e+I/g5hTHXODHN9D68vsN5SouO?=
 =?us-ascii?Q?GqSOwPtT+19t2/Xb46kt6/MSEO3ZFarAfJ4BPLEC6Whh5zr2CIL0iJspmAwC?=
 =?us-ascii?Q?BGoOKut4ObKQIoy0CJtBGUTcY/L9UCPQ0uBRQbEOY7HuT3Kfqtq+7rtUNBMS?=
 =?us-ascii?Q?D8RjeUjBmXvWNOwTPlm1pVBp5U3R1LbkMrUE87ZxtyOdXMjxL9hknKYwZKTY?=
 =?us-ascii?Q?0612abFWu9lO1bqV3zw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qDehiIMLDLZex/bC0KOj11LxauN2URvanLXx5zx+eJsBlzIO/jXDG5lEK1Lm?=
 =?us-ascii?Q?xpsj+aQJijqAN3zjG/AsFwm6pnh2tH/ozXwrQf52T/kuN/0K69y6tAGIO9um?=
 =?us-ascii?Q?clOJUn++Wbl8HDMyZYIR7O1MiLPg1WzQuPQwgy5XKjUixe7M1ssqJ4Uh9nJ1?=
 =?us-ascii?Q?jSW/s8SPqq5SCRkVfbFvGBpSR088mwGCcG2wCscL7EuWT9LSbhE02bBGlZsT?=
 =?us-ascii?Q?zfTAmnjjbUzLwuNmMxlJRHGBONKo0rKuDZyfwyP61v8wQ6BPsinM0FzhToLc?=
 =?us-ascii?Q?tUP1YuQ5vgeFXqATHRZFCyLrg4/RERjhiWJVzv7QgOxdPj4tJ1Uc4/Q8VCqh?=
 =?us-ascii?Q?IJlsyDIwDQ95sshUaM8SToqVQvIODqIi55amnQ9hqbRZWJeF7QJwKxnqfN+9?=
 =?us-ascii?Q?uPgcl00QkNL0J0phOfSN7A1BfSE5F7uOnfOwJAO6dC3ahnEnGEwtSoIOEZ8L?=
 =?us-ascii?Q?Q57F9oc8zNf4q0RMvtKs6lc9gyb+t1dmgLerHx3zNcxdZKteArUBu/NQwjqf?=
 =?us-ascii?Q?CcNhqZD0GfI92w3nmpnnIN9j6zYZI4qR1S5e+2KNL7KLuGIxFgwh98rCdszk?=
 =?us-ascii?Q?hGu/K0JdqmnjV9HtTICqi1bdiN5ZjeMT/v2uCPTkCXccYvBE+OHPYGc/Wsrc?=
 =?us-ascii?Q?TISt8KkbY2kftHApHza6GiAg49JEukEv3ZCfP73YG/0yi4wpwlcsrb1vyLrb?=
 =?us-ascii?Q?IcEznq9iNPkgZGrYhjiuO0Eyhe60K+ca/mY9RBbOT2XjrtPP4HSzt3Ib2/nO?=
 =?us-ascii?Q?mTdwsPHZc3bHpBMTGHg9ga8dgPznKNhnnA/y22qJiXXg7eyHIxH8dy6L3KXw?=
 =?us-ascii?Q?w1zYKB6gOsZ/3LuMFK5oPqMCLfOom3ADBFd9CYK6uMOdEq884/eLzL9QBx5p?=
 =?us-ascii?Q?ECJCR8g8Oy4VoaRmmHUxTZodZnBmXMWdaZF2LoECDtkv2wxYu8cH/8QWNiwH?=
 =?us-ascii?Q?IfP53LTkgVTe4I2dOU5LoVP/OFnzxP5lVbKWLV4h/G+tbG0Z8T2hGR+ON+Fi?=
 =?us-ascii?Q?u45l87A5XPioYhheQAGKRaex4MvvXG8LXvJMYJexo0dbzWdbPlFFd9qCJCpM?=
 =?us-ascii?Q?qLaluIsvlme1I8tPLCsoU1/3UQZWadkUCCiyutcbbX2kB9zj5PJU7HGIU5zu?=
 =?us-ascii?Q?zUyKTXvUi9nNXD9drW550QPhjTbKlYqF2ZVoDR1TnPWGEa3+EvNcGWRZ4I+4?=
 =?us-ascii?Q?10jhXMHMhulxcWtMzBkwKj3qtFTyBIUubQEmxh30Yp+lk8cC11UQcOVOrOFa?=
 =?us-ascii?Q?afUGMv3XSNGNyv7aCC/RbIauTOI4yi657x7DsMmztFqCFhtxco+tn4uBMvCL?=
 =?us-ascii?Q?pxWEciDzX7TihPaMQQxYTlkksda3dJ3xBYT1R2N2iY0rOZqJZbA47V35DI8G?=
 =?us-ascii?Q?3cfoADv+KWeRHHV4jZzBmZYOI5TgwNWB+vtiqj80TEchq+9EqWThB0i6vF58?=
 =?us-ascii?Q?rHpPwwmHTY1dZiEBu3YBsPiETSGajngZcBN6F5NFW9vsWfneKE9+RpTSlKh7?=
 =?us-ascii?Q?2w5vXIHC8lls/CxybRIjsfAH/4CdXrl7XRqJO7CTV7ItN1FWySWWPWEOMj1P?=
 =?us-ascii?Q?nY+5LTaN/UqDwFh15XqYHbb5T94RD9MYz5CLnVz6OoJgztax2W6mr7ivhy7B?=
 =?us-ascii?Q?H0C0sjTyLv3Vpydu8t9mE5SXy4mmoDoQzrsln5+5TYFC5v2+ehvx062eB6uC?=
 =?us-ascii?Q?vJoHEH3AQYFJFTsp6h3sVLoRpChP5w105yx/0O3ah1lIbLIhf9CTN6KloySK?=
 =?us-ascii?Q?umlUwIZksw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de19806-7f44-47e5-4b05-08de5fed8a77
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 10:51:37.0780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aj1I2u7ZMqDYCVwzcU/fadN0Bic5WbvX8FWrDNqiJoeW2j+qcVAG3xd11dlNdCBTCfFsqHXNGUcgEdfVO/jN/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9760
X-Stat-Signature: 8ua8ofmntm64gnnu9aucn61jrpioqb83
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 15F36180005
X-HE-Tag: 1769770391-440633
X-HE-Meta: U2FsdGVkX197kKotw7FOnSzJf0E7pIPlSAWisTbsAzU8eU4dYSaGsTF4trwcS3ros7cFZrFUXujUKlz0EwDbb3xHebyM8/78j5fYWKwc3K73EW3NQpGirHe7mRURuHm5CvREoq3QaeDtm6zeRIdaWioZqbrl5frcsoZF/rGzXShQfPoLXoFV6kyYw87+jBiRDQPNG8MPnNP9Pud1GkcWDjE4v5dYML1MhktaE46A6EFiy8bTnZmS7yoIUi4cTXwtMgCXcT0wTVkWSSQ5HhYHvUmkiH5cET7Ya+ebDFv0+ULmS5Ydc8aUAYAoF1lWhCAiGk+JGRothmLFl7asa5b+05PkJXOpu9jBydDRedhm2iT+qVIv3FHT9twjsoZQBSETZrOjTqs68S9V3CwA/xH1JwmADthl90LwsjQw0d4vUxyLk9MHAKFQnN+rWtRoNpnMtKJRj5IwNWM98v6MDwvemgliqIzvOtt3rrmVWVueiCDxuAoORBXnNHhY4Q+a/FVUCByHvYXqX47/rrXuQOcJD9thu+ys7vtnL7fj9k8I6qZYbAiCAbbKtwu6oXfGaEq9n28aa6JQ8zf290Xz/jCWkEKGoTx6gAgcXhZiYKTPDwLr9asVxRIN7Syk+Wkasje9rbDWWh8SLE07xlEQS4XmACmVPfy2lXNuWd/oTWdeepHPGXyMTF83wJcgDTjjOMeW+fMieQtOGMaYzFb24G9qNcD7UJQf7f2b/UWkvDbtZdxa0S3RnhDfjEHqHFfgVkrg27vBzJvpM7HE7IDoc/E9AqNq+mpOHjuZnkSmz3bLvo0nbnc124GuOrXm2NyvnRTg7QqqBxcYG77M8SRhorRu3xMHYDHKxbWd6oNJB5OOlhBhOZOjiHv3P52iq0s9DFfUGSHPS6F+Tzo7FISu/RZP2vZLNJskjd3jGmV8w3P8z2BxQhVGuY2mExLt7whse+9K0Rzr1Ns4pFFIwFO2imk
 oRyh0lmK
 U8QSs3K5Qf0dHgFL9E9JFbgZ674IGQRLKUYx83xTqd1APNPdNg8duUsaunE9ygkJi2C3YpGlGcjHwfXvW9W9RA51QMNen0RRH3pStOdC0sFsSW59uwSHJJc88spwJBBzn+P9IzxuXJ5zeF4Dfnm6/NnAK7YgnLnyK/EFdMv39n/z200+GHmgXp0zpJLvba938E2m2nZ3ZrT3cVmF/L/UCR0flT/+KA6Sl8hUZEtgCKpmRhxi7WdB/8E70uQZAsUlFWX46SbhCNDA2ds564bXqqIOjdru2E46Ap0p97GpOvRhJE4msVrqvLKTjnTYwaz9tq9mw1RZ92mDj1uB4WiWsbrMoSOsSRyPDP+vYGA5pqjbnEVRMmft2VUjWQXr/zj/790j9j7oEiuMalcX2+BUzYOpBy1RFRRbCib+RklmCs6hastJeq+Gt+4uplgME66D7ummxI5qxs0hgjYKdVw/teP4KWlJEp3YOZ7pN0K4UwLj5LbJ6EqyO6sY38BS8su/TpEU0TwyzXaFTftpmFTBygEY4K34r6HmUWCLH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To create a new device private entry for a given struct page, that page
is first converted to its pfn, before passing the pfn to
make_writable_device_private_entry() (and friends).

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn and must be handled separately.

Prepare for this with a new set of helpers:

- make_readable_device_private_entry_from_page()
- make_writable_device_private_entry_from_page()

These helpers take a struct page as parameter instead of a pfn. This
will allow more flexibility for handling the swap offset field
differently for device private pages.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v1:
  - New to series
v2:
  - Add flag param
v3:
  - No change
---
 include/linux/swapops.h | 24 ++++++++++++++++++++++++
 mm/huge_memory.c        | 14 ++++++--------
 mm/migrate.c            |  6 ++----
 mm/migrate_device.c     | 12 ++++--------
 4 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8b39983792ea..080e27da6b47 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -138,11 +138,23 @@ static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 	return swp_entry(SWP_DEVICE_READ, offset);
 }
 
+static inline swp_entry_t make_readable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(SWP_DEVICE_READ, page_to_pfn(page) | flags);
+}
+
 static inline swp_entry_t make_writable_device_private_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_DEVICE_WRITE, offset);
 }
 
+static inline swp_entry_t make_writable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(SWP_DEVICE_WRITE, page_to_pfn(page) | flags);
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_DEVICE_EXCLUSIVE, offset);
@@ -169,11 +181,23 @@ static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_writable_device_private_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_writable_device_private_entry_from_page(struct page *page,
+								       pgoff_t flags)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e3a448cdb34d..03f1f13bb24c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3219,11 +3219,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			 * is false.
 			 */
 			if (write)
-				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_writable_device_private_entry_from_page(
+							page + i, 0);
 			else
-				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_readable_device_private_entry_from_page(
+							page + i, 0);
 			/*
 			 * Young and dirty bits are not progated via swp_entry
 			 */
@@ -4950,11 +4950,9 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		swp_entry_t entry;
 
 		if (pmd_write(pmde))
-			entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_writable_device_private_entry_from_page(new, 0);
 		else
-			entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_readable_device_private_entry_from_page(new, 0);
 		pmde = swp_entry_to_pmd(entry);
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
diff --git a/mm/migrate.c b/mm/migrate.c
index 4688b9e38cd2..24e3ebbab1e1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -399,11 +399,9 @@ static bool remove_migration_pte(struct folio *folio,
 
 		if (unlikely(is_device_private_page(new))) {
 			if (pte_write(pte))
-				entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+				entry = make_writable_device_private_entry_from_page(new, 0);
 			else
-				entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+				entry = make_readable_device_private_entry_from_page(new, 0);
 			pte = softleaf_to_pte(entry);
 			if (pte_swp_soft_dirty(old_pte))
 				pte = pte_swp_mksoft_dirty(pte);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c876526ac6a3..0ca6f78df0e2 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -836,11 +836,9 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
-			swp_entry = make_writable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_writable_device_private_entry_from_page(page, 0);
 		else
-			swp_entry = make_readable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_readable_device_private_entry_from_page(page, 0);
 		entry = swp_entry_to_pmd(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
@@ -1033,11 +1031,9 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
-			swp_entry = make_writable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_writable_device_private_entry_from_page(page, 0);
 		else
-			swp_entry = make_readable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_readable_device_private_entry_from_page(page, 0);
 		entry = swp_entry_to_pte(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
-- 
2.34.1


