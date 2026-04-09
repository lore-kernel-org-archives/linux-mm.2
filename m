Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EB710FC456
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 01:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74B86B0005; Wed,  8 Apr 2026 21:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE1B6B0088; Wed,  8 Apr 2026 21:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EDB6B008A; Wed,  8 Apr 2026 21:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B51BB6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:46:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5141113A8B7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:46:57 +0000 (UTC)
X-FDA: 84637328874.01.122DE35
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8659E100012
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:46:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="i7Mi/nxs";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.43.9 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775699214; a=rsa-sha256;
	cv=pass;
	b=ts3f0dQDBSsG+HDdWhhJH5JjqOVwwii7VsThBakEpT0ge01Zj7ZLthFZVaPTGXLi8/NtZo
	5/ERg73MmZuqnNk1Jvm0Z1yUFXUYUvDL8Nq782WmAzKRI8PCqqZD7Gu+0Ycleyhc9UqL6u
	xNmQjNHYK1RJ/JB1IZwgkiAwxEgePWc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775699214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cgZwUsEp+Fou+nbjZzChxWuB+FnrqGbSddTmQgmRT50=;
	b=AvvbA8MYBvkGyimuXcoH7psaZG+/EI4BG+6N2/SbrJCQKj+tM3DZj2LJ7NZJIkzKPmYmKc
	r4ZvBJqHK92zjeDvzoHUI2UJv7RnCww/AipjBh7+rPzWvscxJx5baQuNzixhKDUT1tq9ku
	dYCPZjRCCMmKTp/sj5rsOWV7gfNgR5s=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="i7Mi/nxs";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.43.9 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSGCNSA3/DwpUqmIMcL006KaM8Jv6r8lvoH0+I213AxnzkXlTYaBJqP7glVKBB2Erk6vJyuhkB3ijXZKWKbp0gY0yHVPSIySrPWGK7WmYFVMtjXbnjG3gsc8ouW9pfmXLiQV4CUzpHA4hQQZAIDh6GGAbRWixA7lVD+mGRe9631enH9ZzW0plKwhQaNYHLdwktxELTg/35Ko4uEZxVxHrTZxTcuASkPF/3e0ivV0XCfeBfqwK/PekK/bHgf0E09gtwoADZ43WynXcnDkUyo7ZfUhkhXNG12ruXdN+bRw7nmGEftHEm58fes6glaiSO46ZS5HEKHDxMiAo5guDT3UKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgZwUsEp+Fou+nbjZzChxWuB+FnrqGbSddTmQgmRT50=;
 b=MtYKx8jf8XPKYgGtuWpG0e53+Mk/GLoBVibWitZCwfOt1+xRmvMefLpMBVO7u8aFLo+pTZHEOCupUQq47Wc4a7LBcrNfHXPCxtZC4GRn4ptdjjX8344d0mrjbXlZ262FeYzvkOclXeOe/OG4H0r98wCVOzweRHe3ZksCoqjfVAkBpsClUPMLtIA9hZoRjdjbaOAqwWlzQ6QkOmJnrL1sbzetb/hcDp1IZrxg26oKbOmpaXjvIyx2rw+c8hC78tPZytjQk+mA+kt4Omc7Bl/aunDLLQAS3MphYyFgju/OLJwJhYWdd4mY0mE0M6YflV2Wl8GV2+VsBNM7u/llfA2OYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgZwUsEp+Fou+nbjZzChxWuB+FnrqGbSddTmQgmRT50=;
 b=i7Mi/nxs0lRTUxYoI/fBw/5lhxAv2wI+WzEWIt3OpeZF9MBISYgxyFB52THMdLQoMCyd0vfOos4RN+GMqyg/SquArTRPqjT90Ytlj3MN0/cHGWTn4vteFwKXKzCKeLr0RjEcgkln3gSaBu/+n68rRLEUNBfCJ9DpXH4tpF4sQovLZrumxkZaTopr00Us4HQwK6MspGohL0JCdv5ogZiILRT4FYy1uZwl3IEle03x0Ud4xvuyfJVpoU6MEYWZHx40Ti4RpyW78P5dVZIBn9AQBNXHl22/a6RiLVV1OkeO6YQBaFDKaznolvzGGGb9a9fomOBawzDcWetAnpz6IkHrIQ==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 PH7PR12MB5734.namprd12.prod.outlook.com (2603:10b6:510:1e1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.18; Thu, 9 Apr 2026 01:46:50 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9769.020; Thu, 9 Apr 2026
 01:46:50 +0000
From: John Hubbard <jhubbard@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peter Xu <peterx@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	John Hubbard <jhubbard@nvidia.com>,
	Sourab Gupta <sougupta@nvidia.com>
Subject: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0 folios
Date: Wed,  8 Apr 2026 18:46:47 -0700
Message-ID: <20260409014647.397515-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.53.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0217.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::12) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|PH7PR12MB5734:EE_
X-MS-Office365-Filtering-Correlation-Id: 90a5bbd4-4add-4eab-16ec-08de95d9de4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	R+t8kLQFMFYqc845dogzneOg1wRZYcrdGGoVawIXZrt3F4ZC23ySCZ3SAvjDDYktTfJUUhEt+JnrJ3fPcu44whKnFyAN9WldQpJKZRG6T2VJN5m2QOsOPA36eBk4CkYS3Qmujrbb28lr8gUgiJyKVcCbR47lyAhDD+jM7YfPK5+OUamevu6Ow3keSzEkqr+eF8uBGb6XqH3BbV6Qa0cnBorXpubddIiHtlf2+TW5mEq4CIt00PmbSxx/lZrCZTJH1x5CoiQKelhQ1CnqQ821ztx2KGgGR5mF3wIvSMDydFe7RSlKfO+6O1kakTR9AGyZSygni8mH9rJwuFddt24kmW5bJRkyV2452sqVdxw9THsRnId13WopVSQKiMBLVNomH+xwYUDTimBswiNLK3ydAfreX+nGGxltfDdcCiqeMNApLIr/RRfF2MOVhmSg+gezzgwp19r2EA0SnrlBzfig6m+/d9LzBDi5LFGO0TPU+Hhe+28GhrVvKLTegI17Ar4mVyKGAmDJKHd8nxHGCkeRJRbWuYWJfghp6Nwc/E5V4GSw4xF46B/AH2ZqAz/I1MCbLUeAqUkVxKXCctJmi6yRBXNUluR7E0V3QjhJoXliOqm1oZsWTipNOSOkyEeNcZgyPkMCKbeSp4IGgumqNG7GT3gdiWUTLmmmVwaefLyxd1Ka5T92aNVnHqarZhphaAKzy9op5uIP8B8QSakiOSkNMEZROe4zu9WSPFLzFXwpG+o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9+vh3JKzpxhsmoPUZznmpsPDSOYJF4pc0GhUGmdcfTcuu3AsIV6dfuQAN98x?=
 =?us-ascii?Q?o3GTc+znRXO7uBx4tS2K+9sFdtA3Hde7Z/l8vnlbuySx2PIgqyLDIoDSLa5W?=
 =?us-ascii?Q?mUS8pHLpgf23KSeLmpupKz5Dca5jhykbU3DJyMdYBq2lJJk2Kw6/vABd7TGM?=
 =?us-ascii?Q?srFmrOaEZGEx35UKsC7XsVtvGQpWzA1W9VCTXKS/bElOdcJ0kRW+0P7t1IU+?=
 =?us-ascii?Q?xpfwoQ7VmIiEpfc8wVbPCazNx9MW6N3smkDqXxzH2SAV+dwcf4Z9X+mcuWka?=
 =?us-ascii?Q?2ySiUxS9updlbCuMmdqpXyoEMtC3Lbpe4PJOmn7PeX5MiVwuZ+ncVmL5E5bA?=
 =?us-ascii?Q?tpT2xfFtnDFbV5JcGs9m/Z9h1P4FGcAhWYTZUHYyjGXVKgxyXcGyr4CAhRx3?=
 =?us-ascii?Q?NuT30dC+d4RoZJ1nGWsCM3j5wjTWgNyq6CCOAloQo5hU8gJMm7nV8ZTUlALt?=
 =?us-ascii?Q?SF8frB5JCsJ/jB79XuzHkHrXYKrA/qVccdBY6qAWtF1LJAzRKJVwLpG/gjbT?=
 =?us-ascii?Q?SJVtQ/r9EeBM9wPOQfH49OzP3lpDP322QeoieJpesquzyoIB0ETggZzKLniR?=
 =?us-ascii?Q?je/ta1ozJcBtHieWttr4c+f3D2ZlKaZ6I1tMLYrXoOiZRnpx1Xp4+yPTUwEL?=
 =?us-ascii?Q?xsdWy0olAnBzKjzCcRBx511e4T+K43Q68Bkfgl3FcWF0hhAtjsQ2E8A+snLV?=
 =?us-ascii?Q?UsQEfsa00cY11yXpqgddptV/1c0qkaJIyWtOyhXrzYcal95+QWgS9FA/RIqY?=
 =?us-ascii?Q?vCYePZJGBnCwr7xhm3hSAcU8u0zYKuvIu4kmLZIIhpYZWhDTeJKN9WjbUzGa?=
 =?us-ascii?Q?U/vcR7WBt5TJiv/02xe/MtNleHcYDaas9w3/RexfjNyNVj4PPEGlZxzgZ7Xi?=
 =?us-ascii?Q?pllvyJVOza/Edfq7rsu+UurNOI92oACaGeXRayb9ND8Zz1v0kgfVL2bZiLHb?=
 =?us-ascii?Q?pmMGYF0jX69Mha9F/jAribwQOgCzvP5QROrZltIB/oqMAilWGKoeu5M10y8v?=
 =?us-ascii?Q?H8gs2pcKk29dzQRHz7c16e2UaYVOAT3dbSSgVpGECGBE3NU7kDeZxexRMIBy?=
 =?us-ascii?Q?1S16owCLTpowpkYudTfVErueLwQ1VHBVz8AII4NIbjztbnTsrPUHIxuLzlTW?=
 =?us-ascii?Q?4I0VZDLt74c0JhCBFgK9XIlXft4nVyfQovFDPaMkc+6BB2KwHY2HL4Cs97UZ?=
 =?us-ascii?Q?mgrVhhuyJ0V0myi2QJqU65VomXApmhXlQi2LmfafFEMLt6be2yBM+QIR/6Hr?=
 =?us-ascii?Q?wTGPFfvscBGKASyPcYTN8YDT5EXHsbcHVXqL0Wh5lW2MB9XzHcBV+2+3gBx4?=
 =?us-ascii?Q?Qidcip1UKwkB4VwLFsHQzZf7nGPvWkn3FKuRFw3O44Wb/dSuWqrXlbL3wlV2?=
 =?us-ascii?Q?//xLbPIzpmLCkEHCqD0gBLCIej7D7TUxcoaWX9HIIJXVpXMb0/m3l68hiUgA?=
 =?us-ascii?Q?WAGY/vBbA/HmgpUTxFwMxgO0ZQUT8Ejwv+uZCdPBz42S3ajDcbODCwjwFGiF?=
 =?us-ascii?Q?RB6R1lePWV1kM1t2rYSNdgq+lN/zNZZUY75ejCAhCx1e/46e2J7sC487CyDZ?=
 =?us-ascii?Q?fPBvInlKNpvykxg1amQjfEs6h/F6C7269+D47G6e9+qmniBGI7i6BV20/ka0?=
 =?us-ascii?Q?Jxez5eqKd7aExPtQCJWvvhZNgQI0nPMMmfcRmNftzk3pdv/knraGtS4lGyu3?=
 =?us-ascii?Q?SmzPM/uBEDxNLCcMyFrSHtZzSaBxxE9Qe46FiFEJ60gnBtgH4vL1MfOZPwkM?=
 =?us-ascii?Q?c8qLF2yv3w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a5bbd4-4add-4eab-16ec-08de95d9de4b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 01:46:50.4731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxzElzRrps0C4YueLbYY9kZfkHON/W6xmFM8cJby77kJkutcTG9pBVnn8lGl4KXgkjbOTkyu+dw3ZEdlx2ztqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5734
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8659E100012
X-Stat-Signature: 1zsp5dauwwpcyd6xkqqnmet7q9gk9ff6
X-HE-Tag: 1775699214-94685
X-HE-Meta: U2FsdGVkX19aW+56R4FAeOtEQkJMX+n2+E81UFAQVbdVKUf3+a+sW8GNGsaFOECVdth85qFd+X6wxkZONVFVjQ+0OM3SdpbGU8Ma1F0zMIt7H9qwC76pd1c7LY/glVrjUmoQg6zaEFew+b6+E1RRqipjebOqsbh3G4m9PI2pF4PNmibutIfMm2v9GlIBs26TV3ZGTaLWvBNJIDG6XsYkCSPl0nHDu6cIJ/4ZsXHbfztO0voFr9cn9a5gdi+5E8V1zO7i3UyL4kvJY0cHniSZGiPUL+D9nVeDKLH/nDkO8wQgcV4763U+e3/75xUASFELCy+7lCGYxPvLY5KaKjHXd5UsGq5dOdwR6uLe87p8MjreAz1FUl4lQ5OAxLg5HkTZ7Us4RBnjo1hHy5Tz/vqk8mLV18f/U39DTMx3SWd5TFt220EskUIRG9EtlVED0N2enDZr/WhpfsDRReSCC24TLiFaier0Vssv0rHZaCtkMd0ba5+TyXmYA1Rz2KqKEIuNCxKY/hGhJECGwvMHJ4HmrmF+JpPvP4nPYM89GS2tPcd7IqdUERE6iNj40Qhhx3H5UAQVPdZznK/AmhmsHEAFyVbldPB0j0whQKgOANupX4ZyOg0UYSqsEN4hxZ4DhcPZvmMxpt47Oy/xN66Mi60/rmbHZO/ZNw6viiwhWTtYP+WhiW0TAITG0CveTQCClaIIAIoeXW6PON5SwL5BcesaEE9hsRZLwvmpcFZqcPWiYY4TBV0uqNmUdMQwNNc2kq2EyIlWy5U5oJTrC2VlQgR7p9jfG4Sfa7ICdeN/VbphRh+FiO+GTUbt5njtiTKKCycHykZonU/kSlRMntP0eT1lk2DGM2/SzUbOmtf71SO4aCtxSFzZqY9s6CvMg1uGmVNu9gzCZEgynFdicve8rErSvdjrUWzWPEHq5c6G+Dn4JAEJtZ9IFR2h36UMnr7ixfyAR7yImtw1QCiLzLi67z7
 jrz4cZH0
 nZfywqVTY9+/GdSdUMVxk7LSTlq1JITEH5qZ0bMJtXdLZoC45BtIpyLEAb5yLjQrBy/6OrQu/619YVCzBSseI6fQWzDwdJDdUPhzH+z0B9tURdJ2rxcBS6/+IY80NY9HNjbwD7xnt/Wgln4mGgksIfv6ttEjNgfk8VwLvJzeh/HOSSRE0fhEprjWiv/HJN8SAfcCooURTNj4dGnpYBqNp+iYS+L0i9HJys11uXOiiaXwu20ghbLZX02Ubg8oXyXS5NRY+u1jxXEVHr9o3pxBcSgI0zHoQagQb7AUABT8biovE3rpANA5FWB+S4Gdxx7V8kWVV+U0kN+IEcjnEZAMgqNYHljmP15svj6X9UiDCrXLFs5zsC2t6lred6oJD3BuafKmF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
gup_fast_folio_allowed() falls back to the slow path for any order-0
folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
performance regression for drivers that allocate pages with alloc_page()
and insert them into VMAs via vm_insert_page(). These pages legitimately
have a NULL folio->mapping, but they cannot be secretmem pages.

Secretmem pages are always added to the secretmem inode's page cache via
filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
A folio with a NULL mapping can never be a secretmem folio. The
NULL-mapping check was intended to handle truncated file-backed pages (a
reject_file_backed concern), not secretmem detection.

When only check_secretmem is true (and reject_file_backed is false), a
NULL mapping is sufficient to prove the folio is not secretmem, so the
fast path can proceed.

Tested-by: Sourab Gupta <sougupta@nvidia.com>
Fixes: f002882ca369 ("mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6ee73..3ea661e67eea 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2784,12 +2784,17 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 	mapping = READ_ONCE(folio->mapping);
 
 	/*
-	 * The mapping may have been truncated, in any case we cannot determine
-	 * if this mapping is safe - fall back to slow path to determine how to
-	 * proceed.
+	 * If the mapping is NULL (truncated, or never set), we cannot
+	 * determine whether the folio is file-backed, so a long-term writable
+	 * pin must fall back to the slow path.
+	 *
+	 * Otherwise, a NULL mapping proves this is not a secretmem folio
+	 * (secretmem folios always have a valid mapping to the secretmem
+	 * inode's address_space), so in that case, we can continue with the
+	 * fast path.
 	 */
 	if (!mapping)
-		return false;
+		return !reject_file_backed;
 
 	/* Anonymous folios pose no problem. */
 	mapping_flags = (unsigned long)mapping & FOLIO_MAPPING_FLAGS;

base-commit: 7f87a5ea75f011d2c9bc8ac0167e5e2d1adb1594
-- 
2.53.0


