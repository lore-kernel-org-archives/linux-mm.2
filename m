Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D8CCA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 20:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B01A8E0006; Wed,  3 Sep 2025 16:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587BC8E0001; Wed,  3 Sep 2025 16:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428928E0006; Wed,  3 Sep 2025 16:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFA78E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:35:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD3ED1608E1
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:35:45 +0000 (UTC)
X-FDA: 83849095050.11.67AAB62
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5CAF780003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:35:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KfTnhhEJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZrXWbB0F;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756931742; a=rsa-sha256;
	cv=pass;
	b=mMdTUWCEJ9R2a+mpdpuHIvBQnkIvAVxzlywdALPuYXf8gKs1hwPQd3jDzhI/r9Fv62Zzjj
	kNiZGayieiyqTHT5vv8ZCD1tAd8N+xX6jSiyBXk/r2KgVGBNO29GKAKU+u6iyMEi/HMrS+
	7h/o19fdE1qQ/JrTgG6E/1TVci5ory8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KfTnhhEJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZrXWbB0F;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756931742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNh4hDfJqQdypQCyAAgOL9u1az5uqIEM/+Unvv0n5Bs=;
	b=M193ltG49hUe/+TtAU/+atJ//5wA+dgZvzsUJgWJdoIo/MoZClfuVdr27kUPFcDUK3QMlG
	zqChoVHe1uPheNwzpqUWxJAq2HKX4ZNX8ig46jk4iinBzieEIhwyIBPNGpvmKxebFymmi0
	RErm0EU+jzuAv26vWjuG3vxLg3QyD8E=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583KU2DA025010;
	Wed, 3 Sep 2025 20:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RNh4hDfJqQdypQCyAA
	gOL9u1az5uqIEM/+Unvv0n5Bs=; b=KfTnhhEJK1feHNqjT3izrAPyeDvyM98u3Z
	SXtSZ7IzKHZJh/67+cR1EZYCHPmuPithHWszx2eMhk9DeTU4dgsYTEkegVZZ8+DK
	D+xz3USKFy9OtBC4A/LfqJflQsfOY2EEMyyymUWvn8NahWZKSHdTC68Z6+cDpMb9
	d3vsiGSx8OzsJnIpQ8904K2fAyguxRQ6TXJ7grx6bZcyti9zY/raZ17Xv2lt4iK9
	WAB3sfBzKp6o/igOEo899w7OKTe/Yq9dyoaA5OrKzdu9Di5I9cSLBhNirGFM9ONR
	85h1zUNlY368TO7gfUe6dYUprs4PJZS2xHZXyaxk/55MujRkMLxA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48xvrr809e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 20:35:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583J398o032516;
	Wed, 3 Sep 2025 20:35:31 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012063.outbound.protection.outlook.com [52.101.43.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrh49bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 20:35:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITBniQytyHOR0m1qObYro3ALfyp+lh5iGRa/q3NLpWqn+Q08bmmF8+SJs80rpRdKvN0cf2mygLyXMm5bxdcKxOQruj0R9AQ8sR1/xgwgsVi0yYE1FW1MQDG5dfagJitQb75hh1myfB38WwnDslXn0Iz4/1Js9EzAaRqv8apIdEflfNItY6h4rlRKwcznYyzdXv+XB7u31E09bAOrNuo5xsPqJ/WcCHDEqsQ3qjCbDLoloWYjs2tYHoHVJZKtHY/Z3mNNEJfOk1APgIpgx5OIa5CEQ8nalvA8G69HBVEfiZJwLJwma6BgL0ShNreEtX1qD1c+xVYDa/3oaHv9Nzpseg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNh4hDfJqQdypQCyAAgOL9u1az5uqIEM/+Unvv0n5Bs=;
 b=R3hxKiMzY/3d+3rH63z4FzEBXYqIJ4/Az/o0rINCvFCcuMo9J13oPPjyZbIdua6a17gV9mB5a72QMXHAwGoINIRhjs+AeBRfPWz/N3CeVnCwX4dYulKkDvkMAI3Hg8w4qK7Q6aoKPZK4V3GjEM8zuEpjB5dQv2OFQlLlLGAGReWiyz3ugyrmWg6fx38r00K/TQOH5I4v4AVZAHsE+bb/aEmw9rAmrMdLzVnExF6DNQQubT6Czi9BHrHHWXOvUkOtT3z1U8tXjlLilofPq3ph8ovBwwsex9DbnpZnji9NGUZ1HkT0vNJTR88fo7Pwkz7PEz48KQyjmUdddF7Jp9k51A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNh4hDfJqQdypQCyAAgOL9u1az5uqIEM/+Unvv0n5Bs=;
 b=ZrXWbB0FxW7FA1GWHsQ4as8w8moDvzH/h7BxgS8g2SyGqaFZZedhExxWASF0a10t2HvZMIFrO5LstPXxWmchhJwGjTarHceN2EVDSxw0QHP3yCXbwQdPO+WK/HRjsXsUk/AnSRrPQko7ej1mK+SYFDrph9qNnBZzWfRMlnj2fms=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5059.namprd10.prod.outlook.com (2603:10b6:208:327::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 20:35:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 20:35:27 +0000
Date: Wed, 3 Sep 2025 21:35:24 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org,
        willy@infradead.org, hughd@google.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
Message-ID: <6265a655-22ba-4013-b726-1c5af9893f5a@lucifer.local>
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903054635.19949-2-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903054635.19949-2-dev.jain@arm.com>
X-ClientProxiedBy: LO4P265CA0186.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5059:EE_
X-MS-Office365-Filtering-Correlation-Id: 43013a69-b4ed-44a5-c992-08ddeb296aa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?upVNqr+T7f9oyOuexK5UuqGN1BtsSjoX09FkgDAPIDfvaBDwj5ldxpc0K+Ql?=
 =?us-ascii?Q?YgfiSIi3e7snTPzTUtityGuy9GBNiRZ/t3kA//YZz+uDd70I2VIQcQdnPAZC?=
 =?us-ascii?Q?CtkEGbk/KiN1B1sbKqMPNpezMOXektcCUowpvqTXZUBttM0v/DYIsztbT8tI?=
 =?us-ascii?Q?UIJYl59aPnN9Hk3pzdDyKagzJJJGc2oF0XERnFFNr2kSe4d8jEslJpO//Mli?=
 =?us-ascii?Q?bSJdJ+vpn9A5z+v96odphEeAPmikax3a5yXINkkMmSLBMo5nfJ1bb0igi3M6?=
 =?us-ascii?Q?Kqy7GcTMQ+ALXqHhOpT/WuLWXGbOeG9r/24lDqo5vuz9W4/UP3ME2IL5x2LY?=
 =?us-ascii?Q?hfmvF6m6PkoBaiB3xcT2V+ufOpi6dCT4xCHxPFgGqH3ogONtf83FR8uXQH48?=
 =?us-ascii?Q?nITi6jw6NQNBfqCdvlkAxMU3IaEdbpopJ0A0cYylY8Fw/gCvJP2u4DHIClhv?=
 =?us-ascii?Q?GUl5nujnTgma7j969XnG9FKpefwN0CnfPSKxiougqNCyASrsue4Ilto2yFJA?=
 =?us-ascii?Q?k1otOxhC1fkEmshqcpE+FxI+Of4tUDjajZV3dz0rBvYPAgpfNr81Lk7pynUJ?=
 =?us-ascii?Q?LmOb7U2wSPEh2q1ODBONeleUpWd4fgtQDPJYSzdmxiMHWyFR4voYEojSNiT6?=
 =?us-ascii?Q?FzESfCylxUD5+0RMzFvTHc8dpXN8b3o6cQQ82begNqREtn6SpqhWKcdHMw38?=
 =?us-ascii?Q?U0zpArETI9F+egJOaTvxjalT0Yi7rtEYcg1/ZZ9swZaTja4G88Iz+m8vfd52?=
 =?us-ascii?Q?hdpugt+L8N6T0DOKp3rJfN5sduxEBMEfxHDmtQJjMRODqA1LfaACSTD/Be8U?=
 =?us-ascii?Q?6IhEk3fsTUJbuptivWPn5vS9TiqFi3ooIH4L7d+njXgnWvK+pCXpJ4bxCI/d?=
 =?us-ascii?Q?lAJaqCis0iAhnmR63WwfbpNeBRLylbECEGLbR7hWjcFzRTF+424gX7DfSUUR?=
 =?us-ascii?Q?LgPwUHLK1Ea/KMEzaW17ewFbOedww7uYMOmclbVkx9/bCLx9cjO4gE2UIIAB?=
 =?us-ascii?Q?E++U++pv7QtpbHnyGnZNB25gmX/EcvWjEGTOjdQWnGOHXIUVqmw2oV2WpkcR?=
 =?us-ascii?Q?sPXC+TgEKgNinLeraaXMxRkaHLj8ZnZlP0Anb3cxWGPB0SP8n3zCsR5HfVNF?=
 =?us-ascii?Q?nH68Hn+Zqhxw8UX+SG+/Afi4vbWn/oTw6JNrByUQGXsAC+oHiY4DYawPBYH8?=
 =?us-ascii?Q?2bF09uZcIk5Y9TkbjaKLvhHsKLonb9bnajjx6pN8fMySYPKS1fQMlwUeldGX?=
 =?us-ascii?Q?dFNsJG9ZxZ/roaQyZ4GkaKFMXus+76Q/xuuSNKBIV4/i+o/lzlOwW1SQklTT?=
 =?us-ascii?Q?DufbhK44AAqadvZxv1zPw0AuvmcDPfKnwu9C2MzcLcFkSggfLOd3OjJfTVZ6?=
 =?us-ascii?Q?xv7ErmEquDNJ73inFxzgQ4DEefAzXg5Emo4KK3i/kZRSx7/wKz9LW63Av491?=
 =?us-ascii?Q?+SnPJAltU1g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NZNYQrQabfouIL17Lb/A5AsnU+RHBd4ytKRnzAJad2QiLVXHjKtsaS5dd4QQ?=
 =?us-ascii?Q?D7iBtxJcayPaG8pN0nkwd6mnwq/0xxKS1W0AH14IteaEO8f6h7hLFuEZVWAM?=
 =?us-ascii?Q?vgEpng6SwPMUyeuBe3MnToz2Nzw9v5jTPCr8J9D0JiPGKxytp0WXYw/NctLJ?=
 =?us-ascii?Q?hFHZhBbRi348ZbCq0RoiJxK5Nvylk/D4cukDNJ0yr7PiRaSMygsBNIPqmNTF?=
 =?us-ascii?Q?Jo2rUXpq56lD9YI6ocqML8zdv2JVGmVyPBYzB/faMi8hB+g54SHGyYpfi8et?=
 =?us-ascii?Q?EI04geLqEM01rZ9wR/0D/Q1hLaIO4/bwjy3u3l4sGpIvYY9/aBTJmWAyYObI?=
 =?us-ascii?Q?xfw39rSpDdeeo7zbL28SSQSKuk3JTgvoPqNm4gIyJup0eMpTm4aB09gLtdc/?=
 =?us-ascii?Q?2/HKMfsIckQdx/o+q4smd6kvegcPKh8gBOXev9fz9pbXKMkNXOATBMS/OhNn?=
 =?us-ascii?Q?M58+ahzG+2l3aNzrqy24IZqs0ZoYf1F4Wu0H6zozd2rfyYMdimTxa4baUVqx?=
 =?us-ascii?Q?zJ3ejKnI3SVFLGH7l+aoXYIZ7H5qQDldSo453LMtjn3ruUOk84o7nEXA3PD8?=
 =?us-ascii?Q?bMnRlZlnoGo2BR3/nSspK+YbH2oKngp24I4iF2atmaQPPOiNPJp5WaXyKS0c?=
 =?us-ascii?Q?PB0cU12ste8JTV7xVGY6IIa26vVIip1lDvfWOJnlfn5/t3/6ldNC9a0RaqZS?=
 =?us-ascii?Q?uxgtWInWe4EUBuMki52eNrd7g1Bqmbq9nL0CBck+8bD1Lg5iBYz7KRQiUMgf?=
 =?us-ascii?Q?zhFP0PjJgL3y9SPZeLJeg66gF862jD6z96ZJK81P5VnLXfEVRyFqcshtJqQh?=
 =?us-ascii?Q?vL37gTi9wAJulK95mDGoNuTzqAIV2uVCvk+N2xuoaSURi43QUkf+avyBcYrb?=
 =?us-ascii?Q?4jNnufNDCO0hY5YaB7UCoFTyeEyX5caDS0t68Zjz3UU2iis6dzDuVpEjMV5X?=
 =?us-ascii?Q?31GL9pnJQIKWy4f8Hef69GxbJLuL0fWpAoNGdcV9zXleE4v3wHyvfJlD1avC?=
 =?us-ascii?Q?7ZFF5yK0169G3HPihS8yVWGrgBGT8oxBv+9TBOLsO+I81R5LWSGWEgC4QP0/?=
 =?us-ascii?Q?keobPs24XlqJOV/r/fLKI5DxgpWpF/VDiNS7WYuLH+YqMUJ+jDXGgxSrRRY7?=
 =?us-ascii?Q?kAXZNOVU+eVpCbP8lWzNznxNCT7ZAhyYbzawvWIu8SWhBoTYINBZbrXv78Dz?=
 =?us-ascii?Q?91fvwFNiU5zY0ya41KkbmhAf7Oxf/cVZ1Uce7+Ig44+dMBFUXHcFmaefmHcx?=
 =?us-ascii?Q?fiHrZT/RRYXFKm0KKf+PMihpAqcUa6S+uRoj3CK9FvywvUMaD//HNGxLb3x+?=
 =?us-ascii?Q?TArqyYNzXukHHDveLdumQBOf9emhm4tAudaMBecKbsw3JlQxslzoZIuJYage?=
 =?us-ascii?Q?VWH45+TEaH352ZFS5OkF0BPFhF5g1f9+YnB5MthP3bhVmL0Gce4r24yNono3?=
 =?us-ascii?Q?FuJPkHGFkfUUWV7XvMCUUCmquL294u2SUTodHchjKTKP92KWzKlV5jcbM5sc?=
 =?us-ascii?Q?c+spzwfQEifMBGmFlvMZgeJaFcZd4q5NUVR+lJbou6wuZek6IYHD7voGTeeG?=
 =?us-ascii?Q?kJ4PDqM7uHWHi+0gNty0Gpk5bKvOxq9Mgd3poK5rzM6FbZCs52/ikg2mvhDz?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H3WJCT6I0+oAEWD9uTXTkhHNbtRVVCywW0qq4yZ+M3g5LDEhD5marZjd+s3a7x8mlo+nnwXYRrZoQPRuxSZsobBHU7UrFQ+zcHrf/UgorL4TdmoH2ARMtjt/i3Hpe4rJtR8R2b9A7naWQSzUBKb8SYf8Al3KWKFrXCLyABH2fM4CbnO1q3kKHxI+KSDoT421jEOv79Fyx1QARU2ozBBiaCCu8GKdv6bMYjqWVDKfQ7ZVuz2TGXX4+VxHyMRVlfPAtb0y+DEXdnRoSlfsyf6to57+mVxuOV5w5d/ijRMzDH3b3a6WplJ+4DgLUwmyuA+UdHK6BDTjTDS48+M61BGR7q/bWygbK3Fsbh/ATO67ZelxBkHyJaTeUnH7CsAuoB2/u6XedbjbBG3CcNM8/Xm9b3JIFNyAGUKV55mwhzcRlZ1WRI13GImHyHCcQoPWxTkMLQGUhuqrlZWtFVxhmOop3aePcu7LOYiFqljN4R39NQWnrNXmEwPMnWr7fa5/EoDKpLE8lh6yCAr6lrJtkySpevgxj+7sL8st7etvR1hPuX18WgyRpLdDCPOpJaezYOyCW8t+R4Bc/PTbZ/mYb1NnyhQvjeB7hrWac7i5Tx0jbas=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43013a69-b4ed-44a5-c992-08ddeb296aa4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 20:35:27.2454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hx4/gxStupm2RWFHFNowTQzUJ3nUkNZpc1OB0CPJ2/a3+3tZAaTAVu6asyHkLq+59nBKgHsQiOfQyldPyWupedS4O4OlrkUlO/FExcuEo/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509030207
X-Proofpoint-GUID: dj407n5BJMXe7Q8tjzBSwBUzkZxg72Nw
X-Proofpoint-ORIG-GUID: dj407n5BJMXe7Q8tjzBSwBUzkZxg72Nw
X-Authority-Analysis: v=2.4 cv=Ta+WtQQh c=1 sm=1 tr=0 ts=68b8a695 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8
 a=I21kJJIRW9ACrEPWX3oA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf
 awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAzMDIwNiBTYWx0ZWRfX/DgJoZ7cCPtf
 EOS06q0zH+dOYyJ75IAPfZORHecJ6adID+wu825TsI5oWcd2M8kZgxUHJnH3QQg/MlyH1uZDMKX
 fda4G+dYsBmv9t+gXneykZSLixuJVNj0rvmDZAIPwuP0XHxo8HFZ1xk+E81R6ieD8CWRLuQIUMb
 zdS+w8NN9Ie4RnQXo5Ex+8eQt/e3ItWMqFSSLO8fajPBfmKFEYA7zZ2ChiV0mMWch3Fadc5BzbZ
 2FXI0QxrrpQHkxiLCjCXF2Oc1WlDDZC8fQpgSxtxpztSaFW63sZUogWh49knSNpgp4H5LGUGunC
 nu7q4r1UaN0Xpcdczw6pNIff1JsaiOm+ghh2WxvLDZktiN45koFf5sVoGk6I3ubVuxvGULV/TOQ
 JYNFQK5n/4WQQobhJR8Q7yaVUQT/rA==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CAF780003
X-Stat-Signature: kqxg95eww14mwt7bgesuks7w1zupa3pu
X-Rspam-User: 
X-HE-Tag: 1756931742-563852
X-HE-Meta: U2FsdGVkX1+ucUk8tG1jOZEQ3JI0YyjyyIA/2+KFBdXK+pynPswD/sI+L0K/1dMZPmQwGNqYEn7r+C/AnsxNjwRKv9yxGvzTvAygNK+oDldKUiBqjaGE/UfkL5k9FtgkvP77NmnWB2dh+PM8V5ZdS7I3edCLxqTRz9nb7CdqJrYMVswdRR6e6gX5MHJQa45aSnozlt733XMznbuxKg80JgSxQNreKUa8IyJfje6+eJ4hvg0euYUtMyRJCjP34SQvPrcDp5abA0/DDu+Cq4TtP4jdAvD04hzsUAZ1zGaAAdhQirIhZmNd0ngyKHJIwdUjRP1L1iXSRCR1T//ju3cCi5EmCpTf3nE4S7UEPQvGB339HMc5WPERnkUznoVqAyOK8cvZJnqxAhoA1noZKyo/TEcdbKfUEUGbNZSuyJFaw7L7FqsNkx2Oa1ZK31rbw30BtnM1h3jbt8HimUoTFtPb+omox5Q0deqocsbIpmUxdVCRbdz2pPhgXxOdsRQ3XyirfZCWngM9MKq8fb8WlMhXZ1oTEqwGytC9Ct37O8HR8/r9Zg+U/ocQNNLOID1owXAM+7PcUPkU36zG+GKVgqYROAH1pcnkmnDV5p1Fq/x+ddhiSIQZTHvivZs6EBFENh/cNz1w6b6OYX7UHqiUfGc63/hMTgfKEmA9/Ul8PwjhxqYaBuaIekb/znkZzGN0ATGRyldyeFlRrggN5y00mREnyjqtXAxtJugiNFoDqfcHuTnd+jkYMgC6cdTi2b/r+r/Skv/JgsASPqDEe3FhfihIsY7m6muQCTA9k5ar3n/pfzIt4rUmu9l4Bgl6AAWM6b24aIlNPX7Z/3GLNB03kWn5uJtxndVZhUO+kqHXKKAv9E0MM6UkAoHOvFfn6nyF5+6U8WynPv13UMVNX2Gz7Z9Sz37KOrh3jwMYbu+BYp8gOGE2ZbRnnnLl8js6E+8KiUR1ugYXJ19NfFFcANzMexO
 zfva3C8N
 Te3XWfyKI8BMFea5Fsgpq48SVigGOXdB9gs/M3+2BafCBoU8zitioax/I68LbOjEIE6XO3EXNIK/k88JpATbX7PgadQyQbmb1SJoUVEUARHszMPpebcNGkDwsJh4QOP1RhFoQV/DdCAkT59VY4e1GurLygK9EBH12SoMJLzqH5W3VOk4bWLNzW63PNYY+iyzgqAE37yVjjgHOMBJSKU4SzrAK55tviX7O0RlLnXQbczDNH/UGaQUKrbWa8A54eHXvIa3fX+Sgc6hklGv9uaKZuv9EaJQ5/5UzoBkne1+DcH++01axyW/o7EBmEfAnckKtSzBhYpEv5pb6GrlBtS4laCGS/6mr0HsrDOOCkw1ogZu9FvxjBZUsaGvaG5Po6R42i97seJuLce4gSLMkGelTr6TfWbUD4/Mi7XMYMWOEix7dvZlFspet2MeeWRIV5yD2H9XGxAoypWh5P1Ewlms9O47LapXxlIGR2VmuXy94YedlyM9DF0tGOLM49Wj5JTjmHpyXrLtVqSy2ydAmQ0rE8WUuvYKhr1nR0ElttHJaaUFALN+RihP2k+kJRf8fRwEunCxo+JpBIy19D9N2EevDtogUUPlzqSr7N1BlHRqmJyrEIt9fp8zcdqsnJpp3OLtlMkXA/Ly9uTWi+qcXV4NQ/0EXHy5cQew2iWItkwT1eocpaJeTDD5mO/q6B3DlWJXMxrxcW8WjchFO66stxOgvubmEi96NGHa3q///4H6J5PKXfdN9y8d+hNFs/db/b/bXjf/rBHvMZ06QD7V7nnQV09at2oEOHFBfkznoQaWf4X/jj4UzZZI7H9arwwvLboeanl20PTELJYfhyQQ+ZsE8kye96mXkPuIf159fzVJm5jvRsluP8epltcaXvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:16:35AM +0530, Dev Jain wrote:
> Now that all actionable outcomes from checking pte_write() are gone,
> drop the related references.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/trace/events/huge_memory.h | 19 ++++++-------------
>  mm/khugepaged.c                    | 14 +++-----------
>  2 files changed, 9 insertions(+), 24 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 2305df6cb485..dd94d14a2427 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -19,7 +19,6 @@
>  	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
>  	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
>  	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
> -	EM( SCAN_PAGE_RO,		"no_writable_page")		\
>  	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
>  	EM( SCAN_PAGE_NULL,		"page_null")			\
>  	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
> @@ -55,15 +54,14 @@ SCAN_STATUS
>
>  TRACE_EVENT(mm_khugepaged_scan_pmd,
>
> -	TP_PROTO(struct mm_struct *mm, struct folio *folio, bool writable,
> +	TP_PROTO(struct mm_struct *mm, struct folio *folio,
>  		 int referenced, int none_or_zero, int status, int unmapped),
>
> -	TP_ARGS(mm, folio, writable, referenced, none_or_zero, status, unmapped),
> +	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
>
>  	TP_STRUCT__entry(
>  		__field(struct mm_struct *, mm)
>  		__field(unsigned long, pfn)
> -		__field(bool, writable)
>  		__field(int, referenced)
>  		__field(int, none_or_zero)
>  		__field(int, status)
> @@ -73,17 +71,15 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
>  	TP_fast_assign(
>  		__entry->mm = mm;
>  		__entry->pfn = folio ? folio_pfn(folio) : -1;
> -		__entry->writable = writable;
>  		__entry->referenced = referenced;
>  		__entry->none_or_zero = none_or_zero;
>  		__entry->status = status;
>  		__entry->unmapped = unmapped;
>  	),
>
> -	TP_printk("mm=%p, scan_pfn=0x%lx, writable=%d, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
> +	TP_printk("mm=%p, scan_pfn=0x%lx, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
>  		__entry->mm,
>  		__entry->pfn,
> -		__entry->writable,
>  		__entry->referenced,
>  		__entry->none_or_zero,
>  		__print_symbolic(__entry->status, SCAN_STATUS),
> @@ -117,15 +113,14 @@ TRACE_EVENT(mm_collapse_huge_page,
>  TRACE_EVENT(mm_collapse_huge_page_isolate,
>
>  	TP_PROTO(struct folio *folio, int none_or_zero,
> -		 int referenced, bool  writable, int status),
> +		 int referenced, int status),
>
> -	TP_ARGS(folio, none_or_zero, referenced, writable, status),
> +	TP_ARGS(folio, none_or_zero, referenced, status),
>
>  	TP_STRUCT__entry(
>  		__field(unsigned long, pfn)
>  		__field(int, none_or_zero)
>  		__field(int, referenced)
> -		__field(bool, writable)
>  		__field(int, status)
>  	),
>
> @@ -133,15 +128,13 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
>  		__entry->pfn = folio ? folio_pfn(folio) : -1;
>  		__entry->none_or_zero = none_or_zero;
>  		__entry->referenced = referenced;
> -		__entry->writable = writable;
>  		__entry->status = status;
>  	),
>
> -	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, writable=%d, status=%s",
> +	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s",
>  		__entry->pfn,
>  		__entry->none_or_zero,
>  		__entry->referenced,
> -		__entry->writable,
>  		__print_symbolic(__entry->status, SCAN_STATUS))
>  );
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a0f1df2a7ae6..af5f5c80fe4e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -39,7 +39,6 @@ enum scan_result {
>  	SCAN_PTE_NON_PRESENT,
>  	SCAN_PTE_UFFD_WP,
>  	SCAN_PTE_MAPPED_HUGEPAGE,
> -	SCAN_PAGE_RO,
>  	SCAN_LACK_REFERENCED_PAGE,
>  	SCAN_PAGE_NULL,
>  	SCAN_SCAN_ABORT,
> @@ -557,7 +556,6 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	struct folio *folio = NULL;
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> -	bool writable = false;
>
>  	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, address += PAGE_SIZE) {
> @@ -671,9 +669,6 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
>  								     address)))
>  			referenced++;
> -
> -		if (pte_write(pteval))
> -			writable = true;
>  	}
>
>  	if (unlikely(cc->is_khugepaged && !referenced)) {
> @@ -681,13 +676,13 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	} else {
>  		result = SCAN_SUCCEED;
>  		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -						    referenced, writable, result);
> +						    referenced, result);
>  		return result;
>  	}
>  out:
>  	release_pte_pages(pte, _pte, compound_pagelist);
>  	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -					    referenced, writable, result);
> +					    referenced, result);
>  	return result;
>  }
>
> @@ -1280,7 +1275,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	unsigned long _address;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
> -	bool writable = false;
>
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>
> @@ -1344,8 +1338,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  			result = SCAN_PTE_UFFD_WP;
>  			goto out_unmap;
>  		}
> -		if (pte_write(pteval))
> -			writable = true;
>
>  		page = vm_normal_page(vma, _address, pteval);
>  		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> @@ -1435,7 +1427,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		*mmap_locked = false;
>  	}
>  out:
> -	trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
> +	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
>  				     none_or_zero, result, unmapped);
>  	return result;
>  }
> --
> 2.30.2
>

