Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497EDE6BF00
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB0D6B00A1; Fri, 30 Jan 2026 06:17:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE436B00A3; Fri, 30 Jan 2026 06:17:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791196B00AB; Fri, 30 Jan 2026 06:17:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64AEE6B00A1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:17:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03ABED4900
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:17:05 +0000 (UTC)
X-FDA: 84388378452.20.E6B6BB9
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010016.outbound.protection.outlook.com [52.101.61.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2ED6B1C000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:17:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=K7z+k8Um;
	spf=pass (imf18.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.61.16 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
	b=pNrhQfmIP4UzXSm23NTg0l4DWBpA8cR0DCPvi5B5n6VSvEMJ9p+KXEY4mmavZ+9ciAg7bu
	f3z57ruQB1c2oPm+DvWvbw6qDey3m8e4PM/4UhTqBjFM6XoBd5WpdhXDzUQtN33u/UJH/u
	GLVvcmtpw9MuaD2lmk7EkfP+glgwfsM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=K7z+k8Um;
	spf=pass (imf18.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.61.16 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771823; a=rsa-sha256;
	cv=pass;
	b=DtT5eHOdKuFQtQvBlUl9hjQIxcMReRBSodY75PG/xKDnEf3gtUsjAIcHaS/1L+kzvUqD1y
	sU15kjvMwV6RCS4n3TFjfW12H8jMd63+HJT3RBLrOT1c0Re6AuvpRMPEZwwg+zGqde3seX
	g1cC4JXU+Dhvi2g/j9yAXIMd60TH8Z4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iojUb4XNPhS4a0+K3Vm1GNWQPi8qIutc/QTivZ5y9LwBvqvPThZzKU0IZQHJ2KTkzvbzvJov8K3LhjuAjCmiET/lw7o1a3Pfa3+MrkrNiP0ZsFUD8z/pg0uj49Ils6atTw3t/Uk1ZAb6wmCpfcredetiNdvdgmCenBpHN258JeBKA/a/UA9vCnev9979lAKt683nSGatuifFTQaLhEre0sqyY9I2pEnB48i0yL4vv3z0uSb146Tu5WPhpqOGThFBvTMrMH5XwBRp3KA6PW4iwE8frUbWYOBMzpxYip3rS7XhO3GVjlbTrs7pS1tfWNAGvft0P+2uxGIdiprUB5bcxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
 b=pQm/k+kwolloDauh5AbkyCzQBMCbiBoxm5Hvpmrh1ydCF1RxND3aWhTyHu/Kfo6873Yc89QZicLoOX525tMfk2ps22J2iahVR2MNgFlJg1j47BGYTEQjJG4vVbGpGIWUJeaIOIgHHLs9AnIX1Wrjk0rymzu+wsgrSCfpx2ng//unlzDlF3Mc+hoHXIq670jVnw4yLVF9OtYMoo58VAgW0ExemTV+V/Tncxd3w8ImGN7Dw1sF8XCPa3wOB30omXNlOac+nacnr5P99LFL76CvDl6LDvVFy0lbpGXG3bnWnXEItZC8fikQ06xXJw9jv1SF919wSHxTWDx2P+iRHMREiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+rviONyzMsmjlkCVvAHR9/2R2g42k4emVzDC6C8uz4=;
 b=K7z+k8UmPyN+s+IWRiGcvhv9fE9M8wGhhz4pDMFRNBY3p7jGuT9BXlflA1vVpKCoaBDZpZmxe99+lB8LxMJ6e3qM7gTsOhxLpQfs0e/SKKqAkOvjN9h6f3JPjs03hQGD6D/6MMUFCFoXD7zA7uOq8tjF3ayMH8poOiWuacBRqvKj4aFskjmr0UmuJQWpUstgs5Tja6sASv4W3ZQdhJss9qUhspKLQ1nVJrAvS5rvdoX5oufX4dM07mq8t93KiD6xme2aOzWl9ieUpMZslgpyzH+17bUhNNef6U07srrcimz9Gf+SR8+Tmkv9nmy8TsyM4PYv/+pZIwM8iW7TMZ5Dwg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SN7PR12MB7836.namprd12.prod.outlook.com (2603:10b6:806:34e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 11:11:31 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 11:11:31 +0000
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
Subject: [PATCH v5 10/13] mm: Add helpers to create device private entries from struct pages
Date: Fri, 30 Jan 2026 22:10:47 +1100
Message-Id: <20260130111050.53670-11-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130111050.53670-1-jniethe@nvidia.com>
References: <20260130111050.53670-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::21) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SN7PR12MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: 44e6e9cc-e9c4-48a0-7afd-08de5ff0520b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KKVfzTrCsbRZSB5vYvDeMk/KZnVmyEUWSdvWvEpIVvIQnDik9P5NA4HFtWpa?=
 =?us-ascii?Q?sHZXsvV2cg/3pq6vofmvBJ5VBO8WlKorCgnd73VCpGsCmHEzVmE5FSK1moRz?=
 =?us-ascii?Q?ijQyG1HWMINjG26Qr8aJfYFS0TEeabcrNhXJWE5wUZ6X6Ia//GkAw9nUMewS?=
 =?us-ascii?Q?rs5C651m+HQwB0Y7PEO7teqyWcPLr7dnivSuw9iLH9LVoEKrGcbJfXS3C4yj?=
 =?us-ascii?Q?+0EcN++P0hLjHbGz22dPVPHCeHcAaGO8NAFIDyzBdVXh7PQoFuJ7rTk0wyxl?=
 =?us-ascii?Q?aHubKQb9Dmm5/HCN9SU18vjzjV0WS5bxhEpvQkDcxPAfWh8R5GJ406sZNPA0?=
 =?us-ascii?Q?orAagf06mIkm7eTZWBcSi3rTBHhGkMlWdk3Ae0pdyWrpaMnoL+h68BCOwre7?=
 =?us-ascii?Q?Mz+awrkOfIg/N+iNxrspNDYYeUo49ZHbj7bRc+RoJElaB6zwyBevlUqvnIjM?=
 =?us-ascii?Q?0Aaum6PRLIKc+Z+MhOF70eeBSeG8iySDMWz3xZSiG/Iy2e3GVS76L8W8lrBX?=
 =?us-ascii?Q?FNc9C94lTcsYHA/iLsh8p8sQrf8g68/Xij5E2MUlGQ5or+XMWtCq+HFbhYYn?=
 =?us-ascii?Q?HZKwhcZPRE+2CyDSj1Lg1udkFey4m1ere7Z2SRGE1/7iRuXQ3FGbyMSugs5c?=
 =?us-ascii?Q?tOSenvhcl2VaSCmaeIen4HuZ20qqscIy6opbX2yOe1aOpKTNFAEO93KWQUjb?=
 =?us-ascii?Q?iS3yh541vCdcIznZDnMa8XHFjO3Bk/hRO0ImmUO5/cLom7jW8SOtFBuI8YKG?=
 =?us-ascii?Q?HmL6G1/5z/c/trdEqOfDb5BfKcSEWwn4J0NdWl0hkHV8F3LJg2w0hbEJkHym?=
 =?us-ascii?Q?MljplpLl+ja0YzYXdCzcdoCVraQIwBVnUlmZS6GqWbz7YoL9hLJa39A2HevA?=
 =?us-ascii?Q?yhhGNsHLZqcC/VR/VHLmBEgMB7/LO/W7wgZZDFpPEWUuvSiy4hY5kTCn/6r1?=
 =?us-ascii?Q?Z5zh9KuS94+JWQKUau8vM0gspScGWbzjovFLAG2eHbAXeo7MZNz3fjWLFJQ5?=
 =?us-ascii?Q?Gd63EtfEdPoA7p4tCpQbNaqVYQ+rK3eDypGK+loQui6uE67nT4NEyJHJuUDX?=
 =?us-ascii?Q?fmtmP4TAUkdMkfQKTUX1Afo/cVTt33C5zqlNWEKLfseEIpdM8A291wZMUNmU?=
 =?us-ascii?Q?+cCCMWoAJtFPN2dINpE/spIrQMio8Ctt9IR8qwy1vFOPgi26NFg2WfLi/JUj?=
 =?us-ascii?Q?LDHCysu79cICB9qR67XSErF+gUavQaFqEWE/hsUiwKoyY7z+sTVQq4mWUBpB?=
 =?us-ascii?Q?DANF9GiLL4JkHhW2nMgPCgUy0YCqH8k7i8ZHuIXNuq4hWSeahJGatbmgUCZ5?=
 =?us-ascii?Q?pKw8vgc0SQlx2cyWUtc0INzuevHurZXOYauZaOJI4EV2TjvdlTHxxogxMfE+?=
 =?us-ascii?Q?pjQADDnh5LpgCsLHKnQUJAIXEVUKsOaKI5WkD8f2Awbba7+oJxEXxq/DV8U0?=
 =?us-ascii?Q?pH4BzyBtVOBQ4zoq/1NviiIWWR4y0rXvlfsyG3c7H4+lQ8qHpgLCEg7CCXNm?=
 =?us-ascii?Q?7F78CVvJFQVL3wDjuo/JHqixJgGCaAC88AhXdPSUES7tP686e7jNFpWDH+Th?=
 =?us-ascii?Q?tVAf/MWz3ttuq2deZKo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AXsyuKE8xICUwTh+an2EC0y0MWCo56r6aieyoIKgrhzfHcRIy5LTeaIVd3VX?=
 =?us-ascii?Q?v+qxo3TcR08GBXRrQVaA/mWySGlM0Gv0UwRL7VBz8nl2GkWabTWCvKlpBu6j?=
 =?us-ascii?Q?dJ1qDKJCcDCS4IBs/2JIXVzzLO78/Kb5eCuCzyV7RPStuRFFkCMdlhdHGiMm?=
 =?us-ascii?Q?oqXc9kXgJHk63eetpogFxZ594MWUHwCP/PQJoqMKRrCRW4lj+QRU0q1cTmaj?=
 =?us-ascii?Q?opSOaOOEBCSOq/J/7bk/Ritbp5z8b6nfR9Bfa75TrgPMvY4C/tcfAUN45+f1?=
 =?us-ascii?Q?cjBQNBahFVwdt3w+QScpZ/HTbqSm2o32sngiU2ng9I+i9AWI9L/RMsTRa7Pf?=
 =?us-ascii?Q?h4MFzzSmwn4gFe6YxCjsj5xlmm5pMYtN6a1lpBiDuoPYZQGmeb+kEbyKsWjv?=
 =?us-ascii?Q?mXRfBldNq9773px3hjm+oAoaSYgybwrM8dhX8zxnAMviTIcIcG56+qKNi1aA?=
 =?us-ascii?Q?6aGs+bQRCOa9X9bSwCQz1PWxB8yqRDBwLRQquy9Bh+3GtWinDJp0SlE3nOPB?=
 =?us-ascii?Q?IzJyCLEcxdGe/C+f5Ec2W00XreO/t4Y/CAqPdTqbI+VmSPphrqMDueerKhlV?=
 =?us-ascii?Q?qZNcv0kQ048dIgmOv0RAJnuaJz0F2VBmYZqZWFYcbxi51PSSP5/aVTu01f/m?=
 =?us-ascii?Q?HN78lRDXoAbuMCwuv05CXBtZw2OzTmBY7OHVefRzPxX8NtJ235bidBJ2lf30?=
 =?us-ascii?Q?4+IxH3gmeyPRbrP5eog06OpGGENZuNFW/RPjwDmFpszhDaB/PmxFu8hKiqqW?=
 =?us-ascii?Q?D3RoYuyFFehDTfsmGvvTNnjzLxXJcM359KLswQegtGsXNA+2Cmw5hsEFghLm?=
 =?us-ascii?Q?dado+TCJPNmOT4Dtqe297uq9xAf+3UKVWxBi+u6otEguMSqzyymqfgxYAlZS?=
 =?us-ascii?Q?RPkhDr8b4HCwRnN4/+2IHjimDhIC1Gr8WN4zn9dp2d/5wlKKykNfO309rtCN?=
 =?us-ascii?Q?72cseMdywIb8a12zWndbUAgSORMJqidkA1rq0A37q22FrWlGVs4FhPyR0szW?=
 =?us-ascii?Q?DH6JebZVvruUBUSUWdtGvacjoSX0pOykMRsA3HduL6LFIBkL2hpujqe0Jx/5?=
 =?us-ascii?Q?VRbqYWz7K28B6W0TO65TRZclg0+ZpYMfHraM1Ln/fJvu1i0ath9g4T5cTb8+?=
 =?us-ascii?Q?HPY8CT5iu/U8rkuvmURclTFumdxQTTZNtNAb4wOQd+3AgG8Zj37d8v9GBt8C?=
 =?us-ascii?Q?7BGpLTUgSI6khbX4S/nRS5Wc2QwWZHmjbvjrVrmX9yEaPMtj6WhaqjbvsCwV?=
 =?us-ascii?Q?1fjMBcKFbxGxZzAFQDrWaueTPFzy/WLXSwx97qcvnjapwq7eMDVN+CSbtVGi?=
 =?us-ascii?Q?G42oNcqDnUIKE9vq4sNs7XH1RgwWy+EQE5thjGHWy1DZ2eU774JYQONTivP0?=
 =?us-ascii?Q?hVBBzZQ8JQbewYwQ9GmB0lWMiNN0QOxRb2iyHs1nIDNgTiJObJsY8VqOcWUv?=
 =?us-ascii?Q?e3NSPw66P32wndM2Cfqo31gq3Ak5yQecI8PnArtJA2/vfewu9+M3yFrFVlvH?=
 =?us-ascii?Q?6QvdnBolTdcLAFT2Zr3x+XrhTqgqxf42VxwnYBWJIfZZ54TKr1P2vOpB3n5k?=
 =?us-ascii?Q?LQq7QzkcvATcn8drzy4a89cmvUgRrZi/XKUUbWcSdB9+dyOfDvizBW3zEQVK?=
 =?us-ascii?Q?rP9wq2+4EMGiuQJQcqJiVfInTkXBt8jF4wmsBuEZIT7qbl3sPCa4PkieKJ4J?=
 =?us-ascii?Q?ZqEv+KtEZ8n4oh/40Frhg8BuQNVLhRl/D9snIcdIMEgJNFh7i6HreW2ZPYoh?=
 =?us-ascii?Q?YUgQ7NnC6w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e6e9cc-e9c4-48a0-7afd-08de5ff0520b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 11:11:30.9223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JcC56dIVweMdtcxmys6JXsWyeE4aRKBvv4cPaZL3X8L5D7ObPm81XujlOCTvEwm2SkuuyNYe7RpfPDAJ5/gdMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7836
X-Rspamd-Server: rspam11
X-Stat-Signature: cfdai68zpda87pxdkcftyu4nodby9ype
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ED6B1C000D
X-HE-Tag: 1769771822-449547
X-HE-Meta: U2FsdGVkX1/9gz7cSuVMAKvqPUZZNGtSxVlKfU6UEwtUegsIJTicec1tBKCJEw7WwiD9hc5ez0P+JxXuPqwrtvZsN58LLiy7VP0QGlgSoq71ugGMwYseypc1f2TU2S/TUXqbyRJS+OFnE53mZveDsMT4wj/SoaHOaLqrF6Dok7QT2botrmlVRW3Kh0mDXr9MhuGTEXDMD/I3AKBDacm3JJAvGSDJSlYomlborDqsqyGv9M82Lg6Hen+grR000IoDgwcuAeRTQCcFFVIn8+mSV10TViDqT05cFhaYwEtjSMSEEth9goJtvH0jK3Q8yPYxSRNO0eAb7hpAtil5mZrV8rw5VuicnsR9+ev399DnWszVao0vvKKM06IrWJaymtTfeLe0PiLnxGrqZAeGcOLs8JtOARo/aAbLomKaq+sNyI0t6Q3PxRPAvvg+aRlNgKYRAWIh6bNWmXzMZde2nmgpayDgFhT8ISdo7jIdDtU9jY0DcfSS3BMcN0rn/ccQYowtoUik21OGf0dkz8b7fBVCcoc/zsKOhicW3R0F7mxPoXdVR9RMZZX6Z5cjs6+nxngjm+Pzhku/nnAD5VlmrGVWCPBl3MqF52j8W9zjB7GRtWUJRzLW7AHMTt3Q5Oo5jW4gxPqDv3bQqKH6x2eaj/wmCDYs03XI4B6LFKrFLNxFMS/JLe4shFdX6YdCP2z4CnzGUQtnjNBUdZjEugQ/tfoXHY4TcTdSOENEqN8SrmzxLYfmjdfm8d9UJ7oQo7z+IRZzp8b2UCFJzDFbUZWXD1JCu489rlkC8EQC7UqUdhYXXI98lSzNii3HZCUwg+zDIeZ7I8RnjjV99aHYp95GTWGe6SQCG6PdHSqRcwHwElJyimwYKj6kyDj5VUVvBC4mNp4fIMnRTs7a5ZlBEXIgdrMSsz848O+AFhd3idC0u+GjL4bHpv//PpgjXTtVsxAIgk3oyTtqT16MCkgcka2aMsg
 mHvxXE/e
 ku0xf4CSR2T2JrfHJ6w9rMU7Qum2BOsacKK2UTp/SddehCCFq7a7riKzr/juW7l1PC1o6EFOIWxIQ5xoqqP0u3Y4JEaShQ4D6+JkXoxh/+7b5wgSGcKbe2GYOBs+uXdp96OI+S+vqHsNY+D+q2vbNd2PuqKH8wLHqwmMKInMpvgor/Xq88amD0Y0t0u1m063SW71A5CCqqfnUq3f4EIWhvsaeYwW/8KUYYFkOu+lkpMy7Zcoy+w7sRAQSOfzCs02Hf4zj9W+yJzzovza13yItp9jSkUOzFFub7SWQA/GCXybDEcaY75c/P5HHrAin3j94MejseBD14G3t8LjnM1PbdBq6iJNBQ544HZxNJsB640jWV/xyKzvyXf5SIOvYSbeerYbCbnFXIfo9LNpyfIAgcWNaM09m6Wmt6Khd1Pa9K6vRLsbJIHVtn8ES3ucLQud8seMF9SMSRD0ZpACRJzm9INJHq0mARLUYgDxyKApOgnP/DUM0j8YnqXHjQta85n/KogcgbAvxVUNjAgFo2Ur9yMHcPvzUXyMhDZVd
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


