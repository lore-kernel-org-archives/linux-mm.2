Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 266E4EE6B43
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A956B0089; Fri,  6 Feb 2026 13:08:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718AA6B0092; Fri,  6 Feb 2026 13:08:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2CD6B0093; Fri,  6 Feb 2026 13:08:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4D66B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:08:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E365C139503
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:08:47 +0000 (UTC)
X-FDA: 84414817494.08.5E5857E
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010014.outbound.protection.outlook.com [52.101.85.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id E1FC71C000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:08:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ipww/TbM";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770401325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7riYsWGba2mVWlXppRYKpiuuG8Hi6hHEHD+hw1Z+F4=;
	b=fKs8ZHf4nFlUj0CfmH2fmerHBsh0lNJGWemPP85Jgh+gfsIhuShCXziBw6XniefvDiulSA
	q7ptVfWYTVT1tQE0kG/nIO1icPgKFuHJ0bxaOcE7M7VqRSZC4w5zd/AIo8IFTi8M61CyiT
	ShJef2GOwfVwWz86QhpFAxO1ePEMf9Q=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ipww/TbM";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770401325; a=rsa-sha256;
	cv=pass;
	b=q63/N9EWlUgmRRy4h4BuYdqAMpfNEM1ChJuruu45eTVd9JCuKX5G+rXWrhCSIaOYr/ewNX
	lO/9EpBgOVZ0v4oPGt0ez7aLwb1sblm4B2roeK07Yab8AuGgT0B5drTAL1DJQ2ugjObKOt
	JOXD2GcUx2Ah14rHZ+EWJqFiLKJgX/4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=osYuA0lX9fmGU/l+T9S8FRvykJkAXmnDklln0AYt+z++8ZDXGIED7QKWR2glkE7heKuRHC0Cm/K3Y/IoPSepe4TW1dzZqunvHfOIshs2+P8+yQEuevGGsh+lFUvj4FcISae56RHlD+X6h44QyCn+hZ0Y18O3Lltjnc+r7KRZxTSM5jPmCoMkHMf5vyirJrz/WobmCQ2R+zNdKt0UTZrIL84BRpgulLXnax4/S+2+z0Y4h39iAsEYBL7NPW7mK0qt5/BYnih/ZfTU8/obtVj6UGJU7Xwb2xZp8cXUOkNv4eBA+lzFLo8RvWJTONYj5DxFKzofPrzl9wuT0inM9Zz+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7riYsWGba2mVWlXppRYKpiuuG8Hi6hHEHD+hw1Z+F4=;
 b=bwTKYSt7Xq9zXiJzorgo6Zco3U1I8oeucj1qq1KffcX1IDgLWlVFbpbrI+azW/sKaZ9fiGP1YmNUKccQtCtvX02lgYQ4mW3AtRKjib83SX/n+pVi4Czi1MlcN0I5AriG+mzSCWoQFXELP2RUea9/p5l2K0TCmONhVDGvFIzkBt+rrp2O/xk9mFslS7fkwgCkPD2RGdZIEz5l3/a1TxZ30zcVJ+h8Wm2nTH4ZVjW0sDGD16HdIVM/HIJmH8Au6yACdFAHbsaDL8CV2ZB/2ijUknWOcxoyC3zLG8uukmTeqzmnmz0QqinCGTR77S2g6Gfh2ResTbTu8OM8fBFzASvkLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7riYsWGba2mVWlXppRYKpiuuG8Hi6hHEHD+hw1Z+F4=;
 b=ipww/TbMYIG53kIFEKWG3DIIWreuNu59QAlk4PRbzXYwZMUfn9/LeXbvbrPRWw1w+4nACI9W0naEzT9gwhigZSwMGEwNuQpzcWl/hFzk+y/egafGgT9xOurJYMj9QoPDJH18ddB3YfpeaWLoUobr0+BDZFj2IcAvUhc5D+h7MrKynsf6zu1yTEATVQ9rAY59jFmDi6YtAShyjGPdk8cCl677DbZCDpARAclZP5LzEHCrZsQDBL7NQxGiGD4WQc+jL9t+5TWb5JvePBSpu1dXpZT8rrXr2PrcvwqofSGExjRwIS8qvJNpI2BSV1xJNEfrsKI0pFi4LRJ43PU2Di0beA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8325.namprd12.prod.outlook.com (2603:10b6:208:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Fri, 6 Feb
 2026 18:08:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 18:08:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, ryncsn@gmail.com,
 stable@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 surenb@google.com, Matthew Wilcox <willy@infradead.org>, mhocko@suse.com,
 hannes@cmpxchg.org, jackmanb@google.com
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
Date: Fri, 06 Feb 2026 13:08:30 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
In-Reply-To: <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com>
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:332::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: db8dd7ce-c8ba-446d-2cb8-08de65aabf02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTREMWZ2NDNrejNtWXdFOU5iVlp5RitVUUw3YWpqeWlqQkhWcGFBRUp2bE14?=
 =?utf-8?B?TFdEdnBab0txWXVnVHdIZXdpSXppNUZHcWlPVkZBMWRHQlhENGl5aXBFODBH?=
 =?utf-8?B?NWNhczVyL2tRaHdtZkFnaHlXck4wekZHZXdrN0M4WjhNL0FzcDZzVnE2Zi9J?=
 =?utf-8?B?ZGZDclVINzdBUlhOWWZPaE13K3k2Wkkxd1BDdDhaSSs5TVBDb1B6dFIzd09a?=
 =?utf-8?B?enJJUWV2T1dlN2psWkczaDB0MTdaZnJCSmdIR2xKbklXbEt6U3dDbzlnMkVw?=
 =?utf-8?B?YW82aVlhZEZWYk9SbEF4UEpPZ2JYVzdXK0FyTENKZ2JvN2hnTWJCYVg2ZklG?=
 =?utf-8?B?YS9SMDVrZ3NFWUJXSU4vQkRRZlVUNWtBOHUrTk1kVE43dldGRnkzTFN5eVlP?=
 =?utf-8?B?bXBEL2NPTmNOcGZEU3hWUkNvVWpHanc5d29UVFROa0s1amVuczJUcG0wbzk5?=
 =?utf-8?B?dUFCM01veWx0WXlpcFF4ZFhEZ1JPTkEvem45RVFkdU1lMWRlYW1pcGRMUUg5?=
 =?utf-8?B?TnRMZkd5cFJ0eEEyd3RBQU5zcElrYmY4d1RpN3ltOVRYYUEvcDR6UmJ2NjdO?=
 =?utf-8?B?Q0dQYzFrdXZzcDFpR0JYMis5L002U1V3d2x2Q0tyVEFwaE1KY2FZOG9hM1My?=
 =?utf-8?B?RzJydmlrN20zYkl6NVJqdTZSeklYU0xtRGZDQWpxSys0WDdjUm9lZE52Tk9k?=
 =?utf-8?B?bTBsSzZsRlNKZ3hLWWl0SWxmdXREMFBCVnBqNTJib3Z1Y1hHYXpTOGtneDZJ?=
 =?utf-8?B?bFlERzlEb2ZFS0ZMMHJhYndZdXBpU0ZxSkJkMGRCSlk5YzBDSnZUMWtLeXlE?=
 =?utf-8?B?Y3BiVHR6aTZzQ1lRZE9xZ2RCL3RESk1IMjgxSFcrZk1lYzRPTVFRUUN5L3BG?=
 =?utf-8?B?V2xhaXNMNlNFZEFpNWN1c2VGRUY3UzNCUjNaVzNNd3FTUGlRVE9BTERwVFVv?=
 =?utf-8?B?ajhBbEozK3N0aC9aVUVKaFdIWkxzeEtHSXFFendJVnBBTCsyNnlKR2JGMEF0?=
 =?utf-8?B?U2xoNTRJV01wcU5RZzN5NVVzK200MkxiWWZ3Y3RRNlFNNGhzd21XaEVEWEh4?=
 =?utf-8?B?WEhqZHd2bk9CdnhsdGhBcDBEeElNanpvUlpBN0hEYXNnWktiaVk5VUYzRnZO?=
 =?utf-8?B?OEpuRUI2czh3WlNsKzFQa3FxZUdYa01BVkM0b0pCV21lNTZIR2JaNjJvM0Q2?=
 =?utf-8?B?N2VxaVVPZnJNOWE4clZaODdaWHdUdXQ3VjI2YURBc3djRm1DTlVlR3I4anU0?=
 =?utf-8?B?dCtic2VlV1ZPdmhjemZ2RHV1bUlGdGxMNk5JT29rdW1SNG1ldld2ZldRTldx?=
 =?utf-8?B?UDFTcHBhbVQ2a2ltZDlLdXA4Vnl2UEppaEVwUkJHaUNydHREK1RWWDRvY241?=
 =?utf-8?B?bCtJYzVzRjJadERBdW9HQUwya0V6U1k1bDI3S21xeU5vYjhkZmxjNjZvUjNX?=
 =?utf-8?B?ZjhBZ0lRMk1va2grN2JBVWJ2YjNrdU5uZXhDZFhGSEtMdlNwRm50S2Z3VElK?=
 =?utf-8?B?cEhlcXRHazNjVmlVVHBNdUtUZ25NRGZTa0NlOGl6dlpDRlNCVnBsY2lDZ2ln?=
 =?utf-8?B?WjZ5QmZZUjJwWnZBaktkeWZ3bDhJR09EU2RFWXlSR1Z5eml1aUZzK2tRRHJM?=
 =?utf-8?B?TmtMMWFzeFVQbmNjendndTRiVS9SZGtOckhoRUI3NWM0QmdoYk5nWHVqZ1pH?=
 =?utf-8?B?VzlQTkh2dkpjR2VTN1M0M01PQ0w4cVh4ZEV0aUJzUGRPR3pNWEJBMW96ZmlK?=
 =?utf-8?B?UE9FWm82L3hhZWpNaGVkSWhzTU5GVlZXWTBkdmppYnp3MHIwTmQxY0ZYNWpC?=
 =?utf-8?B?eFI3Z09ZMnRVbHlJN1g4YnVFRkY3elBVb245YXlHdnVKcGszK3I0ZVh5N1RE?=
 =?utf-8?B?RitlYjlCNDBUbk9OOFI4QVNzVkd2cWtIUExDQTByQWxPSFdMU1ZGVGFIem9P?=
 =?utf-8?B?VUxWVGlLcEVRTVhIcytlVm5MWTN3ck92NGtuZWRmWURMcy9oTUhJN3ZpMFFY?=
 =?utf-8?B?V2JVbnU0WmVycVNZNkpOcnIrQlRwYnAyMVJGMU92YjVmZys5aENsRCsvSDNp?=
 =?utf-8?B?YWpZQUQ1dW9GdXN6QUt3OUVGWjdxRHFiV0lJUENyYzRSSzlzMUZwMmt0Uzd0?=
 =?utf-8?Q?u1Vw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UklyT0E2eU84MzFzVERjTHNZMkNiZGRxaXByTVdaYmpTQmFERFU1cmpjZ2RE?=
 =?utf-8?B?WXo1cUZacUlYQjFNYVhmc2Z5cGl4NXgySVVKUFNGS0VPa0oyWTFEQTl5ZXVT?=
 =?utf-8?B?cmNzVldwOWNoK0FnRXhIZnpydkkyVTFEMTJNenkvQ2ZpbDZDR1FlUjRJeVgr?=
 =?utf-8?B?ZEw3K0dibGE5ZDVqVEhVWk9IdmFGVzIvczB1WXVnSlhSQmhMMDhnak5kampx?=
 =?utf-8?B?bGFpMEhWemdHOFp4YVRic0NISDF2VmszWWxtTXB3eC9ETlpObHpINi9FSjFj?=
 =?utf-8?B?b083eFFZOERMQjdXM0xtQ2pQdTJnTEtkVW1EelMrcFpPblVZTG5leXRqSDFi?=
 =?utf-8?B?SFRkVjVOQlpUYU5BTTRaTnBpWDJWdVFWcFF6N2ZuK2lKUDZEc1NKalM2cEg4?=
 =?utf-8?B?N0JZYTE3b1BNWWpXSFpSWTJZb0hPdWw1NUozMjl6alZDR1RKOE1SM2lJWEE3?=
 =?utf-8?B?d3cxa2NZazFVVjdRdFI2VFlQbVNnYUV5dEdSU2hsQUx4WmZoNWpZOHRkVlNj?=
 =?utf-8?B?VkxTVmFVYzVUWkFKSFd0SlJkUkxCc3NhTE1KWWhwNTkxMS9mMDVGcnRJdk5s?=
 =?utf-8?B?QUNNNE5DVitYbVNqSjg0bVpqZzQrYmhob1FTdVpFME5XZGpOWEx3eUxPaVpt?=
 =?utf-8?B?KzhWNElCK2JjcllnanR3dHVaVGxSaVZPSHQ1WWhIc3JmODhDd1Y4SmpMaTB3?=
 =?utf-8?B?WVIraEFtV21vRXFXdXhMYmFMTjNhVWNjZUtEV2V5MHVUd2VqSEhOUUFyOHQ0?=
 =?utf-8?B?bDJ1Zm5DbnpNQkcwN2oweDZLci9FSms0amZRWTFRTzJmaHh4RVh2MXRja3VV?=
 =?utf-8?B?bTU0THVxYUx6VlVsYm9mV2g1ZVNXdmxTOXhxakhUSjZ4anhQbTlpVVlxblVP?=
 =?utf-8?B?bnlTUUlpbGk5ZmtnREtyUzA5QXRrS0d1WXdFeXgraG9LSUVqOHZwNHVpc0xY?=
 =?utf-8?B?VGs2dnJ5Z2dFaklkR2twNVpiKzNyb2haRHY5NWs0NTVHNE5aeGVmeURsZlVn?=
 =?utf-8?B?b04xVWVOeWNTekFCKy9WckdHbGJmczk4cytUTXNtUHl0NE96UjBXYkR6Z21z?=
 =?utf-8?B?bUErMkxNQ2E4QW4wc2QvRG9Zbk83cFk4UStiSUNreUZaNTlCT3haeEJQZ3Vk?=
 =?utf-8?B?SEc3ZE0vRjIxZ05qK1dLSTdrVER5dzBLamx2dUxxRXJwalc1MEdweG1iSFpn?=
 =?utf-8?B?ejhZNTMreWM1UlZRY1BTOXN4MC9nTmZveE5YaWxWRUVWdUs0dTlwUVBnVlRE?=
 =?utf-8?B?QTl3bVpzWHpWYmpEblQzeFFTa1huRW1UWUtOKzlYMEViZGpvbnpodzNmREY3?=
 =?utf-8?B?Q3FjbVEvbEJURy9rYjZTUVhaRXUzK2l6WURnQmNLeFVjMTNSYkFQb1FWZUVw?=
 =?utf-8?B?R0Y2bFNyL1BlMTZyRUc2aFZseHVmMU1MSG9YR1pFMzV5SE9oc3dhY0M3KzN6?=
 =?utf-8?B?UEx5S3lXa3YzcDk0VGRZbGRYdE1rdUdUZkFPWDA2N2V2akNqVUI4bDVnMXNn?=
 =?utf-8?B?MmZpWjFqNUdVN2NINm5paEhaSjZGUGFKbGVFRVlpdzZ1U280UEVaMjBrWmk3?=
 =?utf-8?B?YU9XY2E5bGFqajN4Q0dDUWtUTmQzSVEybE5NQUdibGkwSE9xVUgvOThnZWVG?=
 =?utf-8?B?d1IrWUNxL21HVlB4TjdjRlNxZWZSRWt4OEJsZFZSTkRYM2QzNW9vVXZINEEz?=
 =?utf-8?B?b3Z5d09qNkJxQm5OcDJLSnlmcDR3Ylh2QzdWWFFOSGc2ZHJqdTI4Z05PTldD?=
 =?utf-8?B?VGo5WU9QWWVML2ZOd3lOQ3JiTGtGdXI0MnZ3Zlg2RjY0aVJtMnhBNzFQZUtP?=
 =?utf-8?B?NXoyVGpxY2MwMkVZOEp3MkhFbzlsWml5ckk0QWNPZnE3RWtZVlZwcXQvZEFl?=
 =?utf-8?B?ZUZKbTZWOFc2N2dITm5yNFhkWVN0OUlYYmtpR2Q4ZzV4OVc1anZPWWxGWVVp?=
 =?utf-8?B?QjNQbGk4UjMxVzd1V1FvaUMyanVla05qam1KWC9hajVmSHo4YlY4SFovRVFV?=
 =?utf-8?B?ZHV3SXozanJtM0VWdHA4VVBkMjFwS2NwWG5RTDJpL21IYVVjRTJkY3dVeGhu?=
 =?utf-8?B?QmRRcXYvdWUzT0JxT1dSZytvZ0VVL1dqeUxpaHkvV0l1Qzl0WUQ0QjJNeHBI?=
 =?utf-8?B?eWc2WURMUWlWQXZsOGRwODBGMjBvWmZWN3BzNENVaitIbXZ1Wm9hVWQrSWtk?=
 =?utf-8?B?WVFvemdIbjBVRUZ3UmU5dlFNSlZvNjJtc29MVlU0QndsRTBXRWpVS0x3Z0FJ?=
 =?utf-8?B?OW4rczVGY3UrTGhkbWl0eW5UV3VDWXQ1ZFNHZmFqa2lEWlRwQ1piWHhvcmZS?=
 =?utf-8?Q?RrhIsQrus4Tkv0rkHV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db8dd7ce-c8ba-446d-2cb8-08de65aabf02
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 18:08:35.8300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bLSUfiXezz5rMqipMGLO1WGnK5zEwji0SVCnwZz+echvzNaW7uvHL+VWFKprvCTu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8325
X-Rspamd-Server: rspam11
X-Stat-Signature: 7anqjz7bj4hfrk6aup4jq9y4owwk8jdj
X-Rspam-User: 
X-Rspamd-Queue-Id: E1FC71C000D
X-HE-Tag: 1770401324-130857
X-HE-Meta: U2FsdGVkX1/xX1Zc+3rO6ooYR7vL1qwbUaDjIQLlvxTpyTMtDSRbx0eK0YJTKT3NwI5hBd2mD6kabQ2nxOpN6MwU3RPJD4I75kbYuZnPofFDpO5Mc4FNJ5zm1syRqwTV62RwGqy71R1pjrEImkkWDH9jQMmNyE+VO1iPu02h6TCOmEWzhxHxz4avAfbebt8LwdU7CeBpZ8VGE+pBZKBOI9ePlOk9nVdwd/udR80rqpJe1eFoodrJpyDMpvR1yLjLj1mm7s0iKroz69+cysVJ+75lndv4xtRgzpIb4M0hX8baTuFmFcam412K9AuFHQDtWrLIhsg15V/QA+5rdJvQ0xsx+O2peLAws1zlqoS534UmVVhqc/JnNPGIOMkmfRdgyB47ViM+bygjYcHBQ4z4rGhdaMO/J3pOR8I3Nj/GpMURUYNpSUvmjNQ+E293B4xPK0508D4Po4yk0W6lmoL8NsBpoYwNSpi+oM4CYshHk4k0ad7d9/qIYgpQPv1uKadBLV/zSHNZxX+rsptoQr/kmLjhyGXGjQKetdk6Re1sr046M0if0iatrtLXVY2Mva5TBbYihe+H2awmdLa2aMcp/WWSxZx5sdzkZqyYWKMoWHl+hoVOP10hQ1azO0aF8unIOLMWVFSQEKMWy97F1ePAQ+/zlmapkTOhDLMrD73nzy2M4N0Rsc9hMVN6KwYLBTrm4tvKaXvspgqGHp6C8MPYIwhrUj2X1v0X8B7kIiV1iiT5xEBZckW2/fO8F6PfahAx/PpdmUXnPPBFNO2k9tD4WJuHrOnnKn1xqv/dn3QzC2shvNhSI0o1pUw83GnHdNhdUkodeBpB7tw+eXQjKGYsugdyLLrIDbRzBu90SJP4vOGbeBJw+p292q2MH3lEJlMLtu5V9KSB25Lmn/5jhdQKYvu0VDsD4u5m1spUlDITh8WZO7ubk9/IHeHV8rqihLNU7G24KjkQbYr+ccTjHUp
 TalilfkS
 puLM85iOJIesanPbI2zgX7YYpLxPMHNncOZDPQ0+frne6katFOW3LM9iaoYoO6nV/JzwWTpfkwCwk+bs2qHsRIgAHfDj93PLavQl0t06tcpvZ/KdfRJO9tvXkPM2HiprcPMO4tsfICXlsRIp550k4TelBEb8Q9knu5ozA1dJL8J/5+6t8ymFbMf1HHEBlZmQznXqL6dU90uxAuWkkkkbnxNfbe991rTd3MIhmCZ4HZrIypepVte40MfK5SkZPzIhVTsd455wEUHAMU5mD2T6hU53AkN5HrEwjpRLl3kmxBUv9i4da6ZZLiZXzIFO53mVcaIqd87lfSeddgpqhXZVqYs4HUGno49vABcB5RZY76FnUuZ2A/RtMoh1kVaNelL/pv529xYIO9s7wmoQJJ0QGaFLf4GmljpamlMYFxwGt9ZMhUYpk6B0ARtn1jsl25Ev63MKJynre8phh2mNftfvZ7o4O+cnUyX+LNJc0u+DKQb62uLkefBhFAJWnhP84FXLeudL6rjFhSkXwHh3X8lbq3sBqyJ39ZTaZ90e3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+willy, david, and others included in Andrew=E2=80=99s mm-commit email.

On 6 Feb 2026, at 12:40, Mikhail Gavrilov wrote:

> When vmalloc allocates high-order pages and splits them via split_page(),
> tail pages may retain stale page->private values from previous use by the
> buddy allocator.

Do you have a reproducer for this issue? Last time I checked page->private
usage, I find users clears ->private before free a page. I wonder which one
I was missing. The comment above page_private() does say ->private can
be used on tail pages. If pages are freed with non-zero private in
tail pages, we need to either correct the violating user or clear
all pages ->private in post_alloc_hook() in addition to the head one.
Clearing ->private in split_page() looks like a hack instead of a fix.

>
> This causes a use-after-free in the swap subsystem. The swap code uses
> vmalloc_to_page() to get struct page pointers for swap_map, then uses
> page->private to track swap count continuations. In add_swap_count_
> continuation(), the condition "if (!page_private(head))" assumes fresh
> pages have page->private =3D=3D 0, but tail pages from split_page() may h=
ave
> non-zero stale values.
>
> When page->private accidentally contains a value like SWP_CONTINUED (32),
> swap_count_continued() incorrectly assumes the continuation list is valid
> and iterates over uninitialized page->lru, which may contain LIST_POISON
> values from a previous list_del(), causing a crash:
>
>   KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead0000=
00000107]
>   RIP: 0010:__do_sys_swapoff+0x1151/0x1860
>
> Fix this by clearing page->private for tail pages in split_page(). Note
> that we don't touch page->lru to avoid breaking split_free_page() which
> may have the head page on a list.
>
> Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be sp=
lit rather than compound")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> ---
>  mm/page_alloc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cbf758e27aa2..3604a00e2118 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3122,8 +3122,14 @@ void split_page(struct page *page, unsigned int or=
der)
>  	VM_BUG_ON_PAGE(PageCompound(page), page);
>  	VM_BUG_ON_PAGE(!page_count(page), page);
>
> -	for (i =3D 1; i < (1 << order); i++)
> +	for (i =3D 1; i < (1 << order); i++) {
>  		set_page_refcounted(page + i);
> +		/*
> +		 * Tail pages may have stale page->private from buddy
> +		 * allocator or previous use. Clear it.
> +		 */
> +		set_page_private(page + i, 0);
> +	}
>  	split_page_owner(page, order, 0);
>  	pgalloc_tag_split(page_folio(page), order, 0);
>  	split_page_memcg(page, order);
> --=20
> 2.53.0


Best Regards,
Yan, Zi

