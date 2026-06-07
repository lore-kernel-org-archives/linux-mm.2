Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB00CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 12:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906F46B0088; Sun,  7 Jun 2026 08:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7BC6B008A; Sun,  7 Jun 2026 08:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F5E6B008C; Sun,  7 Jun 2026 08:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62B366B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 08:09:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5FA0140776
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 12:09:43 +0000 (UTC)
X-FDA: 84852997446.18.9516C4C
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012029.outbound.protection.outlook.com [40.107.209.29])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1D86C80006
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 12:09:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GWnGHAtp;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.29 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780834181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFXDSCKXAKi4kGupRZ5SQ9xE2oWSRiN0xua6nRQuhrs=;
	b=plqLCmMd49EXyHj94tve2vRqFXr0zqF8skC+pbI8V1QL0SSqzLo4ymbx1eyhlla1anx1bM
	WJiJml2JlypQy24RPiAtv7un92oYj7hVvD42gKD6U4KcHGF31Wx7/O065Aoc+XIjZLxDNM
	LLy6zfujzFwR3xQ9YSEcMtSto/QyOjs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780834181;
	b=1FHvtdGpx+avxzsgMKZHDxmGHj6uqJkk1nppyDTn89z5lOCiCqajo3YXGRFhr19gmo0o0e
	LsCwRBVmTJQVDJizIAByICDaJ0EhtOQm5G7QMt5757A+GcD1SvPw3erTfRfLsyJBW4GxyG
	kMTB40vDJlRWfFapQfB0xWwIeM7tEIQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GWnGHAtp;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.29 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inKUO0LuN+Uc5GbJ0HQYKYaVSvyDwcG98bD7RCMqj9OSa6aiWOeGaVuDJH5tKNlZWY7PCdJw462ZcTvU5shLgghVozREJC6hICwrnE/x6tpHOuGGK6f5M6GirZED/XioadJLExGgxBmBH8BWB47ok0VFDEoUqPREPFCeskDUvBhb1KkSVGtV+R8/OJ3uiSaK732prT5A5dSMsQ9BXk5bw873QMyeOsS/2ixSx7t+01mBG/PHSyzoBhmLG3CtBncohsu4twBeHDIVCMFIfgoUG3aJ7dknAlZChSMIY2/AGOMyHVDnx1WjKbcOAtye75+61nPOMCbKv1xmyieAFaljOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFXDSCKXAKi4kGupRZ5SQ9xE2oWSRiN0xua6nRQuhrs=;
 b=qmRpKvtFBAotyjH3l0axZfDDpXyx7Ivq1zUc5tDXf6mK0mo/db9+8uhdqx0Wdw/gzlVAl1SlPJLXidzM2HNUTLcql/sYwlYh28vlqXCBZY+gF24dAGn44Zzf/+JT8Z0zUIK25tAXxqU85c7BFitwLtmOHk/K80Yn2YXsURS/FxId/H+KnHLrx/EG7U1usuoaJn/9PmJU57C3Hrahr81I0Ao3b39imYxTvUR00qzrQlEkKlndc5tY5xeNpvSSvdrg/E/Bn+6sUHgOzcDvJOv1FMYfzrhbKpPW+/ycbj15i/DZfXCtcNslpp3bSH66AjEsqWybZuK4lN024nWCzhRixw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFXDSCKXAKi4kGupRZ5SQ9xE2oWSRiN0xua6nRQuhrs=;
 b=GWnGHAtp0MEVqtiAwMCwORdH7K4vrvlKG2ULLsMcESRiheacyH807vC/MPRaeCjwnvjW+tn+ao3MuLWeI2KyNvTtr9Bh02Tp5Os5lvxrt1vJJcwFGAnBOOEz9Ss7JKqvyzeUJUnYwoOlG8+dNU8DNLPwuxspdCEWB8N0V3YhusFk0ZZcvqapOrD2JquPuKcm8Xdi6RHePm9k40+l29jxgYyNnDnHdJS0C69BIsMlKcTw5clS9YBUyhTSId5nr0qQtCGtUfelFgyI9IOOaH1T1QEYe/tK1c8QCyA3HQ9zhSLyMwVFngrusl+jtvyI3KwPItynx5cZquIIYWrNhlie0Q==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.11; Sun, 7 Jun 2026
 12:09:36 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0092.011; Sun, 7 Jun 2026
 12:09:36 +0000
Date: Sun, 7 Jun 2026 09:09:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yiming Qian <yimingqian591@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	keenanat2000@gmail.com, linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] iommu/iommufd: Require write access for writable
 MAP_FILE mappings
Message-ID: <20260607120935.GG1962447@nvidia.com>
References: <20260607085320.73274-1-yimingqian591@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260607085320.73274-1-yimingqian591@gmail.com>
X-ClientProxiedBy: BL1PR13CA0421.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ab97a8d-6488-4952-5abc-08dec48da481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5J8DUZpcT35yiUeS05SFaISnTzIH2tRZNa/Dc10RAK6dmogF3jqDaY2fcg/Xnjm0N86ei9L+4jxvx3vXEMwNOlst5yY5O0A5tx0hsQgQrqIq/XQKnn/sf8mcy0cQfvHCQqn6Tiqe4yz8ejUKnAj0ZeicI1+ueAN1rjTE38o734FszloI9Xxlyr6apMijhRSEqnayMRL7AhKHcxcqOrUk8JUi+BnKpnCDh+k8Zixt6MUsORtDZKh/A94598xuKIrQxBqobp0G7FGfdmxxMel/hnwUzwS9xjwLOonIKopDdASDYMO413EKPa0ydqR5f/OCDVfSCuQodPVr3CiMdDH6VVP9PsDs/J61J5zDJyHcdTSODf/0o31zPdPi0QZdDdvasipj2N3LYfpyGkumCnZjwYh1dxEe7/pMsRq/rdkIC8F6x9ovBi0TF5hBaqP/9D6/SeNPx/Pc67qYxWXzYWSL1+CgMvWl9OBfqxUozIa3bM3E2hgOeAJOHDO2G7ycCHlW80PgXz0SVWGpkcgojiWgpNOUqQ7Uvnz2qSQBKhtbVawoAi9vBz9O5lSqSE/UBTdi0gOn+k+OizxxzNXVEEQ46a4B1tIBTGOQ9EW9LwMq5fV1e8qNyic99xgnDHTui4z+GDwnyiWaL53LkdUXvj8qn8gF31/XcRadPbitRzT97/2nUpaUZpzv62VFAfFsa+r4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AzpxnDcF6dOjDWt5abnnuq6B1WjDUwQxAsdCetKuiULpygNxSaoz9l79tSj6?=
 =?us-ascii?Q?VilVwLTH2DRxxAKOCxFOFHSAo85fnmTxuD/+eL4syh5FDPXKexokd/oYylAw?=
 =?us-ascii?Q?z/ndU488LyImfK9P5HjP/7VgNSdu1ZPocukaTBp8wyKqQsMiSEYH+Xh/CSIQ?=
 =?us-ascii?Q?hca3KIiGoKZZnLSNgQudf6aDiDkkVGVOeRweLU2qB9L8wWw5x0N2jCRa/XQK?=
 =?us-ascii?Q?8AqVWpKIRGJrKjKfm+wn76nymHFaVqJYzqZsSoF1ElLAYIKWBhM8As36gHPz?=
 =?us-ascii?Q?+4OpbLN47L5FXYiIFXXsg8KPxmBKOo5NYDjZlEobm+WzD2KpoOqsHc4vX8qr?=
 =?us-ascii?Q?jTn08tV8fOugqjcE6HEzbYm+MuZEgz7OHuR1dhiWS6z1sX+8d/0jLMn0MJRS?=
 =?us-ascii?Q?kNPCRLIwVQTgqLvgTjCsBDgxoUw27J5Iy2CYZ13x50k+CXpsdqLrQrsUniZJ?=
 =?us-ascii?Q?8J5BWDjUOh/N2LeEkLokO3cc2CS0E2JYzmHSHmbmEJkTLy04Qz5bfl6F28wK?=
 =?us-ascii?Q?JS1n6NdBwhYZptJz87Er4YzEjJIWCY/uh2f7vIH1G6Q9R12BcO+LxMr6KusS?=
 =?us-ascii?Q?B4LWGRVPbNFtMIeIRf2mdgsCjARG1zVP7vNUzkJjEnzsC4UZMl0RR1rXsgAa?=
 =?us-ascii?Q?oHO3Z14SeJV7dJ3Mk3ZIg6tDyo8P28GjwMCVSo8eyFhBnRjqSGdKkb4XvHkz?=
 =?us-ascii?Q?Q3Zx99iiiT3IykNGTjJnYEfqBpMjRRCnN8OK+QsbnTPkgsjQSdSmoCxLJnXY?=
 =?us-ascii?Q?XLHUa+1kkkqp3s1hrtPrtbuo0isAzqYBQL8306BN79bC8QAMggWAUi9K8Tff?=
 =?us-ascii?Q?e/tTTnaAtHlOUn+iETv7WBaPE5r/pkG7BcrPQoKcRG8GmuhPp7FpZ7WaYp9w?=
 =?us-ascii?Q?5a5aIIiPJzezIFsL7CeZA6UJUsV8+UkD+NQYHVboFop+aB36IydfZdCtLSdP?=
 =?us-ascii?Q?Galucc8ScwnZa589SyHPyw5VOdlX/Tg2+KxTaa179gANO1O/yZzoE2QuILMw?=
 =?us-ascii?Q?bQBprWX8zKAl77LxwsDUXBtf6cnwtrRFZRk5lLidr4+M0YGHQu1ijtzgH06u?=
 =?us-ascii?Q?QVHVKUXxyot3f3EnLM6eHs5AIetwK9DSXSnA//3vmPHSGYnEAkHzFgUAIa9p?=
 =?us-ascii?Q?RZeidGyfDWofdebyQecH4Co3i8euSvMhHwGkYBkgdOYAizC0Sl5hHPUtI9Ys?=
 =?us-ascii?Q?knwMH5azcnZRLsTRjLeKyzUNSTqLc/8hR5v0vKWbkoXJLX/x2rHo99Hl1sFh?=
 =?us-ascii?Q?B0pi1F2uS9COjQ0XY6g9MQgbL1zK0C3EKib20RLZOfGUrcuwA9PhlNSw2/Uo?=
 =?us-ascii?Q?rAL9EkSwKrFR4roAHJqIGRGaclNUdOUhhqV5tCeYrXjoXdAcWpEqe9Uw22+3?=
 =?us-ascii?Q?Y+JeDp0Om/a4j0DUk5RNmHFUt1WyZwwLvJd8J7EnmpTwup0+weHF4f8yib5h?=
 =?us-ascii?Q?35U2+gLEX0dx0eE2mz7eJMiU6ldyCB6s6TxkBC2Vadxy+EYnsN18VQjyuykA?=
 =?us-ascii?Q?rPBN8HOg6M5etibN0nSZDx9xQm4U0eJ5+kNGyWsJeIVIjeKjJ+p5du2uZ1lg?=
 =?us-ascii?Q?KwxvI9ZmkeWzAHqJqNOBc3cTBg9qfT8xeXXzO+fsEBtW9eKO/NfwE6b+HL7z?=
 =?us-ascii?Q?joZ/YuF/iYiZgqzVF+NhEU5rjgk8/+QbZrafAcsT10QIno0oVLm9MsCUCI2/?=
 =?us-ascii?Q?C2AYuIzNMfkqMyV37q0LCGlRP2w9KNWQj2yScW3dBMB+WaAs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab97a8d-6488-4952-5abc-08dec48da481
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2026 12:09:36.5414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gu1YS7D97qKzrFX0KfiGkMVK5QB0BEz9TpIxIbig4qmJAuSkwk8y+6gwoORMThvu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D86C80006
X-Stat-Signature: cre1zffdk5n4kec3t8zzmxswz6szfx3z
X-HE-Tag: 1780834180-863058
X-HE-Meta: U2FsdGVkX181msmC5BFkqv1Ku2AbJSLzbZkKGdcPrGv2jQYXjRoFQv3PKPRTSlvIliZfs761aPHFo2Q0aYwQMQaYgE1MOHUG+kx08NdDpJgXS9Gw29hV+kvt/yJApFry0elWKb1T7PSf+mwXMTSc3JhiDPkFH3IIPW+Y7t8ZJS4Ez/y52F/HjLx7A3x+6XmkIW2crSP9UvHBOjlWPQLIFcdWGPDFVfX/jqQ9LCy8hDkX6gXXh/URu9r6ZXpnv8CRVX3+GoI/Eomk8ps61qQtuOyN7LqPTvYyx7oV30JnN+NjlIM02QeEWsqYuicy97JpohkT99tC3YYjzGlsT3ZdDASfnyPw/W85dEs7SfEu/1QxKfhFR6dVkWVpp5sls/PjkINKHlvvmROfyQz1dVZ/lj/yny4wU02yRvghmt8yAwvcOH2j238dbkVLJfrUgCJVF/fo386zcTgTnYboz2S2fVwj++VhzPFAxJDHIG7FIVLCR/sJWCvIFkReOgyWUI3Hla/+a9Z5KBDCscOn9XfwBreK+PTZ/3Y9/NEAYNyGL/9X2u0P8FbwMQAoyZmkOuyteSST99e88RfoXLC1ZOe5iVRETcfDdF2Q6jDwqMoZeIBsTBBqp7rhWPvD8DCUovTA6wQFKFAIVSSr+nh3yjAIU+GuDQnWn/Nwsh67xzhKC9szRpfFpBsH3h7ZCRjxtUDEIpYIWIqKnNBr+6sAdtG3frD6/iTpq7PRJQ143WwtT3f98mz3VXbZjx/1HbtvsMQY4e617wB6S3lt7DbNdfQCCRUdRJ7F0fXblP2O+r6BD0t/Vu4L82pnn5GffJNkkOCXyUP442gqg+xrTxu7E361J/nmG/oZdpibuSMsqnLEGqE6Y6xFLHr9kX6axGr7nBRcsXHtqfyOSjdwPrK2hO1aMBjESCfhGSkApUsxfPBWxCa8pTJzxvv9jF8Q0RPWxocl5pDlvcjgK4vWFOTfRU2
 P4yBxvt6
 332o9G4uwOxVKYW6XzlJZJ8mj3vxht2X0AC4MUXyxYF6/Znq5ekcS2hqMQBSkzuCfd9T58lwzotlsr4mt5TJm7mJUlzUUJVE7X6jwvYVFBPrqWu9S672hK2NOk/kB+ZLXV3Nc7aTN6XCv1LYWVCezF0q7r2RHfNrtrmQd5T/uJ6zI90a1nSH7pDIt3asFeGjeqJ8u/uOwQO3RiAkrIqXccHyeoJqEgsRJJEl/Fr5EE3+NZ1tthyPRzQuckNYzZqmeNQMJkVQYNTCxIAIxuFYyQnmqZgByGWX8e9NhKtANxHpBT09r99YBpWaiWjBVdWpBj1pfY1uWm0N95l5wmduQInvK8GfOi6mc0JjYi0BuOVGniHdacc7oBst0UZq+e6LbXHPcUCzIVMGKUTabcYVv0I64MGQ9cO2wPP2xkoYGhvKneiNIIbfwmIjER8oiTgVp+xvTFeTgscCopt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 07, 2026 at 08:53:18AM +0000, Yiming Qian wrote:
> IOMMU_IOAS_MAP_FILE pins folios from a shmem/tmpfs or hugetlb file and
> uses them as the backing storage for an IOAS mapping.  When userspace sets
> IOMMU_IOAS_MAP_WRITEABLE, the resulting IOMMU PTEs allow DMA writes to the
> file-backed folios.

This looks like an issue with the API design in memfd_pin_folios(),
all users would have a similar bug I think.

I don't know much about memfd but this seems like a legitimate issue.

Add those involved with gup.c and the patch adding memfd_pin_folios()

>  {
>  	struct iopt_pages *pages;
> +	int rc;
> +
> +	if (writable) {
> +		if (!(file->f_mode & FMODE_WRITE))
> +			return ERR_PTR(-EPERM);
> +
> +		rc = mapping_map_writable(file->f_mapping);
> +		if (rc)
> +			return ERR_PTR(rc);
> +	}

We probably need some kind of companion API for memfd_pin_folios(), a
start/pin/destroy kind of thing to manage this?

It should not be open coded like this.

Jason

