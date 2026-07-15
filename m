Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B35DC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A6D6B0093; Wed, 15 Jul 2026 14:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547816B0098; Wed, 15 Jul 2026 14:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CE96B0095; Wed, 15 Jul 2026 14:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA9816B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:05:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F4E8160259
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:49 +0000 (UTC)
X-FDA: 84991789218.19.3F3AD3D
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020141.outbound.protection.outlook.com [52.101.201.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6287D2000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=gnC65t6u;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abzZe3fsbFI4wiw+EAoWz2guLXEYVn3YimvEHKe4VIU=;
	b=xOL5Oe9FTdvJIzC+KYRZgkItM8DCD/pb0jdYGWBmXfsgBYol+Q9VrR+TQ2WyDHFOJw7aC1
	vZX79I2KrseMudLuMNYF/GHa+effOdw8U3fIY8FaTv5dAcLvHrZtICyofzngyng8H+Zh+R
	J9kQJSUMhumslWV+rM3hkAwDIVzxb8E=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=gnC65t6u;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138746;
	b=FIH5KhAvqq5UsEaiXJXn1f4ZuCYwk10knARzuyt6Z3Xl3MgREEXhPB/zIFDqRNDDHepFos
	objGlsuCQytkjDP/+m9OveFVj2aFiBU7Wf8squeSpbUDUZ1jQNdqeTadg7eojQa0v71INJ
	draXAWQCJXSlyObYsncme70EWaMgdSw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lL2TPy9UaS1EfpYKmzJW2lRuhJS68W5O7pjR/b3oJ3pvaBVTUV5sKTYJPBHLQN9KIq2ZNgXVypfylXRd2mVAzg9Ko0M2U/1g6wczitmR3CfsSoTrk80UdxV1zu8+CnbHutoFAG2Il9kQIDtCeztXJbZ1z+H8jQtfSQDB9CTF4SNscGABm+Z4G4czMvUgYwNEeKhxpX9A2Vmjgxgw8B+AbGb8/dgKKDzPRIqszw9mizK8thFSGBAhCWUh544W+zm3b0sEA5xIU8dmvEWdhdXgNVNSMkuP92Vqxsc+8dcsS5a8lb7xMYLWIUcARu3KNnuFyzKv1PtNkogZLtqnc3WpWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abzZe3fsbFI4wiw+EAoWz2guLXEYVn3YimvEHKe4VIU=;
 b=KihD8Jodx5wENBD87naoEB/Y1Q3FZZSJlW4Iawhj+kZSI2L3X6136Iyh7G+onNGifyAa+NafA7tEj7538NWVX4XRYVy4QSsKIU+wsmWen9SHkkhNkSYWkn1l2xa5KJkzdq1K86rlR8gV2CfEEEz63hUkF4RztC6i8F1C2EYid7XHq05WOqnbq0i7ReFgDT+8stUdlSDvp3Y37UENXIOc87mrp8+zHWDGaCjZUbQ5cUdUoJ2eFPy7Rn8rLHAccCspfdJrkaqE3K3Hq9sSF4wGFjFDwB9u9oCKuHu5LJZoCdychFdYM+K26kU4P+elR5Ik3CBNQ9a7BQkvjUc6YzLoBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abzZe3fsbFI4wiw+EAoWz2guLXEYVn3YimvEHKe4VIU=;
 b=gnC65t6ut7hiUcS92BkoXjERrjqiow4/Vn1tJ+5gUQIomGksWSSvYI2CjDbDHD6/nDrpnz+VlIT+iPzyWrCnLPAMrXon40NQd2b80nZgG7z+kPBMw+VqHONd1yKsB7VjWeCZEXeSv3uTiG3R1zPFmL+tp32qv6zEX47o79fZXoc=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:38 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:38 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] arm64: mm: enable percpu kernel page table
Date: Wed, 15 Jul 2026 11:04:07 -0700
Message-ID: <20260715180455.515692-6-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: 404477ca-26c0-4daa-2154-08dee29bacf4
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	3zR8Piin2QepN4JiBcYBCaZfSAp7AKMP2/ULuNK32f5FQCuoYgkBv/hvZ4FZ+oeUb+09tSL1CjbpnP69E1u+gcObjBdNHHyBX+vpffc9Vk76ZsOcBKOP7q2Vlo80Pwku6NlFQQrliy2sH5a/cdBbNo2QRcbFunZQM4O/9FBa9h1BQc7mDmrlvIrw9i0f9STHwOJwsO47MxE7bhUX/21NLQXZ1q6cO5w1yWv4xMKcBGL3ALo00FUvVfk1dsA2hdEqdNRN50RZjW2MiwyLB5Q668EnlqygEhCrzLRWadXGY6vu7m7hn8IjgxegvpPOKPNVDtMDyvzFOEvtC7otI66F9sxWulbCYr0sF/hKT8sUkpGUL0BWSG0vXkK1p9NVvb/sxuz5wfOAsh1vdGcg4iP39HpsWgG2yVLgLF64qCSkUbhqE3fqoMNx6Cr9vYrNB9U0WpPe+pH9y7oRuMYuMeyPjAjVkjFilzvJoOx6Hx2OLf1TUiQ9xq61pVoics951dgEaFHEzPKOsh8aCKpEeLdQHOpA496fxQEZPqPEyVwuX7IAhrz6dmZPlAPzZCBPsvgW3T0F2sawl5ZVgdoJjU7qhmskftoKkNpgsq1aaz8lkpUtNiaHxG8+LR9m0sg5FDbIn0B9UFN5O+X9iChVVC5Cxlo8cRBxsgjF4q3g0OLMs4Bg9tzsqeMSV9pJAtYf6BmHIGsRRFr+1biC2MPZtJxzXg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f/2I/Z2wISLVtTovpvhIbrbBw6kmnm7BFw0KMNF12xXP0VK/DQhK8i7nGHZv?=
 =?us-ascii?Q?s+Y1hKRQAstkh3m2GkNIH8ERzB8ETED7HNmHLlSwYSjg4ZWq9MPwp1f0zhcP?=
 =?us-ascii?Q?0Dof7ltqmWdxBgg+x+m1wJg9vnZ7TdBW3QDkd/5qsGJrqCIZUtu7TpyhSiQY?=
 =?us-ascii?Q?eHIWpJbjfjXM8QVh1o37b+jxyvMQtD2UqT+P6G6n+Ha5kK1EAREHwob4eCc9?=
 =?us-ascii?Q?2WRlwtl9VZuwlPRCWVsvtU7dYgQO1u+RfkemJt9byNO4RqSRK7aI8Syj2JU5?=
 =?us-ascii?Q?q53KkJst/VhUAGi4Wne5lA4WmINhB36LnPTuvdZWctQhw+WyzEkwBVjs5jRm?=
 =?us-ascii?Q?lnLupysREmMW+cysZPqy2Afttu2pouP7qtFd+LPlzULhCS4XnEDScx21kz9g?=
 =?us-ascii?Q?bdFcfm4z6ptTkvABQoOa9T1X+xO6if4NwK0xLU0QeJVSe/nAo8dxYHgf5j1Z?=
 =?us-ascii?Q?E/xIkCvKe+mfvm6ex/gWGsF24ewOs+z8t5nqYKQPvDxEiyV0zF/B4L33zf6T?=
 =?us-ascii?Q?cUdcLgf5/oro/CKfwhZefahUDWs78JGjawvXOhz/goI2c2C/+tD4Lyh5+7fO?=
 =?us-ascii?Q?0/sOXRLRIEsa2G+XtSNHoIXiZFnBaiN8lu3QU3m2njHyaBx+uNl20xH379lD?=
 =?us-ascii?Q?SHVRmc8EzVawuomPMNuZB5B9lU+IwQjbf87iO+/JPt3Yxpg1fBtGQYFuLG92?=
 =?us-ascii?Q?uACr5uxVSzM/hgJWK3QmIAmVBi62UZRJJzelT4Yw8nbq45MCNUdK/IeIyQCP?=
 =?us-ascii?Q?fhD90QH4CC0x/vwg/z7LAtKIidYTgNPqL4jdwrKV/iMWl1Cn/0y6dBjUMNvg?=
 =?us-ascii?Q?bUHGfb9sxwqzs9jiFn1rghZzLWYgRCxzE93IivAUifrUbmXF3ZLbIB7a4riQ?=
 =?us-ascii?Q?lcMx7SjvOWTkDlJ/YVhfSaCXXyaRKnfLJYwRqFLD3P4bDosbD7OjLfkCWdPM?=
 =?us-ascii?Q?QrLlR0JUl74lGnjdhSp5qNMZvBkcZZUbXbXvBh6UtzvdlZuizHtvp7xv237s?=
 =?us-ascii?Q?xO1ZKBTRwT6+KcV07S0NzQktNvjJwO+/ifmqwihODdlWTmbsKO/bnOnUkQoF?=
 =?us-ascii?Q?wQxa4HA4utUfWt37btxEqM+A4k1wPEKXKwCruCvbPkHP0mofjO0AKSSuscOG?=
 =?us-ascii?Q?Xq5WwuiyXZ33NS/xQP3izM+EaWhstop+SxxDyiT9fi2gGBF1rfTh9Irs/7R8?=
 =?us-ascii?Q?qIeBjx98m8aJmikIMTlkP72OZyF+ZdE2eWk57pA9ZoN2US71Tr6hqgC1SQzb?=
 =?us-ascii?Q?xLLsdIZFAncpXIubLGdMbExl9/0Puy+xYZ0dnIVPOgaMK8wuyO0x3isjtLwK?=
 =?us-ascii?Q?jFFG3T/CZxzGY8ETQBu8SlT+b8/oRum2hdMCSwHlQqsB8U1CUpg7DzrJdHTa?=
 =?us-ascii?Q?sAfpqbNWg5nt3ix0P6mH/wYltDVMe3uOk6PytcYEBAR774nMnOaqVfAG4yh7?=
 =?us-ascii?Q?fDkCI3JNsgA4/no0SeQUr3JOVfYAdFFaRq7CT/n6uddVPC0CaZFgkaMbhxvD?=
 =?us-ascii?Q?oziUJUAkR4nMQl52QIatYtNyrTdONiJcfT/cqatjCSdukTH7GCDjiLV8GWM8?=
 =?us-ascii?Q?pIZP0fTEyoTz11uAADEJhvy3po+FX5rqibDeyERrs97hWisRoTTgEkDiy+Mv?=
 =?us-ascii?Q?5Fl691bXR5sjWYdASbq2G52rr/4Jus3qzf/n4BmDwrzddSM1Z9WvqCafeOcS?=
 =?us-ascii?Q?pVVgoDmcOOHpXBJxBUyRvHKP3c0Wf7wOKqArDs4djBErpMbTkBrYKOWHsFEW?=
 =?us-ascii?Q?QqlktyrGENcHBjxuTe25eZRoLT/G88I=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404477ca-26c0-4daa-2154-08dee29bacf4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:38.3836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +6FOKOHYo5OGal9lq8y1VGpC/OZLMVh5T7TszMhqSjX+VsORxqEwU/HwUlruIcqy6ZKlfuGbG9o/roCcwfCZyTI0ebki35FuEg+mM1XL4Oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspamd-Queue-Id: 6287D2000F
X-Stat-Signature: aukz37rs1u84ukd5pdi4pwrntmgtbkz9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784138746-587947
X-HE-Meta: U2FsdGVkX1+Mput1/4RVvbL03zpR6pkoUdzWnuuELfZrxmp5VHyY5OaSqTLj3p96tqz3xvtaiO+GGmWJi5vXjrzOwK+E6QvXIKMG5u23Ee7p0JyolEr/v2Dy/SP4HJvkuoWNcPHJzAZ/9jdglKPn0v/7Nx/dJQKduaewBi5+EyIOGqhDCg/8EZTzfS013ZlE2IPHuZX7pUvjaidsjeMjuvu/OUqrpW6IYXp5tNgkK20At2PNlWSnJrt5yrsa76Ib8EyExmnZEiPJRQ4fVC+iBvq0z3kgVdgcxWNZtr2I94DcVh3gfvHRNvg4VazcaIgGuTZTe0qCrRwQZ4SXO9+6AqP9ZtJ3jMM9icp/3EFqaQzrKNU0KC+5MgKSdwXQ14NxSb0nZZUbFSrK7V34bI2nCcNrEKc5I7JjDC8/Y0XWr5MKvaZfMZVKI0LmrslfFljDRFYH1JrVuNyY5bOXnD9tUfTh9t6czh+mpQRt5cr6LwmcmrWzJpocM9v6yujg04L8sJODhst/pf4vveLzvw5oKK8ZKcYmBu63rg4vlH7GTZquTrNpY3C+ei4uI6ogwGjXqpFcH69fwxbuvlEugT4Y+U+BVzm65dA6jLI4lVx+IDlDJq5YY/z/4vTvxRxVVRYfjNOU7m2yZr9bu0P7UekQuZsznRow08GciDH/NLD3CXXpoQQUrUfx/sOARLWptX3dPkynVl6dAfAg+0wWwSzQZZNgAFtKeITvazrsCiaWHY8NGI8ipdhbEqgzC8/V/x4Spj9TxFF61ZKGDQnJ2eWUstZqUKAmkA2r2wFRnAAlk6YqhHRPhH9GkCXvolhir6m5R5pCenz40IP/yRX9c+9Vwn5GyIfoqu7MiSA+h/573kkwM5m59OkDZ0M7LwCHe1uBvqOjf+F7io8pW670N9v19Dy9d0oFuFgPe+4uG5cyY5VTJ2CZfguMCw0Uxkl4y8fnM1pkUnUwKZb7bH1TgK/
 aMezg3d5
 tuK5bxYMaSHHoY+EFngYuJcQSLYyQw8GCtpSY1DutsL34DlSaaaneqZH/POILjOdr07z4zm9BrimPpNWFYTeRIe1dkj1bB8+5/uOtT0+K1uyYMBLP8GGXYnk7m6fQbyUMV/N2huFtXWGJkXKh5O1kLpYUd3B6UI5sn2fwM9BIOgGxdI5V6u6dMshz2Tcnon4u1SBEavA8+2GByFbaHAoliWnz1Jh8NQA6GnOYKDtZKdo/3lcMxifPq1wYpQW8VgiNeaIpHuGGVaZg2+a1x3lJGJMUAbA9ibOxI7CP2fsGDxLI9yvcIH2My2YtUxj++hTTvhwDHtcsqOnixYUuH93dgOM9Y1+LV2XZVmTp2fBDFFnu213bzDc0xjbvERfO2kfbHNxyd9orE5jmMkl58L5+bM8qcJbYRzR02BQD2JNLinWlOcR6HT6WaBMuOwxZNkB+5Z0uqwTcM8jHri2WcAT0gBwK5JlkhFcke7wq7hh5/1uNLEdNDh89EoOSty5MAUTSq5O5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently all cpus share the same kernel page table (swapper_pg_dir),
this patch creates kernel page table for each cpu and each cpu uses its
own kernel page table.  The cpu 0 keeps using swapper_pg_dir.  All the
kernel page tables share the same content.  So we don't have to
duplicate the whole page table for all cpus, we just need to have
different pgd page for each cpu.  All kernel page table modification (split,
creation, deletion, etc) actually still happens on swapper_pg_dir, the
modification needs to be synchronized to other cpu's page tables when
the top level is modified.

The percpu page table can't be shared across cores, so clear cnp bit
too even though CNP is supported.

Some features may not work with it for now, for example, memory hotplug,
KASAN, etc.  They will be fixed in the following patches.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/include/asm/mmu.h         |  1 +
 arch/arm64/include/asm/mmu_context.h |  9 ++++-
 arch/arm64/include/asm/pgtable.h     | 10 ++++++
 arch/arm64/kernel/setup.c            |  3 ++
 arch/arm64/kernel/smp.c              |  8 +++++
 arch/arm64/mm/mmu.c                  | 53 ++++++++++++++++++++++++++++
 6 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 5e1211c540ab..8ed3b5f3cf84 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -63,6 +63,7 @@ static inline bool arm64_kernel_unmapped_at_el0(void)
 extern void arm64_memblock_init(void);
 extern void paging_init(void);
 extern void bootmem_init(void);
+extern void setup_percpu_pgd(void);
 extern void create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 				   phys_addr_t size, pgprot_t prot);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 803b68758152..0e991b98ed9e 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -27,6 +27,7 @@
 #include <asm/tlbflush.h>
 
 extern bool rodata_full;
+extern pgd_t *percpu_pgd[NR_CPUS];
 
 static inline void contextidr_thread_switch(struct task_struct *next)
 {
@@ -138,7 +139,13 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp);
 
 static inline void cpu_enable_swapper_cnp(void)
 {
-	__cpu_replace_ttbr1(lm_alias(swapper_pg_dir), true);
+	unsigned int cpu = smp_processor_id();
+	pgd_t *ttbr1 = percpu_pgd[cpu];
+
+	if (cpu == 0)
+		ttbr1 = lm_alias(swapper_pg_dir);
+
+	__cpu_replace_ttbr1(ttbr1, false);
 }
 
 static inline void cpu_replace_ttbr1(pgd_t *pgdp)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 27689c62bd25..13e069b01600 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1216,6 +1216,16 @@ p4d_t *p4d_offset_lockless_folded(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
 
 #endif  /* CONFIG_PGTABLE_LEVELS > 4 */
 
+#if CONFIG_PGTABLE_LEVELS == 2
+#define ARCH_PAGE_TABLE_SYNC_MASK      PGTBL_PMD_MODIFIED
+#elif CONFIG_PGTABLE_LEVELS == 3
+#define ARCH_PAGE_TABLE_SYNC_MASK      PGTBL_PUD_MODIFIED
+#elif CONFIG_PGTABLE_LEVELS == 4
+#define ARCH_PAGE_TABLE_SYNC_MASK      PGTBL_P4D_MODIFIED
+#elif CONFIG_PGTABLE_LEVELS == 5
+#define ARCH_PAGE_TABLE_SYNC_MASK      PGTBL_PGD_MODIFIED
+#endif
+
 #define pgd_ERROR(e)	\
 	pr_err("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 23c05dc7a8f2..6d420ad59af4 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -360,6 +360,9 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	smp_init_cpus();
 	smp_build_mpidr_hash();
 
+	/* Must be called after smp_init_cpus */
+	setup_percpu_pgd();
+
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 	/*
 	 * Make sure init_thread_info.ttbr0 always generates translation
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 28ff889658d3..49524a7176b2 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -55,6 +55,8 @@
 
 #include <trace/events/ipi.h>
 
+extern void idmap_cpu_replace_ttbr1(phys_addr_t pgdir);
+
 /*
  * as from 2.5, kernels no longer have an init_tasks structure
  * so we need some other way of telling a new secondary core
@@ -198,6 +200,12 @@ asmlinkage notrace void secondary_start_kernel(void)
 	struct mm_struct *mm = &init_mm;
 	const struct cpu_operations *ops;
 	unsigned int cpu = smp_processor_id();
+	typedef void (ttbr_replace_func)(phys_addr_t);
+	ttbr_replace_func *replace_ttbr;
+
+	phys_addr_t ttbr1 = phys_to_ttbr(virt_to_phys(percpu_pgd[cpu]));
+	replace_ttbr = (void *)__pa_symbol(idmap_cpu_replace_ttbr1);
+	replace_ttbr(ttbr1);
 
 	/*
 	 * All kernel threads share the same mm context; grab a
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f2be501468ce..5a235491f268 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -67,6 +67,59 @@ long __section(".mmuoff.data.write") __early_cpu_boot_status;
 static DEFINE_SPINLOCK(swapper_pgdir_lock);
 static DEFINE_MUTEX(fixmap_lock);
 
+pgd_t *percpu_pgd[NR_CPUS] __ro_after_init;
+bool percpu_pgd_setup_done __ro_after_init = false;
+
+void __init setup_percpu_pgd(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		void *addr;
+
+		if (cpu == 0) {
+			percpu_pgd[cpu] = swapper_pg_dir;
+			continue;
+		}
+
+		addr = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+		if (!addr)
+			panic("Can't alloc percpu pgd\n");
+
+		memcpy(addr, (void *)swapper_pg_dir, PAGE_SIZE);
+		percpu_pgd[cpu] = (pgd_t *)addr;
+	}
+
+	dsb(ishst);
+
+	percpu_pgd_setup_done = true;
+}
+
+void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
+{
+	unsigned long addr, next;
+	int cpu;
+	pgd_t *pgdp = pgd_offset_k(start);
+	pgd_t pgd;
+	unsigned int index = pgd_index(start);
+
+	BUG_ON(start > end);
+
+	if (!percpu_pgd_setup_done)
+		return;
+
+	addr = start;
+	do {
+		pgd = READ_ONCE(*pgdp);
+		next = pgd_addr_end(addr, end);
+		for_each_possible_cpu(cpu) {
+			if (cpu == 0)
+				continue;
+			set_pgd(percpu_pgd[cpu] + index, pgd);
+		}
+	} while (pgdp++, index++, addr = next, addr != end);
+}
+
 void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 {
 	pgd_t *fixmap_pgdp;
-- 
2.47.0


